import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../models/lesson.dart';

/// Card widget representing a lesson session on the daily schedule.
class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onStart;
  final VoidCallback onResume;
  final VoidCallback? onEnd;
  final VoidCallback onReopen;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onStart,
    required this.onResume,
    this.onEnd,
    required this.onReopen,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final int enrolled = lesson.enrolledCount;
    final int attended = lesson.attendedCount;
    final int otherGroup = lesson.otherGroupCount;
    final int totalPresent = attended + otherGroup;
    final double rate = enrolled > 0
        ? (attended / enrolled * 100).clamp(0, 100)
        : (totalPresent > 0 ? 100.0 : 0.0);

    Color statusColor;
    String statusLabel;

    switch (lesson.status) {
      case LessonStatus.inProgress:
        statusColor = Colors.green;
        statusLabel = LocaleKeys.in_progress.tr();
        break;
      case LessonStatus.completed:
        statusColor = Colors.teal;
        statusLabel = LocaleKeys.completed.tr();
        break;
      case LessonStatus.cancelled:
        statusColor = Colors.red;
        statusLabel = LocaleKeys.cancelled.tr();
        break;
      case LessonStatus.scheduled:
        statusColor = colorScheme.primary;
        statusLabel = LocaleKeys.scheduled.tr();
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.h12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.r20),
        border: Border.all(
          color: lesson.status == LessonStatus.inProgress
              ? Colors.green.withValues(alpha: 0.6)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: lesson.status == LessonStatus.inProgress ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimens.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Status badge, time, edit/delete icons
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.w10,
                    vertical: AppDimens.h4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimens.r12),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    statusLabel,
                    style: textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: AppDimens.w8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: AppDimens.iconSize14,
                      color: textTheme.bodySmall?.color,
                    ),
                    SizedBox(width: AppDimens.w4),
                    Text(
                      lesson.startTime,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (lesson.endTime != null &&
                        lesson.endTime!.isNotEmpty &&
                        lesson.endTime != 'null') ...[
                      Text(
                        ' - ${lesson.endTime}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                if (onEdit != null && lesson.id != null)
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20.r,
                      color: colorScheme.primary,
                    ),
                    onPressed: onEdit,
                    tooltip: LocaleKeys.edit_lesson.tr(),
                    visualDensity: VisualDensity.compact,
                  ),
                if (onDelete != null && lesson.id != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20.r,
                      color: colorScheme.error,
                    ),
                    onPressed: onDelete,
                    tooltip: LocaleKeys.delete_lesson.tr(),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            SizedBox(height: AppDimens.h10),

            // Group Name & Topic
            Text(
              lesson.groupName ?? LocaleKeys.unassigned.tr(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (lesson.title.isNotEmpty) ...[
              SizedBox(height: AppDimens.h4),
              Text(
                lesson.title,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            SizedBox(height: AppDimens.h12),

            // Bottom Section: Stats & Action Buttons
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${LocaleKeys.present.tr()}: ',
                        style: textTheme.bodySmall,
                      ),
                      Text(
                        '$totalPresent / $enrolled (${rate.toStringAsFixed(0)}%)',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (lesson.status == LessonStatus.scheduled)
                  FilledButton.icon(
                    onPressed: onStart,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: AppDimens.h8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: Text(LocaleKeys.start_lesson.tr()),
                  )
                else if (lesson.status == LessonStatus.inProgress) ...[
                  if (onEnd != null) ...[
                    OutlinedButton.icon(
                      onPressed: onEnd,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: AppDimens.h8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.r12),
                        ),
                      ),
                      icon: const Icon(Icons.stop_circle_outlined, size: 16),
                      label: Text(LocaleKeys.end_lesson.tr()),
                    ),
                    SizedBox(width: AppDimens.w8),
                  ],
                  FilledButton.icon(
                    onPressed: onResume,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: AppDimens.h8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                      ),
                    ),
                    icon: const Icon(Icons.qr_code_scanner, size: 18),
                    label: Text(LocaleKeys.resume_lesson.tr()),
                  ),
                ] else if (lesson.status == LessonStatus.completed)
                  OutlinedButton.icon(
                    onPressed: onReopen,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.w12,
                        vertical: AppDimens.h8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                      ),
                    ),
                    icon: const Icon(Icons.restart_alt_rounded, size: 16),
                    label: Text(LocaleKeys.reopen_lesson.tr()),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
