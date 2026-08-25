// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentNote _$StudentNoteFromJson(Map<String, dynamic> json) => _StudentNote(
  id: (json['id'] as num?)?.toInt(),
  studentId: (json['studentId'] as num).toInt(),
  noteId: (json['noteId'] as num).toInt(),
  deliveredDate: json['deliveredDate'] == null
      ? null
      : DateTime.parse(json['deliveredDate'] as String),
);

Map<String, dynamic> _$StudentNoteToJson(_StudentNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'noteId': instance.noteId,
      'deliveredDate': instance.deliveredDate?.toIso8601String(),
    };
