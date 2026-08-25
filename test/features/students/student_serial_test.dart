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

  group('Student Serial Number Auto-Increment Tests (Elite Series)', () {
    late Database db;
    late StudentCubit cubit;

    setUp(() async {
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createAppSettingsTable);
      cubit = StudentCubit(databaseService: TestDatabaseService(db));
    });

    tearDown(() async {
      await cubit.close();
      await db.close();
    });

    test('Returns starting EL-01-00001 for sec_1 on empty database', () async {
      final serial = await cubit.getNextSerialNumber('sec_1');
      expect(serial, 'EL-01-00001');
    });

    test('Increments sequentially as sec_1 students are added', () async {
      expect(await cubit.getNextSerialNumber('sec_1'), 'EL-01-00001');

      final assigned1 = await cubit.createStudent({
        'serial_number': 'EL-01-00001',
        'name': 'Student 1',
        'grade': 'sec_1',
      });
      expect(assigned1, 'EL-01-00001');
      expect(await cubit.getNextSerialNumber('sec_1'), 'EL-01-00002');

      final assigned2 = await cubit.createStudent({
        'serial_number': 'EL-01-00002',
        'name': 'Student 2',
        'grade': 'sec_1',
      });
      expect(assigned2, 'EL-01-00002');
      expect(await cubit.getNextSerialNumber('sec_1'), 'EL-01-00003');
    });

    test('Calculates distinct independent sequential ranges for all stages',
        () async {
      expect(await cubit.getNextSerialNumber('sec_1'), 'EL-01-00001');
      expect(await cubit.getNextSerialNumber('sec_2'), 'EL-02-00001');
      expect(await cubit.getNextSerialNumber('sec_3'), 'EL-03-00001');

      await cubit.createStudent({
        'serial_number': 'EL-02-00001',
        'name': 'Sec 2 Student 1',
        'grade': 'sec_2',
      });

      // sec_2 increments, while sec_1 remains at starting index
      expect(await cubit.getNextSerialNumber('sec_2'), 'EL-02-00002');
      expect(await cubit.getNextSerialNumber('sec_1'), 'EL-01-00001');
    });

    test('Avoids duplicate collisions when serial exists', () async {
      await cubit.createStudent({
        'serial_number': 'EL-01-00001',
        'name': 'Existing Student',
        'grade': 'sec_1',
      });
      await cubit.createStudent({
        'serial_number': 'EL-01-00002',
        'name': 'Existing Student 2',
        'grade': 'sec_1',
      });

      expect(await cubit.getNextSerialNumber('sec_1'), 'EL-01-00003');
    });

    test(
        'createStudent automatically resolves conflicts when duplicate serial is submitted',
        () async {
      await cubit.createStudent({
        'serial_number': 'EL-01-00001',
        'name': 'Original Student',
        'grade': 'sec_1',
      });

      final resolvedSerial = await cubit.createStudent({
        'serial_number': 'EL-01-00001',
        'name': 'Concurrent Student',
        'grade': 'sec_1',
      });

      expect(resolvedSerial, 'EL-01-00002');
      expect(await cubit.getNextSerialNumber('sec_1'), 'EL-01-00003');
    });
  });
}
