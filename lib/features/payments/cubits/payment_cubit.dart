import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';

part 'payment_cubit.freezed.dart';

@freezed
abstract class PaymentState with _$PaymentState {
  const factory PaymentState({
    @Default([]) List<Map<String, dynamic>> payments,
    @Default([]) List<Map<String, dynamic>> dailyPayments,
    @Default(false) bool isLoading,
    @Default(0.0) double totalSurplus,
    String? error,
  }) = _PaymentState;
}

class PaymentCubit extends Cubit<PaymentState> {
  final DatabaseService _databaseService;

  PaymentCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const PaymentState());

  /// Load payments for a specific student.
  Future<void> loadPayments(int studentId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.query(
        DBQueries.tablePayments,
        where: 'student_id = ?',
        whereArgs: <Object?>[studentId],
        orderBy: 'year DESC, month DESC',
      );

      // Calculate total surplus (carry-forward) for this student
      final double surplus = _calculateTotalSurplus(results);

      emit(
        state.copyWith(
          payments: results,
          totalSurplus: surplus,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Adds a new payment transaction. Each call creates a new record.
  Future<void> addPaymentTransaction({
    required int studentId,
    required int month,
    required int year,
    required double totalAmount,
    required double paidAmount,
  }) async {
    try {
      final Database db = await _databaseService.database;

      await db.insert(DBQueries.tablePayments, <String, Object?>{
        'student_id': studentId,
        'month': month,
        'year': year,
        'total_amount': totalAmount,
        'paid_amount': paidAmount,
        'paid_date': DateTime.now().toIso8601String(),
      });

      await loadPayments(studentId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadDailyPayments(DateTime date) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final String dateStr = date.toIso8601String().split('T')[0];

      final List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.loadDailyPaymentsBase,
        ['$dateStr%'],
      );

      emit(state.copyWith(dailyPayments: results, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> updatePayment(int id, Map<String, dynamic> data) async {
    try {
      final Database db = await _databaseService.database;
      await db.update(
        DBQueries.tablePayments,
        data,
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );

      // Reload for the student
      final Object? studentId = data['student_id'];
      if (studentId != null) await loadPayments(studentId as int);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deletePayment(int id, int studentId) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(DBQueries.tablePayments, where: 'id = ?', whereArgs: <Object?>[id]);
      await loadPayments(studentId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  double _calculateTotalSurplus(List<Map<String, Object?>> payments) {
    if (payments.isEmpty) return 0;

    // Group payments by month and year
    final Map<String, double> monthlyPaid = {};
    final Map<String, double> monthlyTotal = {};

    for (final Map<String, Object?> p in payments) {
      final String key = '${p['year']}_${p['month']}';
      final double paid = (p['paid_amount'] as num).toDouble();
      final double total = (p['total_amount'] as num).toDouble();

      monthlyPaid[key] = (monthlyPaid[key] ?? 0) + paid;
      // We assume total_amount is the same for all records of the same month
      monthlyTotal[key] = total;
    }

    double surplus = 0;
    for (final String key in monthlyPaid.keys) {
      final double paid = monthlyPaid[key]!;
      final double total = monthlyTotal[key]!;
      if (paid > total) {
        surplus += (paid - total);
      }
    }
    return surplus;
  }
}
