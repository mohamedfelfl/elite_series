// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num?)?.toInt(),
  username: json['username'] as String,
  passwordHash: json['passwordHash'] as String,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$UserPermissionEnumMap, e))
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'passwordHash': instance.passwordHash,
  'role': _$UserRoleEnumMap[instance.role]!,
  'permissions': instance.permissions
      .map((e) => _$UserPermissionEnumMap[e]!)
      .toList(),
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$UserRoleEnumMap = {UserRole.admin: 'admin', UserRole.user: 'user'};

const _$UserPermissionEnumMap = {
  UserPermission.manageStudents: 'manageStudents',
  UserPermission.manageGroups: 'manageGroups',
  UserPermission.managePayments: 'managePayments',
  UserPermission.manageAttendance: 'manageAttendance',
  UserPermission.generateQrCards: 'generateQrCards',
  UserPermission.viewReports: 'viewReports',
  UserPermission.manageUsers: 'manageUsers',
  UserPermission.manageSettings: 'manageSettings',
  UserPermission.manageExams: 'manageExams',
  UserPermission.manageAssistants: 'manageAssistants',
  UserPermission.manageNotes: 'manageNotes',
};
