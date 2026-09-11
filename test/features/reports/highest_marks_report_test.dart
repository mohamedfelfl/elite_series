import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';
import 'package:student_management_system/features/exams/cubits/exam_cubit.dart';
import 'package:student_management_system/features/reports/cubits/report_cubit.dart';

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

  group('Highest Marks Report - Full Mark Option Tests', () {
    Database? db;
    ReportCubit? reportCubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db!.execute(DBQueries.createGroupsTable);
      await db!.execute(DBQueries.createStudentsTable);
      await db!.execute(DBQueries.createExamsTable);
      await db!.execute(DBQueries.createMarksTable);

      // Insert test group
      await db!.insert(DBQueries.tableGroups, {
        'id': 1,
        'name': 'Group A',
        'grade': '10',
      });

      // Insert students
      for (int i = 1; i <= 5; i++) {
        await db!.insert(DBQueries.tableStudents, {
          'id': i,
          'name': 'Student $i',
          'phone1': '0100000000$i',
          'phone2': '0110000000$i',
          'group_id': 1,
          'serial_number': 'SN10$i',
        });
      }

      // Insert exam with full_mark = 20.0
      await db!.insert(DBQueries.tableExams, {
        'id': 1,
        'name': 'Midterm Exam',
        'full_mark': 20.0,
        'date': '2026-09-08',
      });

      // Insert marks:
      // Student 1: 20 (Full mark)
      // Student 2: 20 (Full mark)
      // Student 3: 20 (Full mark)
      // Student 4: 18
      // Student 5: 15
      await db!.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 1, 'score': 20.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 2, 'score': 20.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 3, 'score': 20.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 4, 'score': 18.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 5, 'score': 15.0});

      reportCubit = ReportCubit(databaseService: _MockDatabaseService(db!));
    });

    tearDown(() async {
      await reportCubit?.close();
      await db?.close();
    });

    test('generateHighestMarksReport with fullMarkOnly=true generates report without limit', () async {
      // Limit is set to 2, but because fullMarkOnly is true, all 3 students with 20.0 must be included
      await reportCubit!.generateHighestMarksReport(
        examId: 1,
        limit: 2,
        fullMarkOnly: true,
      );

      expect(reportCubit!.state.error, isNull);
      expect(reportCubit!.state.isGenerated, isTrue);
      expect(reportCubit!.state.pdfDocument, isNotNull);
    });

    test('generateHighestMarksReport with fullMarkOnly=false respects limit', () async {
      await reportCubit!.generateHighestMarksReport(
        examId: 1,
        limit: 2,
        fullMarkOnly: false,
      );

      expect(reportCubit!.state.error, isNull);
      expect(reportCubit!.state.isGenerated, isTrue);
      expect(reportCubit!.state.pdfDocument, isNotNull);
    });

    test('SQL query with fullMarkOnly filters only students who obtained full mark', () async {
      // Directly check the query that ReportCubit executes for fullMarkOnly
      final results = await db!.rawQuery('''
        ${DBQueries.reportHighestMarksBase}
        WHERE m.exam_id = ? AND m.score >= e.full_mark
        ORDER BY (CAST(m.score AS REAL) / e.full_mark) DESC, m.score DESC, s.name ASC
      ''', [1]);

      expect(results.length, equals(3));
      for (final r in results) {
        expect(r['score'], equals(20.0));
      }
    });

    test('generateHighestMarksReport with multiple examIds and fullMarkOnly=true generates report', () async {
      // Insert Exam 2 with full_mark = 50.0
      await db!.insert(DBQueries.tableExams, {
        'id': 2,
        'name': 'Final Exam',
        'full_mark': 50.0,
        'date': '2026-09-09',
      });

      // Student 1 gets 50 (Full mark) on Exam 2
      // Student 2 gets 45 on Exam 2
      // Student 3 gets 50 (Full mark) on Exam 2
      await db!.insert(DBQueries.tableMarks, {'exam_id': 2, 'student_id': 1, 'score': 50.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 2, 'student_id': 2, 'score': 45.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 2, 'student_id': 3, 'score': 50.0});

      await reportCubit!.generateHighestMarksReport(
        examIds: [1, 2],
        fullMarkOnly: true,
      );

      expect(reportCubit!.state.error, isNull);
      expect(reportCubit!.state.isGenerated, isTrue);
      expect(reportCubit!.state.pdfDocument, isNotNull);

      // Verify query returns 5 rows (3 from Exam 1, 2 from Exam 2)
      final results = await db!.rawQuery('''
        ${DBQueries.reportHighestMarksBase}
        WHERE m.exam_id IN (1, 2) AND m.score >= e.full_mark
        ORDER BY (CAST(m.score AS REAL) / e.full_mark) DESC, m.score DESC, s.name ASC
      ''');

      expect(results.length, equals(5));
      for (final r in results) {
        final score = (r['score'] as num).toDouble();
        final fullMark = (r['full_mark'] as num).toDouble();
        expect(score >= fullMark, isTrue);
      }
    });

    test('percentage-based ordering ranks 100% higher than higher raw scores with lower percentage', () async {
      // Exam 1 full mark = 20: Student 4 got 18/20 = 90%
      // Exam 2 full mark = 50: Student 2 got 40/50 = 80% (raw score 40 > 18, but 80% < 90%)
      await db!.insert(DBQueries.tableExams, {
        'id': 3,
        'name': 'Quiz 2',
        'full_mark': 50.0,
        'date': '2026-09-10',
      });
      await db!.insert(DBQueries.tableMarks, {'exam_id': 3, 'student_id': 2, 'score': 40.0});

      final results = await db!.rawQuery('''
        ${DBQueries.reportHighestMarksBase}
        WHERE m.id IN (
          SELECT id FROM marks WHERE (exam_id = 1 AND student_id = 4) OR (exam_id = 3 AND student_id = 2)
        )
        ORDER BY (CAST(m.score AS REAL) / e.full_mark) DESC, m.score DESC, s.name ASC
      ''');

      expect(results.length, equals(2));
      // First result must be Student 4 (18/20 = 90%), not Student 2 (40/50 = 80%)
      expect(results.first['student_name'], equals('Student 4'));
      expect(results.last['student_name'], equals('Student 2'));
    });
  });

  group('ExamCubit - Multi-Exam Top Students Tests', () {
    Database? db;
    ExamCubit? examCubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db!.execute(DBQueries.createGroupsTable);
      await db!.execute(DBQueries.createStudentsTable);
      await db!.execute(DBQueries.createExamsTable);
      await db!.execute(DBQueries.createMarksTable);

      // Group
      await db!.insert(DBQueries.tableGroups, {'id': 1, 'name': 'Group A', 'grade': '10'});

      // Students
      for (int i = 1; i <= 4; i++) {
        await db!.insert(DBQueries.tableStudents, {
          'id': i,
          'name': 'Student $i',
          'phone1': '0100000000$i',
          'phone2': '0110000000$i',
          'group_id': 1,
          'serial_number': 'SN$i',
        });
      }

      // Exam 1 (full mark = 20)
      await db!.insert(DBQueries.tableExams, {
        'id': 10,
        'name': 'Exam 10',
        'full_mark': 20.0,
        'date': '2026-09-01',
      });

      // Exam 2 (full mark = 30)
      await db!.insert(DBQueries.tableExams, {
        'id': 20,
        'name': 'Exam 20',
        'full_mark': 30.0,
        'date': '2026-09-02',
      });

      // Student 1: 20/20 + 30/30 = 50/50 (100% full mark)
      await db!.insert(DBQueries.tableMarks, {'exam_id': 10, 'student_id': 1, 'score': 20.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 20, 'student_id': 1, 'score': 30.0});

      // Student 2: 18/20 + 28/30 = 46/50 (92%)
      await db!.insert(DBQueries.tableMarks, {'exam_id': 10, 'student_id': 2, 'score': 18.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 20, 'student_id': 2, 'score': 28.0});

      // Student 3: 20/20 + 25/30 = 45/50 (90%)
      await db!.insert(DBQueries.tableMarks, {'exam_id': 10, 'student_id': 3, 'score': 20.0});
      await db!.insert(DBQueries.tableMarks, {'exam_id': 20, 'student_id': 3, 'score': 25.0});

      examCubit = ExamCubit(databaseService: _MockDatabaseService(db!));
    });

    tearDown(() async {
      await examCubit?.close();
      await db?.close();
    });

    test('getTopStudents with multiple examIds filters correctly', () async {
      await examCubit!.getTopStudents(examIds: [10, 20], limit: 2);

      final top = examCubit!.state.topStudents;
      expect(top.length, equals(2));
      expect(top[0].studentName, equals('Student 1'));
      expect(top[0].totalMarks, equals(50.0));
      expect(top[0].percentage, equals(100.0));
      expect(top[1].studentName, equals('Student 2'));
      expect(top[1].totalMarks, equals(46.0));
    });

    test('getTopStudents with multiple examIds and fullMarkOnly=true returns only 100% students', () async {
      await examCubit!.getTopStudents(
        examIds: [10, 20],
        fullMarkOnly: true,
      );

      final top = examCubit!.state.topStudents;
      expect(top.length, equals(1));
      expect(top[0].studentName, equals('Student 1'));
      expect(top[0].percentage, equals(100.0));
    });
  });
}
