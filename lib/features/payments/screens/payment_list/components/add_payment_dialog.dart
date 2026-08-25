import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/payment_cubit.dart';

/// Shows the Add Payment dialog.
void showAddPaymentDialog({
  required BuildContext context,
  required Map<String, Object?> selectedStudent,
}) {
  final totalController = TextEditingController();
  final paidController = TextEditingController();

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final payments = context.read<PaymentCubit>().state.payments;

  List<Map<String, dynamic>> findMonthlyPayments(int m, int y) {
    return payments.where((p) => p['month'] == m && p['year'] == y).toList();
  }

  void updateControllers(int m, int y) {
    final monthlyResults = findMonthlyPayments(m, y);
    if (monthlyResults.isNotEmpty) {
      totalController.text = monthlyResults.first['total_amount'].toString();
      paidController.clear();
    } else {
      totalController.clear();
      paidController.clear();
    }
  }

  // Initialize for current month/year
  updateControllers(selectedMonth, selectedYear);
  String? errorMessage;

  showDialog(
    context: context,
    builder: (BuildContext ctx) => StatefulBuilder(
      builder: (BuildContext ctx, StateSetter setDialogState) {
        final monthlyResults = findMonthlyPayments(
          selectedMonth,
          selectedYear,
        );
        final bool exists = monthlyResults.isNotEmpty;
        final double existingTotal = exists
            ? (monthlyResults.first['total_amount'] as num).toDouble()
            : 0.0;
        final double existingPaid = monthlyResults.fold(
          0.0,
          (sum, p) => sum + (p['paid_amount'] as num).toDouble(),
        );
        final bool isFullyPaid = exists && existingPaid >= existingTotal;
        final colorScheme = Theme.of(ctx).colorScheme;
        final textTheme = Theme.of(ctx).textTheme;

        final defaultInputDeco = InputDecoration(
          filled: true,
          fillColor: colorScheme.surfaceContainerHigh,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        );

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.all(24.r),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(40.r),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            LocaleKeys.new_transaction.tr(),
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerHigh,
                            padding: EdgeInsets.all(12.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),

                  // Body
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.month.tr(),
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  DropdownButtonFormField<int>(
                                    initialValue: selectedMonth,
                                    isExpanded: true,
                                    decoration: defaultInputDeco,
                                    items: List.generate(
                                      12,
                                      (int i) => DropdownMenuItem<int>(
                                        value: i + 1,
                                        child: Text('${i + 1}'),
                                      ),
                                    ),
                                    onChanged: (int? v) {
                                      setDialogState(() {
                                        selectedMonth = v!;
                                        errorMessage = null;
                                        updateControllers(
                                          selectedMonth,
                                          selectedYear,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.year.tr(),
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  DropdownButtonFormField<int>(
                                    initialValue: selectedYear,
                                    isExpanded: true,
                                    decoration: defaultInputDeco,
                                    items: List.generate(
                                      5,
                                      (int i) => DropdownMenuItem<int>(
                                        value: DateTime.now().year + i - 1,
                                        child: Text(
                                          '${DateTime.now().year + i - 1}',
                                        ),
                                      ),
                                    ),
                                    onChanged: (int? v) {
                                      setDialogState(() {
                                        selectedYear = v!;
                                        errorMessage = null;
                                        updateControllers(
                                          selectedMonth,
                                          selectedYear,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        if (exists) ...[
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: isFullyPaid
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isFullyPaid
                                    ? Colors.green.withValues(alpha: 0.3)
                                    : Colors.orange.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isFullyPaid
                                          ? Icons.check_circle
                                          : Icons.warning_amber_rounded,
                                      color: isFullyPaid
                                          ? Colors.green
                                          : Colors.orange,
                                      size: 20.r,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      isFullyPaid
                                          ? LocaleKeys.month_completed.tr()
                                          : LocaleKeys.existing_payment_found
                                              .tr(),
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isFullyPaid
                                            ? Colors.green.shade700
                                            : Colors.orange.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Total: ${LocaleKeys.currency_symbol.tr()} ${existingTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Paid: ${LocaleKeys.currency_symbol.tr()} ${existingPaid.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.total_amount.tr(),
                              style: textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: exists
                                    ? colorScheme.onSurfaceVariant.withValues(
                                        alpha: 0.5,
                                      )
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              controller: totalController,
                              readOnly: exists,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              decoration: defaultInputDeco.copyWith(
                                hintText: '0.00',
                                prefixIcon: const Icon(
                                  Icons.payments_outlined,
                                ),
                                suffixIcon: exists
                                    ? Tooltip(
                                        message: LocaleKeys.total_lock_tooltip
                                            .tr(),
                                        child: Icon(
                                          Icons.lock_outline,
                                          color: colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.5),
                                        ),
                                      )
                                    : null,
                                filled: true,
                                fillColor: exists
                                    ? colorScheme.surfaceContainerHighest
                                    : colorScheme.surfaceContainerHigh,
                              ),
                            ),
                            if (exists)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 6.h,
                                  right: 4.w,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 13,
                                      color: colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.6),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      LocaleKeys.uses_prev_month_total.tr(),
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        if (isFullyPaid)
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: colorScheme.error,
                                  size: 20.r,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    LocaleKeys.month_already_paid.tr(),
                                    style: TextStyle(
                                      color: colorScheme.error,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.paid_amount_extra.tr(),
                                style: textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextField(
                                controller: paidController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                decoration: defaultInputDeco.copyWith(
                                  errorText: errorMessage,
                                  hintText: '0.00',
                                  prefixIcon: const Icon(Icons.payment),
                                  helperText: exists
                                      ? 'Remaining: ${LocaleKeys.currency_symbol.tr()} ${(existingTotal - existingPaid).clamp(0.0, double.infinity).toStringAsFixed(2)}'
                                      : null,
                                ),
                              ),
                            ],
                          ),

                        SizedBox(height: 48.h),

                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: isFullyPaid
                                    ? null
                                    : () {
                                        final total =
                                            double.tryParse(
                                              totalController.text,
                                            ) ??
                                            0;
                                        final paid =
                                            double.tryParse(
                                              paidController.text,
                                            ) ??
                                            0;

                                        if (total > 0) {
                                          if ((existingPaid + paid) > total) {
                                            setDialogState(() {
                                              errorMessage = LocaleKeys
                                                  .cannot_pay_more_than_total
                                                  .tr();
                                            });
                                            return;
                                          }

                                          context
                                              .read<PaymentCubit>()
                                              .addPaymentTransaction(
                                                studentId:
                                                    selectedStudent['id']
                                                        as int,
                                                month: selectedMonth,
                                                year: selectedYear,
                                                totalAmount: total,
                                                paidAmount: paid,
                                              );
                                          Navigator.pop(ctx);
                                        }
                                      },
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 24.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys.save_transaction.tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: FilledButton.tonal(
                                onPressed: () => Navigator.pop(ctx),
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      colorScheme.surfaceContainerHighest,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 24.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys.cancel.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
