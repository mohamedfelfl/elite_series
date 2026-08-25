import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';

/// Manages database backup and restore operations.
///
/// Backups are stored in a fixed location: Documents/StudentManagement/Backups/
/// The database file is already SQLCipher-encrypted, providing inherent encryption.
class BackupService {
  final DatabaseService _databaseService;

  BackupService({required DatabaseService databaseService})
    : _databaseService = databaseService;

  /// Get the fixed backup directory path.
  Future<String> getBackupDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(
      p.join(documentsDir.path, 'StudentManagement', 'Backups'),
    );
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  /// Get the database file path.
  Future<String> getDatabasePath() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return p.join(
      documentsDir.path,
      'StudentManagement',
      'student_management.db',
    );
  }

  /// Create a manual backup of the database.
  /// Returns the path to the backup file.
  Future<String> createBackup({String? customName}) async {
    final dbPath = await getDatabasePath();
    final backupDir = await getBackupDirectory();

    // Close the database connection to ensure file is not locked
    // We will re-open it on next database access
    await _databaseService.close();

    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final backupName = customName ?? 'backup_$timestamp';
    final backupPath = p.join(backupDir, '$backupName.db');

    try {
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        throw Exception('Database file not found');
      }

      final targetFile = File(backupPath);
      if (await targetFile.exists()) {
        await targetFile.delete();
      }

      await dbFile.copy(backupPath);

      if (kDebugMode) {
        print('BackupService: Backup created at $backupPath');
      }

      return backupPath;
    } catch (e) {
      if (kDebugMode) {
        print('BackupService: Error creating backup: $e');
      }
      rethrow;
    }
  }

  /// Restore the database from a backup file.
  /// Returns true if successful.
  Future<bool> restoreFromBackup(String backupPath) async {
    final dbPath = await getDatabasePath();

    try {
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw Exception('Backup file not found: $backupPath');
      }

      // Close the current database
      await _databaseService.close();

      // Create a backup of the current database before restoring
      final currentDb = File(dbPath);
      if (await currentDb.exists()) {
        final preRestoreBackup = '$dbPath.pre_restore';
        await currentDb.copy(preRestoreBackup);
      }

      // Copy backup over the current database
      await backupFile.copy(dbPath);

      if (kDebugMode) {
        print('BackupService: Database restored from $backupPath');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('BackupService: Error restoring backup: $e');
      }
      rethrow;
    }
  }

  /// List all available backup files.
  Future<List<BackupInfo>> listBackups() async {
    final backupDir = await getBackupDirectory();
    final dir = Directory(backupDir);

    if (!await dir.exists()) {
      return [];
    }

    final files = await dir
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.db'))
        .cast<File>()
        .toList();

    final backups = <BackupInfo>[];
    for (final file in files) {
      final stat = await file.stat();
      backups.add(
        BackupInfo(
          path: file.path,
          name: p.basenameWithoutExtension(file.path),
          size: stat.size,
          createdAt: stat.modified,
        ),
      );
    }

    // Sort newest first
    backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return backups;
  }

  /// Delete a specific backup file.
  Future<void> deleteBackup(String backupPath) async {
    final file = File(backupPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Delete old backups, keeping only the most recent [maxBackups].
  Future<int> pruneBackups(int maxBackups) async {
    final backups = await listBackups();
    int deletedCount = 0;

    if (backups.length > maxBackups) {
      for (int i = maxBackups; i < backups.length; i++) {
        await deleteBackup(backups[i].path);
        deletedCount++;
      }
    }

    return deletedCount;
  }

  /// Get the current database file size in bytes.
  Future<int> getDatabaseSize() async {
    final dbPath = await getDatabasePath();
    final file = File(dbPath);
    if (await file.exists()) {
      final stat = await file.stat();
      return stat.size;
    }
    return 0;
  }

  /// Get record counts for all tables.
  Future<Map<String, int>> getRecordCounts() async {
    final Database db = await _databaseService.database;
    final tables = [
      DBQueries.tableStudents,
      DBQueries.tableGroups,
      DBQueries.tablePayments,
      DBQueries.tableAttendance,
      DBQueries.tableExams,
      DBQueries.tableMarks,
      DBQueries.tableAssistants,
      DBQueries.tableAssistantAttendance,
      DBQueries.tableNotes,
      DBQueries.tableStudentNotes,
      DBQueries.tableUsers,
      DBQueries.tableLoginAttempts,
    ];

    final counts = <String, int>{};
    for (final table in tables) {
      try {
        final result = await db.query(table, columns: ['COUNT(*) as count']);
        counts[table] = result.first['count'] as int;
      } catch (_) {
        counts[table] = 0;
      }
    }

    return counts;
  }

  /// Run VACUUM to optimize database size.
  Future<void> optimizeDatabase() async {
    final Database db = await _databaseService.database;
    await db.execute('VACUUM');
  }

  /// Run integrity check on the database.
  Future<String> checkIntegrity() async {
    final Database db = await _databaseService.database;
    final result = await db.rawQuery('PRAGMA integrity_check');
    return result.first.values.first.toString();
  }

  /// Export data as CSV (students).
  Future<String> exportStudentsCsv() async {
    final Database db = await _databaseService.database;
    final rows = await db.rawQuery(DBQueries.exportStudentsCsv);

    final buffer = StringBuffer();
    buffer.writeln(
      'Serial Number,Name,Address,Phone 1,Phone 2,Father Job,School,Previous Teacher,Group,Grade,Status,Created At',
    );

    for (final row in rows) {
      buffer.writeln(
        '"${row['serial_number']}",'
        '"${row['name']}",'
        '"${row['address']}",'
        '"${row['phone1']}",'
        '"${row['phone2']}",'
        '"${row['father_job']}",'
        '"${row['school']}",'
        '"${row['previous_teacher']}",'
        '"${row['group_name'] ?? 'N/A'}",'
        '"${row['grade'] ?? 'N/A'}",'
        '"${row['student_status']}",'
        '"${row['created_at']}"',
      );
    }

    return buffer.toString();
  }

  /// Export data as CSV (payments).
  Future<String> exportPaymentsCsv() async {
    final Database db = await _databaseService.database;
    final rows = await db.rawQuery(DBQueries.exportPaymentsCsv);

    final buffer = StringBuffer();
    buffer.writeln(
      'Student Name,Serial Number,Month,Year,Total Amount,Paid Amount,Paid Date',
    );

    for (final row in rows) {
      buffer.writeln(
        '"${row['student_name']}",'
        '"${row['serial_number']}",'
        '${row['month']},'
        '${row['year']},'
        '${row['total_amount']},'
        '${row['paid_amount']},'
        '"${row['paid_date'] ?? ''}"',
      );
    }

    return buffer.toString();
  }

  /// Export data as CSV (attendance).
  Future<String> exportAttendanceCsv() async {
    final Database db = await _databaseService.database;
    final rows = await db.rawQuery(DBQueries.exportAttendanceCsv);

    final buffer = StringBuffer();
    buffer.writeln(
      'Date,Lesson Time,Lesson Group,Student Serial,Student Name,Student Group,Status,Notes',
    );

    for (final row in rows) {
      buffer.writeln(
        '"${row['date'] ?? ''}",'
        '"${row['lesson_time'] ?? ''}",'
        '"${row['lesson_group'] ?? ''}",'
        '"${row['serial_number'] ?? ''}",'
        '"${row['student_name'] ?? ''}",'
        '"${row['student_group'] ?? ''}",'
        '"${row['status'] ?? ''}",'
        '"${row['notes'] ?? ''}"',
      );
    }

    return buffer.toString();
  }

  /// Export data as CSV (marks/grades).
  Future<String> exportMarksCsv() async {
    final Database db = await _databaseService.database;
    final rows = await db.rawQuery(DBQueries.exportMarksCsv);

    final buffer = StringBuffer();
    buffer.writeln('Student Name,Serial Number,Exam Name,Score,Full Mark');

    for (final row in rows) {
      buffer.writeln(
        '"${row['student_name']}",'
        '"${row['serial_number']}",'
        '"${row['exam_name']}",'
        '${row['score']},'
        '${row['full_mark']}',
      );
    }

    return buffer.toString();
  }

  /// Save a CSV string to the backup directory.
  Future<String> saveCsvFile(String csvContent, String fileName) async {
    final backupDir = await getBackupDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final filePath = p.join(backupDir, '${fileName}_$timestamp.csv');
    final file = File(filePath);
    await file.writeAsString(csvContent);
    return filePath;
  }

  /// Purge data older than the specified number of years.
  Future<Map<String, int>> purgeOldData(int years) async {
    final Database db = await _databaseService.database;
    final cutoff = DateTime.now()
        .subtract(Duration(days: years * 365))
        .toIso8601String();

    final counts = <String, int>{};

    counts['attendance'] = await db.delete(
      DBQueries.tableAttendance,
      where: 'date < ?',
      whereArgs: [cutoff],
    );

    counts['payments'] = await db.delete(
      DBQueries.tablePayments,
      where: 'paid_date < ?',
      whereArgs: [cutoff],
    );

    return counts;
  }

  /// Reset ALL data (nuclear option). Drops all data but keeps table structure.
  Future<void> resetAllData() async {
    final Database db = await _databaseService.database;
    await db.transaction((txn) async {
      await txn.delete(DBQueries.tableStudentNotes);
      await txn.delete(DBQueries.tableNotes);
      await txn.delete(DBQueries.tableMarks);
      await txn.delete(DBQueries.tableExamGroups);
      await txn.delete(DBQueries.tableAssistantAttendance);
      await txn.delete(DBQueries.tableAssistants);
      await txn.delete(DBQueries.tableAttendance);
      await txn.delete(DBQueries.tablePayments);
      await txn.delete(DBQueries.tableStudents);
      await txn.delete(DBQueries.tableGroupSchedules);
      await txn.delete(DBQueries.tableGroups);
      await txn.delete(DBQueries.tableExams);
      // Keep users, login_attempts, device_binding, app_settings
    });
  }
}

/// Information about a backup file.
class BackupInfo {
  final String path;
  final String name;
  final int size;
  final DateTime createdAt;

  const BackupInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.createdAt,
  });

  /// Format size as human-readable string.
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
