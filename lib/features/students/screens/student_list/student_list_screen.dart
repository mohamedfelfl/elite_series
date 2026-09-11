import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../groups/cubits/group_cubit.dart';
import '../../cubits/student_cubit.dart';
import 'components/duplicate_students_dialog.dart';
import 'components/empty_student_state.dart';
import 'components/student_batch_action_bar.dart';
import 'components/student_card_list.dart';
import 'components/student_data_table.dart';
import 'components/student_list_banner.dart';
import 'components/student_search_header.dart';

@RoutePage()
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _searchController = TextEditingController();
  int _rowsPerPage = 10;
  String? _selectedGrade;
  bool _isDense = true;

  @override
  void initState() {
    super.initState();
    context.read<StudentCubit>().loadStudents();
    context.read<GroupCubit>().loadGroups();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetAllFilters() {
    _searchController.clear();
    setState(() => _selectedGrade = null);
    context.read<StudentCubit>().search('');
    context.read<StudentCubit>().filterByGroup(null);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: context.router.canPop()
          ? AppBar(
              title: Text(
                LocaleKeys.students_directory.tr(),
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
            )
          : null,
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, groupState) {
          return BlocBuilder<StudentCubit, StudentState>(
            builder: (BuildContext context, StudentState state) {
              final bool isSearching = state.searchQuery.isNotEmpty;
              final bool hasGradeFilter = _selectedGrade != null;
              final bool hasGroupFilter = state.selectedGroupId != null;
              final bool hasActiveFilters =
                  isSearching || hasGradeFilter || hasGroupFilter;

              // Filter by grade client-side for zero-latency response
              final List<Map<String, dynamic>> displayedStudents =
                  _selectedGrade == null
                      ? state.students
                      : state.students
                          .where((s) => s['grade']?.toString() == _selectedGrade)
                          .toList();

              final int filteredCount = displayedStudents.length;
              final int totalStudents = state.totalCount;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header & Quick Metrics Bar ──
                    StudentListBanner(
                      totalStudents: totalStudents,
                      filteredStudents: filteredCount,
                      isFiltered: hasActiveFilters,
                      onAddPressed: () =>
                          context.router.push(StudentFormRoute()),
                      onManageDuplicatesPressed: () =>
                          DuplicateStudentsDialog.show(context),
                      onResetFilters: _resetAllFilters,
                    ),

                    const SizedBox(height: 8),

                    // ── Search & Filter Toolbar ──
                    StudentSearchHeader(
                      searchController: _searchController,
                      onSearchChanged: (String q) =>
                          context.read<StudentCubit>().search(q),
                      onClearSearch: () {
                        _searchController.clear();
                        context.read<StudentCubit>().search('');
                      },
                      selectedGrade: _selectedGrade,
                      onGradeChanged: (grade) {
                        setState(() => _selectedGrade = grade);
                      },
                      selectedGroupId: state.selectedGroupId,
                      onGroupChanged: (groupId) {
                        context.read<StudentCubit>().filterByGroup(groupId);
                      },
                      groups: groupState.groups,
                      rowsPerPage: _rowsPerPage,
                      onRowsPerPageChanged: (int? value) {
                        if (value != null) {
                          setState(() => _rowsPerPage = value);
                        }
                      },
                      hasActiveFilters: hasActiveFilters,
                      onResetAllFilters: _resetAllFilters,
                      isDense: _isDense,
                      onDensityChanged: (dense) {
                        setState(() => _isDense = dense);
                      },
                    ),

                    const SizedBox(height: 6),

                    // ── Contextual Batch Action Bar (Animates when selection active) ──
                    StudentBatchActionBar(
                      selectedCount: state.selectedIds.length,
                      totalCount: displayedStudents.length,
                      onToggleAll: () =>
                          context.read<StudentCubit>().toggleAll(),
                      onClearSelection: () =>
                          context.read<StudentCubit>().clearSelection(),
                      onDeletePressed: () =>
                          _confirmBulkDelete(state.selectedIds),
                    ),

                    // ── Student List Area (Desktop Table vs. Mobile Cards) ──
                    Expanded(
                      child: state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : displayedStudents.isEmpty
                              ? EmptyStudentState(
                                  isFiltered: hasActiveFilters,
                                  onClearFilters: _resetAllFilters,
                                  onAddStudent: () => context.router
                                      .push(StudentFormRoute()),
                                )
                              : LayoutBuilder(
                                  builder: (context, constraints) {
                                    // Use data table for desktop/tablet (>= 800px), card list for mobile (< 800px)
                                    if (constraints.maxWidth >= 800) {
                                      return StudentDataTable(
                                        students: displayedStudents,
                                        selectedIds: state.selectedIds,
                                        rowsPerPage: _rowsPerPage,
                                        isDense: _isDense,
                                        onToggleAll: () => context
                                            .read<StudentCubit>()
                                            .toggleAll(),
                                        onToggleSelection: (id) => context
                                            .read<StudentCubit>()
                                            .toggleSelection(id),
                                        onDeleteStudent: (s) =>
                                            _confirmDelete(s),
                                      );
                                    } else {
                                      return StudentCardList(
                                        students: displayedStudents,
                                        selectedIds: state.selectedIds,
                                        rowsPerPage: _rowsPerPage,
                                        onToggleSelection: (id) => context
                                            .read<StudentCubit>()
                                            .toggleSelection(id),
                                        onDeleteStudent: (s) =>
                                            _confirmDelete(s),
                                      );
                                    }
                                  },
                                ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(Map<String, Object?> student) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        title: Text(LocaleKeys.delete_student.tr()),
        content: Text(
          LocaleKeys.confirm_delete_student.tr(
            args: [student['name'].toString()],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<StudentCubit>().deleteStudent(student['id'] as int);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      ),
    );
  }

  void _confirmBulkDelete(Set<int> ids) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        title: Text(LocaleKeys.delete_student.tr()),
        content: Text(
          LocaleKeys.confirm_bulk_delete.tr(args: ['${ids.length}']),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<StudentCubit>().deleteMultipleStudents(ids);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      ),
    );
  }
}
