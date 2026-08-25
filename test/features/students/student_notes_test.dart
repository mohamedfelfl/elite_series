import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';
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

  group('Student Notes (ملاحظات الطالب) Tests', () {
    late Database db;
    late StudentCubit cubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(DBQueries.createGroupsTable);
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createAppSettingsTable);
      cubit = StudentCubit(databaseService: TestDatabaseService(db));
    });

    tearDown(() async {
      await cubit.close();
      await db.close();
    });

    test('Creates student with notes and retrieves it', () async {
      final serial = await cubit.createStudent({
        'serial_number': '10777',
        'name': 'Ahmed Ali',
        'grade': 'prep_1',
        'notes': 'يحتاج إلى متابعة في الواجبات المنزلية',
      });

      expect(serial, '10777');

      final student = await cubit.getStudentBySerial('10777');
      expect(student, isNotNull);
      expect(student!['name'], 'Ahmed Ali');
      expect(student['notes'], 'يحتاج إلى متابعة في الواجبات المنزلية');
    });

    test('Creates student without notes defaults to empty string', () async {
      await cubit.createStudent({
        'serial_number': '10778',
        'name': 'Mona Mohamed',
        'grade': 'prep_1',
      });

      final student = await cubit.getStudentBySerial('10778');
      expect(student, isNotNull);
      expect(student!['notes'], '');
    });

    test('Updates student notes successfully', () async {
      await cubit.createStudent({
        'serial_number': '10779',
        'name': 'Sara Hassan',
        'grade': 'prep_1',
        'notes': 'ملاحظة أولية',
      });

      final initial = await cubit.getStudentBySerial('10779');
      expect(initial, isNotNull);
      final int id = initial!['id'] as int;

      await cubit.updateStudent(id, {
        'serial_number': '10779',
        'name': 'Sara Hassan',
        'grade': 'prep_1',
        'notes': 'تم تحديث الملاحظة بنجاح - مستوى متقدم',
      });

      final updated = await cubit.getStudentById(id);
      expect(updated, isNotNull);
      expect(updated!['notes'], 'تم تحديث الملاحظة بنجاح - مستوى متقدم');
    });

    test('Schema migration: alterStudentsAddNotes adds notes column to existing table', () async {
      final migrationDb = await databaseFactory.openDatabase('migration_test.db');
      await migrationDb.execute('DROP TABLE IF EXISTS students');

      // Simulate an old table without notes column
      await migrationDb.execute('''
        CREATE TABLE students (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          serial_number TEXT NOT NULL UNIQUE,
          name TEXT NOT NULL,
          address TEXT NOT NULL DEFAULT '',
          phone1 TEXT NOT NULL DEFAULT '',
          phone2 TEXT NOT NULL DEFAULT '',
          father_job TEXT NOT NULL DEFAULT '',
          school TEXT NOT NULL DEFAULT '',
          previous_teacher TEXT NOT NULL DEFAULT '',
          group_id INTEGER,
          grade TEXT,
          student_status TEXT NOT NULL DEFAULT 'normal',
          attendance_day TEXT,
          created_at TEXT NOT NULL DEFAULT (datetime('now'))
        )
      ''');

      // Insert record in old schema
      await migrationDb.rawInsert(
        'INSERT INTO students (serial_number, name) VALUES (?, ?)',
        ['10001', 'Old Student'],
      );

      // Run migration
      await migrationDb.execute(DBQueries.alterStudentsAddNotes);

      // Verify query on notes column succeeds
      final rows = await migrationDb.rawQuery('SELECT id, name, notes FROM students WHERE id = 1');
      expect(rows.length, 1);
      expect(rows.first['name'], 'Old Student');
      expect(rows.first['notes'], '');

      // Insert new record with notes
      await migrationDb.rawInsert(
        'INSERT INTO students (serial_number, name, notes) VALUES (?, ?, ?)',
        ['10002', 'New Student', 'ملاحظة بعد الترحيل'],
      );

      final row2 = await migrationDb.rawQuery('SELECT notes FROM students WHERE serial_number = ?', ['10002']);
      expect(row2.first['notes'], 'ملاحظة بعد الترحيل');

      await migrationDb.close();
      await databaseFactory.deleteDatabase('migration_test.db');
    });
  });
}
