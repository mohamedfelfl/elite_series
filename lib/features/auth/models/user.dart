import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User roles in the system.
enum UserRole { admin, user }

/// Permissions that can be assigned to users based on Elite Series allowed features.
enum UserPermission {
  manageStudents,
  manageGroups,
  managePayments,
  manageAttendance,
  generateQrCards,
  viewReports,
  manageUsers,
  manageSettings,
  // Deprecated permissions preserved for backward compatibility
  manageExams,
  manageAssistants,
  manageNotes,
}

extension UserPermissionX on UserPermission {
  /// Whether this permission corresponds to an active feature in Elite Series.
  bool get isAllowedFeature {
    switch (this) {
      case UserPermission.manageStudents:
      case UserPermission.manageGroups:
      case UserPermission.managePayments:
      case UserPermission.manageAttendance:
      case UserPermission.generateQrCards:
      case UserPermission.viewReports:
      case UserPermission.manageUsers:
      case UserPermission.manageSettings:
        return true;
      case UserPermission.manageExams:
      case UserPermission.manageAssistants:
      case UserPermission.manageNotes:
        return false;
    }
  }

  /// Human-readable localized title in Arabic.
  String get localizedName {
    switch (this) {
      case UserPermission.manageStudents:
        return 'إدارة الطلاب';
      case UserPermission.manageGroups:
        return 'إدارة المجموعات';
      case UserPermission.managePayments:
        return 'إدارة المدفوعات';
      case UserPermission.manageAttendance:
        return 'تسجيل الحضور (QR)';
      case UserPermission.generateQrCards:
        return 'توليد كروت الـ QR';
      case UserPermission.viewReports:
        return 'التقارير والإحصائيات';
      case UserPermission.manageUsers:
        return 'إدارة المستخدمين';
      case UserPermission.manageSettings:
        return 'إعدادات النظام';
      case UserPermission.manageExams:
        return 'الامتحانات';
      case UserPermission.manageAssistants:
        return 'المساعدين';
      case UserPermission.manageNotes:
        return 'المذكرات';
    }
  }
}

@freezed
abstract class User with _$User {
  const factory User({
    int? id,
    required String username,
    required String passwordHash,
    @Default(UserRole.user) UserRole role,
    @Default([]) List<UserPermission> permissions,
    DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserX on User {
  /// Checks if the user has a specific permission or is an admin.
  bool can(UserPermission permission) {
    if (role == UserRole.admin) return true;
    return permissions.contains(permission);
  }

  /// List of allowed permissions for Elite Series features.
  static List<UserPermission> get allowedPermissions =>
      UserPermission.values.where((p) => p.isAllowedFeature).toList();
}
