import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../cubits/report_cubit.dart';
import 'student_search_picker.dart';

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
        Text(
          LocaleKeys.select_student.tr(),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        StudentSearchPicker(
          selectedStudentId: _selectedStudentId,
          onStudentSelected: (student) {
            setState(() {
              _selectedStudentId = student?['id'] as int?;
            });
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

