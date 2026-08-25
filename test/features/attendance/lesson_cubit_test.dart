import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';
import 'package:student_management_system/features/attendance/cubits/lesson_cubit.dart';
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
  group('Lesson Model Tests', () {
    test('Lesson default values and copyWith maintain state', () {
      const lesson = Lesson(
        groupId: 1,
        date: '2026-08-25',
        startTime: '16:00',
      );

      expect(lesson.id, isNull);
      expect(lesson.groupId, equals(1));
      expect(lesson.status, equals(LessonStatus.scheduled));
      expect(lesson.enrolledCount, equals(0));
      expect(lesson.attendedCount, equals(0));

      final active = lesson.copyWith(
        id: 42,
        status: LessonStatus.inProgress,
        attendedCount: 15,
      );

      expect(active.id, equals(42));
      expect(active.status, equals(LessonStatus.inProgress));
      expect(active.attendedCount, equals(15));
    });

    test('Lesson JSON serialization works correctly', () {
      final json = {
        'id': 10,
        'groupId': 2,
        'date': '2026-08-25',
        'startTime': '18:00',
        'title': 'Revision',
        'status': 'inProgress',
      };

      final lesson = Lesson.fromJson(json);
      expect(lesson.id, equals(10));
      expect(lesson.groupId, equals(2));
      expect(lesson.status, equals(LessonStatus.inProgress));
      expect(lesson.title, equals('Revision'));
    });
  });

  group('LessonCubit Database Tests', () {
    late Database db;
    late LessonCubit cubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(DBQueries.createGroupsTable);
      await db.execute(DBQueries.createGroupSchedulesTable);
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createLessonsTable);
      await db.execute(DBQueries.createAttendanceTable);

      // Insert dummy group
      await db.insert('groups', {
        'id': 1,
        'name': 'السبت والثلاثاء الساعة 12',
        'grade': 'sec_1',
      });

      cubit = LessonCubit(databaseService: TestDatabaseService(db));
    });

    tearDown(() async {
      await cubit.close();
      await db.close();
    });

    test('startLesson correctly inserts lesson with created_at and sets inProgress', () async {
      const scheduledLesson = Lesson(
        groupId: 1,
        date: '2026-08-25',
        startTime: '12:00',
        title: 'Session 1',
      );

      await cubit.startLesson(scheduledLesson);

      expect(cubit.state.activeLesson, isNotNull);
      expect(cubit.state.activeLesson!.id, isNotNull);
      expect(cubit.state.activeLesson!.status, LessonStatus.inProgress);
      expect(cubit.state.error, isNull);

      final rows = await db.query('lessons', where: 'id = ?', whereArgs: [cubit.state.activeLesson!.id]);
      expect(rows.length, 1);
      expect(rows.first['created_at'], isNotNull);
      expect(rows.first['status'], 'inProgress');
    });

    test('createAdHocLesson correctly inserts scheduled lesson with created_at', () async {
      await cubit.createAdHocLesson(
        groupId: 1,
        date: DateTime(2026, 8, 25),
        startTime: '14:00',
        title: 'Extra Session',
      );

      final rows = await db.query('lessons');
      expect(rows.length, 1);
      expect(rows.first['start_time'], '14:00');
      expect(rows.first['created_at'], isNotNull);
    });
  });
}
