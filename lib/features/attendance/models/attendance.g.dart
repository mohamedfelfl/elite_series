// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Attendance _$AttendanceFromJson(Map<String, dynamic> json) => _Attendance(
  id: (json['id'] as num?)?.toInt(),
  lessonId: (json['lessonId'] as num?)?.toInt(),
  studentId: (json['studentId'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
  notes: json['notes'] as String? ?? '',
  studentName: json['studentName'] as String?,
  serialNumber: json['serialNumber'] as String?,
  groupName: json['groupName'] as String?,
);

Map<String, dynamic> _$AttendanceToJson(_Attendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lessonId': instance.lessonId,
      'studentId': instance.studentId,
      'date': instance.date.toIso8601String(),
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'studentName': instance.studentName,
      'serialNumber': instance.serialNumber,
      'groupName': instance.groupName,
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.attended: 'attended',
  AttendanceStatus.missed: 'missed',
  AttendanceStatus.otherLesson: 'otherLesson',
};
