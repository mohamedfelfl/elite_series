import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../app/constants/db_queries.dart';
import '../../../app/di/injection.dart';
import '../../../app/services/data_migration_service.dart';
import '../../../app/services/data_sync_service.dart';
import '../../../app/services/database_service.dart';
import '../../../app/utils/qr_code_helper.dart';
import '../services/student_merge_service.dart';

part 'student_cubit.freezed.dart';

@freezed
abstract class StudentState with _$StudentState {
  const factory StudentState({
    @Default([]) List<Map<String, dynamic>> students,
    @Default(false) bool isLoading,
    @Default('') String searchQuery,
    @Default(0) int totalCount,
    @Default({}) Set<int> selectedIds,
    int? selectedGroupId,
    String? error,
  }) = _StudentState;
}

class StudentCubit extends Cubit<StudentState> {
  final DatabaseService _databaseService;
  final StudentMergeService _mergeService;
  final DataSyncService? _dataSyncService;
  StreamSubscription<SyncEntity>? _syncSub;

  StudentCubit({
    required DatabaseService databaseService,
    StudentMergeService? mergeService,
    DataSyncService? dataSyncService,
  })  : _databaseService = databaseService,
        _mergeService = mergeService ?? StudentMergeService(databaseService: databaseService),
        _dataSyncService = dataSyncService ?? (getIt.isRegistered<DataSyncService>() ? getIt<DataSyncService>() : null),
        super(const StudentState()) {
    _syncSub = _dataSyncService?.syncStream.listen((entity) {
      if (entity == SyncEntity.groups) {
        loadStudents(silent: true);
      }
    });
  }

  Future<void> loadStudents({bool silent = false}) async {
    if (!silent) {
      emit(state.copyWith(isLoading: true, error: null));
    }
    try {
      final Database db = await _databaseService.database;

      // Always fetch total count (unfiltered)
      final List<Map<String, Object?>> countResult = await db.rawQuery(
        DBQueries.countStudents,
      );
      final int total = (countResult.first['cnt'] as int?) ?? 0;

      // Fetch filtered results
      final String query =
          '''
        ${DBQueries.getStudentsBase}
        ${_buildWhereClause()}
        ORDER BY s.name ASC
      ''';
      final List<Map<String, Object?>> results = await db.rawQuery(
        query,
        _buildWhereArgs(),
      );

      int currentTotal = total;
      List<Map<String, Object?>> currentResults = results;

      if (currentTotal == 0) {
        try {
          if (getIt.isRegistered<DataMigrationService>()) {
            final migrationResult =
                await getIt<DataMigrationService>().checkAndAutoMigrate();
            if (migrationResult != null && migrationResult.studentsImported > 0) {
              final List<Map<String, Object?>> updatedCount = await db.rawQuery(
                DBQueries.countStudents,
              );
              currentTotal = (updatedCount.first['cnt'] as int?) ?? 0;
              currentResults = await db.rawQuery(
                query,
                _buildWhereArgs(),
              );
            }
          }
        } catch (_) {}
      }

      // Prune selectedIds to only include IDs still in the result set
      final resultIds = currentResults.map((s) => s['id'] as int).toSet();
      final pruned = state.selectedIds.intersection(resultIds);

      emit(
        state.copyWith(
          students: currentResults,
          totalCount: currentTotal,
          selectedIds: pruned,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query, selectedIds: const {}));
    loadStudents();
  }

  void filterByGroup(int? groupId) {
    emit(state.copyWith(selectedGroupId: groupId));
    loadStudents();
  }

  // ── Selection helpers ──

  void toggleSelection(int id) {
    final updated = Set<int>.from(state.selectedIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(state.copyWith(selectedIds: updated));
  }

  void selectAll() {
    final allIds = state.students.map((s) => s['id'] as int).toSet();
    emit(state.copyWith(selectedIds: allIds));
  }

  void toggleAll() {
    if (state.selectedIds.length == state.students.length) {
      // Deselect all
      clearSelection();
    } else {
      // Select all visible
      selectAll();
    }
  }

  void clearSelection() {
    emit(state.copyWith(selectedIds: const {}));
  }

  // ── CRUD ──

  Future<String> createStudent(
    Map<String, dynamic> data, {
    bool allowDuplicateName = false,
  }) async {
    try {
      final Database db = await _databaseService.database;
      final name = data['name']?.toString().trim() ?? '';
      if (!allowDuplicateName && name.isNotEmpty) {
        final existing = await db.query(
          DBQueries.tableStudents,
          where: 'LOWER(TRIM(name)) = LOWER(TRIM(?))',
          whereArgs: [name],
        );
        if (existing.isNotEmpty) {
          throw Exception('student_name_exists');
        }
      }

      final grade = (data['grade']?.toString() ?? 'sec_1').trim().toLowerCase();
      String serial = data['serial_number']?.toString().trim() ?? '';

      // Perform atomic serial check, allocation & insertion inside a database transaction
      final finalSerial = await db.transaction<String>((txn) async {
        bool needsRecalculation = serial.isEmpty;
        if (!needsRecalculation) {
          final existing = await txn.rawQuery(
            'SELECT id FROM ${DBQueries.tableStudents} WHERE serial_number = ?',
            [serial],
          );
          if (existing.isNotEmpty) {
            needsRecalculation = true;
          }
        }

        if (needsRecalculation) {
          serial = await _calculateNextSerial(txn, grade);
        }

        final Map<String, dynamic> insertData = Map<String, dynamic>.from(data);
        insertData['serial_number'] = serial;
        insertData['grade'] = grade;

        await txn.insert(DBQueries.tableStudents, insertData);

        // Update tracking counter in app_settings table
        int? sequenceNum;
        if (serial.contains('-')) {
          sequenceNum = int.tryParse(serial.split('-').last);
        } else {
          sequenceNum = int.tryParse(serial);
        }
        if (sequenceNum != null) {
          await txn.insert(
            DBQueries.tableAppSettings,
            {
              'key': 'serial_counter_$grade',
              'value': sequenceNum.toString(),
              'updated_at': DateTime.now().toIso8601String(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        return serial;
      });

      await loadStudents(silent: true);
      _dataSyncService?.notifyStudentsChanged();
      return finalSerial;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> updateStudent(
    int id,
    Map<String, dynamic> data, {
    bool allowDuplicateName = false,
  }) async {
    try {
      final Database db = await _databaseService.database;
      final name = data['name']?.toString().trim() ?? '';
      if (!allowDuplicateName && name.isNotEmpty) {
        final existing = await db.query(
          DBQueries.tableStudents,
          where: 'LOWER(TRIM(name)) = LOWER(TRIM(?)) AND id != ?',
          whereArgs: [name, id],
        );
        if (existing.isNotEmpty) {
          throw Exception('student_name_exists');
        }
      }

      await db.update(
        DBQueries.tableStudents,
        data,
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
      await loadStudents(silent: true);
      _dataSyncService?.notifyStudentsChanged();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteStudent(int id) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(
        DBQueries.tableStudents,
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
      await loadStudents(silent: true);
      _dataSyncService?.notifyStudentsChanged();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteMultipleStudents(Set<int> ids) async {
    if (ids.isEmpty) return;
    try {
      final Database db = await _databaseService.database;
      final placeholders = List.filled(ids.length, '?').join(',');
      await db.rawDelete(
        '${DBQueries.deleteMultipleStudentsBase} ($placeholders)',
        ids.toList(),
      );
      emit(state.copyWith(selectedIds: const {}));
      await loadStudents(silent: true);
      _dataSyncService?.notifyStudentsChanged();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Fetches all students with their group names (unfiltered) for duplicate checks and references.
  Future<List<Map<String, dynamic>>> getAllStudentsWithGroups() => getAllStudentsRaw();

  /// Returns all active students directly as maps without affecting cubit state.
  Future<List<Map<String, dynamic>>> getAllStudentsRaw() async {
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.rawQuery(
        '''
        ${DBQueries.getStudentsBase}
        ORDER BY s.name ASC
        ''',
      );
      return results.map((r) => Map<String, dynamic>.from(r)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Searches for students matching [query] (name, serial number, or phone)
  /// with an optional [limit]. Does NOT alter the cubit's global state.
  Future<List<Map<String, dynamic>>> searchStudentsQuick(
    String query, {
    int limit = 10,
  }) async {
    final clean = query.trim();
    if (clean.isEmpty) return const [];
    try {
      final Database db = await _databaseService.database;

      // Variants for Arabic alif normalization
      final normAlif = clean
          .replaceAll('أ', 'ا')
          .replaceAll('إ', 'ا')
          .replaceAll('آ', 'ا');
      final hamzaAbove = clean.replaceAll('ا', 'أ');

      final variants = <String>{clean, normAlif, hamzaAbove}
          .where((v) => v.isNotEmpty)
          .toList();

      final orClauses = variants
          .map((_) => DBQueries.studentSearchCondition)
          .join(' OR ');
      final args = <Object?>[];
      for (final v in variants) {
        final w = '%$v%';
        args.addAll([w, w, w]);
      }
      args.add(limit);

      final String sql = '''
        ${DBQueries.getStudentsBase}
        WHERE ($orClauses)
        ORDER BY s.name ASC
        LIMIT ?
      ''';
      final List<Map<String, Object?>> results = await db.rawQuery(sql, args);
      return results.map((r) => Map<String, dynamic>.from(r)).toList();
    } catch (e) {
      return const [];
    }
  }

  // ── Duplicate Management & Merge ──

  Future<List<DuplicateStudentGroup>> findDuplicates() {
    return _mergeService.findDuplicates();
  }

  Future<MergeSummary> previewMerge({
    required int primaryId,
    required List<int> duplicateIds,
  }) {
    return _mergeService.previewMerge(
      primaryId: primaryId,
      duplicateIds: duplicateIds,
    );
  }

  Future<void> mergeStudents({
    required int primaryId,
    required List<int> duplicateIds,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _mergeService.mergeStudents(
        primaryId: primaryId,
        duplicateIds: duplicateIds,
      );
      emit(state.copyWith(selectedIds: const {}));
      await loadStudents(silent: true);
      _dataSyncService?.notifyStudentsChanged();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getStudentById(int id) async {
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.getStudentById,
        <Object?>[id],
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStudentBySerial(String rawSerial) async {
    final serial = QrCodeHelper.extractSerialNumber(rawSerial);
    if (serial.isEmpty) return null;

    try {
      final Database db = await _databaseService.database;
      List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.getStudentBySerial,
        <Object?>[serial],
      );

      if (results.isEmpty && rawSerial.trim() != serial) {
        results = await db.rawQuery(
          DBQueries.getStudentBySerial,
          <Object?>[rawSerial.trim()],
        );
      }

      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      return null;
    }
  }

  /// Map grade to Elite Series stage code prefix (sec_1 -> '01', sec_2 -> '02', sec_3 -> '03')
  static String getStagePrefix(String grade) {
    final clean = grade.trim().toLowerCase();
    switch (clean) {
      case 'sec_1':
      case '1':
      case 'first':
      case 'stage_1':
        return '01';
      case 'sec_2':
      case '2':
      case 'second':
      case 'stage_2':
        return '02';
      case 'sec_3':
      case '3':
      case 'third':
      case 'stage_3':
        return '03';
      default:
        if (clean.contains('1')) return '01';
        if (clean.contains('2')) return '02';
        if (clean.contains('3')) return '03';
        return '01';
    }
  }

  Future<String> _calculateNextSerial(dynamic executor, String grade) async {
    final String cleanGrade = grade.trim().toLowerCase();
    final String stagePrefix = getStagePrefix(cleanGrade);
    final String codePrefix = 'EL-$stagePrefix-';

    int maxSequence = 0;

    // 1. Read tracked counter from app_settings
    try {
      final List<Map<String, Object?>> tracked = await executor.rawQuery(
        'SELECT value FROM ${DBQueries.tableAppSettings} WHERE key = ?',
        ['serial_counter_$cleanGrade'],
      );
      if (tracked.isNotEmpty) {
        final trackedVal = int.tryParse(tracked.first['value']?.toString().trim() ?? '');
        if (trackedVal != null && trackedVal > maxSequence) {
          maxSequence = trackedVal;
        }
      }
    } catch (_) {}

    // 2. Read existing serials from students table
    final List<Map<String, Object?>> rows = await executor.rawQuery(
      'SELECT serial_number FROM ${DBQueries.tableStudents}',
    );

    final Set<String> existingSerials = <String>{};

    for (final row in rows) {
      final serialRaw = row['serial_number']?.toString().trim();
      if (serialRaw == null || serialRaw.isEmpty) continue;
      existingSerials.add(serialRaw);

      if (serialRaw.startsWith(codePrefix)) {
        final numericPart = serialRaw.substring(codePrefix.length);
        final parsed = int.tryParse(numericPart);
        if (parsed != null && parsed > maxSequence) {
          maxSequence = parsed;
        }
      }
    }

    int nextSequence = maxSequence + 1;
    String candidate = '$codePrefix${nextSequence.toString().padLeft(5, '0')}';

    while (existingSerials.contains(candidate)) {
      nextSequence++;
      candidate = '$codePrefix${nextSequence.toString().padLeft(5, '0')}';
    }

    return candidate;
  }

  Future<String> getNextSerialNumber(String grade) async {
    try {
      final Database db = await _databaseService.database;
      return await _calculateNextSerial(db, grade);
    } catch (e) {
      final stagePrefix = getStagePrefix(grade);
      return 'EL-$stagePrefix-00001';
    }
  }

  String _buildWhereClause() {
    final List<String> conditions = <String>[];
    if (state.searchQuery.isNotEmpty) {
      conditions.add(DBQueries.studentSearchCondition);
    }
    if (state.selectedGroupId != null) {
      conditions.add(DBQueries.studentGroupCondition);
    }
    return conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';
  }

  List<Object?> _buildWhereArgs() {
    final List<Object?> args = <Object?>[];
    if (state.searchQuery.isNotEmpty) {
      final String q = '%${state.searchQuery}%';
      args.addAll(<Object?>[q, q, q]);
    }
    if (state.selectedGroupId != null) {
      args.add(state.selectedGroupId);
    }
    return args;
  }

  @override
  Future<void> close() {
    _syncSub?.cancel();
    return super.close();
  }
}
