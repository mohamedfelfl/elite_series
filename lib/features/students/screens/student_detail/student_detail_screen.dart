import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/dimens.dart';
import '../../../../app/router/app_router.gr.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/student_cubit.dart';
import '../../../auth/cubits/auth_cubit.dart';
import '../../../auth/models/user.dart';
import '../../../payments/cubits/payment_cubit.dart';
import '../../../attendance/cubits/attendance_cubit.dart';
import '../../../exams/cubits/exam_cubit.dart';
import 'tabs/attendance_tab.dart';
import 'tabs/info_tab.dart';
import 'tabs/marks_tab.dart';
import 'tabs/payments_tab.dart';

@RoutePage()
class StudentDetailScreen extends StatefulWidget {
  final int id;

  const StudentDetailScreen({super.key, required this.id});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _student;
  bool _canManagePayments = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    _canManagePayments = user?.can(UserPermission.managePayments) ?? false;
    _tabController = TabController(
      length: _canManagePayments ? 4 : 3,
      vsync: this,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final student = await context.read<StudentCubit>().getStudentById(
      widget.id,
    );
    setState(() => _student = student);

    if (mounted) {
      if (_canManagePayments) {
        context.read<PaymentCubit>().loadPayments(widget.id);
      }
      context.read<AttendanceCubit>().loadAttendance(widget.id);
      context.read<ExamCubit>().loadStudentMarks(widget.id);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_student == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppDimens.p24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, colorScheme.primaryContainer],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.router.maybePop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          await context.router.push(
                            StudentFormRoute(id: widget.id),
                          );
                          if (mounted) {
                            _loadData();
                          }
                        },
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimens.h8),
                  Text(
                    _student!['name']?.toString() ?? '',
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppDimens.h4),
                  Text(
                    '${LocaleKeys.serial.tr(args: [_student!['serial_number'].toString()])} • ${_student!['group_name'] ?? LocaleKeys.unassigned.tr()}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: isDark ? Colors.white : colorScheme.primary,
            unselectedLabelColor:
                isDark ? Colors.white70 : colorScheme.onSurfaceVariant,
            indicatorColor: isDark ? Colors.white : colorScheme.primary,
            tabs: [
              Tab(text: LocaleKeys.info.tr()),
              if (_canManagePayments) Tab(text: LocaleKeys.tab_payments.tr()),
              Tab(text: LocaleKeys.tab_attendance.tr()),
              Tab(text: LocaleKeys.tab_marks.tr()),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                InfoTab(student: _student!),
                if (_canManagePayments)
                  PaymentsTab(
                    studentId: widget.id,
                    studentStatus:
                        _student!['student_status']?.toString() ?? 'normal',
                  ),
                AttendanceTab(
                  studentId: widget.id,
                  studentStatus:
                      _student!['student_status']?.toString() ?? 'normal',
                ),
                MarksTab(studentId: widget.id, onRefresh: _loadData),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
