import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/locale_keys.g.dart';

/// Header area showing selected student info with add/close actions.
class PaymentHeader extends StatelessWidget {
  final Map<String, Object?> selectedStudent;
  final double totalPaid;
  final double totalDue;
  final VoidCallback onAddPayment;
  final VoidCallback onClose;

  const PaymentHeader({
    super.key,
    required this.selectedStudent,
    required this.totalPaid,
    required this.totalDue,
    required this.onAddPayment,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isFree = selectedStudent['student_status'] == 'free';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedStudent['name'] as String? ?? 'N/A',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                LocaleKeys.total_payments.tr(
                  args: [
                    NumberFormat('#,##0').format(totalPaid),
                    NumberFormat('#,##0').format(totalDue),
                  ],
                ),
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (!isFree)
          ElevatedButton.icon(
            onPressed: onAddPayment,
            icon: const Icon(Icons.add),
            label: Text(LocaleKeys.add_record.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.r),
              ),
              elevation: 4,
            ),
          ),
        SizedBox(width: 8.w),
        IconButton.filledTonal(
          icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
          onPressed: onClose,
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
