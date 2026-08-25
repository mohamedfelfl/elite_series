import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/locale_keys.g.dart';

/// Warning banner shown when a student has 'free' status.
class FreeStudentWarning extends StatelessWidget {
  const FreeStudentWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              color: colorScheme.error,
              size: 28.r,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              LocaleKeys.payment_disabled_free_student.tr(),
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
