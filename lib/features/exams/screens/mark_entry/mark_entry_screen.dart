import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../students/cubits/student_cubit.dart';
import '../../cubits/exam_cubit.dart';
import 'components/exam_mark_summary_card.dart';
import 'components/student_mark_row.dart';

@RoutePage()
class MarkEntryScreen extends StatefulWidget {
  final int? id;
  final int? studentId;
  const MarkEntryScreen({super.key, this.id, this.studentId});

  @override
  State<MarkEntryScreen> createState() => _MarkEntryScreenState();
}

class _MarkEntryScreenState extends State<MarkEntryScreen> {
  bool _isSaving = false;
  final Map<int, TextEditingController> _scoreControllers = {};
  final Map<int, FocusNode> _focusNodes = {};
  final Map<String, GlobalKey> _studentKeys = {};
  bool _hasScrolled = false;
  int? _highlightedStudentId;
  bool _canPop = false;

  // Search & Filter State
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _groupsScrollController = ScrollController();
  String _searchQuery = '';
  String? _selectedGroupFilter; // null means "All Groups"
  bool _onlyUngraded = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _highlightedStudentId = widget.studentId;
    if (widget.id != null) {
      context.read<ExamCubit>().loadExams();
      context.read<ExamCubit>().loadMarks(widget.id!);
      context.read<ExamCubit>().loadExamStudents(widget.id!);
    }
    _searchController.addListener(() {
      final query = _searchController.text.trim().toLowerCase();
      if (query != _searchQuery) {
        setState(() => _searchQuery = query);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupsScrollController.dispose();
    for (final TextEditingController c in _scoreControllers.values) {
      c.dispose();
    }
    for (final FocusNode f in _focusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop || _isSaving) return;

        setState(() => _isSaving = true);
        await _saveAll(showSnackbar: false);

        if (context.mounted) {
          setState(() {
            _canPop = true;
            _isSaving = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(
            LocaleKeys.grade_entry.tr(),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveAll,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded, size: 20),
                label: Text(LocaleKeys.save_all.tr()),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<StudentCubit, StudentState>(
          builder: (BuildContext context, StudentState studentState) {
            return BlocBuilder<ExamCubit, ExamState>(
              builder: (BuildContext context, ExamState examState) {
                if (studentState.isLoading || examState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 1. Resolve Exam Metadata
                Map<String, dynamic> currentExam = {};
                double fullMark = 100.0;
                String examName = '';
                String examDate = '';
                if (widget.id != null) {
                  currentExam = examState.exams.firstWhere(
                    (e) => e['id'] == widget.id,
                    orElse: () => <String, dynamic>{},
                  );
                  fullMark = (currentExam['full_mark'] as num?)?.toDouble() ?? 100.0;
                  examName = currentExam['name']?.toString() ?? '';
                  examDate = currentExam['date']?.toString() ?? '';
                }

                // 2. Pre-fill existing marks into controllers
                for (final Map<String, Object?> mark in examState.marks) {
                  final int sId = mark['student_id'] as int;
                  final scoreStr = (mark['score'] as num?)?.toString() ?? '';
                  if (!_scoreControllers.containsKey(sId)) {
                    final controller = TextEditingController(text: scoreStr);
                    controller.addListener(() {
                      if (mounted) {
                        setState(() => _hasUnsavedChanges = true);
                      }
                    });
                    _scoreControllers[sId] = controller;
                  }
                }

                final grouped = examState.groupedExamStudents;
                if (grouped.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            LocaleKeys.no_students.tr(),
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. Compute live metrics across all students in exam
                int totalStudentsCount = 0;
                int gradedCount = 0;
                double totalScoreSum = 0.0;
                double? highestScore;

                final List<Map<String, Object?>> allExamStudents = [];
                for (final entry in grouped.entries) {
                  for (final s in entry.value) {
                    final studentMap = Map<String, Object?>.from(s);
                    studentMap['group_name'] = entry.key;
                    allExamStudents.add(studentMap);
                    totalStudentsCount++;

                    final int sId = s['id'] as int;
                    final text = _scoreControllers[sId]?.text.trim() ?? '';
                    final score = double.tryParse(text);
                    if (score != null) {
                      gradedCount++;
                      totalScoreSum += score;
                      if (highestScore == null || score > highestScore) {
                        highestScore = score;
                      }
                    }
                  }
                }

                final double averageScore = gradedCount > 0 ? (totalScoreSum / gradedCount) : 0.0;

                // 4. Filter students according to search, group, and ungraded toggles
                final List<Map<String, Object?>> filteredStudents = allExamStudents.where((s) {
                  final name = (s['name']?.toString() ?? '').toLowerCase();
                  final serial = (s['serial_number']?.toString() ?? '').toLowerCase();
                  final group = s['group_name']?.toString() ?? '';
                  final int sId = s['id'] as int;
                  final text = _scoreControllers[sId]?.text.trim() ?? '';

                  if (_searchQuery.isNotEmpty) {
                    if (!name.contains(_searchQuery) && !serial.contains(_searchQuery)) {
                      return false;
                    }
                  }

                  if (_selectedGroupFilter != null && group != _selectedGroupFilter) {
                    return false;
                  }

                  if (_onlyUngraded && text.isNotEmpty) {
                    return false;
                  }

                  return true;
                }).toList();

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ─── Hero Summary & Live KPIs ───
                            ExamMarkSummaryCard(
                              examName: examName,
                              examDate: examDate,
                              fullMark: fullMark,
                              totalStudents: totalStudentsCount,
                              gradedCount: gradedCount,
                              averageScore: averageScore,
                              highestScore: highestScore,
                            ),

                            const SizedBox(height: 20),

                            // ─── Search, Group Tabs & Filter Controls ───
                            _buildFilterToolbar(
                              context,
                              groups: grouped.keys.toList(),
                              allStudentsCount: totalStudentsCount,
                              filteredCount: filteredStudents.length,
                            ),

                            const SizedBox(height: 16),

                            // ─── Structured Gradebook Card Table ───
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  // Table Header
                                  _buildTableHeader(context),

                                  // Table Rows or Empty State
                                  if (filteredStudents.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(40),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.filter_alt_off_rounded,
                                              size: 48,
                                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              LocaleKeys.no_students_found.tr(),
                                              style: textTheme.bodyLarge?.copyWith(
                                                color: colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    ...List.generate(filteredStudents.length, (index) {
                                      final student = filteredStudents[index];
                                      final int sId = student['id'] as int;
                                      final String group = student['group_name']?.toString() ?? '';
                                      final String rowKey = '${group}_$sId';

                                      if (!_scoreControllers.containsKey(sId)) {
                                        final controller = TextEditingController();
                                        controller.addListener(() {
                                          if (mounted) {
                                            setState(() => _hasUnsavedChanges = true);
                                          }
                                        });
                                        _scoreControllers[sId] = controller;
                                      }
                                      _focusNodes.putIfAbsent(sId, () => FocusNode());
                                      _studentKeys.putIfAbsent(rowKey, () => GlobalKey());

                                      _scrollToStudentIfNeeded(sId, rowKey);

                                      // Callback to focus the next student in the list
                                      void onSubmittedNext(String _) {
                                        if (index + 1 < filteredStudents.length) {
                                          final nextId = filteredStudents[index + 1]['id'] as int;
                                          _focusNodes[nextId]?.requestFocus();
                                        } else {
                                          _focusNodes[sId]?.unfocus();
                                          _saveAll();
                                        }
                                      }

                                      return StudentMarkRow(
                                        student: student,
                                        scoreController: _scoreControllers[sId]!,
                                        studentKey: _studentKeys[rowKey]!,
                                        isHighlighted: _highlightedStudentId == sId,
                                        fullMark: fullMark,
                                        groupName: group,
                                        focusNode: _focusNodes[sId],
                                        onSubmitted: onSubmittedNext,
                                        isEvenRow: index % 2 == 1,
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Sticky Bottom Action & Status Dock ───
                    _buildBottomDock(
                      context,
                      totalStudents: totalStudentsCount,
                      filteredCount: filteredStudents.length,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterToolbar(
    BuildContext context, {
    required List<String> groups,
    required int allStudentsCount,
    required int filteredCount,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input & Ungraded Toggle Row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: LocaleKeys.search_student_or_serial.tr(),
                  prefixIcon: const Icon(Icons.search_rounded, size: 22),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: colorScheme.surfaceContainer,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Ungraded Filter Chip
            FilterChip(
              selected: _onlyUngraded,
              label: Text(LocaleKeys.only_ungraded.tr()),
              avatar: Icon(
                _onlyUngraded
                    ? Icons.filter_alt_rounded
                    : Icons.filter_alt_outlined,
                size: 16,
                color: _onlyUngraded ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              ),
              onSelected: (selected) {
                setState(() => _onlyUngraded = selected);
              },
              backgroundColor: colorScheme.surfaceContainer,
              selectedColor: colorScheme.primary,
              labelStyle: theme.textTheme.labelMedium?.copyWith(
                color: _onlyUngraded ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.chipRadius),
                side: BorderSide(
                  color: _onlyUngraded
                      ? Colors.transparent
                      : colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Group Filter Chips Row with mouse wheel, drag, and button scrolling
        Row(
          children: [
            Expanded(
              child: Listener(
                onPointerSignal: (pointerSignal) {
                  if (pointerSignal is PointerScrollEvent && _groupsScrollController.hasClients) {
                    final double target = (_groupsScrollController.offset + pointerSignal.scrollDelta.dy)
                        .clamp(0.0, _groupsScrollController.position.maxScrollExtent);
                    _groupsScrollController.jumpTo(target);
                  }
                },
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
                  child: SingleChildScrollView(
                    controller: _groupsScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: ChoiceChip(
                            label: Text('${LocaleKeys.all_groups.tr()} ($allStudentsCount)'),
                            selected: _selectedGroupFilter == null,
                            onSelected: (_) => setState(() => _selectedGroupFilter = null),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.chipRadius),
                            ),
                          ),
                        ),
                        ...groups.map((g) {
                          final isSelected = _selectedGroupFilter == g;
                          return Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: ChoiceChip(
                              label: Text(g),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedGroupFilter = isSelected ? null : g;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.chipRadius),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (groups.length > 2) ...[
              const SizedBox(width: 4),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (_groupsScrollController.hasClients) {
                      _groupsScrollController.animateTo(
                        (_groupsScrollController.offset - 200).clamp(0.0, _groupsScrollController.position.maxScrollExtent),
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      size: 22,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (_groupsScrollController.hasClients) {
                      _groupsScrollController.animateTo(
                        (_groupsScrollController.offset + 200).clamp(0.0, _groupsScrollController.position.maxScrollExtent),
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;
          if (isCompact) {
            return Row(
              children: [
                Text(
                  LocaleKeys.students.tr(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  LocaleKeys.score.tr(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 50),
                Text(
                  LocaleKeys.grade_evaluation.tr(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              SizedBox(
                width: 90,
                child: Text(
                  LocaleKeys.serial_number.tr(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Text(
                  LocaleKeys.student_name.tr(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Text(
                  LocaleKeys.groups.tr(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: Center(
                  child: Text(
                    LocaleKeys.score.tr(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              SizedBox(
                width: 125,
                child: Center(
                  child: Text(
                    LocaleKeys.grade_evaluation.tr(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomDock(
    BuildContext context, {
    required int totalStudents,
    required int filteredCount,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Status Icon & Text
            Icon(
              _hasUnsavedChanges ? Icons.edit_note_rounded : Icons.check_circle_outline_rounded,
              size: 20,
              color: _hasUnsavedChanges ? colorScheme.primary : Colors.teal,
            ),
            const SizedBox(width: 8),
            Text(
              _hasUnsavedChanges ? LocaleKeys.unsaved_marks.tr() : LocaleKeys.all_marks_saved.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _hasUnsavedChanges ? colorScheme.onSurface : Colors.teal,
              ),
            ),
            const Spacer(),

            // Save All Button
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveAll,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save_rounded, size: 20),
              label: Text(LocaleKeys.save_all.tr()),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToStudentIfNeeded(int studentId, String rowKey) {
    if (widget.studentId != null && !_hasScrolled && widget.studentId == studentId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_studentKeys[rowKey]?.currentContext != null) {
          Scrollable.ensureVisible(
            _studentKeys[rowKey]!.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.5,
          );
          if (mounted) {
            setState(() {
              _hasScrolled = true;
            });
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _highlightedStudentId = null;
                });
              }
            });
          }
        }
      });
    }
  }

  Future<void> _saveAll({bool showSnackbar = true}) async {
    if (widget.id == null || (_isSaving && showSnackbar)) return;

    if (showSnackbar) setState(() => _isSaving = true);

    try {
      final Map<int, double> scores = <int, double>{};
      final List<int> clearedStudentIds = <int>[];
      final examState = context.read<ExamCubit>().state;
      final Set<int> existingMarkStudentIds = examState.marks
          .map((m) => m['student_id'] as int)
          .toSet();

      for (final MapEntry<int, TextEditingController> entry in _scoreControllers.entries) {
        final text = entry.value.text.trim();
        if (text.isEmpty) {
          if (existingMarkStudentIds.contains(entry.key)) {
            clearedStudentIds.add(entry.key);
          }
        } else {
          final double? score = double.tryParse(text);
          if (score != null) {
            scores[entry.key] = score;
          }
        }
      }

      if (scores.isNotEmpty || clearedStudentIds.isNotEmpty) {
        await context.read<ExamCubit>().saveMarksQuietly(
          widget.id!,
          scores,
          clearedStudentIds: clearedStudentIds,
        );
        await Future.delayed(const Duration(milliseconds: 50));

        if (mounted) {
          setState(() => _hasUnsavedChanges = false);
        }

        if (showSnackbar && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.marks_saved_success.tr()),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.teal.shade800,
            ),
          );
        }
      }
    } finally {
      if (showSnackbar && mounted) setState(() => _isSaving = false);
    }
  }
}
