import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../../generated/locale_keys.g.dart';

import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';
import '../../../app/utils/time_helper.dart';
import '../models/attendance.dart';

part 'attendance_cubit.freezed.dart';

@freezed
abstract class AttendanceState with _$AttendanceState {
  const factory AttendanceState({
    @Default([]) List<Map<String, dynamic>> records,
    @Default(false) bool isLoading,
    @Default(false) bool scanSuccess,
    String? lastScannedStudent,
    String? error,
  }) = _AttendanceState;
}

class AttendanceCubit extends Cubit<AttendanceState> {
  final DatabaseService _databaseService;

  AttendanceCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const AttendanceState());

  /// Load attendance records for a student.
  Future<void> loadAttendance(int studentId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.loadStudentAttendance,
        [studentId],
      );
      emit(state.copyWith(records: results, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Load all attendance globally.
  Future<void> loadAllAttendance() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.loadAllAttendance,
      );
      emit(state.copyWith(records: results, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Load recent global scans for the scanner screen.
  Future<void> loadRecentScans({int? lessonId}) async {
    try {
      final Database db = await _databaseService.database;
      List<Map<String, Object?>> latestRecords;
      if (lessonId != null) {
        latestRecords = await db.rawQuery(
          '''
          SELECT a.*, s.name as student_name 
          FROM attendance a
          JOIN students s ON a.student_id = s.id
          WHERE a.lesson_id = ?
          ORDER BY a.id DESC LIMIT 10
        ''',
          [lessonId],
        );
      } else {
        latestRecords = await db.rawQuery(DBQueries.loadRecentScans);
      }
      emit(state.copyWith(records: latestRecords));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Record attendance via QR scan or manual ID entry.
  /// [serialNumber] is the student's serial number from the QR code.
  /// [lessonId] is the optional active lesson session ID.
  Future<void> recordAttendanceBySerial(
    String serialNumber, {
    int? lessonId,
    AttendanceStatus status = AttendanceStatus.attended,
    String notes = '',
  }) async {
    try {
      final Database db = await _databaseService.database;

      // Find student by serial number
      final List<Map<String, Object?>> students = await db.query(
        DBQueries.tableStudents,
        where: 'serial_number = ?',
        whereArgs: <Object?>[serialNumber.trim()],
      );

      if (students.isEmpty) {
        emit(
          state.copyWith(
            error: LocaleKeys.student_not_found_with_serial.tr(
              args: [serialNumber],
            ),
            scanSuccess: false,
          ),
        );
        return;
      }

      final Map<String, Object?> student = students.first;
      final int studentId = student['id'] as int;
      final String studentName = student['name'] as String;
      final int? studentGroupId = student['group_id'] as int?;
      final now = DateTime.now();
      final String currentDayName = DateFormat('EEEE', 'en_US').format(now);
      final String currentDayNameAr = _getArabicDayName(currentDayName);
      final String currentDayNameArAlt = currentDayNameAr
          .replaceAll('أ', 'ا')
          .replaceAll('إ', 'ا');
      final String today = now.toIso8601String().split('T').first;

      // Determine attendance status & notes
      AttendanceStatus finalStatus = status;
      String notesToInsert = notes;

      if (lessonId != null) {
        // Query lesson group
        final List<Map<String, Object?>> lessonRows = await db.query(
          DBQueries.tableLessons,
          where: 'id = ?',
          whereArgs: [lessonId],
        );

        if (lessonRows.isNotEmpty) {
          final int lessonGroupId = lessonRows.first['group_id'] as int;
          if (studentGroupId == lessonGroupId) {
            finalStatus = AttendanceStatus.attended;
            notesToInsert = LocaleKeys.attended_his_group.tr();
          } else {
            finalStatus = AttendanceStatus.otherLesson;
            final List<Map<String, Object?>> groupRow = await db.query(
              DBQueries.tableGroups,
              columns: ['name'],
              where: 'id = ?',
              whereArgs: [lessonGroupId],
            );
            final String groupName =
                groupRow.isNotEmpty ? (groupRow.first['name'] as String) : '';
            notesToInsert = LocaleKeys.attended_another_group.tr(
              args: [groupName],
            );
          }
        }

        // Check duplicate within the active lesson
        final List<Map<String, Object?>> existing = await db.query(
          DBQueries.tableAttendance,
          where: 'lesson_id = ? AND student_id = ?',
          whereArgs: <Object?>[lessonId, studentId],
        );

        if (existing.isNotEmpty) {
          emit(
            state.copyWith(
              error: LocaleKeys.already_attended_lesson.tr(args: [studentName]),
              scanSuccess: false,
            ),
          );
          return;
        }
      } else {
        // Fallback global daily check
        if (studentGroupId != null) {
          final List<Map<String, Object?>> groupSchedules = await db.query(
            DBQueries.tableGroupSchedules,
            where: 'group_id = ?',
            whereArgs: [studentGroupId],
          );

          final bool isStudentGroupDay = groupSchedules.any((s) {
            final day = s['day_of_week']?.toString() ?? '';
            return day == currentDayName ||
                day == currentDayNameAr ||
                day == currentDayNameArAlt;
          });

          if (isStudentGroupDay) {
            finalStatus = AttendanceStatus.attended;
            notesToInsert = LocaleKeys.attended_his_group.tr();
          } else {
            finalStatus = AttendanceStatus.otherLesson;
            final List<Map<String, Object?>> otherGroupsToday = await db
                .rawQuery(DBQueries.getGroupsToday, [
                  currentDayName,
                  currentDayNameAr,
                  currentDayNameArAlt,
                ]);

            if (otherGroupsToday.isNotEmpty) {
              final String groupName = _findClosestGroup(otherGroupsToday, now);
              notesToInsert = LocaleKeys.attended_another_group.tr(
                args: [groupName],
              );
            } else {
              finalStatus = AttendanceStatus.otherLesson;
              notesToInsert = '';
            }
          }
        } else {
          finalStatus = AttendanceStatus.attended;
          notesToInsert = LocaleKeys.attended_no_group.tr();
        }

        final List<Map<String, Object?>> existing = await db.query(
          DBQueries.tableAttendance,
          where: 'student_id = ? AND date = ? AND lesson_id IS NULL',
          whereArgs: <Object?>[studentId, today],
        );

        if (existing.isNotEmpty) {
          emit(
            state.copyWith(
              error: LocaleKeys.attendance_already_recorded_today.tr(
                args: [studentName],
              ),
              scanSuccess: false,
            ),
          );
          return;
        }
      }

      await db.insert(DBQueries.tableAttendance, <String, Object?>{
        'lesson_id': ?lessonId,
        'student_id': studentId,
        'date': today,
        'status': finalStatus.name,
        'notes': notesToInsert,
      });

      // Reload attendance history
      final List<Map<String, Object?>> latestRecords = lessonId != null
          ? await db.rawQuery(
              '''
              SELECT a.*, s.name as student_name 
              FROM attendance a
              JOIN students s ON a.student_id = s.id
              WHERE a.lesson_id = ?
              ORDER BY a.id DESC LIMIT 10
            ''',
              [lessonId],
            )
          : await db.rawQuery(DBQueries.loadRecentScans);

      emit(
        state.copyWith(
          records: latestRecords,
          scanSuccess: true,
          lastScannedStudent: studentName,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), scanSuccess: false));
    }
  }

  /// Add attendance manually for a specific student and date.
  Future<void> addAttendance({
    required int studentId,
    required DateTime date,
    required AttendanceStatus status,
    int? lessonId,
    String notes = '',
  }) async {
    try {
      final Database db = await _databaseService.database;
      await db.insert(DBQueries.tableAttendance, <String, Object?>{
        'lesson_id': ?lessonId,
        'student_id': studentId,
        'date': date.toIso8601String().split('T').first,
        'status': status.name,
        'notes': notes,
      });
      await loadAttendance(studentId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Update an existing attendance record.
  Future<void> updateAttendance(
    int id,
    AttendanceStatus status, {
    String? notes,
  }) async {
    try {
      final Database db = await _databaseService.database;
      final Map<String, Object?> updates = <String, Object?>{
        'status': status.name,
      };
      if (notes != null) updates['notes'] = notes;

      await db.update(
        DBQueries.tableAttendance,
        updates,
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteAttendance(int id, {int? studentId}) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(
        DBQueries.tableAttendance,
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
      if (studentId != null) {
        await loadAttendance(studentId);
      } else {
        await loadAllAttendance();
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void resetScanState() {
    emit(
      state.copyWith(scanSuccess: false, lastScannedStudent: null, error: null),
    );
  }

  String _findClosestGroup(
    List<Map<String, Object?>> groupsWithTimes,
    DateTime now,
  ) {
    String? closestGroupName;
    int minDifference = 999999999;

    for (final group in groupsWithTimes) {
      final String? timeStr = group['time'] as String?;
      final String name = group['name'] as String;

      if (timeStr == null || timeStr.isEmpty) {
        closestGroupName ??= name;
        continue;
      }

      final DateTime? parsedDate = _parseTimeToDateTime(timeStr, now);
      if (parsedDate != null) {
        final int diff =
            (parsedDate.millisecondsSinceEpoch - now.millisecondsSinceEpoch)
                .abs();
        if (diff < minDifference) {
          minDifference = diff;
          closestGroupName = name;
        }
      } else {
        closestGroupName ??= name;
      }
    }
    return closestGroupName ??
        (groupsWithTimes.isNotEmpty
            ? groupsWithTimes.first['name'] as String
            : '');
  }

  DateTime? _parseTimeToDateTime(String timeString, DateTime now) {
    if (timeString.isEmpty) return null;
    final time = TimeHelper.parseTime(timeString);
    if (time == null) return null;
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  String _getArabicDayName(String englishDayName) {
    switch (englishDayName) {
      case 'Saturday':
        return 'السبت';
      case 'Sunday':
        return 'الأحد';
      case 'Monday':
        return 'الإثنين';
      case 'Tuesday':
        return 'الثلاثاء';
      case 'Wednesday':
        return 'الأربعاء';
      case 'Thursday':
        return 'الخميس';
      case 'Friday':
        return 'الجمعة';
      default:
        return englishDayName;
    }
  }
}
