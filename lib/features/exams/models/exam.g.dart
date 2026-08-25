// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exam _$ExamFromJson(Map<String, dynamic> json) => _Exam(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  fullMark: (json['fullMark'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$ExamToJson(_Exam instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'fullMark': instance.fullMark,
  'date': instance.date.toIso8601String(),
};
