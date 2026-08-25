import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import 'database_service.dart';

/// Result summary of a database migration run.
class MigrationResult {
  final bool success;
  final int groupsImported;
  final int schedulesImported;
  final int studentsImported;
  final String? errorMessage;

  const MigrationResult({
    required this.success,
    this.groupsImported = 0,
    this.schedulesImported = 0,
    this.studentsImported = 0,
    this.errorMessage,
  });

  @override
  String toString() =>
      'MigrationResult(success: $success, groups: $groupsImported, schedules: $schedulesImported, students: $studentsImported, error: $errorMessage)';
}

/// Service that handles migrating data from legacy or external SQLite databases (e.g. elite.db)
/// into the application's encrypted SQLCipher database.
class DataMigrationService {
  final DatabaseService _databaseService;

  DataMigrationService({required DatabaseService databaseService})
      : _databaseService = databaseService;

  static const String defaultSourceDbPath =
      r'C:\Users\moham\Desktop\kamal\Elite Series - Mohamed Kamal\Elite_Data\elite.db';

  /// Maps source stage IDs (stage_1, stage_2, stage_3) to app grade tokens (sec_1, sec_2, sec_3)
  static String mapStageToGrade(String stageId) {
    switch (stageId.trim().toLowerCase()) {
      case 'stage_1':
        return 'sec_1';
      case 'stage_2':
        return 'sec_2';
      case 'stage_3':
        return 'sec_3';
      default:
        if (stageId.contains('1')) return 'sec_1';
        if (stageId.contains('2')) return 'sec_2';
        if (stageId.contains('3')) return 'sec_3';
        return 'sec_1';
    }
  }

  /// Removes redundant stage numbers (1 ث, 2 ث, 3 ث) and cleans group names
  static String cleanGroupName(String name) {
    String n = name.trim();
    n = n.replaceAll('الثللاثاء', 'الثلاثاء');
    n = n.replaceAll(RegExp(r'\s*[123]\s*ث\s*'), ' ');
    n = n.replaceAll(RegExp(r'\s+'), ' ').trim();
    return n;
  }

  /// Normalizes Arabic student names to detect duplicates with slight spelling variations,
  /// compound name spacing, punctuation, and diacritics.
  static String normalizeStudentName(String name) {
    String t = name.trim();
    // Strip leading/trailing dashes, symbols, or punctuation
    t = t.replaceAll(RegExp(r'^[\s\-.*#_]+|[\s\-.*#_]+$'), '').trim();
    // Remove diacritics (tashkeel) and tatweel
    t = t.replaceAll(RegExp(r'[\u064B-\u065F\u0640]'), '');
    t = t.replaceAll(RegExp(r'\s+'), ' ');
    // Unify alifs
    t = t.replaceAll(RegExp(r'[إأآٱ]'), 'ا');
    // Unify hamza on yaa/waw and taa marbuta
    t = t
        .replaceAll('ئ', 'ي')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ء', '')
        .replaceAll('ذكي', 'زكي');

    // Unify specific compound prefixes only (e.g. عبد الرحمن / عبدالرحمن, أبو الفتوح / ابوالفتوح)
    t = t.replaceAll(RegExp(r'عبد\s+'), 'عبد');
    t = t.replaceAll(RegExp(r'ابو\s+'), 'ابو');
    t = t.replaceAll(RegExp(r'نور\s+ال'), 'نورال');
    t = t.replaceAll(RegExp(r'ضياء\s+ال'), 'ضياءال');
    t = t.replaceAll(RegExp(r'سيف\s+ال'), 'سيفال');
    t = t.replaceAll(RegExp(r'منه\s+الله'), 'منهالله');
    t = t.replaceAll(RegExp(r'ايه\s+الله'), 'ايهالله');

    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
    return t;
  }

  /// Check if auto-migration is needed and run it if the source database exists.
  Future<MigrationResult?> checkAndAutoMigrate({String? customPath}) async {
    final path = customPath ?? defaultSourceDbPath;
    final file = File(path);
    if (!await file.exists()) {
      return null;
    }

    try {
      sql.Database? sourceDb;
      int sourceStudentCount = 0;
      try {
        sourceDb = sql.sqlite3.open(path, mode: sql.OpenMode.readOnly);
        final res = sourceDb.select('SELECT COUNT(*) as c FROM students');
        if (res.isNotEmpty) {
          sourceStudentCount = (res.first['c'] as num?)?.toInt() ?? 0;
        }
      } catch (e) {
        debugPrint('Reading source DB student count error: $e');
      } finally {
        sourceDb?.dispose();
      }

      final db = await _databaseService.database;
      final targetStudentCount = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM students'),
          ) ??
          0;

      if (sourceStudentCount > targetStudentCount || targetStudentCount == 0) {
        debugPrint(
          'Automated sync/migration: target has $targetStudentCount, source has $sourceStudentCount. Starting migration from: $path',
        );
        return await migrateFromEliteDb(path);
      }
    } catch (e) {
      debugPrint('checkAndAutoMigrate check failed: $e');
    }
    return null;
  }

  /// Migrates all stages, groups, group schedules, and students from the external elite.db
  Future<MigrationResult> migrateFromEliteDb(String sourceDbPath) async {
    final file = File(sourceDbPath);
    if (!await file.exists()) {
      return MigrationResult(
        success: false,
        errorMessage: 'ملف قاعدة البيانات غير موجود: $sourceDbPath',
      );
    }

    sql.Database? sourceDb;
    try {
      sourceDb = sql.sqlite3.open(sourceDbPath, mode: sql.OpenMode.readOnly);
      final targetDb = await _databaseService.database;

      int groupsImported = 0;
      int schedulesImported = 0;
      int studentsImported = 0;

      await targetDb.transaction((txn) async {
        // 1. Read all groups from source
        final groupsResultSet = sourceDb!.select('''
          SELECT id, stage_id, name, days, start_time, duration_minutes, created_at
          FROM groups
        ''');

        final Map<String, int> sourceGroupIdToTargetId = {};

        for (final row in groupsResultSet) {
          final sourceId = row['id']?.toString() ?? '';
          final stageId = row['stage_id']?.toString() ?? 'stage_1';
          final rawName = row['name']?.toString() ?? 'مجموعة';
          final name = cleanGroupName(rawName);
          final grade = mapStageToGrade(stageId);
          final rawDays = row['days']?.toString() ?? '[]';
          final startTime = row['start_time']?.toString() ?? '12:00';
          final createdAt = row['created_at']?.toString() ??
              DateTime.now().toIso8601String();

          List<String> daysList = [];
          try {
            final decoded = jsonDecode(rawDays);
            if (decoded is List) {
              daysList = decoded.map((e) => e.toString()).toList();
            }
          } catch (_) {
            daysList = [rawDays];
          }

          final dayOfWeekCombined = daysList.join(' و ');

          // Check if group already exists by name & grade
          final existing = await txn.query(
            'groups',
            columns: ['id'],
            where: 'name = ? AND grade = ?',
            whereArgs: [name, grade],
            limit: 1,
          );

          int targetGroupId;
          if (existing.isNotEmpty) {
            targetGroupId = existing.first['id'] as int;
          } else {
            targetGroupId = await txn.insert('groups', {
              'name': name,
              'grade': grade,
              'day_of_week': dayOfWeekCombined,
              'time': startTime,
              'created_at': createdAt,
            });
            groupsImported++;

            // Insert schedule entries
            for (final day in daysList) {
              if (day.trim().isNotEmpty) {
                await txn.insert('group_schedules', {
                  'group_id': targetGroupId,
                  'day_of_week': day.trim(),
                  'time': startTime,
                });
                schedulesImported++;
              }
            }
          }

          sourceGroupIdToTargetId[sourceId] = targetGroupId;
        }

        // 2. Read all students with their current group membership
        final studentsResultSet = sourceDb!.select('''
          SELECT st.id, st.name, st.student_code, st.stage_id, st.notes, st.created_at,
                 m.group_id as current_group_id
          FROM students st
          LEFT JOIN student_group_memberships m ON m.student_id = st.id AND m.is_current = 1
        ''');

        // Pre-load existing students to prevent duplicates and keep older ones
        final List<Map<String, Object?>> existingRows = await txn.query(
          'students',
          columns: ['id', 'name', 'serial_number'],
        );
        final Set<String> existingSerials = {};
        final Map<String, int> existingNormalizedNames = {};

        for (final r in existingRows) {
          final s = r['serial_number']?.toString().trim() ?? '';
          final n = r['name']?.toString().trim() ?? '';
          final id = r['id'] as int;
          if (s.isNotEmpty) existingSerials.add(s);
          if (n.isNotEmpty) {
            final norm = normalizeStudentName(n);
            existingNormalizedNames.putIfAbsent(norm, () => id);
          }
        }

        for (final row in studentsResultSet) {
          final studentCode = row['student_code']?.toString().trim() ?? '';
          final name = row['name']?.toString().trim() ?? '';
          final stageId = row['stage_id']?.toString() ?? 'stage_1';
          final grade = mapStageToGrade(stageId);
          final sourceGroupId = row['current_group_id']?.toString();
          final notes = row['notes']?.toString() ?? '';
          final createdAt = row['created_at']?.toString() ??
              DateTime.now().toIso8601String();

          final targetGroupId = sourceGroupId != null
              ? sourceGroupIdToTargetId[sourceGroupId]
              : null;

          if (studentCode.isEmpty || name.isEmpty) continue;

          final normName = normalizeStudentName(name);

          // If student already exists by serial or by normalized name, keep the old one
          if (existingSerials.contains(studentCode) ||
              existingNormalizedNames.containsKey(normName)) {
            final existingId = existingNormalizedNames[normName];
            if (existingId != null && targetGroupId != null) {
              await txn.update(
                'students',
                {'group_id': targetGroupId, 'grade': grade},
                where: 'id = ?',
                whereArgs: [existingId],
              );
            }
            continue;
          }

          final newStudentId = await txn.insert('students', {
            'serial_number': studentCode,
            'name': name,
            'address': '',
            'phone1': '',
            'phone2': '',
            'father_job': '',
            'school': '',
            'previous_teacher': '',
            'group_id': targetGroupId,
            'grade': grade,
            'student_status': 'normal',
            'attendance_day': null,
            'notes': notes,
            'created_at': createdAt,
          });
          studentsImported++;
          existingSerials.add(studentCode);
          existingNormalizedNames[normName] = newStudentId;
        }

        // 3. Update stage serial counters in app_settings table
        try {
          for (final stageGrade in ['sec_1', 'sec_2', 'sec_3']) {
            final stagePrefix = stageGrade == 'sec_1'
                ? '01'
                : (stageGrade == 'sec_2' ? '02' : '03');
            final List<Map<String, Object?>> rows = await txn.rawQuery('''
              SELECT serial_number FROM students WHERE serial_number LIKE 'EL-$stagePrefix-%'
            ''');
            int maxSeq = 0;
            for (final r in rows) {
              final s = r['serial_number']?.toString() ?? '';
              final numPart = int.tryParse(s.split('-').last);
              if (numPart != null && numPart > maxSeq) {
                maxSeq = numPart;
              }
            }
            if (maxSeq > 0) {
              await txn.insert(
                'app_settings',
                {
                  'key': 'serial_counter_$stageGrade',
                  'value': maxSeq.toString(),
                  'updated_at': DateTime.now().toIso8601String(),
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
        } catch (_) {}
      });

      debugPrint(
        'Migration Completed Successfully: $groupsImported groups, $schedulesImported schedules, $studentsImported students imported.',
      );

      return MigrationResult(
        success: true,
        groupsImported: groupsImported,
        schedulesImported: schedulesImported,
        studentsImported: studentsImported,
      );
    } catch (e, st) {
      debugPrint('Migration failed with error: $e\n$st');
      return MigrationResult(
        success: false,
        errorMessage: e.toString(),
      );
    } finally {
      sourceDb?.dispose();
    }
  }
}
