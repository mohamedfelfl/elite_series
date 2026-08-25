import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../app/shared/animations/app_animations.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/dashboard_cubit.dart';
import 'banner_stat.dart';

/// Welcome banner with stats overview on the dashboard.
class PremiumBanner extends StatelessWidget {
  final DashboardState state;
  final String username;

  const PremiumBanner({
    super.key,
    required this.state,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimens.p28),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.primary,
        borderRadius: BorderRadius.circular(AppDimens.r28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: AppDimens.r24,
            offset: Offset(0, AppDimens.h8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.welcome_admin
                .tr()
                .replaceAll('المسؤول', username)
                .replaceAll('Admin', username),
            textAlign: TextAlign.start,
            style: textTheme.titleMedium?.copyWith(
              color: isDark
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: AppDimens.h8),
          Text(
            LocaleKeys.center_overview.tr(),
            textAlign: TextAlign.start,
            style: textTheme.headlineMedium?.copyWith(
              color: isDark
                  ? colorScheme.onSurface
                  : colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.h24),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BannerStat(
                  label: LocaleKeys.total_students.tr(),
                  value: state.totalStudents,
                  isDark: isDark,
                ),
                _buildSeparator(colorScheme, isDark),
                BannerStat(
                  label: LocaleKeys.total_groups.tr(),
                  value: state.totalGroups,
                  isDark: isDark,
                ),
                _buildSeparator(colorScheme, isDark),
                BannerStat(
                  label: LocaleKeys.attendance_rate.tr(),
                  value: state.attendanceRate.round(),
                  isDark: isDark,
                ),
                _buildSeparator(colorScheme, isDark),
                BannerStat(
                  label: LocaleKeys.payments_tracking.tr(),
                  value: state.paymentCollectionRate.round(),
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animateSpringEntrance();
  }

  Widget _buildSeparator(ColorScheme colorScheme, bool isDark) {
    return Container(
      height: AppDimens.h32,
      width: 1.5,
      margin: EdgeInsets.symmetric(horizontal: AppDimens.w12),
      decoration: BoxDecoration(
        color: (isDark ? colorScheme.onSurface : colorScheme.onPrimary)
            .withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
