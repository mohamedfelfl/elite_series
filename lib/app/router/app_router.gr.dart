// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i28;
import 'package:flutter/material.dart' as _i29;
import 'package:student_management_system/app/shared/screens/shell_screen.dart'
    as _i23;
import 'package:student_management_system/features/admin/screens/admin_panel/admin_panel_screen.dart'
    as _i1;
import 'package:student_management_system/features/admin/screens/user_form/user_form_screen.dart'
    as _i27;
import 'package:student_management_system/features/assistants/screens/assistant_detail/assistant_detail_screen.dart'
    as _i2;
import 'package:student_management_system/features/assistants/screens/assistant_form/assistant_form_screen.dart'
    as _i3;
import 'package:student_management_system/features/assistants/screens/assistant_list/assistant_list_screen.dart'
    as _i4;
import 'package:student_management_system/features/attendance/screens/qr_scanner/qr_scanner_screen.dart'
    as _i19;
import 'package:student_management_system/features/auth/screens/login/login_screen.dart'
    as _i13;
import 'package:student_management_system/features/dashboard/screens/dashboard/dashboard_screen.dart'
    as _i5;
import 'package:student_management_system/features/exams/screens/exam_detail/exam_detail_screen.dart'
    as _i6;
import 'package:student_management_system/features/exams/screens/exam_form/exam_form_screen.dart'
    as _i7;
import 'package:student_management_system/features/exams/screens/exam_list/exam_list_screen.dart'
    as _i8;
import 'package:student_management_system/features/exams/screens/exams_management/exams_management_screen.dart'
    as _i9;
import 'package:student_management_system/features/exams/screens/mark_entry/mark_entry_screen.dart'
    as _i14;
import 'package:student_management_system/features/groups/screens/group_form/group_form_screen.dart'
    as _i10;
import 'package:student_management_system/features/groups/screens/group_list/group_list_screen.dart'
    as _i11;
import 'package:student_management_system/features/notes/screens/notes_screen.dart'
    as _i15;
import 'package:student_management_system/features/payments/screens/payment_form/payment_form_screen.dart'
    as _i16;
import 'package:student_management_system/features/payments/screens/payment_list/payment_list_screen.dart'
    as _i17;
import 'package:student_management_system/features/qr_card_generator/presentation/screens/qr_card_generator_screen.dart'
    as _i18;
import 'package:student_management_system/features/reports/screens/honored_students/honored_students_screen.dart'
    as _i12;
import 'package:student_management_system/features/reports/screens/report/report_screen.dart'
    as _i20;
import 'package:student_management_system/features/settings/screens/settings_screen.dart'
    as _i21;
import 'package:student_management_system/features/settings/screens/setup_wizard_screen.dart'
    as _i22;
import 'package:student_management_system/features/students/screens/student_detail/student_detail_screen.dart'
    as _i24;
import 'package:student_management_system/features/students/screens/student_form/student_form_screen.dart'
    as _i25;
import 'package:student_management_system/features/students/screens/student_list/student_list_screen.dart'
    as _i26;

/// generated route for
/// [_i1.AdminPanelScreen]
class AdminPanelRoute extends _i28.PageRouteInfo<void> {
  const AdminPanelRoute({List<_i28.PageRouteInfo>? children})
    : super(AdminPanelRoute.name, initialChildren: children);

  static const String name = 'AdminPanelRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdminPanelScreen();
    },
  );
}

/// generated route for
/// [_i2.AssistantDetailScreen]
class AssistantDetailRoute
    extends _i28.PageRouteInfo<AssistantDetailRouteArgs> {
  AssistantDetailRoute({
    _i29.Key? key,
    required Map<String, dynamic> assistant,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         AssistantDetailRoute.name,
         args: AssistantDetailRouteArgs(key: key, assistant: assistant),
         initialChildren: children,
       );

  static const String name = 'AssistantDetailRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssistantDetailRouteArgs>();
      return _i2.AssistantDetailScreen(
        key: args.key,
        assistant: args.assistant,
      );
    },
  );
}

class AssistantDetailRouteArgs {
  const AssistantDetailRouteArgs({this.key, required this.assistant});

  final _i29.Key? key;

  final Map<String, dynamic> assistant;

  @override
  String toString() {
    return 'AssistantDetailRouteArgs{key: $key, assistant: $assistant}';
  }
}

/// generated route for
/// [_i3.AssistantFormScreen]
class AssistantFormRoute extends _i28.PageRouteInfo<AssistantFormRouteArgs> {
  AssistantFormRoute({
    _i29.Key? key,
    Map<String, dynamic>? assistant,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         AssistantFormRoute.name,
         args: AssistantFormRouteArgs(key: key, assistant: assistant),
         initialChildren: children,
       );

  static const String name = 'AssistantFormRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssistantFormRouteArgs>(
        orElse: () => const AssistantFormRouteArgs(),
      );
      return _i3.AssistantFormScreen(key: args.key, assistant: args.assistant);
    },
  );
}

class AssistantFormRouteArgs {
  const AssistantFormRouteArgs({this.key, this.assistant});

  final _i29.Key? key;

  final Map<String, dynamic>? assistant;

  @override
  String toString() {
    return 'AssistantFormRouteArgs{key: $key, assistant: $assistant}';
  }
}

/// generated route for
/// [_i4.AssistantListScreen]
class AssistantListRoute extends _i28.PageRouteInfo<void> {
  const AssistantListRoute({List<_i28.PageRouteInfo>? children})
    : super(AssistantListRoute.name, initialChildren: children);

  static const String name = 'AssistantListRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i4.AssistantListScreen();
    },
  );
}

/// generated route for
/// [_i5.DashboardScreen]
class DashboardRoute extends _i28.PageRouteInfo<void> {
  const DashboardRoute({List<_i28.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i5.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i6.ExamDetailScreen]
class ExamDetailRoute extends _i28.PageRouteInfo<ExamDetailRouteArgs> {
  ExamDetailRoute({
    _i29.Key? key,
    required int examId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         ExamDetailRoute.name,
         args: ExamDetailRouteArgs(key: key, examId: examId),
         initialChildren: children,
       );

  static const String name = 'ExamDetailRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ExamDetailRouteArgs>();
      return _i6.ExamDetailScreen(key: args.key, examId: args.examId);
    },
  );
}

class ExamDetailRouteArgs {
  const ExamDetailRouteArgs({this.key, required this.examId});

  final _i29.Key? key;

  final int examId;

  @override
  String toString() {
    return 'ExamDetailRouteArgs{key: $key, examId: $examId}';
  }
}

/// generated route for
/// [_i7.ExamFormScreen]
class ExamFormRoute extends _i28.PageRouteInfo<ExamFormRouteArgs> {
  ExamFormRoute({
    _i29.Key? key,
    int? examId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         ExamFormRoute.name,
         args: ExamFormRouteArgs(key: key, examId: examId),
         initialChildren: children,
       );

  static const String name = 'ExamFormRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ExamFormRouteArgs>(
        orElse: () => const ExamFormRouteArgs(),
      );
      return _i7.ExamFormScreen(key: args.key, examId: args.examId);
    },
  );
}

class ExamFormRouteArgs {
  const ExamFormRouteArgs({this.key, this.examId});

  final _i29.Key? key;

  final int? examId;

  @override
  String toString() {
    return 'ExamFormRouteArgs{key: $key, examId: $examId}';
  }
}

/// generated route for
/// [_i8.ExamListScreen]
class ExamListRoute extends _i28.PageRouteInfo<void> {
  const ExamListRoute({List<_i28.PageRouteInfo>? children})
    : super(ExamListRoute.name, initialChildren: children);

  static const String name = 'ExamListRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i8.ExamListScreen();
    },
  );
}

/// generated route for
/// [_i9.ExamsManagementScreen]
class ExamsManagementRoute extends _i28.PageRouteInfo<void> {
  const ExamsManagementRoute({List<_i28.PageRouteInfo>? children})
    : super(ExamsManagementRoute.name, initialChildren: children);

  static const String name = 'ExamsManagementRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i9.ExamsManagementScreen();
    },
  );
}

/// generated route for
/// [_i10.GroupFormScreen]
class GroupFormRoute extends _i28.PageRouteInfo<GroupFormRouteArgs> {
  GroupFormRoute({_i29.Key? key, int? id, List<_i28.PageRouteInfo>? children})
    : super(
        GroupFormRoute.name,
        args: GroupFormRouteArgs(key: key, id: id),
        initialChildren: children,
      );

  static const String name = 'GroupFormRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupFormRouteArgs>(
        orElse: () => const GroupFormRouteArgs(),
      );
      return _i10.GroupFormScreen(key: args.key, id: args.id);
    },
  );
}

class GroupFormRouteArgs {
  const GroupFormRouteArgs({this.key, this.id});

  final _i29.Key? key;

  final int? id;

  @override
  String toString() {
    return 'GroupFormRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i11.GroupListScreen]
class GroupListRoute extends _i28.PageRouteInfo<void> {
  const GroupListRoute({List<_i28.PageRouteInfo>? children})
    : super(GroupListRoute.name, initialChildren: children);

  static const String name = 'GroupListRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i11.GroupListScreen();
    },
  );
}

/// generated route for
/// [_i12.HonoredStudentsScreen]
class HonoredStudentsRoute extends _i28.PageRouteInfo<void> {
  const HonoredStudentsRoute({List<_i28.PageRouteInfo>? children})
    : super(HonoredStudentsRoute.name, initialChildren: children);

  static const String name = 'HonoredStudentsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i12.HonoredStudentsScreen();
    },
  );
}

/// generated route for
/// [_i13.LoginScreen]
class LoginRoute extends _i28.PageRouteInfo<void> {
  const LoginRoute({List<_i28.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i13.LoginScreen();
    },
  );
}

/// generated route for
/// [_i14.MarkEntryScreen]
class MarkEntryRoute extends _i28.PageRouteInfo<MarkEntryRouteArgs> {
  MarkEntryRoute({
    _i29.Key? key,
    int? id,
    int? studentId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         MarkEntryRoute.name,
         args: MarkEntryRouteArgs(key: key, id: id, studentId: studentId),
         initialChildren: children,
       );

  static const String name = 'MarkEntryRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MarkEntryRouteArgs>(
        orElse: () => const MarkEntryRouteArgs(),
      );
      return _i14.MarkEntryScreen(
        key: args.key,
        id: args.id,
        studentId: args.studentId,
      );
    },
  );
}

class MarkEntryRouteArgs {
  const MarkEntryRouteArgs({this.key, this.id, this.studentId});

  final _i29.Key? key;

  final int? id;

  final int? studentId;

  @override
  String toString() {
    return 'MarkEntryRouteArgs{key: $key, id: $id, studentId: $studentId}';
  }
}

/// generated route for
/// [_i15.NotesScreen]
class NotesRoute extends _i28.PageRouteInfo<void> {
  const NotesRoute({List<_i28.PageRouteInfo>? children})
    : super(NotesRoute.name, initialChildren: children);

  static const String name = 'NotesRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i15.NotesScreen();
    },
  );
}

/// generated route for
/// [_i16.PaymentFormScreen]
class PaymentFormRoute extends _i28.PageRouteInfo<void> {
  const PaymentFormRoute({List<_i28.PageRouteInfo>? children})
    : super(PaymentFormRoute.name, initialChildren: children);

  static const String name = 'PaymentFormRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i16.PaymentFormScreen();
    },
  );
}

/// generated route for
/// [_i17.PaymentListScreen]
class PaymentListRoute extends _i28.PageRouteInfo<PaymentListRouteArgs> {
  PaymentListRoute({
    _i29.Key? key,
    int? studentId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         PaymentListRoute.name,
         args: PaymentListRouteArgs(key: key, studentId: studentId),
         rawQueryParams: {'studentId': studentId},
         initialChildren: children,
       );

  static const String name = 'PaymentListRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<PaymentListRouteArgs>(
        orElse: () =>
            PaymentListRouteArgs(studentId: queryParams.optInt('studentId')),
      );
      return _i17.PaymentListScreen(key: args.key, studentId: args.studentId);
    },
  );
}

class PaymentListRouteArgs {
  const PaymentListRouteArgs({this.key, this.studentId});

  final _i29.Key? key;

  final int? studentId;

  @override
  String toString() {
    return 'PaymentListRouteArgs{key: $key, studentId: $studentId}';
  }
}

/// generated route for
/// [_i18.QrCardGeneratorScreen]
class QrCardGeneratorRoute extends _i28.PageRouteInfo<void> {
  const QrCardGeneratorRoute({List<_i28.PageRouteInfo>? children})
    : super(QrCardGeneratorRoute.name, initialChildren: children);

  static const String name = 'QrCardGeneratorRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i18.QrCardGeneratorScreen();
    },
  );
}

/// generated route for
/// [_i19.QrScannerScreen]
class QrScannerRoute extends _i28.PageRouteInfo<void> {
  const QrScannerRoute({List<_i28.PageRouteInfo>? children})
    : super(QrScannerRoute.name, initialChildren: children);

  static const String name = 'QrScannerRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i19.QrScannerScreen();
    },
  );
}

/// generated route for
/// [_i20.ReportScreen]
class ReportRoute extends _i28.PageRouteInfo<void> {
  const ReportRoute({List<_i28.PageRouteInfo>? children})
    : super(ReportRoute.name, initialChildren: children);

  static const String name = 'ReportRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i20.ReportScreen();
    },
  );
}

/// generated route for
/// [_i21.SettingsScreen]
class SettingsRoute extends _i28.PageRouteInfo<void> {
  const SettingsRoute({List<_i28.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i21.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i22.SetupWizardScreen]
class SetupWizardRoute extends _i28.PageRouteInfo<void> {
  const SetupWizardRoute({List<_i28.PageRouteInfo>? children})
    : super(SetupWizardRoute.name, initialChildren: children);

  static const String name = 'SetupWizardRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i22.SetupWizardScreen();
    },
  );
}

/// generated route for
/// [_i23.ShellScreen]
class ShellRoute extends _i28.PageRouteInfo<void> {
  const ShellRoute({List<_i28.PageRouteInfo>? children})
    : super(ShellRoute.name, initialChildren: children);

  static const String name = 'ShellRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i23.ShellScreen();
    },
  );
}

/// generated route for
/// [_i24.StudentDetailScreen]
class StudentDetailRoute extends _i28.PageRouteInfo<StudentDetailRouteArgs> {
  StudentDetailRoute({
    _i29.Key? key,
    required int id,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         StudentDetailRoute.name,
         args: StudentDetailRouteArgs(key: key, id: id),
         initialChildren: children,
       );

  static const String name = 'StudentDetailRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StudentDetailRouteArgs>();
      return _i24.StudentDetailScreen(key: args.key, id: args.id);
    },
  );
}

class StudentDetailRouteArgs {
  const StudentDetailRouteArgs({this.key, required this.id});

  final _i29.Key? key;

  final int id;

  @override
  String toString() {
    return 'StudentDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i25.StudentFormScreen]
class StudentFormRoute extends _i28.PageRouteInfo<StudentFormRouteArgs> {
  StudentFormRoute({_i29.Key? key, int? id, List<_i28.PageRouteInfo>? children})
    : super(
        StudentFormRoute.name,
        args: StudentFormRouteArgs(key: key, id: id),
        initialChildren: children,
      );

  static const String name = 'StudentFormRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StudentFormRouteArgs>(
        orElse: () => const StudentFormRouteArgs(),
      );
      return _i25.StudentFormScreen(key: args.key, id: args.id);
    },
  );
}

class StudentFormRouteArgs {
  const StudentFormRouteArgs({this.key, this.id});

  final _i29.Key? key;

  final int? id;

  @override
  String toString() {
    return 'StudentFormRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i26.StudentListScreen]
class StudentListRoute extends _i28.PageRouteInfo<void> {
  const StudentListRoute({List<_i28.PageRouteInfo>? children})
    : super(StudentListRoute.name, initialChildren: children);

  static const String name = 'StudentListRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i26.StudentListScreen();
    },
  );
}

/// generated route for
/// [_i27.UserFormScreen]
class UserFormRoute extends _i28.PageRouteInfo<UserFormRouteArgs> {
  UserFormRoute({_i29.Key? key, int? id, List<_i28.PageRouteInfo>? children})
    : super(
        UserFormRoute.name,
        args: UserFormRouteArgs(key: key, id: id),
        initialChildren: children,
      );

  static const String name = 'UserFormRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserFormRouteArgs>(
        orElse: () => const UserFormRouteArgs(),
      );
      return _i27.UserFormScreen(key: args.key, id: args.id);
    },
  );
}

class UserFormRouteArgs {
  const UserFormRouteArgs({this.key, this.id});

  final _i29.Key? key;

  final int? id;

  @override
  String toString() {
    return 'UserFormRouteArgs{key: $key, id: $id}';
  }
}
