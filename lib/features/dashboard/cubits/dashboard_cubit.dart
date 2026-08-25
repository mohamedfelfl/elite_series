import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';

part 'dashboard_cubit.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(0) int totalStudents,
    @Default(0) int totalGroups,
    @Default(0) int totalAssistants,
    @Default(0) int totalExams,
    @Default(0.0) double attendanceRate,
    @Default(0.0) double paymentCollectionRate,
    @Default(0) int upcomingExams,
    @Default([]) List<Map<String, dynamic>> recentAttendance,
    @Default([]) List<Map<String, dynamic>> recentPayments,
    @Default(false) bool isLoading,
    String? error,
  }) = _DashboardState;
}

class DashboardCubit extends Cubit<DashboardState> {
  final DatabaseService _databaseService;

  DashboardCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const DashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final db = await _databaseService.database;

      // Total students
      final studentCount =
          Sqflite.firstIntValue(
            await db.rawQuery(DBQueries.countStudents),
          ) ??
          0;

      // Total groups
      final groupCount =
          Sqflite.firstIntValue(
            await db.rawQuery(DBQueries.countGroups),
          ) ??
          0;

      // Total assistants
      final assistantCount =
          Sqflite.firstIntValue(
            await db.rawQuery(DBQueries.countAssistants),
          ) ??
          0;

      // Total exams
      final examCount =
          Sqflite.firstIntValue(
            await db.rawQuery(DBQueries.countExams),
          ) ??
          0;

      // Attendance rate (last 30 days)
      final today = DateTime.now();
      final thirtyDaysAgo = today.subtract(const Duration(days: 30));
      final attendanceStats = await db.rawQuery(
        DBQueries.dashboardAttendanceStats,
        [thirtyDaysAgo.toIso8601String().split('T').first],
      );

      double attendanceRate = 0;
      if (attendanceStats.isNotEmpty) {
        final total = (attendanceStats.first['total'] as num?)?.toDouble() ?? 0;
        final attended =
            (attendanceStats.first['attended'] as num?)?.toDouble() ?? 0;
        if (total > 0) attendanceRate = (attended / total) * 100;
      }

      // Payment collection rate (current month)
      final paymentStats = await db.rawQuery(
        DBQueries.dashboardPaymentStats,
        [today.month, today.year],
      );

      double paymentRate = 0;
      if (paymentStats.isNotEmpty) {
        final totalDue =
            (paymentStats.first['total_due'] as num?)?.toDouble() ?? 0;
        final totalPaid =
            (paymentStats.first['total_paid'] as num?)?.toDouble() ?? 0;
        if (totalDue > 0) paymentRate = (totalPaid / totalDue) * 100;
      }

      // Upcoming exams
      final upcomingExamCount =
          Sqflite.firstIntValue(
            await db.rawQuery(DBQueries.dashboardUpcomingExams, [
              today.toIso8601String().split('T').first,
            ]),
          ) ??
          0;

      // Recent attendance (last 5)
      final recentAttendance = await db.rawQuery(DBQueries.dashboardRecentAttendance);

      // Recent payments (last 5)
      final recentPayments = await db.rawQuery(DBQueries.dashboardRecentPayments);

      emit(
        state.copyWith(
          totalStudents: studentCount,
          totalGroups: groupCount,
          totalAssistants: assistantCount,
          totalExams: examCount,
          attendanceRate: attendanceRate,
          paymentCollectionRate: paymentRate,
          upcomingExams: upcomingExamCount,
          recentAttendance: recentAttendance,
          recentPayments: recentPayments,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
