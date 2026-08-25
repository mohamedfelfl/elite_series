// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Mark _$MarkFromJson(Map<String, dynamic> json) => _Mark(
  id: (json['id'] as num?)?.toInt(),
  examId: (json['examId'] as num).toInt(),
  studentId: (json['studentId'] as num).toInt(),
  score: (json['score'] as num).toDouble(),
  studentName: json['studentName'] as String?,
  examName: json['examName'] as String?,
  examFullMark: (json['examFullMark'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MarkToJson(_Mark instance) => <String, dynamic>{
  'id': instance.id,
  'examId': instance.examId,
  'studentId': instance.studentId,
  'score': instance.score,
  'studentName': instance.studentName,
  'examName': instance.examName,
  'examFullMark': instance.examFullMark,
};
