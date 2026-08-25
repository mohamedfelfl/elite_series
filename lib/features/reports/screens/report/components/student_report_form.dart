import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../students/cubits/student_cubit.dart';
import '../../../cubits/report_cubit.dart';

/// Student report form: select student → generate PDF.
class StudentReportForm extends StatefulWidget {
  const StudentReportForm({super.key});

  @override
  State<StudentReportForm> createState() => _StudentReportFormState();
}

class _StudentReportFormState extends State<StudentReportForm> {
  int? _selectedStudentId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.select_student.tr(), style: textTheme.titleMedium),
        SizedBox(height: 12.h),
        BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<int?>(
                  width: constraints.maxWidth,
                  initialSelection: _selectedStudentId,
                  label: Text(LocaleKeys.student.tr()),
                  leadingIcon: const Icon(Icons.person),
                  enableSearch: true,
                  enableFilter: true,
                  dropdownMenuEntries: state.students
                      .map(
                        (s) => DropdownMenuEntry<int?>(
                          value: s['id'] as int,
                          label: '${s['name']} (${s['serial_number']})',
                        ),
                      )
                      .toList(),
                  onSelected: (v) {
                    if (v != null) setState(() => _selectedStudentId = v);
                  },
                );
              },
            );
          },
        ),
        SizedBox(height: 24.h),
        BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: _selectedStudentId == null || state.isLoading
                    ? null
                    : () => context.read<ReportCubit>().generateStudentReport(
                        _selectedStudentId!,
                      ),
                icon: state.isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(LocaleKeys.generate_report.tr()),
              ),
            );
          },
        ),
      ],
    );
  }
}
