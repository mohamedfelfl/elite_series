import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/note.dart';

part 'notes_state.freezed.dart';

@freezed
abstract class NotesState with _$NotesState {
  const factory NotesState({
    @Default(false) bool isLoading,
    @Default([]) List<Note> notes,
    @Default({}) Map<int, bool> currentDeliveries, // Persistent in DB
    @Default({}) Map<int, bool> pendingDeliveries, // Draft changes in UI
    int? selectedNoteId,
    String? error,
    DateTime? lastSaveTimestamp,
  }) = _NotesState;
}
