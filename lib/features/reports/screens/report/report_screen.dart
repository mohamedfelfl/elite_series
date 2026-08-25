import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:printing/printing.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../groups/cubits/group_cubit.dart';
import '../../../students/cubits/student_cubit.dart';
import '../../cubits/report_cubit.dart';
import 'components/attendance_date_report_form.dart';
import 'components/payment_report_forms.dart';
import 'components/student_report_form.dart';
import 'components/lesson_attendance_report_form.dart';

@RoutePage()
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportType _selectedType = ReportType.student;

  @override
  void initState() {
    super.initState();
    context.read<StudentCubit>().loadStudents();
    context.read<GroupCubit>().loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state.isGenerated && state.pdfDocument != null) {
          final doc = state.pdfDocument!;
          context.read<ReportCubit>().resetState();

          showDialog(
            context: context,
            builder: (dialogContext) => Dialog(
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: 800.w,
                height: 600.h,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PdfPreview(
                        build: (format) => doc.save(),
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        canDebug: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        appBar: context.router.canPop()
            ? AppBar(
                title: Text(
                  LocaleKeys.reports.tr(),
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                centerTitle: true,
              )
            : null,
        body: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.reports_subtitle.tr(),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 24.h),

              // Report type selector
              _buildReportTypeSelector(),
              SizedBox(height: 24.h),

              // Report form
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: _buildActiveReportForm(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.w,
      children: [
        ChoiceChip(
          label: Text(LocaleKeys.student_report.tr()),
          selected: _selectedType == ReportType.student,
          onSelected: (_) =>
              setState(() => _selectedType = ReportType.student),
        ),
        ChoiceChip(
          label: Text(LocaleKeys.attendance_date.tr()),
          selected: _selectedType == ReportType.attendanceDate,
          onSelected: (_) => setState(
            () => _selectedType = ReportType.attendanceDate,
          ),
        ),
        ChoiceChip(
          label: Text(LocaleKeys.lesson_report.tr()),
          selected: _selectedType == ReportType.lessonSession,
          onSelected: (_) =>
              setState(() => _selectedType = ReportType.lessonSession),
        ),
        ChoiceChip(
          label: Text(LocaleKeys.group_summary_report.tr()),
          selected: _selectedType == ReportType.groupAttendanceSummary,
          onSelected: (_) =>
              setState(() => _selectedType = ReportType.groupAttendanceSummary),
        ),
        ChoiceChip(
          label: Text(LocaleKeys.daily_payments.tr()),
          selected: _selectedType == ReportType.dailyPayments,
          onSelected: (_) => setState(
            () => _selectedType = ReportType.dailyPayments,
          ),
        ),
        ChoiceChip(
          label: Text(LocaleKeys.group_payments_report.tr()),
          selected: _selectedType == ReportType.groupPayments,
          onSelected: (_) => setState(
            () => _selectedType = ReportType.groupPayments,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveReportForm() {
    switch (_selectedType) {
      case ReportType.student:
        return const StudentReportForm();
      case ReportType.attendanceDate:
        return const AttendanceDateReportForm();
      case ReportType.dailyPayments:
        return const DailyPaymentsReportForm();
      case ReportType.groupPayments:
        return const GroupPaymentsReportForm();
      case ReportType.lessonSession:
      case ReportType.absenteeFollowUp:
      case ReportType.groupAttendanceSummary:
        return LessonAttendanceReportForm(reportType: _selectedType);
      default:
        return const SizedBox.shrink();
    }
  }
}
