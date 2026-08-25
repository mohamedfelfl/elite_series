import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/locale_keys.g.dart';
import 'transaction_tile.dart';

/// Container for the transactions table with filter functionality.
class TransactionListSection extends StatelessWidget {
  final List<Map<String, dynamic>> allPayments;
  final List<Map<String, dynamic>> filteredPayments;
  final Map<String, double> monthlyPaid;
  final Map<String, double> monthlyDue;
  final bool isFiltering;
  final TextEditingController filterController;
  final VoidCallback onToggleFilter;
  final VoidCallback onFilterChanged;
  final void Function(Map<String, dynamic> payment) onTapPayment;
  final void Function(Map<String, dynamic> payment) onDeletePayment;

  const TransactionListSection({
    super.key,
    required this.allPayments,
    required this.filteredPayments,
    required this.monthlyPaid,
    required this.monthlyDue,
    required this.isFiltering,
    required this.filterController,
    required this.onToggleFilter,
    required this.onFilterChanged,
    required this.onTapPayment,
    required this.onDeletePayment,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.transaction_record.tr(),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: onToggleFilter,
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: Text(LocaleKeys.filter.tr()),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isFiltering)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w)
                  .copyWith(bottom: 16.h),
              child: TextField(
                controller: filterController,
                onChanged: (_) => onFilterChanged(),
                decoration: InputDecoration(
                  hintText: LocaleKeys.search_payment_hint.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
          if (allPayments.isEmpty)
            Padding(
              padding: EdgeInsets.all(48.r),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48.r,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    LocaleKeys.no_transactions.tr(),
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (ctx, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth > 800
                      ? constraints.maxWidth
                      : 800,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Table Header
                      _buildTableHeader(textTheme, colorScheme),
                      if (filteredPayments.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(32.r),
                          child: Center(
                            child: Text(
                              LocaleKeys.no_results_found.tr(),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredPayments.length,
                          itemBuilder: (context, i) {
                            final p = filteredPayments[i];
                            final key = "${p['month']}-${p['year']}";
                            final isMonthPaid =
                                (monthlyPaid[key] ?? 0) >=
                                (monthlyDue[key] ?? 0);
                            return TransactionTile(
                              payment: p,
                              isFullyPaidMonth: isMonthPaid,
                              onTap: () => onTapPayment(p),
                              onDelete: () => onDeletePayment(p),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _headerCell(LocaleKeys.date_month.tr(), 2, textTheme, colorScheme),
          _headerCell(LocaleKeys.description.tr(), 3, textTheme, colorScheme),
          _headerCell(LocaleKeys.total_amount.tr(), 2, textTheme, colorScheme),
          _headerCell(LocaleKeys.paid_amount.tr(), 2, textTheme, colorScheme),
          _headerCell(LocaleKeys.status.tr(), 2, textTheme, colorScheme),
          const SizedBox(width: 48), // actions spacing
        ],
      ),
    );
  }

  Widget _headerCell(
    String text,
    int flex,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
