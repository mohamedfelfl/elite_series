import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../app/router/app_router.gr.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../payments/cubits/payment_cubit.dart';

class PaymentsTab extends StatelessWidget {
  final int studentId;
  final String studentStatus;

  const PaymentsTab({
    super.key,
    required this.studentId,
    required this.studentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Navigate to full payment screen button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                onPressed: () =>
                    context.router.push(PaymentListRoute(studentId: studentId)),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: Text(LocaleKeys.payments_tracking.tr()),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final bool isFree = studentStatus == 'free';

              if (state.payments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFree ? Icons.info_outline : Icons.payments_outlined,
                        size: 64,
                        color: isFree
                            ? colorScheme.error.withValues(alpha: 0.5)
                            : colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          isFree
                              ? LocaleKeys.payment_disabled_free_student.tr()
                              : LocaleKeys.no_payment_records.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: isFree
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                                fontWeight: isFree ? FontWeight.bold : null,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Group payments by month/year and sum paid amounts,
              // so the remaining matches the full payment screen's calculation.
              final Map<String, Map<String, dynamic>> grouped = {};
              for (final p in state.payments) {
                final key = '${p['year']}_${p['month']}';
                if (!grouped.containsKey(key)) {
                  grouped[key] = {
                    'month': p['month'],
                    'year': p['year'],
                    'total_amount': (p['total_amount'] as num).toDouble(),
                    'total_paid': 0.0,
                  };
                }
                grouped[key]!['total_paid'] =
                    (grouped[key]!['total_paid'] as double) +
                    (p['paid_amount'] as num).toDouble();
              }

              final groupedList = grouped.values.toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: groupedList.length,
                itemBuilder: (context, i) {
                  final p = groupedList[i];
                  final double total = p['total_amount'] as double;
                  final double paid = p['total_paid'] as double;
                  final double remaining = total - paid;
                  final bool isPaid = remaining <= 0;

                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${p['month']}/${p['year']}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: isDark
                                            ? Colors.white
                                            : colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  LocaleKeys.payment_summary.tr(
                                    args: [
                                      total.toStringAsFixed(2),
                                      paid.toStringAsFixed(2),
                                    ],
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: isDark
                                            ? Colors.white70
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(
                              isPaid
                                  ? LocaleKeys.paid.tr()
                                  : LocaleKeys.due_amount.tr(
                                      args: [remaining.toStringAsFixed(2)],
                                    ),
                              style: TextStyle(
                                color: isPaid ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
