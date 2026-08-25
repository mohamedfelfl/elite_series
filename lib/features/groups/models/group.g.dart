// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Group _$GroupFromJson(Map<String, dynamic> json) => _Group(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  grade: json['grade'] as String?,
  schedules:
      (json['schedules'] as List<dynamic>?)
          ?.map((e) => GroupSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$GroupToJson(_Group instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'grade': instance.grade,
  'schedules': instance.schedules,
  'createdAt': instance.createdAt?.toIso8601String(),
};
