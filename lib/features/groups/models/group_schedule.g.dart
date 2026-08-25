// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupSchedule _$GroupScheduleFromJson(Map<String, dynamic> json) =>
    _GroupSchedule(
      id: (json['id'] as num?)?.toInt(),
      groupId: (json['groupId'] as num?)?.toInt(),
      dayOfWeek: json['dayOfWeek'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$GroupScheduleToJson(_GroupSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'dayOfWeek': instance.dayOfWeek,
      'time': instance.time,
    };
