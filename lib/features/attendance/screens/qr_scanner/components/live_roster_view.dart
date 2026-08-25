import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../models/attendance.dart';

/// Live roster displaying Attended vs Absent students with 1-tap manual toggle.
class LiveRosterView extends StatefulWidget {
  final List<Map<String, dynamic>> attendedStudents;
  final List<Map<String, dynamic>> absentStudents;
  final ValueChanged<int> onMarkPresent;
  final ValueChanged<int> onRemoveAttendance;

  const LiveRosterView({
    super.key,
    required this.attendedStudents,
    required this.absentStudents,
    required this.onMarkPresent,
    required this.onRemoveAttendance,
  });

  @override
  State<LiveRosterView> createState() => _LiveRosterViewState();
}

class _LiveRosterViewState extends State<LiveRosterView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppDimens.r16),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(AppDimens.r14),
            ),
            labelColor: colorScheme.onPrimary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            labelStyle: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: LocaleKeys.attended_tab.tr(
                  args: [widget.attendedStudents.length.toString()],
                ),
              ),
              Tab(
                text: LocaleKeys.absent_tab.tr(
                  args: [widget.absentStudents.length.toString()],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimens.h16),
        AnimatedBuilder(
          animation: _tabController,
          builder: (context, _) {
            final isAttendedTab = _tabController.index == 0;
            final currentList = isAttendedTab
                ? widget.attendedStudents
                : widget.absentStudents;

            if (currentList.isEmpty) {
              return Container(
                padding: EdgeInsets.all(AppDimens.p32),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      isAttendedTab
                          ? Icons.person_search_outlined
                          : Icons.celebration_outlined,
                      size: 48.r,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: AppDimens.h12),
                    Text(
                      isAttendedTab
                          ? LocaleKeys.no_attendance_records.tr()
                          : LocaleKeys.all_enrolled_attended.tr(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentList.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final student = currentList[index];
                if (isAttendedTab) {
                  return _buildAttendedTile(student, theme);
                } else {
                  return _buildAbsentTile(student, theme);
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAttendedTile(Map<String, dynamic> record, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final String name = record['student_name']?.toString() ?? '';
    final String serial = record['serial_number']?.toString() ?? '';
    final String status = record['status']?.toString() ?? '';
    final String notes = record['notes']?.toString() ?? '';
    final int recordId = (record['id'] as int?) ?? 0;

    final bool isOwnGroup = status == AttendanceStatus.attended.name;
    final String displayNotes = notes.isNotEmpty
        ? notes
        : (isOwnGroup
            ? LocaleKeys.attended_his_group.tr()
            : LocaleKeys.other_lesson.tr());

    final Color badgeColor = isOwnGroup ? Colors.green : Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.p16,
        vertical: AppDimens.p12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: badgeColor.withValues(alpha: 0.15),
            radius: 18.r,
            child: Icon(Icons.check, size: 18.r, color: badgeColor),
          ),
          SizedBox(width: AppDimens.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (serial.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    serial,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppDimens.w8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w10,
              vertical: AppDimens.h4,
            ),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimens.r12),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              displayNotes,
              style: textTheme.labelSmall?.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (recordId > 0)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 20.r,
                color: colorScheme.error,
              ),
              onPressed: () => widget.onRemoveAttendance(recordId),
            ),
        ],
      ),
    );
  }

  Widget _buildAbsentTile(Map<String, dynamic> student, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final String name = student['name']?.toString() ?? '';
    final String serial = student['serial_number']?.toString() ?? '';
    final String phone1 = student['phone1']?.toString() ?? '';
    final int studentId = (student['id'] as int?) ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.p16,
        vertical: AppDimens.p12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            radius: 18.r,
            child: Icon(Icons.close, size: 18.r, color: Colors.red),
          ),
          SizedBox(width: AppDimens.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (serial.isNotEmpty)
                      Text(
                        serial,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (phone1.isNotEmpty) ...[
                      SizedBox(width: AppDimens.w8),
                      Text('•', style: textTheme.bodySmall),
                      SizedBox(width: AppDimens.w8),
                      Text(
                        phone1,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.w8),
          FilledButton.tonalIcon(
            onPressed: () => widget.onMarkPresent(studentId),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green.withValues(alpha: 0.15),
              foregroundColor: Colors.green.shade800,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.w12,
                vertical: AppDimens.h8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.r12),
              ),
            ),
            icon: const Icon(Icons.check, size: 16),
            label: Text(LocaleKeys.mark_present.tr()),
          ),
        ],
      ),
    );
  }
}
