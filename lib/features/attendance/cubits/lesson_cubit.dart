import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';
import '../models/attendance.dart';
import '../models/lesson.dart';

part 'lesson_cubit.freezed.dart';

@freezed
abstract class LessonState with _$LessonState {
  const factory LessonState({
    @Default([]) List<Lesson> dailyLessons,
    Lesson? activeLesson,
    @Default([]) List<Map<String, dynamic>> attendedRoster,
    @Default([]) List<Map<String, dynamic>> absentRoster,
    @Default(false) bool isLoading,
    @Default(false) bool scanSuccess,
    String? lastScannedStudent,
    String? error,
    DateTime? selectedDate,
  }) = _LessonState;
}

class LessonCubit extends Cubit<LessonState> {
  final DatabaseService _databaseService;

  LessonCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const LessonState());

  /// Load daily lessons for a selected date.
  /// Combines already-instantiated rows in `lessons` table with dynamic
  /// unstarted schedule slots for groups meeting on this day of the week.
  Future<void> loadLessonsForDate(DateTime date) async {
    emit(state.copyWith(isLoading: true, error: null, selectedDate: date));
    try {
      final Database db = await _databaseService.database;
      final String dateStr = date.toIso8601String().split('T').first;
      final String dayNameEn = DateFormat('EEEE', 'en_US').format(date);
      final String dayNameAr = _getArabicDayName(dayNameEn);
      final String dayNameArAlt = dayNameAr
          .replaceAll('أ', 'ا')
          .replaceAll('إ', 'ا');

      // 1. Query persisted lessons for this date
      final List<Map<String, Object?>> persistedRows = await db.rawQuery(
        DBQueries.loadLessonsForDate,
        [dateStr],
      );

      final List<Lesson> persistedLessons = persistedRows.map((r) {
        final statusStr = r['status'] as String? ?? 'scheduled';
        final status = LessonStatus.values.firstWhere(
          (e) => e.name == statusStr || _mapStatusNameToEnum(statusStr) == e,
          orElse: () => LessonStatus.scheduled,
        );

        final int enrolled = (r['enrolled_count'] as int?) ?? 0;
        final int attended = (r['attended_count'] as int?) ?? 0;
        final int otherGroup = (r['other_group_count'] as int?) ?? 0;
        final int absent = (enrolled - attended).clamp(0, 999999);

        return Lesson(
          id: r['id'] as int?,
          groupId: r['group_id'] as int,
          date: r['date'] as String,
          startTime: r['start_time'] as String,
          endTime: r['end_time'] as String?,
          title: (r['title'] as String?) ?? '',
          status: status,
          groupName: r['group_name'] as String?,
          enrolledCount: enrolled,
          attendedCount: attended,
          otherGroupCount: otherGroup,
          absentCount: absent,
        );
      }).toList();

      // 2. Query scheduled groups for this day of week that haven't been started yet
      final List<Map<String, Object?>> scheduledGroups = await db.rawQuery(
        DBQueries.getGroupsToday,
        [dayNameEn, dayNameAr, dayNameArAlt],
      );

      final List<Lesson> dynamicScheduledLessons = [];
      for (final g in scheduledGroups) {
        final int groupId = g['group_id'] as int;
        final String groupName = g['name'] as String;
        final String time = (g['time'] as String?) ?? '00:00';

        // Check if already in persisted lessons
        final bool alreadyExists = persistedLessons.any(
          (l) => l.groupId == groupId,
        );

        if (!alreadyExists) {
          final List<Map<String, Object?>> enrolledStudents = await db.query(
            DBQueries.tableStudents,
            columns: ['id'],
            where: 'group_id = ?',
            whereArgs: [groupId],
          );

          dynamicScheduledLessons.add(
            Lesson(
              groupId: groupId,
              date: dateStr,
              startTime: time,
              status: LessonStatus.scheduled,
              groupName: groupName,
              enrolledCount: enrolledStudents.length,
              attendedCount: 0,
              otherGroupCount: 0,
              absentCount: enrolledStudents.length,
            ),
          );
        }
      }

      final List<Lesson> allDaily = [
        ...persistedLessons,
        ...dynamicScheduledLessons,
      ];

      // If there's an active lesson in state that was updated, refresh it
      Lesson? currentActive = state.activeLesson;
      if (currentActive != null && currentActive.id != null) {
        final match = allDaily.where((l) => l.id == currentActive!.id);
        if (match.isNotEmpty) {
          currentActive = match.first;
        }
      }

      emit(
        state.copyWith(
          dailyLessons: allDaily,
          activeLesson: currentActive,
          isLoading: false,
        ),
      );

      if (currentActive != null) {
        await loadRosterForActiveLesson();
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Start a lesson session (setting status = inProgress and locking activeLesson).
  Future<void> startLesson(Lesson lesson) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      int lessonId;

      if (lesson.id == null) {
        // Persist dynamic scheduled lesson to DB
        lessonId = await db.insert(DBQueries.tableLessons, <String, Object?>{
          'group_id': lesson.groupId,
          'date': lesson.date,
          'start_time': lesson.startTime,
          'end_time': lesson.endTime,
          'title': lesson.title,
          'status': 'inProgress',
          'created_at': lesson.createdAt ?? DateTime.now().toIso8601String(),
        });
      } else {
        lessonId = lesson.id!;
        await db.update(
          DBQueries.tableLessons,
          <String, Object?>{'status': 'inProgress'},
          where: 'id = ?',
          whereArgs: [lessonId],
        );
      }

      final updatedLesson = lesson.copyWith(
        id: lessonId,
        status: LessonStatus.inProgress,
      );

      // Guarantee only one lesson is in progress across the database
      await db.update(
        DBQueries.tableLessons,
        <String, Object?>{'status': 'completed'},
        where: 'status = ? AND id != ?',
        whereArgs: ['inProgress', lessonId],
      );

      emit(state.copyWith(activeLesson: updatedLesson, isLoading: false));

      if (state.selectedDate != null) {
        await loadLessonsForDate(state.selectedDate!);
      }
      await loadRosterForActiveLesson();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Load real-time Attended vs Absent roster for the active lesson session.
  Future<void> loadRosterForActiveLesson() async {
    final active = state.activeLesson;
    if (active == null || active.id == null) return;

    try {
      final Database db = await _databaseService.database;

      // 1. Get all students enrolled in the lesson's group
      final List<Map<String, Object?>> enrolled = await db.rawQuery(
        DBQueries.loadEnrolledStudentsForGroup,
        [active.groupId],
      );

      // 2. Get all attendance records for this lesson session
      final List<Map<String, Object?>> attendedRecords = await db.rawQuery(
        DBQueries.loadLessonAttendance,
        [active.id],
      );

      // Build attended student id set
      final Set<int> attendedStudentIds = attendedRecords
          .map((r) => r['student_id'] as int)
          .toSet();

      // 3. Derive absent students (enrolled minus attended)
      final List<Map<String, dynamic>> absentList = enrolled
          .where((s) => !attendedStudentIds.contains(s['id'] as int))
          .map((s) => Map<String, dynamic>.from(s))
          .toList();

      final List<Map<String, dynamic>> attendedList = attendedRecords
          .map((r) => Map<String, dynamic>.from(r))
          .toList();

      // Recalculate counts on active lesson
      final int attendedInGroup = attendedList
          .where((r) => r['status'] == AttendanceStatus.attended.name)
          .length;
      final int otherGroup = attendedList
          .where((r) => r['status'] == AttendanceStatus.otherLesson.name)
          .length;

      final updatedActive = active.copyWith(
        enrolledCount: enrolled.length,
        attendedCount: attendedInGroup,
        otherGroupCount: otherGroup,
        absentCount: absentList.length,
      );

      emit(
        state.copyWith(
          activeLesson: updatedActive,
          attendedRoster: attendedList,
          absentRoster: absentList,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Record a scan inside the active lesson session.
  Future<void> recordScanInActiveLesson(String serialNumber) async {
    final active = state.activeLesson;
    if (active == null || active.id == null) {
      emit(
        state.copyWith(
          error: LocaleKeys.no_active_lesson_hint.tr(),
          scanSuccess: false,
        ),
      );
      return;
    }

    try {
      final Database db = await _databaseService.database;

      // Find student by serial
      final List<Map<String, Object?>> students = await db.query(
        DBQueries.tableStudents,
        where: 'serial_number = ?',
        whereArgs: [serialNumber.trim()],
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

      final student = students.first;
      final int studentId = student['id'] as int;
      final String studentName = student['name'] as String;
      final int? studentGroupId = student['group_id'] as int?;

      // Check if student already checked into this lesson
      final List<Map<String, Object?>> existing = await db.query(
        DBQueries.tableAttendance,
        where: 'lesson_id = ? AND student_id = ?',
        whereArgs: [active.id, studentId],
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

      // Determine status and notes
      AttendanceStatus status;
      String notes;

      if (studentGroupId == active.groupId) {
        status = AttendanceStatus.attended;
        notes = LocaleKeys.attended_his_group.tr();
      } else {
        status = AttendanceStatus.otherLesson;
        final String activeGroupName = active.groupName ?? '';
        notes = LocaleKeys.attended_another_group.tr(args: [activeGroupName]);
      }

      await db.insert(DBQueries.tableAttendance, <String, Object?>{
        'lesson_id': active.id,
        'student_id': studentId,
        'date': active.date,
        'status': status.name,
        'notes': notes,
      });

      emit(
        state.copyWith(
          scanSuccess: true,
          lastScannedStudent: studentName,
          error: null,
        ),
      );

      await loadRosterForActiveLesson();
      if (state.selectedDate != null) {
        await loadLessonsForDate(state.selectedDate!);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), scanSuccess: false));
    }
  }

  /// 1-tap toggle manual attendance for an absent student.
  Future<void> markStudentPresent(int studentId) async {
    final active = state.activeLesson;
    if (active == null || active.id == null) return;

    try {
      final Database db = await _databaseService.database;

      final List<Map<String, Object?>> existing = await db.query(
        DBQueries.tableAttendance,
        where: 'lesson_id = ? AND student_id = ?',
        whereArgs: [active.id, studentId],
      );

      if (existing.isEmpty) {
        await db.insert(DBQueries.tableAttendance, <String, Object?>{
          'lesson_id': active.id,
          'student_id': studentId,
          'date': active.date,
          'status': AttendanceStatus.attended.name,
          'notes': LocaleKeys.attended_his_group.tr(),
        });
      }

      await loadRosterForActiveLesson();
      if (state.selectedDate != null) {
        await loadLessonsForDate(state.selectedDate!);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Delete an attendance record from the active lesson.
  Future<void> removeAttendanceRecord(int attendanceId) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(
        DBQueries.tableAttendance,
        where: 'id = ?',
        whereArgs: [attendanceId],
      );
      await loadRosterForActiveLesson();
      if (state.selectedDate != null) {
        await loadLessonsForDate(state.selectedDate!);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// End lesson session and lock it as completed.
  Future<void> endLesson(int lessonId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      await db.update(
        DBQueries.tableLessons,
        <String, Object?>{'status': 'completed'},
        where: 'id = ?',
        whereArgs: [lessonId],
      );

      emit(state.copyWith(activeLesson: null, isLoading: false));

      if (state.selectedDate != null) {
        await loadLessonsForDate(state.selectedDate!);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Reopen a completed lesson.
  Future<void> reopenLesson(Lesson lesson) async {
    if (lesson.id == null) return;
    await startLesson(lesson);
  }

  /// Create an ad-hoc extra/revision lesson session.
  Future<void> createAdHocLesson({
    required int groupId,
    required DateTime date,
    required String startTime,
    String? endTime,
    String title = '',
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final String dateStr = date.toIso8601String().split('T').first;

      await db.insert(DBQueries.tableLessons, <String, Object?>{
        'group_id': groupId,
        'date': dateStr,
        'start_time': startTime,
        'end_time': endTime,
        'title': title,
        'status': 'scheduled',
        'created_at': DateTime.now().toIso8601String(),
      });

      await loadLessonsForDate(date);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Update an existing lesson session.
  Future<void> updateLesson({
    required int lessonId,
    required int groupId,
    required DateTime date,
    required String startTime,
    String? endTime,
    String title = '',
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final String dateStr = date.toIso8601String().split('T').first;

      await db.update(
        DBQueries.tableLessons,
        <String, Object?>{
          'group_id': groupId,
          'date': dateStr,
          'start_time': startTime,
          'end_time': endTime,
          'title': title,
        },
        where: 'id = ?',
        whereArgs: [lessonId],
      );

      // If updating active lesson, refresh it
      if (state.activeLesson?.id == lessonId) {
        final List<Map<String, Object?>> rows = await db.rawQuery(
          DBQueries.loadLessonById,
          [lessonId],
        );
        if (rows.isNotEmpty) {
          final r = rows.first;
          final statusStr = r['status'] as String? ?? 'scheduled';
          final status = LessonStatus.values.firstWhere(
            (e) => e.name == statusStr || _mapStatusNameToEnum(statusStr) == e,
            orElse: () => LessonStatus.scheduled,
          );
          final updated = Lesson(
            id: r['id'] as int?,
            groupId: r['group_id'] as int,
            date: r['date'] as String,
            startTime: r['start_time'] as String,
            endTime: r['end_time'] as String?,
            title: (r['title'] as String?) ?? '',
            status: status,
            groupName: r['group_name'] as String?,
            enrolledCount: (r['enrolled_count'] as int?) ?? 0,
            attendedCount: (r['attended_count'] as int?) ?? 0,
            otherGroupCount: (r['other_group_count'] as int?) ?? 0,
            absentCount: (((r['enrolled_count'] as int?) ?? 0) -
                    ((r['attended_count'] as int?) ?? 0))
                .clamp(0, 999999),
          );
          emit(state.copyWith(activeLesson: updated));
        }
      }

      await loadLessonsForDate(date);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Delete a lesson session and its attendance records.
  Future<void> deleteLesson(int lessonId) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(
        DBQueries.tableLessons,
        where: 'id = ?',
        whereArgs: [lessonId],
      );

      if (state.activeLesson?.id == lessonId) {
        emit(state.copyWith(activeLesson: null));
      }

      if (state.selectedDate != null) {
        await loadLessonsForDate(state.selectedDate!);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void setActiveLesson(Lesson? lesson) {
    emit(state.copyWith(activeLesson: lesson));
    if (lesson != null) {
      loadRosterForActiveLesson();
    }
  }

  void resetScanState() {
    emit(
      state.copyWith(scanSuccess: false, lastScannedStudent: null, error: null),
    );
  }

  LessonStatus _mapStatusNameToEnum(String name) {
    switch (name) {
      case 'inProgress':
      case 'in_progress':
        return LessonStatus.inProgress;
      case 'completed':
        return LessonStatus.completed;
      case 'cancelled':
        return LessonStatus.cancelled;
      default:
        return LessonStatus.scheduled;
    }
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
