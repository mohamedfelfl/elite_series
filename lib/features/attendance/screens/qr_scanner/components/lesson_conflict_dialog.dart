import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../models/lesson.dart';

/// Modal dialog that prompts the user to close the currently running lesson
/// before starting or activating a new one.
class LessonConflictDialog {
  static Future<bool> show(
    BuildContext context, {
    required Lesson currentRunningLesson,
    required Lesson newLessonToStart,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final colorScheme = theme.colorScheme;
        final currentInfo =
            '${currentRunningLesson.groupName ?? ''} (${currentRunningLesson.startTime})';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.r24),
          ),
          icon: Icon(
            Icons.warning_amber_rounded,
            size: 44.r,
            color: Colors.amber.shade800,
          ),
          title: Text(
            LocaleKeys.active_lesson_already_running.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            LocaleKeys.another_lesson_running_warning.tr(
              args: [currentInfo],
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.r12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
              ),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.r12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
              ),
              child: Text(LocaleKeys.end_current_and_start_new.tr()),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
