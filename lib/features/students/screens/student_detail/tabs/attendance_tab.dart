import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../attendance/cubits/attendance_cubit.dart';

class AttendanceTab extends StatelessWidget {
  final int studentId;
  const AttendanceTab({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.records.isEmpty) {
          return Center(child: Text(LocaleKeys.no_attendance_records.tr()));
        }
        return ListView.builder(
          padding: EdgeInsets.all(AppDimens.cardPadding),
          itemCount: state.records.length,
          itemBuilder: (context, i) {
            final a = state.records[i];
            final status = a['status']?.toString() ?? '';
            final notes = a['notes']?.toString() ?? '';
            final date = a['date']?.toString() ?? '';
            final lessonTime = a['lesson_time']?.toString() ?? '';
            final lessonGroup = a['lesson_group_name']?.toString() ?? '';

            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.h6),
              child: Container(
                padding: EdgeInsets.all(AppDimens.p12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppDimens.r12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: textTheme.bodyMedium?.copyWith(
                              color: isDark ? Colors.white : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (lessonTime.isNotEmpty ||
                              lessonGroup.isNotEmpty) ...[
                            SizedBox(height: AppDimens.h2),
                            Text(
                              [
                                if (lessonTime.isNotEmpty) lessonTime,
                                if (lessonGroup.isNotEmpty) lessonGroup,
                              ].join(' • '),
                              style: textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: AppDimens.w12),
                    _buildBadge(status, notes, textTheme),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBadge(String status, String notes, TextTheme textTheme) {
    final String displayNotes = notes.isEmpty
        ? (status == 'attended'
            ? LocaleKeys.attended_his_group.tr()
            : status == 'missed'
            ? LocaleKeys.missed.tr()
            : LocaleKeys.other_lesson.tr())
        : notes;

    Color badgeColor;
    if (status == 'attended') {
      badgeColor = Colors.green;
    } else if (status == 'missed') {
      badgeColor = Colors.red;
    } else {
      badgeColor = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w10,
        vertical: AppDimens.h4,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.r16),
        border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        displayNotes,
        style: textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
