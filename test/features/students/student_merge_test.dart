import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';
import 'package:student_management_system/features/students/cubits/student_cubit.dart';
import 'package:student_management_system/features/students/services/student_merge_service.dart';

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

  group('StudentMergeService - normalizeName Tests', () {
    test('Normalizes Arabic alef variants', () {
      expect(StudentMergeService.normalizeName('أحمد'), 'احمد');
      expect(StudentMergeService.normalizeName('إبراهيم'), 'ابراهيم');
      expect(StudentMergeService.normalizeName('آلاء'), 'الاء');
    });

    test('Strips Arabic diacritics (harakat)', () {
      expect(StudentMergeService.normalizeName('مُحَمَّدٌ'), 'محمد');
      expect(StudentMergeService.normalizeName('عَلِيٌّ'), 'علي');
      expect(StudentMergeService.normalizeName('فَاطِمَةُ'), 'فاطمه');
    });

    test('Normalizes taa marbuta and alef maqsura', () {
      expect(StudentMergeService.normalizeName('سارة'), 'ساره');
      expect(StudentMergeService.normalizeName('منى'), 'مني');
      expect(StudentMergeService.normalizeName('مصطفى'), 'مصطفي');
    });

    test('Removes tatweel and normalizes whitespace', () {
      expect(StudentMergeService.normalizeName('أحـــمد   محــمد'), 'احمد محمد');
      expect(StudentMergeService.normalizeName('   علي   حسن   '), 'علي حسن');
    });
  });

  group('Student Merge & Duplicate Detection Integration Tests', () {
    late Database db;
    late StudentMergeService mergeService;
    late StudentCubit studentCubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);

      // Create necessary schema
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createGroupsTable);
      await db.execute(DBQueries.createExamsTable);
      await db.execute(DBQueries.createMarksTable);
      await db.execute(DBQueries.createLessonsTable);
      await db.execute(DBQueries.createAttendanceTable);
      await db.execute(DBQueries.createPaymentsTable);
      await db.execute(DBQueries.createNotesTable);
      await db.execute(DBQueries.createStudentNotesTable);
      await db.execute(DBQueries.createAppSettingsTable);

      final dbService = TestDatabaseService(db);
      mergeService = StudentMergeService(databaseService: dbService);
      studentCubit = StudentCubit(
        databaseService: dbService,
        mergeService: mergeService,
      );
    });

    tearDown(() async {
      await studentCubit.close();
      await db.close();
    });

    test('findDuplicates detects students with slight name variations', () async {
      // Insert duplicate pair
      await db.insert(DBQueries.tableStudents, {
        'id': 1,
        'serial_number': '10001',
        'name': 'أحمد محمد علي',
        'grade': 'prep_1',
      });
      await db.insert(DBQueries.tableStudents, {
        'id': 2,
        'serial_number': '10002',
        'name': 'احمد محمد على',
        'grade': 'prep_1',
      });

      // Insert distinct student
      await db.insert(DBQueries.tableStudents, {
        'id': 3,
        'serial_number': '10003',
        'name': 'محمود حسن مصطفى',
        'grade': 'prep_1',
      });

      final duplicates = await studentCubit.findDuplicates();
      expect(duplicates.length, 1);
      expect(duplicates.first.students.length, 2);
      expect(duplicates.first.students.map((s) => s.id), containsAll([1, 2]));
    });

    test('previewMerge accurately detects records to transfer and conflicts', () async {
      // Create primary and duplicate student
      await db.insert(DBQueries.tableStudents, {
        'id': 10,
        'serial_number': '10010',
        'name': 'أحمد علي',
        'phone1': '01000000001',
      });
      await db.insert(DBQueries.tableStudents, {
        'id': 20,
        'serial_number': '10020',
        'name': 'احمد على',
        'phone1': '01000000001',
        'phone2': '01200000002',
        'school': 'Al-Farabi',
      });

      // Insert exams
      await db.insert(DBQueries.tableExams, {'id': 1, 'name': 'Exam 1', 'full_mark': 100, 'date': '2026-09-01'});
      await db.insert(DBQueries.tableExams, {'id': 2, 'name': 'Exam 2', 'full_mark': 100, 'date': '2026-09-02'});

      // Both took Exam 1 (Conflict); only Duplicate took Exam 2
      await db.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 10, 'score': 80});
      await db.insert(DBQueries.tableMarks, {'exam_id': 1, 'student_id': 20, 'score': 95});
      await db.insert(DBQueries.tableMarks, {'exam_id': 2, 'student_id': 20, 'score': 75});

      // Duplicate has payments
      await db.insert(DBQueries.tablePayments, {
        'student_id': 20,
        'total_amount': 250,
        'paid_amount': 250,
        'paid_date': '2026-09-01',
        'month': 9,
        'year': 2026,
      });

      final preview = await studentCubit.previewMerge(
        primaryId: 10,
        duplicateIds: [20],
      );

      expect(preview.marksToTransfer, 1); // Exam 2
      expect(preview.marksConflictsResolved, 1); // Exam 1
      expect(preview.paymentsToTransfer, 1);
      expect(preview.profileFieldsUpdated, contains('phone2'));
      expect(preview.profileFieldsUpdated, contains('school'));
    });

    test('mergeStudents consolidates marks preserving highest score', () async {
      await db.insert(DBQueries.tableStudents, {
        'id': 1,
        'serial_number': '10001',
        'name': 'الطالب الأساسي',
      });
      await db.insert(DBQueries.tableStudents, {
        'id': 2,
        'serial_number': '10002',
        'name': 'الطالب المكرر',
      });

      await db.insert(DBQueries.tableExams, {'id': 101, 'name': 'Midterm', 'full_mark': 100, 'date': '2026-09-01'});
      await db.insert(DBQueries.tableExams, {'id': 102, 'name': 'Quiz 1', 'full_mark': 20, 'date': '2026-09-05'});

      // Primary had score 70 on Midterm, Duplicate had score 95 on Midterm
      await db.insert(DBQueries.tableMarks, {'exam_id': 101, 'student_id': 1, 'score': 70});
      await db.insert(DBQueries.tableMarks, {'exam_id': 101, 'student_id': 2, 'score': 95});
      // Duplicate had Quiz 1
      await db.insert(DBQueries.tableMarks, {'exam_id': 102, 'student_id': 2, 'score': 18});

      await studentCubit.mergeStudents(primaryId: 1, duplicateIds: [2]);

      // Verify primary now has Midterm with score 95 (higher score kept)
      final primaryMidterm = await db.query(
        DBQueries.tableMarks,
        where: 'exam_id = ? AND student_id = ?',
        whereArgs: [101, 1],
      );
      expect(primaryMidterm.first['score'], 95);

      // Verify primary now has Quiz 1 with score 18
      final primaryQuiz = await db.query(
        DBQueries.tableMarks,
        where: 'exam_id = ? AND student_id = ?',
        whereArgs: [102, 1],
      );
      expect(primaryQuiz.first['score'], 18);

      // Verify duplicate student record was deleted
      final duplicateCheck = await db.query(
        DBQueries.tableStudents,
        where: 'id = ?',
        whereArgs: [2],
      );
      expect(duplicateCheck, isEmpty);

      // Verify no orphan marks remain for student 2
      final orphanMarks = await db.query(
        DBQueries.tableMarks,
        where: 'student_id = ?',
        whereArgs: [2],
      );
      expect(orphanMarks, isEmpty);
    });

    test('mergeStudents consolidates attendance prioritizing attended status', () async {
      await db.insert(DBQueries.tableStudents, {
        'id': 1,
        'serial_number': '10001',
        'name': 'الطالب الأساسي',
      });
      await db.insert(DBQueries.tableStudents, {
        'id': 2,
        'serial_number': '10002',
        'name': 'الطالب المكرر',
      });

      // Primary was absent for lesson 50; Duplicate attended lesson 50
      await db.insert(DBQueries.tableAttendance, {
        'student_id': 1,
        'lesson_id': 50,
        'date': '2026-09-02',
        'status': 'absent',
        'notes': 'Had excuse',
      });
      await db.insert(DBQueries.tableAttendance, {
        'student_id': 2,
        'lesson_id': 50,
        'date': '2026-09-02',
        'status': 'attended',
        'notes': 'Present in center',
      });

      // Duplicate attended lesson 51 (Primary has no record)
      await db.insert(DBQueries.tableAttendance, {
        'student_id': 2,
        'lesson_id': 51,
        'date': '2026-09-09',
        'status': 'attended',
      });

      await studentCubit.mergeStudents(primaryId: 1, duplicateIds: [2]);

      // Primary's status for lesson 50 should now be attended
      final lesson50 = await db.query(
        DBQueries.tableAttendance,
        where: 'student_id = ? AND lesson_id = ?',
        whereArgs: [1, 50],
      );
      expect(lesson50.length, 1);
      expect(lesson50.first['status'], 'attended');
      expect(lesson50.first['notes'], contains('Had excuse'));
      expect(lesson50.first['notes'], contains('Present in center'));

      // Primary should also now have lesson 51
      final lesson51 = await db.query(
        DBQueries.tableAttendance,
        where: 'student_id = ? AND lesson_id = ?',
        whereArgs: [1, 51],
      );
      expect(lesson51.length, 1);
      expect(lesson51.first['status'], 'attended');
    });

    test('mergeStudents backfills contact info and transfers payments', () async {
      await db.insert(DBQueries.tableStudents, {
        'id': 1,
        'serial_number': '10001',
        'name': 'محمد أحمد',
        'phone1': '01011111111',
        'phone2': '',
        'address': '',
        'school': '',
        'notes': 'Primary notes',
      });
      await db.insert(DBQueries.tableStudents, {
        'id': 2,
        'serial_number': '10002',
        'name': 'محمد احمد',
        'phone1': '01011111111',
        'phone2': '01222222222',
        'address': 'Cairo, Egypt',
        'school': 'Orman School',
        'notes': 'Duplicate notes',
      });

      await db.insert(DBQueries.tablePayments, {
        'student_id': 2,
        'total_amount': 300,
        'paid_amount': 300,
        'paid_date': '2026-09-01',
        'month': 9,
        'year': 2026,
      });

      await studentCubit.mergeStudents(primaryId: 1, duplicateIds: [2]);

      final primary = (await db.query(
        DBQueries.tableStudents,
        where: 'id = ?',
        whereArgs: [1],
      )).first;

      expect(primary['phone2'], '01222222222');
      expect(primary['address'], 'Cairo, Egypt');
      expect(primary['school'], 'Orman School');
      expect(primary['notes'], contains('Primary notes'));
      expect(primary['notes'], contains('Duplicate notes'));

      final payments = await db.query(
        DBQueries.tablePayments,
        where: 'student_id = ?',
        whereArgs: [1],
      );
      expect(payments.length, 1);
      expect(payments.first['paid_amount'], 300);
    });
  });
}
