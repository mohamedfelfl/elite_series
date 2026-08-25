import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../../generated/locale_keys.g.dart';

import '../../../app/services/database_service.dart';

part 'assistant_attendance_cubit.freezed.dart';

@freezed
abstract class AssistantAttendanceState with _$AssistantAttendanceState {
  const factory AssistantAttendanceState({
    @Default([]) List<Map<String, dynamic>> records,
    @Default(false) bool isLoading,
    String? error,
  }) = _AssistantAttendanceState;
}

class AssistantAttendanceCubit extends Cubit<AssistantAttendanceState> {
  final DatabaseService _databaseService;

  AssistantAttendanceCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const AssistantAttendanceState());

  Future<void> loadAttendance(int assistantId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.rawQuery(
        '''
        SELECT aa.*
        FROM assistant_attendance aa
        WHERE aa.assistant_id = ?
        ORDER BY aa.date DESC, aa.id DESC
      ''',
        [assistantId],
      );
      emit(state.copyWith(records: results, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> recordAttendance(int assistantId, String type) async {
    try {
      final Database db = await _databaseService.database;
      final today = DateTime.now().toIso8601String().split('T').first;

      // Check the latest record today
      final List<Map<String, Object?>> latest = await db.query(
        'assistant_attendance',
        where: 'assistant_id = ? AND date = ?',
        whereArgs: <Object?>[assistantId, today],
        orderBy: 'id DESC',
        limit: 1,
      );

      if (latest.isNotEmpty) {
        final lastType = latest.first['type'] as String;
        if (lastType == type) {
          final typeString = type == 'in'
              ? LocaleKeys.in_type.tr()
              : LocaleKeys.out_type.tr();
          emit(
            state.copyWith(
              error: LocaleKeys.invalid_attendance_in_out.tr(
                args: [typeString, typeString],
              ),
            ),
          );
          return;
        }
      } else if (type == 'out') {
        // If the very first record of the day is "out" we could theoretically restrict it,
        // but maybe they forgot to sign in. The requirement states:
        // "the error message tell him that in & out are recorded" - wait, the user said
        // "first record attendance is in and the second is out if the user to add attendance again for the assiss. the error message tell him that in & out are recorded"
        // Let's implement specifically that restriction: if there's an IN and OUT for the day, subsequent attempts error.
        // Let's count records today.
      }

      final List<Map<String, Object?>> allToday = await db.query(
        'assistant_attendance',
        where: 'assistant_id = ? AND date = ?',
        whereArgs: <Object?>[assistantId, today],
        orderBy: 'id ASC',
      );

      if (allToday.length >= 2) {
        emit(state.copyWith(error: LocaleKeys.assistant_attendance_full.tr()));
        return;
      }

      if (allToday.isEmpty && type != 'in') {
        emit(state.copyWith(error: LocaleKeys.first_record_must_be_in.tr()));
        return;
      }

      await db.insert('assistant_attendance', <String, Object?>{
        'assistant_id': assistantId,
        'date': today,
        'type': type,
      });

      await loadAttendance(assistantId);
      emit(state.copyWith(error: null)); // Clear any previous error
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteAttendance(int id, int assistantId) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(
        'assistant_attendance',
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
      await loadAttendance(assistantId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
