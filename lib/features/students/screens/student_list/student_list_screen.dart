import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/student_cubit.dart';
import 'components/empty_student_state.dart';
import 'components/search_results_indicator.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<StudentCubit>().loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      body: BlocBuilder<StudentCubit, StudentState>(
        builder: (BuildContext context, StudentState state) {
          final bool isSearching = state.searchQuery.isNotEmpty;
          final int filteredCount = state.students.length;
          final int totalStudents = state.totalCount;
          final bool hasSelection = state.selectedIds.isNotEmpty;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Banner: shows totalCount (stable) ──
                StudentListBanner(totalStudents: totalStudents),
                SizedBox(height: 16.h),

                // ── Search & Actions ──
                StudentSearchHeader(
                  searchController: _searchController,
                  onSearchChanged: (String q) =>
                      context.read<StudentCubit>().search(q),
                  onAddPressed: () => context.router.push(StudentFormRoute()),
                  rowsPerPage: _rowsPerPage,
                  onRowsPerPageChanged: (int? value) {
                    if (value != null) {
                      setState(() => _rowsPerPage = value);
                    }
                  },
                  onBulkDeletePressed: hasSelection
                      ? () => _confirmBulkDelete(state.selectedIds)
                      : null,
                  selectedCount: state.selectedIds.length,
                ),

                // ── Search results indicator (Polished) ──
                if (isSearching && !state.isLoading) ...[
                  SizedBox(height: 12.h),
                  SearchResultsIndicator(count: filteredCount),
                ],

                SizedBox(height: 30.h),

                // ── Data Table ──
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.students.isEmpty
                      ? const EmptyStudentState()
                      : StudentDataTable(
                          students: state.students,
                          selectedIds: state.selectedIds,
                          rowsPerPage: _rowsPerPage,
                          onToggleAll: () =>
                              context.read<StudentCubit>().toggleAll(),
                          onToggleSelection: (id) =>
                              context.read<StudentCubit>().toggleSelection(id),
                          onDeleteStudent: (s) => _confirmDelete(s),
                        ),
                ),
              ],
            ),
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
