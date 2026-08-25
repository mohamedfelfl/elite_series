import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/constants/dimens.dart';
import '../../../../../app/shared/animations/animated_counter.dart';

class BannerStat extends StatelessWidget {
  final String label;
  final num value;
  final bool isDark;

  const BannerStat({
    required this.label,
    required this.value,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedCounter(
          value: value,
          style: textTheme.headlineSmall?.copyWith(
            color: isDark ? colorScheme.onSurface : colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 8.sp,
          ),
        ),
        SizedBox(height: AppDimens.h4),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: isDark
                ? colorScheme.onSurfaceVariant
                : colorScheme.onPrimary.withValues(alpha: 0.8),
            fontSize: 6.sp,
          ),
        ),
      ],
    );
  }
}
