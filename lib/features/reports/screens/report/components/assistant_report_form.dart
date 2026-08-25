import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../assistants/cubits/assistant_cubit.dart';
import '../../../cubits/report_cubit.dart';

/// Assistant report form: select assistant → generate PDF.
class AssistantReportForm extends StatefulWidget {
  const AssistantReportForm({super.key});

  @override
  State<AssistantReportForm> createState() => _AssistantReportFormState();
}

class _AssistantReportFormState extends State<AssistantReportForm> {
  int? _selectedAssistantId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.assistants.tr(), style: textTheme.titleMedium),
        SizedBox(height: 12.h),
        BlocBuilder<AssistantCubit, AssistantState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<int?>(
                  width: constraints.maxWidth,
                  initialSelection: _selectedAssistantId,
                  label: Text(LocaleKeys.assistants_directory.tr()),
                  leadingIcon: const Icon(Icons.support_agent),
                  enableSearch: true,
                  enableFilter: true,
                  dropdownMenuEntries: state.assistants
                      .map(
                        (a) => DropdownMenuEntry<int?>(
                          value: a['id'] as int,
                          label: '${a['name']} (${a['serial_number']})',
                        ),
                      )
                      .toList(),
                  onSelected: (v) {
                    if (v != null) setState(() => _selectedAssistantId = v);
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
                onPressed: _selectedAssistantId == null || state.isLoading
                    ? null
                    : () => context.read<ReportCubit>().generateAssistantReport(
                        _selectedAssistantId!,
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
