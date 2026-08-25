
import 'package:flutter/material.dart';

import '../../../../../app/constants/dimens.dart';

import '../../../models/attendance.dart';

/// A card showing a recent scan result with student name, date, and status badge.
class RecentScanCard extends StatelessWidget {
  final String name;
  final String time;
  final String status;
  final String statusKey;

  const RecentScanCard({
    super.key,
    required this.name,
    required this.time,
    required this.status,
    required this.statusKey,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSuccess = statusKey == AttendanceStatus.attended.name;

    Color badgeColor;
    if (statusKey == AttendanceStatus.attended.name) {
      badgeColor = Colors.green;
    } else if (statusKey == AttendanceStatus.missed.name) {
      badgeColor = Colors.red;
    } else {
      badgeColor = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.all(AppDimens.p16),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.p8),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.check_circle_outline : Icons.info_outline,
              color: badgeColor,
              size: AppDimens.iconSize24,
            ),
          ),
          SizedBox(width: AppDimens.w16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w12,
              vertical: AppDimens.h4,
            ),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimens.r20),
              border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              status,
              style: textTheme.labelSmall?.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
