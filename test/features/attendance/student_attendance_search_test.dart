import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/data_sync_service.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';
import 'package:student_management_system/features/attendance/cubits/lesson_cubit.dart';
import 'package:student_management_system/features/attendance/models/attendance.dart';
import 'package:student_management_system/features/attendance/models/lesson.dart';

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

  group('Student Attendance Search & Mark Present in Active Lessons', () {
    late Database db;
    late DataSyncService dataSyncService;
    late LessonCubit lessonCubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(DBQueries.createGroupsTable);
      await db.execute(DBQueries.createGroupSchedulesTable);
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createLessonsTable);
      await db.execute(DBQueries.createAttendanceTable);

      final dbService = TestDatabaseService(db);
      dataSyncService = DataSyncService(debounceDuration: Duration.zero);
      lessonCubit = LessonCubit(
        databaseService: dbService,
        dataSyncService: dataSyncService,
      );

      // Insert 2 groups
      await db.insert('groups', {
        'id': 1,
        'name': 'مجموعة السبت 10 ص',
        'grade': 'sec_1',
      });
      await db.insert('groups', {
        'id': 2,
        'name': 'مجموعة الأحد 2 م',
        'grade': 'sec_1',
      });

      // Insert students
      // Student 1 in group 1
      await db.insert('students', {
        'id': 1,
        'serial_number': 'EL-01-00001',
        'name': 'أحمد محمد علي',
        'phone1': '01012345678',
        'group_id': 1,
        'grade': 'sec_1',
        'student_status': 'normal',
      });

      // Student 2 in group 2 (free student)
      await db.insert('students', {
        'id': 2,
        'serial_number': 'EL-01-00002',
        'name': 'محمود إبراهيم',
        'phone1': '01198765432',
        'group_id': 2,
        'grade': 'sec_1',
        'student_status': 'free',
      });

      // Student 3 in group 1
      await db.insert('students', {
        'id': 3,
        'serial_number': 'EL-01-00003',
        'name': 'عمر خالد أحمد',
        'phone1': '01255554444',
        'group_id': 1,
        'grade': 'sec_1',
        'student_status': 'normal',
      });

      // Start an active lesson for group 1
      const lesson = Lesson(
        groupId: 1,
        date: '2026-09-12',
        startTime: '10:00',
        title: 'حصة الفيزياء 1',
      );
      await lessonCubit.startLesson(lesson);
    });

    tearDown(() async {
      await lessonCubit.close();
      dataSyncService.dispose();
      await db.close();
    });

    test('searches students by name with Arabic alef normalization', () async {
      // Search with plain alef 'احمد' should find 'أحمد محمد علي' and 'عمر خالد أحمد'
      final resultsPlainAlef =
          await lessonCubit.searchStudentsForActiveLesson('احمد');
      expect(resultsPlainAlef.length, equals(2));
      expect(
        resultsPlainAlef.any((s) => s['name'] == 'أحمد محمد علي'),
        isTrue,
      );
      expect(
        resultsPlainAlef.any((s) => s['name'] == 'عمر خالد أحمد'),
        isTrue,
      );

      // Search with hamza 'أحمد'
      final resultsHamza =
          await lessonCubit.searchStudentsForActiveLesson('أحمد');
      expect(resultsHamza.length, equals(2));
    });

    test('searches students by serial number and phone number', () async {
      // By serial
      final resultsSerial =
          await lessonCubit.searchStudentsForActiveLesson('EL-01-00002');
      expect(resultsSerial.length, equals(1));
      expect(resultsSerial.first['name'], equals('محمود إبراهيم'));

      // By phone
      final resultsPhone =
          await lessonCubit.searchStudentsForActiveLesson('01255554444');
      expect(resultsPhone.length, equals(1));
      expect(resultsPhone.first['name'], equals('عمر خالد أحمد'));
    });

    test('correctly sets is_own_group flag for group 1 vs group 2 students', () async {
      final results = await lessonCubit.searchStudentsForActiveLesson('01');
      expect(results.length, equals(3));

      final student1 = results.firstWhere((s) => s['id'] == 1);
      final student2 = results.firstWhere((s) => s['id'] == 2);

      // Student 1 is in Group 1 (same group as active lesson)
      expect(student1['is_own_group'], isTrue);

      // Student 2 is in Group 2 (different group from active lesson)
      expect(student2['is_own_group'], isFalse);
    });

    test('marks own-group student present and reflects in search results and roster', () async {
      // Initially not attended
      var results = await lessonCubit.searchStudentsForActiveLesson('أحمد');
      var s1 = results.firstWhere((s) => s['id'] == 1);
      expect(s1['is_attended'], isFalse);

      // Mark present
      await lessonCubit.markStudentPresent(1);

      expect(lessonCubit.state.scanSuccess, isTrue);
      expect(lessonCubit.state.lastScannedStudent, equals('أحمد محمد علي'));

      // Verify attendance record in DB
      final records = await db.query('attendance', where: 'student_id = ?', whereArgs: [1]);
      expect(records.length, equals(1));
      expect(records.first['status'], equals(AttendanceStatus.attended.name));

      // Re-search: is_attended should now be true
      results = await lessonCubit.searchStudentsForActiveLesson('أحمد');
      s1 = results.firstWhere((s) => s['id'] == 1);
      expect(s1['is_attended'], isTrue);
    });

    test('marks other-group student present as otherLesson and includes group info', () async {
      // Mark student 2 (enrolled in Group 2) present in Group 1's active lesson
      await lessonCubit.markStudentPresent(2);

      expect(lessonCubit.state.scanSuccess, isTrue);
      // Student 2 is a free student, so lastScannedStudent display contains free student label
      expect(lessonCubit.state.lastScannedStudent, contains('محمود إبراهيم'));

      // Verify attendance record in DB
      final records = await db.query('attendance', where: 'student_id = ?', whereArgs: [2]);
      expect(records.length, equals(1));
      expect(records.first['status'], equals(AttendanceStatus.otherLesson.name));

      // Re-search: is_attended is now true
      final results = await lessonCubit.searchStudentsForActiveLesson('محمود');
      final s2 = results.firstWhere((s) => s['id'] == 2);
      expect(s2['is_attended'], isTrue);
      expect(s2['is_own_group'], isFalse);
    });

    test('prevents duplicate attendance when markStudentPresent is called repeatedly', () async {
      await lessonCubit.markStudentPresent(1);
      await lessonCubit.markStudentPresent(1);

      final records = await db.query('attendance', where: 'student_id = ?', whereArgs: [1]);
      expect(records.length, equals(1));
    });

    test('fires DataSyncService.notifyAttendanceChanged on marking student present', () async {
      bool syncNotified = false;
      final sub = dataSyncService.syncStream.listen((event) {
        if (event == SyncEntity.attendance) {
          syncNotified = true;
        }
      });

      await lessonCubit.markStudentPresent(3);
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(syncNotified, isTrue);
      await sub.cancel();
    });
  });
}
