// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_exam_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentExamResult _$StudentExamResultFromJson(Map<String, dynamic> json) =>
    _StudentExamResult(
      studentId: (json['studentId'] as num).toInt(),
      studentName: json['studentName'] as String,
      serialNumber: json['serialNumber'] as String,
      totalMarks: (json['totalMarks'] as num).toDouble(),
      totalFullMarks: (json['totalFullMarks'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      examCount: (json['examCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StudentExamResultToJson(_StudentExamResult instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'serialNumber': instance.serialNumber,
      'totalMarks': instance.totalMarks,
      'totalFullMarks': instance.totalFullMarks,
      'percentage': instance.percentage,
      'examCount': instance.examCount,
    };
