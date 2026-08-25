import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_management_system/features/students/cubits/student_cubit.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/payment_cubit.dart';
import 'components/add_payment_dialog.dart';
import 'components/edit_payment_dialog.dart';
import 'components/free_student_warning.dart';
import 'components/payment_header.dart';
import 'components/payment_stats_card.dart';
import 'components/remaining_balance_card.dart';
import 'components/student_search_section.dart';
import 'components/transaction_list_section.dart';

@RoutePage()
class PaymentListScreen extends StatefulWidget {
  final int? studentId;
  const PaymentListScreen({super.key, @QueryParam('studentId') this.studentId});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  bool _isFiltering = false;
  Map<String, Object?>? _selectedStudent;

  @override
  void initState() {
    super.initState();
    context.read<StudentCubit>().loadStudents();
    // Auto-select student if navigated with a studentId
    if (widget.studentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final student = await context.read<StudentCubit>().getStudentById(
          widget.studentId!,
        );
        if (student != null && mounted) {
          setState(() => _selectedStudent = student);
          context.read<PaymentCubit>().loadPayments(widget.studentId!);
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: context.router.canPop()
          ? AppBar(
              title: Text(
                LocaleKeys.payments_tracking.tr(),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Column(
            children: [
              if (_selectedStudent == null)
                Expanded(
                  child: StudentSearchSection(
                    searchController: _searchController,
                    onStudentSelected: (s) =>
                        setState(() => _selectedStudent = s),
                  ),
                )
              else
                Expanded(
                  child: BlocBuilder<PaymentCubit, PaymentState>(
                    builder: (BuildContext context, PaymentState state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Calculate totals from student's payments
                      final totals = _calculateTotals(state.payments);

                      final List<Map<String, dynamic>>
                      filteredPayments = _filterPayments(state.payments);

                      final double progress = totals.totalDue > 0
                          ? (totals.totalPaid / totals.totalDue)
                              .clamp(0.0, 1.0)
                          : 0.0;

                      final bool isFree =
                          _selectedStudent!['student_status'] == 'free';

                      return RefreshIndicator(
                        onRefresh: () => context
                            .read<PaymentCubit>()
                            .loadPayments(_selectedStudent!['id'] as int),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              PaymentHeader(
                                selectedStudent: _selectedStudent!,
                                totalPaid: totals.totalPaid,
                                totalDue: totals.totalDue,
                                onAddPayment: () => showAddPaymentDialog(
                                  context: context,
                                  selectedStudent: _selectedStudent!,
                                ),
                                onClose: () =>
                                    setState(() => _selectedStudent = null),
                              ),
                              SizedBox(height: 32.h),

                              if (isFree) ...[
                                const FreeStudentWarning(),
                                SizedBox(height: 16.h),
                              ] else ...[
                                // Bento Grid Style
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    if (constraints.maxWidth > 800) {
                                      return IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: PaymentStatsCard(
                                                progress: progress,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Expanded(
                                              child: RemainingBalanceCard(
                                                remaining: totals.remaining,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          PaymentStatsCard(progress: progress),
                                          SizedBox(height: 16.h),
                                          RemainingBalanceCard(
                                            remaining: totals.remaining,
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 32.h),

                                TransactionListSection(
                                  allPayments: state.payments,
                                  filteredPayments: filteredPayments,
                                  monthlyPaid: totals.monthlyPaid,
                                  monthlyDue: totals.monthlyDue,
                                  isFiltering: _isFiltering,
                                  filterController: _filterController,
                                  onToggleFilter: () {
                                    setState(() {
                                      _isFiltering = !_isFiltering;
                                      if (!_isFiltering) {
                                        _filterController.clear();
                                      }
                                    });
                                  },
                                  onFilterChanged: () => setState(() {}),
                                  onTapPayment: (p) =>
                                      showEditPaymentDialog(
                                        context: context,
                                        payment: p,
                                        selectedStudent: _selectedStudent!,
                                      ),
                                  onDeletePayment: (p) =>
                                      showDeletePaymentDialog(
                                        context: context,
                                        payment: p,
                                        studentId:
                                            _selectedStudent!['id'] as int,
                                      ),
                                ),
                              ],
                              SizedBox(height: 48.h),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _PaymentTotals _calculateTotals(List<Map<String, dynamic>> payments) {
    Map<String, double> monthlyDue = {};
    Map<String, double> monthlyPaid = {};
    double totalPaid = 0;
    for (Map<String, Object?> p in payments) {
      final key = "${p['month']}-${p['year']}";
      monthlyDue[key] = (p['total_amount'] as num).toDouble();
      monthlyPaid[key] =
          (monthlyPaid[key] ?? 0) + (p['paid_amount'] as num).toDouble();
      totalPaid += (p['paid_amount'] as num).toDouble();
    }
    double totalDue = monthlyDue.values.fold(0.0, (sum, val) => sum + val);
    double remaining = totalDue - totalPaid;
    if (remaining < 0) remaining = 0;

    return _PaymentTotals(
      totalPaid: totalPaid,
      totalDue: totalDue,
      remaining: remaining,
      monthlyDue: monthlyDue,
      monthlyPaid: monthlyPaid,
    );
  }

  List<Map<String, dynamic>> _filterPayments(
    List<Map<String, dynamic>> payments,
  ) {
    return payments.where((p) {
      if (!_isFiltering || _filterController.text.trim().isEmpty) {
        return true;
      }
      final query = _filterController.text.toLowerCase().trim();
      final desc =
          '#${p['id']} - ${LocaleKeys.semester_fee.tr(args: ['${p['month']}/${p['year']}'])}'
              .toLowerCase();
      final amount = p['total_amount'].toString();
      final paid = p['paid_amount'].toString();
      return desc.contains(query) ||
          amount.contains(query) ||
          paid.contains(query) ||
          p['month'].toString() == query ||
          p['year'].toString() == query;
    }).toList();
  }
}

class _PaymentTotals {
  final double totalPaid;
  final double totalDue;
  final double remaining;
  final Map<String, double> monthlyDue;
  final Map<String, double> monthlyPaid;

  _PaymentTotals({
    required this.totalPaid,
    required this.totalDue,
    required this.remaining,
    required this.monthlyDue,
    required this.monthlyPaid,
  });
}
