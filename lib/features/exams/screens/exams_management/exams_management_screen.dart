import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../cubits/exam_cubit.dart';

@RoutePage()
class ExamsManagementScreen extends StatefulWidget {
  const ExamsManagementScreen({super.key});

  @override
  State<ExamsManagementScreen> createState() => _ExamsManagementScreenState();
}

class _ExamsManagementScreenState extends State<ExamsManagementScreen> {
  final _searchController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.exams_management.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.router.push(ExamFormRoute()),
          ),
        ],
      ),
      body: BlocBuilder<ExamCubit, ExamState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          var filteredExams = state.exams;
          final query = _searchController.text.trim().toLowerCase();

          if (query.isNotEmpty) {
            filteredExams = filteredExams.where((exam) {
              final name = (exam['name'] as String).toLowerCase();
              return name.contains(query);
            }).toList();
          }

          if (_selectedDateRange != null) {
            filteredExams = filteredExams.where((exam) {
              final examDateStr = exam['date'] as String?;
              if (examDateStr == null) return false;
              try {
                final examDate = DateTime.parse(examDateStr);
                // Strip time for accurate boundary check
                final dateOnly = DateTime(
                  examDate.year,
                  examDate.month,
                  examDate.day,
                );
                final startOnly = DateTime(
                  _selectedDateRange!.start.year,
                  _selectedDateRange!.start.month,
                  _selectedDateRange!.start.day,
                );
                final endOnly = DateTime(
                  _selectedDateRange!.end.year,
                  _selectedDateRange!.end.month,
                  _selectedDateRange!.end.day,
                );

                return dateOnly.isAtSameMomentAs(startOnly) ||
                    dateOnly.isAtSameMomentAs(endOnly) ||
                    (dateOnly.isAfter(startOnly) && dateOnly.isBefore(endOnly));
              } catch (_) {
                return false;
              }
            }).toList();
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: LocaleKeys.search_hint.tr(),
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      decoration: BoxDecoration(
                        color: _selectedDateRange != null
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: _selectedDateRange != null
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDateRange: _selectedDateRange,
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDateRange = picked;
                            });
                          }
                        },
                      ),
                    ),
                    if (_selectedDateRange != null) ...[
                      SizedBox(width: 8.w),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDateRange = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: filteredExams.isEmpty
                    ? Center(child: Text(LocaleKeys.no_exams.tr()))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.r),
                        itemCount: filteredExams.length,
                        itemBuilder: (context, index) {
                          final exam = filteredExams[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12.h),
                            child: ListTile(
                              onTap: () => context.router.push(
                                ExamDetailRoute(examId: exam['id'] as int),
                              ),
                              title: Text(
                                exam['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${LocaleKeys.full_mark.tr()}: ${exam['full_mark']} | ${exam['date']}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _showDeleteDialog(
                                      context,
                                      exam['id'] as int,
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.delete_exam.tr()),
        content: Text(LocaleKeys.delete_exam_confirm.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              context.read<ExamCubit>().deleteExam(id);
              Navigator.pop(context);
            },
            child: Text(
              LocaleKeys.delete.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
