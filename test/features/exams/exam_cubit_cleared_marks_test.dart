import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';
import 'package:student_management_system/features/exams/cubits/exam_cubit.dart';

class _MockDatabaseService extends DatabaseService {
  final Database _db;
  _MockDatabaseService(this._db)
      : super(encryptionService: EncryptionService());

  @override
  Future<Database> get database async => _db;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('ExamCubit - Cleared Marks and Ungraded Student Tests', () {
    late Database db;
    late ExamCubit examCubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(DBQueries.createGroupsTable);
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createExamsTable);
      await db.execute(DBQueries.createMarksTable);

      await db.insert(DBQueries.tableGroups, {
        'id': 1,
        'name': 'Group A',
        'grade': '10',
      });

      for (int i = 1; i <= 3; i++) {
        await db.insert(DBQueries.tableStudents, {
          'id': i,
          'name': 'Student $i',
          'phone1': '0100000000$i',
          'phone2': '0110000000$i',
          'group_id': 1,
          'serial_number': 'SN10$i',
        });
      }

      await db.insert(DBQueries.tableExams, {
        'id': 1,
        'name': 'Science Exam',
        'full_mark': 100.0,
        'date': '2026-09-08',
      });

      // Insert initial marks for students 1 and 2
      await db.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 1, 'score': 95.0});
      await db.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 2, 'score': 80.0});

      final mockDbService = _MockDatabaseService(db);
      examCubit = ExamCubit(databaseService: mockDbService);
      await examCubit.loadMarks(1);
    });

    tearDown(() async {
      await examCubit.close();
      await db.close();
    });

    test('initial marks contain student 1 and 2', () {
      expect(examCubit.state.marks.length, 2);
      final studentIds = examCubit.state.marks.map((m) => m['student_id']).toList();
      expect(studentIds, containsAll([1, 2]));
    });

    test('saveMarksQuietly deletes cleared student marks and keeps active marks', () async {
      // Student 1 updated to 98.0, Student 2 cleared (empty text in UI)
      await examCubit.saveMarksQuietly(
        1,
        {1: 98.0},
        clearedStudentIds: [2],
      );

      expect(examCubit.state.marks.length, 1);
      expect(examCubit.state.marks.first['student_id'], 1);
      expect(examCubit.state.marks.first['score'], 98.0);

      // Verify directly from SQLite
      final rows = await db.query(DBQueries.tableMarks, where: 'exam_id = ?', whereArgs: [1]);
      expect(rows.length, 1);
      expect(rows.first['student_id'], 1);
      expect(rows.first['score'], 98.0);
    });

    test('saveMarks deletes cleared student mark and updates average score', () async {
      // Clear student 1, keep student 2 at 80.0
      await examCubit.saveMarks(
        1,
        {2: 80.0},
        clearedStudentIds: [1],
      );

      expect(examCubit.state.marks.length, 1);
      expect(examCubit.state.marks.first['student_id'], 2);

      final rows = await db.query(DBQueries.tableMarks, where: 'exam_id = ?', whereArgs: [1]);
      expect(rows.length, 1);
      expect(rows.first['student_id'], 2);
    });

    test('deleteMark deletes specific mark for exam and student', () async {
      await examCubit.deleteMark(examId: 1, studentId: 1);

      final rows = await db.query(DBQueries.tableMarks, where: 'exam_id = ? AND student_id = ?', whereArgs: [1, 1]);
      expect(rows, isEmpty);

      final allMarks = await db.query(DBQueries.tableMarks, where: 'exam_id = ?', whereArgs: [1]);
      expect(allMarks.length, 1);
      expect(allMarks.first['student_id'], 2);
    });
  });
}
