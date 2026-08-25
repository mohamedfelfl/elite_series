import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, dynamic> payment;
  final bool isFullyPaidMonth;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.payment,
    required this.isFullyPaidMonth,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final paid = (payment['paid_amount'] as num).toDouble();
    final isPaid = isFullyPaidMonth;

    final months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    final monthName = payment['month'] >= 1 && payment['month'] <= 12
        ? months[payment['month']]
        : payment['month'].toString();

    return InkWell(
      onTap: onTap,
      hoverColor: colorScheme.primary.withValues(alpha: 0.05),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Date / Month
            Expanded(
              flex: 2,
              child: Text(
                '$monthName ${payment['year']}',
                textAlign: TextAlign.start,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // 2. Description
            Expanded(
              flex: 3,
              child: Text(
                LocaleKeys.semester_fee.tr(args: ['']),
                textAlign: TextAlign.start,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 3. Total Amount
            Expanded(
              flex: 2,
              child: Text(
                '${LocaleKeys.currency_symbol.tr()} ${NumberFormat('#,##0.00').format((payment['total_amount'] as num).toDouble())}',
                textAlign: TextAlign.start,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // 4. Paid Amount
            Expanded(
              flex: 2,
              child: Text(
                '${LocaleKeys.currency_symbol.tr()} ${NumberFormat('#,##0.00').format(paid)}',
                textAlign: TextAlign.start,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            // 4. Status
            Expanded(
              flex: 2,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isPaid
                          ? Colors.green.withValues(alpha: 0.3)
                          : Colors.orange.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPaid ? Icons.check_circle_rounded : Icons.pending_rounded,
                        color: isPaid
                            ? Colors.green.shade700
                            : Colors.orange.shade800,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isPaid ? 'مكتمل' : 'غير مكتمل',
                        style: textTheme.bodyLarge?.copyWith(
                          color: isPaid
                              ? Colors.green.shade700
                              : Colors.orange.shade800,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 5. Actions
            SizedBox(
              width: 48,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  iconSize: 20,
                  color: colorScheme.error.withValues(alpha: 0.8),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: onDelete,
                  style: IconButton.styleFrom(
                    hoverColor: colorScheme.error.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
