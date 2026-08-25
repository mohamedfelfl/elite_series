import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../models/lesson.dart';

/// Confirmation dialog with lesson attendance summary before locking session.
class EndLessonDialog extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onConfirmEnd;

  const EndLessonDialog({
    super.key,
    required this.lesson,
    required this.onConfirmEnd,
  });

  static Future<void> show(
    BuildContext context, {
    required Lesson lesson,
    required VoidCallback onConfirmEnd,
  }) {
    return showDialog(
      context: context,
      builder: (context) => EndLessonDialog(
        lesson: lesson,
        onConfirmEnd: onConfirmEnd,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final int totalEnrolled = lesson.enrolledCount;
    final int attended = lesson.attendedCount;
    final int otherGroup = lesson.otherGroupCount;
    final int absent = (totalEnrolled - attended).clamp(0, 999999);
    final int totalPresent = attended + otherGroup;
    final double attendanceRate = totalEnrolled > 0
        ? (attended / totalEnrolled * 100).clamp(0, 100)
        : 100.0;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.r24),
      ),
      title: Row(
        children: [
          Icon(Icons.task_alt_rounded, color: colorScheme.primary, size: 28.r),
          SizedBox(width: AppDimens.w12),
          Text(
            LocaleKeys.confirm_end_lesson.tr(),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              LocaleKeys.confirm_end_lesson_msg.tr(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppDimens.h20),
            Container(
              padding: EdgeInsets.all(AppDimens.p16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(AppDimens.r16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    context,
                    label: LocaleKeys.group.tr(),
                    value: lesson.groupName ?? LocaleKeys.unassigned.tr(),
                    isBold: true,
                  ),
                  const Divider(height: 16),
                  _buildSummaryRow(
                    context,
                    label: LocaleKeys.enrolled_students.tr(),
                    value: totalEnrolled.toString(),
                  ),
                  SizedBox(height: 8.h),
                  _buildSummaryRow(
                    context,
                    label: LocaleKeys.present.tr(),
                    value: '$totalPresent ($attended + $otherGroup ${LocaleKeys.other_lesson.tr()})',
                    color: Colors.green,
                  ),
                  SizedBox(height: 8.h),
                  _buildSummaryRow(
                    context,
                    label: LocaleKeys.absent.tr(),
                    value: absent.toString(),
                    color: absent > 0 ? Colors.red : null,
                  ),
                  const Divider(height: 16),
                  _buildSummaryRow(
                    context,
                    label: LocaleKeys.attendance_rate_pct.tr(),
                    value: '${attendanceRate.toStringAsFixed(1)}%',
                    isBold: true,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.continue_scanning.tr()),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmEnd();
          },
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.r12),
            ),
          ),
          child: Text(LocaleKeys.confirm_end.tr()),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isBold = false,
    Color? color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
