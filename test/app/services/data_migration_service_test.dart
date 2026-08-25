import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as cipher;
import 'package:student_management_system/app/constants/db_queries.dart';
import 'package:student_management_system/app/services/data_migration_service.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/app/services/encryption_service.dart';

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

  group('DataMigrationService Tests', () {
    test('mapStageToGrade maps all known stages correctly', () {
      expect(DataMigrationService.mapStageToGrade('stage_1'), 'sec_1');
      expect(DataMigrationService.mapStageToGrade('stage_2'), 'sec_2');
      expect(DataMigrationService.mapStageToGrade('stage_3'), 'sec_3');
      expect(DataMigrationService.mapStageToGrade('1'), 'sec_1');
      expect(DataMigrationService.mapStageToGrade('2'), 'sec_2');
      expect(DataMigrationService.mapStageToGrade('3'), 'sec_3');
    });

    test('migrateFromEliteDb imports groups, schedules and students cleanly',
        () async {
      const sourceDbPath =
          r'C:\Users\moham\Desktop\kamal\Elite Series - Mohamed Kamal\Elite_Data\elite.db';

      if (!File(sourceDbPath).existsSync()) {
        return;
      }

      final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(DBQueries.createGroupsTable);
      await db.execute(DBQueries.createGroupSchedulesTable);
      await db.execute(DBQueries.createStudentsTable);
      await db.execute(DBQueries.createAppSettingsTable);

      final databaseService = TestDatabaseService(db);
      final migrationService = DataMigrationService(
        databaseService: databaseService,
      );

      final result = await migrationService.migrateFromEliteDb(sourceDbPath);

      expect(result.success, true);
      expect(result.groupsImported, 26);
      expect(result.schedulesImported, 52);
      expect(result.studentsImported, 1910);

      final groupCount = cipher.Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM groups'),
          ) ??
          0;
      final studentCount = cipher.Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM students'),
          ) ??
          0;
      final scheduleCount = cipher.Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM group_schedules'),
          ) ??
          0;

      expect(groupCount, 26);
      expect(studentCount, 1910);
      expect(scheduleCount, 52);

      // Verify a sample student has correct group and grade assigned
      final sampleStudent = await db.rawQuery('''
        SELECT s.name, s.serial_number, s.grade, g.name as group_name
        FROM students s
        LEFT JOIN groups g ON g.id = s.group_id
        WHERE s.serial_number = 'EL-01-00001'
      ''');

      expect(sampleStudent.isNotEmpty, true);
      expect(sampleStudent.first['name'], 'اروي رمضان العارف');
      expect(sampleStudent.first['grade'], 'sec_1');
      expect(sampleStudent.first['group_name'], 'السبت والثلاثاء الساعة 12');

      // Verify student codes across all stages
      final stageCounts = await db.rawQuery('''
        SELECT grade, COUNT(*) as count FROM students GROUP BY grade ORDER BY grade
      ''');
      expect(stageCounts.isNotEmpty, true);

      await db.close();
    });
  });
}
