import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../app/shared/animations/app_animations.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/lesson_cubit.dart';
import '../../../models/lesson.dart';
import 'add_edit_lesson_dialog.dart';
import 'end_lesson_dialog.dart';
import 'lesson_card.dart';
import 'lesson_conflict_dialog.dart';

/// Lessons Management Tab View for adding, editing, starting, ending, and managing lessons.
class LessonsTabView extends StatefulWidget {
  final VoidCallback onSwitchToScanner;

  const LessonsTabView({
    super.key,
    required this.onSwitchToScanner,
  });

  @override
  State<LessonsTabView> createState() => _LessonsTabViewState();
}

class _LessonsTabViewState extends State<LessonsTabView> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LessonCubit>().loadLessonsForDate(_selectedDate);
      }
    });
  }

  void _changeDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    context.read<LessonCubit>().loadLessonsForDate(newDate);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      _changeDate(picked);
    }
  }

  Future<void> _handleStartLesson(Lesson lesson) async {
    final activeLesson = context.read<LessonCubit>().state.activeLesson;
    if (activeLesson != null &&
        activeLesson.id != null &&
        activeLesson.id != lesson.id &&
        activeLesson.status == LessonStatus.inProgress) {
      final confirmed = await LessonConflictDialog.show(
        context,
        currentRunningLesson: activeLesson,
        newLessonToStart: lesson,
      );
      if (!confirmed || !mounted) return;
      await context.read<LessonCubit>().endLesson(activeLesson.id!);
    }
    if (!mounted) return;
    await context.read<LessonCubit>().startLesson(lesson);
    widget.onSwitchToScanner();
  }

  Future<void> _handleResumeLesson(Lesson lesson) async {
    final activeLesson = context.read<LessonCubit>().state.activeLesson;
    if (activeLesson != null &&
        activeLesson.id != null &&
        activeLesson.id != lesson.id &&
        activeLesson.status == LessonStatus.inProgress) {
      final confirmed = await LessonConflictDialog.show(
        context,
        currentRunningLesson: activeLesson,
        newLessonToStart: lesson,
      );
      if (!confirmed || !mounted) return;
      await context.read<LessonCubit>().endLesson(activeLesson.id!);
    }
    if (!mounted) return;
    context.read<LessonCubit>().setActiveLesson(lesson);
    widget.onSwitchToScanner();
  }

  Future<void> _handleReopenLesson(Lesson lesson) async {
    final activeLesson = context.read<LessonCubit>().state.activeLesson;
    if (activeLesson != null &&
        activeLesson.id != null &&
        activeLesson.id != lesson.id &&
        activeLesson.status == LessonStatus.inProgress) {
      final confirmed = await LessonConflictDialog.show(
        context,
        currentRunningLesson: activeLesson,
        newLessonToStart: lesson,
      );
      if (!confirmed || !mounted) return;
      await context.read<LessonCubit>().endLesson(activeLesson.id!);
    }
    if (!mounted) return;
    await context.read<LessonCubit>().reopenLesson(lesson);
    widget.onSwitchToScanner();
  }

  void _confirmDeleteLesson(BuildContext context, int lessonId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.r24),
        ),
        title: Text(LocaleKeys.confirm_delete_lesson.tr()),
        content: Text(
          LocaleKeys.confirm_delete_lesson.tr(),
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<LessonCubit>().deleteLesson(lessonId);
            },
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 18.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date Picker & Actions Bar Card
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimens.r20),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12.w,
              runSpacing: 12.h,
              children: [
                // Date Stepper
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: () {
                        _changeDate(
                          _selectedDate.subtract(const Duration(days: 1)),
                        );
                      },
                    ),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(AppDimens.r12),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 20.r,
                              color: colorScheme.primary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: () {
                        _changeDate(
                          _selectedDate.add(const Duration(days: 1)),
                        );
                      },
                    ),
                  ],
                ),

                // Today Button & Add Lesson Button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isToday) ...[
                      OutlinedButton.icon(
                        onPressed: () => _changeDate(DateTime.now()),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimens.r12),
                          ),
                        ),
                        icon: const Icon(Icons.today, size: 16),
                        label: Text(LocaleKeys.filter_today.tr()),
                      ),
                      SizedBox(width: 10.w),
                    ],
                    FilledButton.icon(
                      onPressed: () {
                        AddEditLessonDialog.show(
                          context,
                          initialDate: _selectedDate,
                        );
                      },
                      style: FilledButton.styleFrom(
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
          ),

          SizedBox(height: 20.h),

          // Daily Lessons List Section
          BlocBuilder<LessonCubit, LessonState>(
            builder: (context, lessonState) {
              if (lessonState.isLoading) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.p32),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              final lessons = lessonState.dailyLessons;

              if (lessons.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(AppDimens.p32),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.r24),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy_outlined,
                        size: 48.r,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        LocaleKeys.no_lessons_today.tr(),
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        LocaleKeys.no_active_lesson_hint.tr(),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          AddEditLessonDialog.show(
                            context,
                            initialDate: _selectedDate,
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(LocaleKeys.add_lesson.tr()),
                      ),
                    ],
                  ),
                );
              }

              // Stats summary pills
              final inProgressCount = lessons
                  .where((l) => l.status == LessonStatus.inProgress)
                  .length;
              final completedCount = lessons
                  .where((l) => l.status == LessonStatus.completed)
                  .length;
              final scheduledCount = lessons
                  .where((l) => l.status == LessonStatus.scheduled)
                  .length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Badges
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 8.h,
                    children: [
                      _buildSummaryBadge(
                        context,
                        label: LocaleKeys.total.tr(),
                        count: lessons.length,
                        color: colorScheme.primary,
                      ),
                      if (inProgressCount > 0)
                        _buildSummaryBadge(
                          context,
                          label: LocaleKeys.in_progress.tr(),
                          count: inProgressCount,
                          color: Colors.green,
                        ),
                      _buildSummaryBadge(
                        context,
                        label: LocaleKeys.scheduled.tr(),
                        count: scheduledCount,
                        color: Colors.blueGrey,
                      ),
                      _buildSummaryBadge(
                        context,
                        label: LocaleKeys.completed.tr(),
                        count: completedCount,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  // Lessons Cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lessons.length,
                    separatorBuilder: (context, index) => SizedBox(height: 14.h),
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return LessonCard(
                        lesson: lesson,
                        onStart: () => _handleStartLesson(lesson),
                        onResume: () => _handleResumeLesson(lesson),
                        onEnd: () {
                          if (lesson.id != null) {
                            EndLessonDialog.show(
                              context,
                              lesson: lesson,
                              onConfirmEnd: () {
                                context.read<LessonCubit>().endLesson(
                                      lesson.id!,
                                    );
                              },
                            );
                          }
                        },
                        onReopen: () => _handleReopenLesson(lesson),
                        onEdit: () {
                          AddEditLessonDialog.show(
                            context,
                            initialDate: _selectedDate,
                            lessonToEdit: lesson,
                          );
                        },
                        onDelete: () {
                          if (lesson.id != null) {
                            _confirmDeleteLesson(context, lesson.id!);
                          }
                        },
                      ).animateStaggeredEntrance(index: index);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBadge(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.r12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            count.toString(),
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
