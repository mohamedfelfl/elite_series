import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../models/lesson.dart';

/// Header banner displaying the active lesson session and quick controls.
class ActiveLessonBanner extends StatelessWidget {
  final Lesson? activeLesson;
  final List<Lesson> availableLessons;
  final ValueChanged<Lesson> onSelectLesson;
  final VoidCallback onEndLesson;
  final VoidCallback? onOpenSchedule;
  final VoidCallback? onAddLesson;

  const ActiveLessonBanner({
    super.key,
    required this.activeLesson,
    required this.availableLessons,
    required this.onSelectLesson,
    required this.onEndLesson,
    this.onOpenSchedule,
    this.onAddLesson,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (activeLesson == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 18.h,
        ),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppDimens.r24),
          border: Border.all(
            color: colorScheme.error.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.error.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colorScheme.error,
              size: 40.r,
            ),
            SizedBox(height: 8.h),
            Text(
              LocaleKeys.no_active_lesson.tr(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              LocaleKeys.no_active_lesson_hint.tr(),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onOpenSchedule != null)
                  FilledButton.icon(
                    onPressed: onOpenSchedule,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_month_outlined, size: 18),
                    label: Text(LocaleKeys.daily_schedule.tr()),
                  ),
                if (onOpenSchedule != null && onAddLesson != null)
                  SizedBox(width: 10.w),
                if (onAddLesson != null)
                  OutlinedButton.icon(
                    onPressed: onAddLesson,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(LocaleKeys.add_lesson.tr()),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    final totalAttended =
        activeLesson!.attendedCount + activeLesson!.otherGroupCount;
    final totalEnrolled = activeLesson!.enrolledCount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.p20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppDimens.r24),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.w10,
                  vertical: AppDimens.h4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimens.r8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppDimens.w6),
                    Text(
                      LocaleKeys.in_progress.tr(),
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Quick Switcher dropdown
              if (availableLessons.length > 1)
                _buildLessonSelectorButton(context),
              // End Lesson action button
              IconButton.filledTonal(
                icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
                tooltip: LocaleKeys.end_lesson.tr(),
                onPressed: onEndLesson,
              ),
            ],
          ),
          SizedBox(height: AppDimens.h12),
          Text(
            activeLesson!.groupName ?? LocaleKeys.unassigned.tr(),
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
          if (activeLesson!.title.isNotEmpty) ...[
            SizedBox(height: AppDimens.h2),
            Text(
              activeLesson!.title,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: AppDimens.h12),
          // Progress and counts
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activeLesson!.endTime != null &&
                                  activeLesson!.endTime!.isNotEmpty &&
                                  activeLesson!.endTime != 'null'
                              ? '${activeLesson!.startTime} - ${activeLesson!.endTime}'
                              : activeLesson!.startTime,
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          totalEnrolled > 0
                              ? '${((totalAttended / totalEnrolled) * 100).toStringAsFixed(0)}%'
                              : '0%',
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimens.h6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.r8),
                      child: LinearProgressIndicator(
                        value: totalEnrolled > 0
                            ? (totalAttended / totalEnrolled).clamp(0.0, 1.0)
                            : 0.0,
                        minHeight: 6.h,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimens.w16),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.w16,
                  vertical: AppDimens.h8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppDimens.r16),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$totalAttended / $totalEnrolled',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      LocaleKeys.present.tr(),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonSelectorButton(BuildContext context) {
    return PopupMenuButton<Lesson>(
      tooltip: LocaleKeys.select_lesson.tr(),
      icon: const Icon(Icons.swap_horiz_rounded),
      onSelected: onSelectLesson,
      itemBuilder: (context) {
        if (availableLessons.isEmpty) {
          return [
            PopupMenuItem<Lesson>(
              enabled: false,
              child: Text(LocaleKeys.no_lessons_today.tr()),
            ),
          ];
        }
        return availableLessons.map((lesson) {
          final isCurrent = lesson.id == activeLesson?.id;
          return PopupMenuItem<Lesson>(
            value: lesson,
            child: Row(
              children: [
                if (isCurrent)
                  const Icon(Icons.check, size: 16, color: Colors.green)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lesson.groupName ?? LocaleKeys.unassigned.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        lesson.endTime != null &&
                                lesson.endTime!.isNotEmpty &&
                                lesson.endTime != 'null'
                            ? '${lesson.startTime} - ${lesson.endTime}'
                            : lesson.startTime,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
