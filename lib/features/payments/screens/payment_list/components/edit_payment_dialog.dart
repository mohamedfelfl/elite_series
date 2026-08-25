import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/payment_cubit.dart';

/// Shows the Edit Payment dialog.
void showEditPaymentDialog({
  required BuildContext context,
  required Map<String, dynamic> payment,
  required Map<String, Object?> selectedStudent,
}) {
  final totalController = TextEditingController(
    text: payment['total_amount'].toString(),
  );
  final paidController = TextEditingController(
    text: payment['paid_amount'].toString(),
  );
  final int paymentId = payment['id'] as int;
  String? errorMessage;

  showDialog(
    context: context,
    builder: (BuildContext ctx) => StatefulBuilder(
      builder: (BuildContext ctx, StateSetter setDialogState) {
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
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            LocaleKeys.edit_transaction.tr(),
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
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: colorScheme.primary.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: colorScheme.primary,
                                size: 20.r,
                              ),
                              SizedBox(width: 12.w),
                              Flexible(
                                child: Text(
                                  LocaleKeys.semester_fee.tr(
                                    args: [
                                      '${payment['month']}/${payment['year']}',
                                    ],
                                  ),
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.total_amount.tr(),
                              style: textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              controller: totalController,
                              readOnly: true,
                              decoration: defaultInputDeco.copyWith(
                                hintText: '0.00',
                                prefixIcon: const Icon(
                                  Icons.payments_outlined,
                                ),
                                suffixIcon: Icon(
                                  Icons.lock_outline,
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.5),
                                ),
                                filled: true,
                                fillColor:
                                    colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${LocaleKeys.paid_amount.tr()} (${LocaleKeys.currency_symbol.tr()})',
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
                              onChanged: (_) {
                                if (errorMessage != null) {
                                  setDialogState(() => errorMessage = null);
                                }
                              },
                              decoration: defaultInputDeco.copyWith(
                                errorText: errorMessage,
                                hintText: '0.00',
                                prefixIcon: const Icon(Icons.payment),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 48.h),

                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  final total =
                                      double.tryParse(totalController.text) ??
                                      0;
                                  final paid =
                                      double.tryParse(paidController.text) ??
                                      0;

                                  if (total > 0 && paid >= 0) {
                                    final payments = context
                                        .read<PaymentCubit>()
                                        .state
                                        .payments;
                                    final month = payment['month'];
                                    final year = payment['year'];
                                    final monthlyPayments = payments
                                        .where(
                                          (p) =>
                                              p['month'] == month &&
                                              p['year'] == year,
                                        )
                                        .toList();
                                    final double existingPaid =
                                        monthlyPayments.fold(
                                      0.0,
                                      (sum, p) =>
                                          sum +
                                          (p['paid_amount'] as num)
                                              .toDouble(),
                                    );
                                    final double currentPaymentPaid =
                                        (payment['paid_amount'] as num)
                                            .toDouble();
                                    final double otherPaid =
                                        existingPaid - currentPaymentPaid;

                                    if ((otherPaid + paid) > total) {
                                      setDialogState(() {
                                        errorMessage = LocaleKeys
                                            .cannot_pay_more_than_total
                                            .tr();
                                      });
                                      return;
                                    }

                                    context
                                        .read<PaymentCubit>()
                                        .updatePayment(paymentId, {
                                          'total_amount': total,
                                          'paid_amount': paid,
                                          'student_id':
                                              selectedStudent['id'],
                                        });
                                    Navigator.pop(ctx);
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 24.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      100.r,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys.save_changes.tr(),
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
                                    borderRadius: BorderRadius.circular(
                                      100.r,
                                    ),
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

/// Shows the delete payment confirmation dialog.
void showDeletePaymentDialog({
  required BuildContext context,
  required Map<String, dynamic> payment,
  required int studentId,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      title: Text(
        LocaleKeys.delete.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(LocaleKeys.delete_payment_confirm.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(LocaleKeys.cancel.tr()),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            context.read<PaymentCubit>().deletePayment(
              payment['id'] as int,
              studentId,
            );
            Navigator.pop(ctx);
          },
          child: Text(LocaleKeys.delete.tr()),
        ),
      ],
    ),
  );
}
