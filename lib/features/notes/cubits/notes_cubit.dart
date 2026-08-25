import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';
import '../models/note.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final DatabaseService _databaseService;

  NotesCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const NotesState()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DBQueries.tableNotes,
        orderBy: 'id DESC',
      );

      final notes = maps.map((e) => Note.fromJson(e)).toList();
      emit(state.copyWith(isLoading: false, notes: notes));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addNote(String name, double price) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final db = await _databaseService.database;
      await db.insert(DBQueries.tableNotes, {'name': name, 'price': price});
      await loadNotes();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> updateNote(int id, String name, double price) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final db = await _databaseService.database;
      await db.update(
        DBQueries.tableNotes,
        {'name': name, 'price': price},
        where: 'id = ?',
        whereArgs: [id],
      );
      await loadNotes();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteNote(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final db = await _databaseService.database;
      await db.delete(DBQueries.tableNotes, where: 'id = ?', whereArgs: [id]);
      await loadNotes();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  void selectNoteForDelivery(int? noteId) {
    emit(
      state.copyWith(
        selectedNoteId: noteId,
        currentDeliveries: {},
        pendingDeliveries: {},
      ),
    );
    if (noteId != null) {
      loadDeliveries(noteId);
    }
  }

  Future<void> loadDeliveries(int noteId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DBQueries.tableStudentNotes,
        where: 'note_id = ?',
        whereArgs: [noteId],
      );

      final deliveries = <int, bool>{};
      for (final map in maps) {
        deliveries[map['student_id'] as int] = true;
      }

      emit(
        state.copyWith(
          isLoading: false,
          currentDeliveries: deliveries,
          pendingDeliveries: {}, // Always start with empty selection
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void updateDeliveryStatusLocal(int studentId, bool delivered) {
    final noteId = state.selectedNoteId;
    if (noteId == null) return;

    final newPending = Map<int, bool>.from(state.pendingDeliveries);
    final isCurrentlyDelivered = state.currentDeliveries[studentId] == true;

    if (delivered == isCurrentlyDelivered) {
      newPending.remove(studentId);
    } else {
      newPending[studentId] = delivered;
    }
    emit(state.copyWith(pendingDeliveries: newPending));
  }

  void updateBatchDeliveryLocal(List<int> studentIds, bool delivered) {
    final noteId = state.selectedNoteId;
    if (noteId == null || studentIds.isEmpty) return;

    final newPending = Map<int, bool>.from(state.pendingDeliveries);
    for (final id in studentIds) {
      final isCurrentlyDelivered = state.currentDeliveries[id] == true;
      if (delivered == isCurrentlyDelivered) {
        newPending.remove(id);
      } else {
        newPending[id] = delivered;
      }
    }
    emit(state.copyWith(pendingDeliveries: newPending));
  }

  Future<void> saveDeliveries() async {
    final noteId = state.selectedNoteId;
    if (noteId == null) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final db = await _databaseService.database;
      final newCurrent = Map<int, bool>.from(state.currentDeliveries);

      await db.transaction((txn) async {
        final now = DateTime.now().toIso8601String();
        for (final entry in state.pendingDeliveries.entries) {
          final id = entry.key;
          final targetDelivered = entry.value;

          if (targetDelivered) {
            // Target: Delivered -> Add to DB
            await txn.insert(
              DBQueries.tableStudentNotes,
              {'student_id': id, 'note_id': noteId, 'delivered_date': now},
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
            newCurrent[id] = true;
          } else {
            // Target: Not Delivered -> Remove from DB
            await txn.delete(
              DBQueries.tableStudentNotes,
              where: 'student_id = ? AND note_id = ?',
              whereArgs: [id, noteId],
            );
            newCurrent.remove(id);
          }
        }
      });

      emit(
        state.copyWith(
          isLoading: false,
          currentDeliveries: newCurrent,
          pendingDeliveries: {}, // Reset after save
          lastSaveTimestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  void clearPendingDeliveries() {
    emit(state.copyWith(pendingDeliveries: {}));
  }
}
