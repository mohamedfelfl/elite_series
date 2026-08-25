import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.gr.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/exam_cubit.dart';
import 'components/action_card.dart';

@RoutePage()
class ExamDetailScreen extends StatelessWidget {
  final int examId;

  /*
### 5. Code Polish & Environment
- **Lint Resolution**: Fixed string interpolation and deprecated member warnings (`surfaceVariant`, `withOpacity`).
- **Gradle Update**: Upgraded the Gradle wrapper from `7.3.1` to `8.0`. This was done to address the "Unsupported class file major version 69" error, ensuring better compatibility with modern Java runtimes (Java 17+).

## Verification Results

### Navigation & UI Verified:
1.  **Dashboard** -> "View All" (Scheduled Exams).
2.  **Exams Management** -> Select specific exam (e.g., "Math Final").
3.  **Exam Details** -> Hub shown with gradient header.
4.  **Action** -> "Enter Student Marks" navigates correctly to the bulk entry screen.
5.  **Action** -> "Modify Exam Information" navigates correctly to the centered edit form.

### Lint Analysis Verified:
- **`lib/` analysis**: No remaining warnings for deprecated members or string interpolation.
- **`scripts/` note**: `avoid_print` warnings in `seed_students.dart` are acknowledged as acceptable for standalone CLI scripts.
*/

  const ExamDetailScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        final exam = state.exams.firstWhere(
          (e) => e['id'] == examId,
          orElse: () => {},
        );

        if (exam.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(LocaleKeys.no_exams.tr())),
          );
        }

        final title = exam['name']?.toString() ?? 'Exam';
        final date = exam['date']?.toString() ?? '';
        final fullMark = (exam['full_mark'] as num?)?.toStringAsFixed(0) ?? '0';

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(LocaleKeys.exam_details.tr()),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: colorScheme.onSurface,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exam Header Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 12.r,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16.r,
                            color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            date,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Icon(
                            Icons.assignment_turned_in,
                            size: 16.r,
                            color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "${LocaleKeys.full_mark.tr()}: $fullMark",
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                Text(
                  LocaleKeys.quick_actions.tr(),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),

                // Action Cards
                ActionCard(
                  title: LocaleKeys.modify_exam_info.tr(),
                  subtitle: LocaleKeys.modify_exam_desc.tr(),
                  icon: Icons.edit_note_rounded,
                  color: AppColors.examTabActiveText,
                  onTap: () =>
                      context.router.push(ExamFormRoute(examId: examId)),
                ),
                SizedBox(height: 16.h),
                ActionCard(
                  title: LocaleKeys.enter_marks_info.tr(),
                  subtitle: LocaleKeys.enter_marks_desc.tr(),
                  icon: Icons.grade_rounded,
                  color: AppColors.examTabInactiveText,
                  onTap: () async {
                    await context.router.push(MarkEntryRoute(id: examId));
                    if (context.mounted) {
                      // Refresh exam marks and statistics after returning
                      context.read<ExamCubit>().loadMarks(examId);
                      context.read<ExamCubit>().calculateAverageScore();
                      context.read<ExamCubit>().getTopStudents();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
