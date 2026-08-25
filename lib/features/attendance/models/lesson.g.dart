// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: (json['id'] as num?)?.toInt(),
  groupId: (json['groupId'] as num).toInt(),
  date: json['date'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String?,
  title: json['title'] as String? ?? '',
  status:
      $enumDecodeNullable(_$LessonStatusEnumMap, json['status']) ??
      LessonStatus.scheduled,
  groupName: json['groupName'] as String?,
  enrolledCount: (json['enrolledCount'] as num?)?.toInt() ?? 0,
  attendedCount: (json['attendedCount'] as num?)?.toInt() ?? 0,
  otherGroupCount: (json['otherGroupCount'] as num?)?.toInt() ?? 0,
  absentCount: (json['absentCount'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'groupId': instance.groupId,
  'date': instance.date,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'title': instance.title,
  'status': _$LessonStatusEnumMap[instance.status]!,
  'groupName': instance.groupName,
  'enrolledCount': instance.enrolledCount,
  'attendedCount': instance.attendedCount,
  'otherGroupCount': instance.otherGroupCount,
  'absentCount': instance.absentCount,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$LessonStatusEnumMap = {
  LessonStatus.scheduled: 'scheduled',
  LessonStatus.inProgress: 'inProgress',
  LessonStatus.completed: 'completed',
  LessonStatus.cancelled: 'cancelled',
};
