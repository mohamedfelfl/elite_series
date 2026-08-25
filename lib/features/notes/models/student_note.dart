import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_note.freezed.dart';
part 'student_note.g.dart';

@freezed
abstract class StudentNote with _$StudentNote {
  const factory StudentNote({
    int? id,
    required int studentId,
    required int noteId,
    DateTime? deliveredDate,
  }) = _StudentNote;

  factory StudentNote.fromJson(Map<String, dynamic> json) =>
      _$StudentNoteFromJson(json);
}
