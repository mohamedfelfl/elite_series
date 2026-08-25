import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../cubits/report_cubit.dart';

/// Attendance date report form: select date range → generate PDF.
class AttendanceDateReportForm extends StatefulWidget {
  const AttendanceDateReportForm({super.key});

  @override
  State<AttendanceDateReportForm> createState() =>
      _AttendanceDateReportFormState();
}

class _AttendanceDateReportFormState extends State<AttendanceDateReportForm> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.attendance_date.tr(), style: textTheme.titleMedium),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.from_date.tr(),
                  prefixIcon: const Icon(Icons.date_range),
                ),
                controller: TextEditingController(
                  text: _fromDate != null
                      ? DateFormat('yyyy-MM-dd').format(_fromDate!)
                      : '',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _fromDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _fromDate = date);
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: LocaleKeys.to_date.tr(),
                  prefixIcon: const Icon(Icons.date_range),
                ),
                controller: TextEditingController(
                  text: _toDate != null
                      ? DateFormat('yyyy-MM-dd').format(_toDate!)
                      : '',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _toDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _toDate = date);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () =>
                          context.read<ReportCubit>().generateAttendanceReport(
                            fromDate: _fromDate,
                            toDate: _toDate,
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
