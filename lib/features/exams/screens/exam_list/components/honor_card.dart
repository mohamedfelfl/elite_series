import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/shared/animations/app_animations.dart';
import '../../../../../app/shared/animations/pressable_scale.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../models/student_exam_result.dart';

class HonorCard extends StatelessWidget {
  final StudentExamResult result;
  final int rank;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isDark;

  const HonorCard({
    super.key,
    required this.result,
    required this.rank,
    required this.colorScheme,
    required this.textTheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    if (rank == 1) {
      rankColor = AppColors.rankFirst;
    } else if (rank == 2) {
      rankColor = AppColors.rankSecond;
    } else {
      rankColor = AppColors.rankThird;
    }

    return PressableScale(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surfaceContainerLow : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: rankColor.withValues(alpha: isDark ? 0.3 : 0.15),
            width: 1.2,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: rankColor.withValues(alpha: 0.1),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(color: rankColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              result.studentName,
              style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              '${result.totalMarks.toStringAsFixed(1)} / ${result.totalFullMarks.toStringAsFixed(0)}',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '${result.percentage.toStringAsFixed(1)}%',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).animateSpringEntrance();
  }
}
