import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';

part 'assistant_cubit.freezed.dart';

@freezed
abstract class AssistantState with _$AssistantState {
  const factory AssistantState({
    @Default([]) List<Map<String, dynamic>> assistants,
    @Default(false) bool isLoading,
    @Default('') String searchQuery,
    @Default(0) int totalCount,
    @Default({}) Set<int> selectedIds,
    String? error,
  }) = _AssistantState;
}

class AssistantCubit extends Cubit<AssistantState> {
  final DatabaseService _databaseService;

  AssistantCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const AssistantState());

  Future<void> loadAssistants() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;

      final List<Map<String, Object?>> countResult = await db.rawQuery(
        DBQueries.countAssistants,
      );
      final int total = (countResult.first['cnt'] as int?) ?? 0;

      final String query =
          '''
        ${DBQueries.getAssistantsBase}
        ${_buildWhereClause()}
        ORDER BY name ASC
      ''';
      final List<Map<String, Object?>> results = await db.rawQuery(
        query,
        _buildWhereArgs(),
      );

      final resultIds = results.map((s) => s['id'] as int).toSet();
      final pruned = state.selectedIds.intersection(resultIds);

      emit(
        state.copyWith(
          assistants: results,
          totalCount: total,
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
    loadAssistants();
  }

  void toggleSelection(int id) {
    final updated = Set<int>.from(state.selectedIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(state.copyWith(selectedIds: updated));
  }

  void toggleAll() {
    if (state.selectedIds.length == state.assistants.length) {
      emit(state.copyWith(selectedIds: const {}));
    } else {
      final allIds = state.assistants.map((s) => s['id'] as int).toSet();
      emit(state.copyWith(selectedIds: allIds));
    }
  }

  void clearSelection() {
    emit(state.copyWith(selectedIds: const {}));
  }

  Future<void> createAssistant(Map<String, dynamic> data) async {
    try {
      final Database db = await _databaseService.database;
      await db.insert(DBQueries.tableAssistants, data);
      await loadAssistants();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> updateAssistant(int id, Map<String, dynamic> data) async {
    try {
      final Database db = await _databaseService.database;
      await db.update(
        DBQueries.tableAssistants,
        data,
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
      await loadAssistants();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteAssistant(int id) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(DBQueries.tableAssistants, where: 'id = ?', whereArgs: <Object?>[id]);
      await loadAssistants();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteMultipleAssistants(Set<int> ids) async {
    if (ids.isEmpty) return;
    try {
      final Database db = await _databaseService.database;
      final placeholders = List.filled(ids.length, '?').join(',');
      await db.rawDelete(
        '${DBQueries.deleteMultipleAssistantsBase} ($placeholders)',
        ids.toList(),
      );
      emit(state.copyWith(selectedIds: const {}));
      await loadAssistants();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getAssistantById(int id) async {
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.query(
        DBQueries.tableAssistants,
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      return null;
    }
  }

  String _buildWhereClause() {
    final List<String> conditions = <String>[];
    if (state.searchQuery.isNotEmpty) {
      conditions.add('(name LIKE ? OR serial_number LIKE ? OR phone LIKE ?)');
    }
    return conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';
  }

  List<Object?> _buildWhereArgs() {
    final List<Object?> args = <Object?>[];
    if (state.searchQuery.isNotEmpty) {
      final String q = '%${state.searchQuery}%';
      args.addAll(<Object?>[q, q, q]);
    }
    return args;
  }
}
