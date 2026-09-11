import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:sqflite_sqlcipher/sqflite.dart' as mobile;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqlcipher_library_windows/sqlcipher_library_windows.dart';
import 'package:sqlite3/open.dart' as sqlite_open;

import '../constants/db_queries.dart';
import 'encryption_service.dart';

/// Centralized database service for initializing and accessing the SQLite database.
///
/// Supports both mobile (sqflite) and desktop (sqflite_common_ffi).
/// The database is encrypted using a passphrase stored in secure storage.
class DatabaseService {
  static Database? _database;
  static const int _dbVersion = 1;
  static const String _dbName = 'student_management.db';

  // ignore: unused_field
  final EncryptionService _encryptionService;

  DatabaseService({required EncryptionService encryptionService})
    : _encryptionService = encryptionService;

  /// Returns the singleton database instance, initializing if needed.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database factory for the current platform.
  static void initPlatform() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      if (Platform.isWindows) {
        sqlite_open.open.overrideFor(
          sqlite_open.OperatingSystem.windows,
          openSQLCipherOnWindows,
        );
      }
      ffi.sqfliteFfiInit();
      // We don't override the global databaseFactory to avoid typing issues with sqflite_sqlcipher
    }
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await _getDatabasePath();
    final String password = await _encryptionService.getDatabaseKey();

    if (kDebugMode) {
      print('Database path: $dbPath');
    }

    try {
      return await _openDbWithPassword(dbPath, password);
    } catch (e) {
      // If the database is an old unencrypted database, SQLCipher will throw "file is not a database".
      // We will backup the old DB and create a fresh encrypted one.
      if (e.toString().contains('not a database')) {
        if (kDebugMode) {
          print(
            'Found old unencrypted DB, renaming to .old and starting fresh encrypted one.',
          );
        }
        try {
          final File oldDb = File(dbPath);
          if (await oldDb.exists()) {
            await oldDb.rename('$dbPath.old');
          }
        } catch (_) {}
        // Try opening again
        return await _openDbWithPassword(dbPath, password);
      }
      rethrow;
    }
  }

  Future<Database> _openDbWithPassword(String dbPath, String password) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return ffi.databaseFactoryFfi.openDatabase(
        dbPath,
        options: ffi.OpenDatabaseOptions(
          version: _dbVersion,
          onCreate: _onCreate,
          onOpen: _onOpen,
          onConfigure: (db) async {
            // Execute PRAGMA key first to unlock the SQLCipher database
            await db.execute("PRAGMA key = '$password'");
            await db.execute('PRAGMA foreign_keys = ON');
            await db.execute('PRAGMA busy_timeout = 5000');
            await db.execute('PRAGMA journal_mode = WAL');
            await db.execute('PRAGMA synchronous = NORMAL');
          },
        ),
      );
    } else {
      return mobile.openDatabase(
        dbPath,
        password: password,
        version: _dbVersion,
        onCreate: _onCreate,
        onOpen: _onOpen,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
          await db.execute('PRAGMA busy_timeout = 5000');
          await db.execute('PRAGMA journal_mode = WAL');
          await db.execute('PRAGMA synchronous = NORMAL');
        },
      );
    }
  }

  Future<String> _getDatabasePath() async {
    final Directory documentsDir = await getApplicationDocumentsDirectory();
    final Directory dbDir = Directory(
      join(documentsDir.path, 'StudentManagement'),
    );
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    return join(dbDir.path, _dbName);
  }

  /// Create all tables on first launch.
  Future<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();

    batch.execute(DBQueries.createUsersTable);
    batch.execute(DBQueries.createGroupsTable);
    batch.execute(DBQueries.createGroupSchedulesTable);
    batch.execute(DBQueries.createStudentsTable);
    batch.execute(DBQueries.createPaymentsTable);
    batch.execute(DBQueries.createLessonsTable);
    batch.execute(DBQueries.createAttendanceTable);
    batch.execute(DBQueries.createAssistantsTable);
    batch.execute(DBQueries.createAssistantAttendanceTable);
    batch.execute(DBQueries.createExamsTable);
    batch.execute(DBQueries.createExamGroupsTable);
    batch.execute(DBQueries.createMarksTable);
    batch.execute(DBQueries.createNotesTable);
    batch.execute(DBQueries.createStudentNotesTable);
    batch.execute(DBQueries.createAppSettingsTable);
    batch.execute(DBQueries.createDeviceBindingTable);
    batch.execute(DBQueries.createLoginAttemptsTable);

    await batch.commit(noResult: true);

    // Create indexes for performance
    await db.execute(DBQueries.createIdxStudentsGroup);
    await db.execute(DBQueries.createIdxPaymentsStudent);
    await db.execute(DBQueries.createIdxAttendanceStudent);
    await db.execute(DBQueries.createIdxAttendanceDate);
    await db.execute(DBQueries.createIdxMarksExam);
    await db.execute(DBQueries.createIdxMarksStudent);
    await db.execute(DBQueries.createIdxGroupSchedulesGroup);
    await db.execute(DBQueries.createIdxAssistantAttendanceAssistant);
    await db.execute(DBQueries.createIdxAssistantAttendanceDate);
    await db.execute(DBQueries.createIdxLoginAttemptsUsername);
    await db.execute(DBQueries.createIdxLessonsGroup);
    await db.execute(DBQueries.createIdxLessonsDate);
    await db.execute(DBQueries.createIdxLessonsStatus);
    await db.execute(DBQueries.createIdxAttendanceLesson);
    await db.execute(DBQueries.createIdxStudentsSerial);
    await db.execute(DBQueries.createIdxStudentsName);
    await db.execute(DBQueries.createIdxAttendanceLessonStudent);
  }

  /// Ensure all required tables exist on every open.
  /// This handles existing databases that were created at an older version.
  Future<void> _onOpen(Database db) async {
    if (kDebugMode) {
      print('Running _onOpen: ensuring all required tables exist...');
    }

    // Tables
    await db.execute(DBQueries.createUsersTable);
    await db.execute(DBQueries.createGroupsTable);
    await db.execute(DBQueries.createGroupSchedulesTable);
    await db.execute(DBQueries.createStudentsTable);
    await db.execute(DBQueries.createPaymentsTable);
    await db.execute(DBQueries.createLessonsTable);
    await db.execute(DBQueries.createAttendanceTable);
    await db.execute(DBQueries.createAssistantsTable);
    await db.execute(DBQueries.createAssistantAttendanceTable);
    await db.execute(DBQueries.createExamsTable);
    await db.execute(DBQueries.createExamGroupsTable);
    await db.execute(DBQueries.createMarksTable);
    await db.execute(DBQueries.createNotesTable);
    await db.execute(DBQueries.createStudentNotesTable);
    await db.execute(DBQueries.createAppSettingsTable);
    await db.execute(DBQueries.createDeviceBindingTable);
    await db.execute(DBQueries.createLoginAttemptsTable);

    // Ensure columns added in past migrations exist
    try {
      await db.execute(DBQueries.alterUsersAddSalt);
    } catch (_) {}
    try {
      await db.execute(DBQueries.alterUsersAddMustChangePassword);
    } catch (_) {}
    try {
      await db.execute(DBQueries.alterGroupsAddGrade);
    } catch (_) {}
    try {
      await db.execute(DBQueries.alterStudentsAddGrade);
    } catch (_) {}
    try {
      await db.execute(DBQueries.alterStudentsAddStatus);
    } catch (_) {}
    try {
      await db.execute(DBQueries.alterStudentsAddAttendanceDay);
    } catch (_) {}
    try {
      await db.execute(DBQueries.alterStudentsAddNotes);
    } catch (_) {}
    try {
      await db.execute(DBQueries.alterAttendanceAddLessonId);
    } catch (_) {}
    try {
      await db.execute(DBQueries.alterLessonsAddCreatedAt);
    } catch (_) {}

    // Ensure indexes exist
    try {
      await db.execute(DBQueries.createIdxStudentsGroup);
      await db.execute(DBQueries.createIdxPaymentsStudent);
      await db.execute(DBQueries.createIdxAttendanceStudent);
      await db.execute(DBQueries.createIdxAttendanceDate);
      await db.execute(DBQueries.createIdxMarksExam);
      await db.execute(DBQueries.createIdxMarksStudent);
      await db.execute(DBQueries.createIdxGroupSchedulesGroup);
      await db.execute(DBQueries.createIdxAssistantAttendanceAssistant);
      await db.execute(DBQueries.createIdxAssistantAttendanceDate);
      await db.execute(DBQueries.createIdxLoginAttemptsUsername);
      await db.execute(DBQueries.createIdxLessonsGroup);
      await db.execute(DBQueries.createIdxLessonsDate);
      await db.execute(DBQueries.createIdxLessonsStatus);
      await db.execute(DBQueries.createIdxAttendanceLesson);
      await db.execute(DBQueries.createIdxStudentsSerial);
      await db.execute(DBQueries.createIdxStudentsName);
      await db.execute(DBQueries.createIdxAttendanceLessonStudent);
    } catch (_) {}

    // Auto-migrate legacy attendance records without a lesson_id
    try {
      final List<Map<String, Object?>> unlinked = await db.rawQuery('''
        SELECT DISTINCT a.date, s.group_id
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        WHERE a.lesson_id IS NULL AND s.group_id IS NOT NULL
      ''');

      for (final row in unlinked) {
        final String date = row['date'] as String;
        final int groupId = row['group_id'] as int;

        final List<Map<String, Object?>> existingLesson = await db.query(
          DBQueries.tableLessons,
          where: 'group_id = ? AND date = ?',
          whereArgs: [groupId, date],
          limit: 1,
        );

        int lessonId;
        if (existingLesson.isNotEmpty) {
          lessonId = existingLesson.first['id'] as int;
        } else {
          lessonId = await db.insert(DBQueries.tableLessons, {
            'group_id': groupId,
            'date': date,
            'start_time': '00:00',
            'status': 'completed',
            'title': 'Legacy Session',
            'created_at': DateTime.now().toIso8601String(),
          });
        }

        await db.rawUpdate('''
          UPDATE attendance
          SET lesson_id = ?
          WHERE date = ? AND lesson_id IS NULL AND student_id IN (
            SELECT id FROM students WHERE group_id = ?
          )
        ''', [lessonId, date, groupId]);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Legacy attendance migration notice: $e');
      }
    }

    // Clean group names to remove redundant stage numbers (e.g. "1 ث", "2 ث", "3 ث")
    try {
      final List<Map<String, Object?>> groupRows =
          await db.query(DBQueries.tableGroups);
      for (final g in groupRows) {
        final id = g['id'] as int;
        final rawName = g['name']?.toString() ?? '';
        String cleanName = rawName.replaceAll('الثللاثاء', 'الثلاثاء');
        cleanName = cleanName.replaceAll(RegExp(r'\s*[123]\s*ث\s*'), ' ');
        cleanName = cleanName.replaceAll(RegExp(r'\s+'), ' ').trim();
        if (cleanName != rawName && cleanName.isNotEmpty) {
          await db.update(
            DBQueries.tableGroups,
            {'name': cleanName},
            where: 'id = ?',
            whereArgs: [id],
          );
        }
      }
    } catch (_) {}

    // Clean up any duplicate student names, keeping the oldest record
    try {
      final List<Map<String, Object?>> allStudents = await db.query(
        DBQueries.tableStudents,
        columns: ['id', 'name'],
        orderBy: 'id ASC',
      );
      final Map<String, int> seenStudents = {};
      final List<int> duplicateIdsToDelete = [];

      for (final st in allStudents) {
        final id = st['id'] as int;
        final name = st['name']?.toString().trim() ?? '';
        if (name.isEmpty) continue;
        String norm = name.replaceAll(RegExp(r'^[\s\-.*#_]+|[\s\-.*#_]+$'), '').trim();
        norm = norm.replaceAll(RegExp(r'[\u064B-\u065F\u0640]'), '');
        norm = norm.replaceAll(RegExp(r'\s+'), ' ');
        norm = norm.replaceAll(RegExp(r'[إأآٱ]'), 'ا');
        norm = norm
            .replaceAll('ئ', 'ي')
            .replaceAll('ى', 'ي')
            .replaceAll('ة', 'ه')
            .replaceAll('ؤ', 'و')
            .replaceAll('ء', '')
            .replaceAll('ذكي', 'زكي');

        // Unify specific compound prefixes only (e.g. عبد الرحمن / عبدالرحمن, أبو الفتوح / ابوالفتوح)
        norm = norm.replaceAll(RegExp(r'عبد\s+'), 'عبد');
        norm = norm.replaceAll(RegExp(r'ابو\s+'), 'ابو');
        norm = norm.replaceAll(RegExp(r'نور\s+ال'), 'نورال');
        norm = norm.replaceAll(RegExp(r'ضياء\s+ال'), 'ضياءال');
        norm = norm.replaceAll(RegExp(r'سيف\s+ال'), 'سيفال');
        norm = norm.replaceAll(RegExp(r'منه\s+الله'), 'منهالله');
        norm = norm.replaceAll(RegExp(r'ايه\s+الله'), 'ايهالله');

        norm = norm.replaceAll(RegExp(r'\s+'), ' ').trim();

        if (seenStudents.containsKey(norm)) {
          duplicateIdsToDelete.add(id);
        } else {
          seenStudents[norm] = id;
        }
      }

      for (final dupId in duplicateIdsToDelete) {
        await db.delete(
          DBQueries.tableStudents,
          where: 'id = ?',
          whereArgs: [dupId],
        );
      }
    } catch (_) {}
  }

  /// Close the database connection.
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
