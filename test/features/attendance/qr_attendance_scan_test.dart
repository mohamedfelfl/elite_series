import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';
import 'package:student_management_system/features/attendance/cubits/attendance_cubit.dart';
import 'package:student_management_system/features/attendance/cubits/lesson_cubit.dart';
import 'package:student_management_system/features/attendance/models/attendance.dart';
import 'package:student_management_system/features/attendance/models/lesson.dart';
import 'package:student_management_system/features/students/cubits/student_cubit.dart';

class TestDatabaseService extends DatabaseService {
  final Database _testDb;
  TestDatabaseService(this._testDb)
      : super(encryptionService: EncryptionService());

  @override
  Future<Database> get database async => _testDb;
}

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('QR Attendance Scan with Printed Cards', () {
    late Database db;
    late LessonCubit lessonCubit;
    late AttendanceCubit attendanceCubit;
    late StudentCubit studentCubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(DBQueries.createGroupsTable);
      await db.execute(DBQueries.createGroupSchedulesTable);
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createLessonsTable);
      await db.execute(DBQueries.createAttendanceTable);

      final dbService = TestDatabaseService(db);
      lessonCubit = LessonCubit(databaseService: dbService);
      attendanceCubit = AttendanceCubit(databaseService: dbService);
      studentCubit = StudentCubit(databaseService: dbService);

      // Insert group
      await db.insert('groups', {
        'id': 1,
        'name': 'مجموعة السبت 10 صباحاً',
        'grade': 'sec_1',
      });

      // Insert student with serial_number EL-01-00003
      await db.insert('students', {
        'id': 1,
        'serial_number': 'EL-01-00003',
        'name': 'أحمد محمد علي',
        'group_id': 1,
        'grade': 'sec_1',
      });
    });

    tearDown(() async {
      await lessonCubit.close();
      await attendanceCubit.close();
      await studentCubit.close();
      await db.close();
    });

    test('LessonCubit records attendance when printed QR pattern is scanned', () async {
      // Start an active lesson
      const scheduledLesson = Lesson(
        groupId: 1,
        date: '2026-08-29',
        startTime: '10:00',
        title: 'الدرس الأول',
      );
      await lessonCubit.startLesson(scheduledLesson);

      expect(lessonCubit.state.activeLesson, isNotNull);

      // Scan printed pattern
      const printedScan = 'ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003';
      await lessonCubit.recordScanInActiveLesson(printedScan);

      expect(lessonCubit.state.scanSuccess, isTrue);
      expect(lessonCubit.state.lastScannedStudent, equals('أحمد محمد علي'));
      expect(lessonCubit.state.error, isNull);

      final attendanceRecords = await db.query('attendance');
      expect(attendanceRecords.length, equals(1));
      expect(attendanceRecords.first['student_id'], equals(1));
      expect(attendanceRecords.first['status'], equals(AttendanceStatus.attended.name));
    });

    test('AttendanceCubit records attendance when printed QR pattern is scanned', () async {
      const printedScan = 'ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003';
      await attendanceCubit.recordAttendanceBySerial(printedScan);

      expect(attendanceCubit.state.scanSuccess, isTrue);
      expect(attendanceCubit.state.lastScannedStudent, equals('أحمد محمد علي'));
      expect(attendanceCubit.state.error, isNull);

      final attendanceRecords = await db.query('attendance');
      expect(attendanceRecords.length, equals(1));
      expect(attendanceRecords.first['student_id'], equals(1));
    });

    test('StudentCubit finds student by printed QR pattern', () async {
      const printedScan = 'ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003';
      final student = await studentCubit.getStudentBySerial(printedScan);

      expect(student, isNotNull);
      expect(student!['id'], equals(1));
      expect(student['serial_number'], equals('EL-01-00003'));
      expect(student['name'], equals('أحمد محمد علي'));
    });
  });
}
