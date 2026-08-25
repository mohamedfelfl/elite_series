import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/shared/animations/animated_counter.dart';
import '../../../../../app/shared/animations/app_animations.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

class StudentListBanner extends StatelessWidget {
  final int totalStudents;

  const StudentListBanner({super.key, required this.totalStudents});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(28.r),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : colorScheme.primary,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 24.r,
              offset: Offset(0, 8.h),
            ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.groups,
              size: 100.r,
              color: colorScheme.onPrimary.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.total_enrolled.tr(),
                style: textTheme.titleLarge?.copyWith(
                  color: isDark
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedCounter(
                value: totalStudents,
                style: textTheme.displayMedium?.copyWith(
                  color: isDark ? colorScheme.onSurface : colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animateSpringEntrance();
  }
}
