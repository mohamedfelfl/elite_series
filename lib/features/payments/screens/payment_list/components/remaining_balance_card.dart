import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/shared/animations/animated_counter.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

class RemainingBalanceCard extends StatelessWidget {
  final double remaining;

  const RemainingBalanceCard({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textTheme = theme.textTheme;

    // Exact colors from Stitch Design Theme
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final primaryContainerColor = theme.colorScheme.surfaceContainerLow;
    final onPrimaryContainerColor = theme.colorScheme.onTertiaryContainer;
    final errorColor = theme.colorScheme.error;

    return Container(
      padding: EdgeInsets.all(40.r),
      decoration: BoxDecoration(
        color: primaryContainerColor,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: primaryColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: primaryColor,
                    size: 36.r,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    child: Text(
                      'المستحق حالياً',
                      style: textTheme.labelMedium?.copyWith(
                        color: onPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                LocaleKeys.remaining_balance.tr(),
                style: textTheme.bodyLarge?.copyWith(
                  color: onPrimaryContainerColor.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: 8.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedCounter(
                  value: remaining,
                  prefix: '${LocaleKeys.currency_symbol.tr()} ',
                  fractionDigits: 2,
                  style: textTheme.displayLarge?.copyWith(
                    color: onPrimaryContainerColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, color: errorColor, size: 20.r),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'يرجى السداد قبل الموعد النهائي لتجنب الغرامات',
                  style: textTheme.bodyMedium?.copyWith(
                    color: errorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
