// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Student _$StudentFromJson(Map<String, dynamic> json) => _Student(
  id: (json['id'] as num?)?.toInt(),
  serialNumber: json['serialNumber'] as String,
  name: json['name'] as String,
  address: json['address'] as String? ?? '',
  phone1: json['phone1'] as String? ?? '',
  phone2: json['phone2'] as String? ?? '',
  fatherJob: json['fatherJob'] as String? ?? '',
  school: json['school'] as String? ?? '',
  previousTeacher: json['previousTeacher'] as String? ?? '',
  grade: json['grade'] as String?,
  groupId: (json['groupId'] as num?)?.toInt(),
  groupName: json['groupName'] as String?,
  studentStatus: json['studentStatus'] as String? ?? 'normal',
  attendanceDay: json['attendanceDay'] as String?,
  notes: json['notes'] as String? ?? '',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$StudentToJson(_Student instance) => <String, dynamic>{
  'id': instance.id,
  'serialNumber': instance.serialNumber,
  'name': instance.name,
  'address': instance.address,
  'phone1': instance.phone1,
  'phone2': instance.phone2,
  'fatherJob': instance.fatherJob,
  'school': instance.school,
  'previousTeacher': instance.previousTeacher,
  'grade': instance.grade,
  'groupId': instance.groupId,
  'groupName': instance.groupName,
  'studentStatus': instance.studentStatus,
  'attendanceDay': instance.attendanceDay,
  'notes': instance.notes,
  'createdAt': instance.createdAt?.toIso8601String(),
};
