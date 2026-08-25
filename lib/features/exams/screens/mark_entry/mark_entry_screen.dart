import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../students/cubits/student_cubit.dart';
import '../../cubits/exam_cubit.dart';
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
  final Map<String, GlobalKey> _studentKeys = {};
  bool _hasScrolled = false;
  int? _highlightedStudentId;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    _highlightedStudentId = widget.studentId;
    if (widget.id != null) {
      context.read<ExamCubit>().loadExams();
      context.read<ExamCubit>().loadMarks(widget.id!);
      context.read<ExamCubit>().loadExamStudents(widget.id!);
    }
  }

  @override
  void dispose() {
    for (final TextEditingController c in _scoreControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      LocaleKeys.grade_entry.tr(),
                      style: textTheme.headlineLarge,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveAll,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(LocaleKeys.save_all.tr()),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<StudentCubit, StudentState>(
                  builder: (BuildContext context, StudentState studentState) {
                    return BlocBuilder<ExamCubit, ExamState>(
                      builder: (BuildContext context, ExamState examState) {
                        if (studentState.isLoading || examState.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Pre-fill existing marks
                        for (final Map<String, Object?> mark
                            in examState.marks) {
                          final int sId = mark['student_id'] as int;
                          final scoreStr =
                              (mark['score'] as num?)?.toString() ?? '';
                          if (!_scoreControllers.containsKey(sId)) {
                            _scoreControllers[sId] = TextEditingController(
                              text: scoreStr,
                            );
                          } else if (_scoreControllers[sId]!.text.isEmpty &&
                              scoreStr.isNotEmpty) {
                            _scoreControllers[sId]!.text = scoreStr;
                          }
                        }

                        final grouped = examState.groupedExamStudents;
                        if (grouped.isEmpty) {
                          return Center(
                            child: Text(
                              LocaleKeys.no_students.tr(),
                              style: textTheme.bodyLarge,
                            ),
                          );
                        }

                        // Get full mark for color coding
                        double? fullMark;
                        if (widget.id != null) {
                          final exam = examState.exams.firstWhere(
                            (e) => e['id'] == widget.id,
                            orElse: () => <String, dynamic>{},
                          );
                          fullMark =
                              (exam['full_mark'] as num?)?.toDouble();
                        }

                        return Card(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: grouped.entries.map((groupEntry) {
                                final groupName = groupEntry.key;
                                final groupStudents = groupEntry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Text(
                                        groupName,
                                        style: textTheme.titleLarge?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    ...groupStudents.map((student) {
                                      final int studentId =
                                          student['id'] as int;
                                      final String rowKey =
                                          '${groupName}_$studentId';
                                      _scoreControllers.putIfAbsent(
                                        studentId,
                                        () => TextEditingController(),
                                      );
                                      _studentKeys.putIfAbsent(
                                        rowKey,
                                        () => GlobalKey(),
                                      );

                                      _scrollToStudentIfNeeded(studentId, rowKey);

                                      return StudentMarkRow(
                                        student: student,
                                        scoreController:
                                            _scoreControllers[studentId]!,
                                        studentKey: _studentKeys[rowKey]!,
                                        isHighlighted:
                                            _highlightedStudentId == studentId,
                                        fullMark: fullMark,
                                      );
                                    }),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToStudentIfNeeded(int studentId, String rowKey) {
    if (widget.studentId != null &&
        !_hasScrolled &&
        widget.studentId == studentId) {
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
    if (widget.id == null || _isSaving && showSnackbar) return;

    if (showSnackbar) setState(() => _isSaving = true);

    try {
      final Map<int, double> scores = <int, double>{};
      for (final MapEntry<int, TextEditingController> entry
          in _scoreControllers.entries) {
        final double? score = double.tryParse(entry.value.text);
        if (score != null) {
          scores[entry.key] = score;
        }
      }

      if (scores.isNotEmpty) {
        await context.read<ExamCubit>().saveMarksQuietly(widget.id!, scores);
        await Future.delayed(const Duration(milliseconds: 50));

        if (showSnackbar && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.marks_saved_success.tr())),
          );
        }
      }
    } finally {
      if (showSnackbar && mounted) setState(() => _isSaving = false);
    }
  }
}
