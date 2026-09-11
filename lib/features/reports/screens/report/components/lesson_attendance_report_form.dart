import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../attendance/cubits/lesson_cubit.dart';
import '../../../../groups/cubits/group_cubit.dart';
import '../../../cubits/report_cubit.dart';

/// Form component for generating lesson attendance & absence report, or group summary report.
class LessonAttendanceReportForm extends StatefulWidget {
  final ReportType reportType;

  const LessonAttendanceReportForm({super.key, required this.reportType});

  @override
  State<LessonAttendanceReportForm> createState() =>
      _LessonAttendanceReportFormState();
}

class _LessonAttendanceReportFormState
    extends State<LessonAttendanceReportForm> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedLessonId;
  int? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    context.read<LessonCubit>().loadLessonsForDate(_selectedDate);
    context.read<GroupCubit>().loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isGroupSummary =
        widget.reportType == ReportType.groupAttendanceSummary;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isGroupSummary
                ? LocaleKeys.group_summary_report.tr()
                : LocaleKeys.lesson_report.tr(),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            isGroupSummary
                ? LocaleKeys.group_summary_report_desc.tr()
                : LocaleKeys.lesson_report_desc.tr(),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 24.h),

          if (isGroupSummary) ...[
            BlocBuilder<GroupCubit, GroupState>(
              builder: (context, groupState) {
                return DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: LocaleKeys.group.tr(),
                    prefixIcon: const Icon(Icons.group_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.r16),
                    ),
                  ),
                  initialValue: _selectedGroupId,
                  items: groupState.groups.map((g) {
                    return DropdownMenuItem<int>(
                      value: g['id'] as int,
                      child: Text(g['name'] as String),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedGroupId = val;
                    });
                  },
                );
              },
            ),
          ] else ...[
            // Date Picker Field
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.calendar_today_outlined,
                color: colorScheme.primary,
              ),
              title: Text(
                DateFormat('yyyy-MM-dd').format(_selectedDate),
                style: textTheme.bodyLarge,
              ),
              trailing: TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _selectedLessonId = null;
                    });
                    if (context.mounted) {
                      context.read<LessonCubit>().loadLessonsForDate(picked);
                    }
                  }
                },
                child: Text(LocaleKeys.edit.tr()),
              ),
            ),
            const Divider(),
            SizedBox(height: AppDimens.h8),

            // Lesson Selection Dropdown
            BlocBuilder<LessonCubit, LessonState>(
              builder: (context, lessonState) {
                final persistedLessons = lessonState.dailyLessons
                    .where((l) => l.id != null)
                    .toList();

                if (persistedLessons.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      LocaleKeys.no_lessons_today.tr(),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: LocaleKeys.select_lesson.tr(),
                    prefixIcon: const Icon(Icons.class_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.r16),
                    ),
                  ),
                  initialValue: _selectedLessonId,
                  items: persistedLessons.map((l) {
                    return DropdownMenuItem<int>(
                      value: l.id,
                      child: Text('${l.groupName} - ${l.startTime}'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedLessonId = val;
                    });
                  },
                );
              },
            ),
          ],
          SizedBox(height: 32.h),

          FilledButton.icon(
            onPressed: () {
              if (isGroupSummary) {
                if (_selectedGroupId != null) {
                  context
                      .read<ReportCubit>()
                      .generateGroupAttendanceSummaryReport(_selectedGroupId!);
                }
              } else {
                if (_selectedLessonId != null) {
                  context.read<ReportCubit>().generateLessonSessionReport(
                    _selectedLessonId!,
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.r16),
              ),
            ),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(LocaleKeys.generate_report.tr()),
          ),
        ],
      ),
    );
  }
}
