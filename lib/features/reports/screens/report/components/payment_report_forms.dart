import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../groups/cubits/group_cubit.dart';
import '../../../cubits/report_cubit.dart';

/// Daily payments report form.
class DailyPaymentsReportForm extends StatefulWidget {
  const DailyPaymentsReportForm({super.key});

  @override
  State<DailyPaymentsReportForm> createState() =>
      _DailyPaymentsReportFormState();
}

class _DailyPaymentsReportFormState extends State<DailyPaymentsReportForm> {
  DateTime? _fromDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.select_day.tr(), style: textTheme.titleMedium),
        SizedBox(height: 12.h),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: LocaleKeys.paid_date.tr(),
            prefixIcon: const Icon(Icons.calendar_today),
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
        SizedBox(height: 24.h),
        BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: _fromDate == null || state.isLoading
                    ? null
                    : () => context
                          .read<ReportCubit>()
                          .generateDailyPaymentReport(_fromDate!),
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

/// Group payments report form.
class GroupPaymentsReportForm extends StatefulWidget {
  const GroupPaymentsReportForm({super.key});

  @override
  State<GroupPaymentsReportForm> createState() =>
      _GroupPaymentsReportFormState();
}

class _GroupPaymentsReportFormState extends State<GroupPaymentsReportForm> {
  int? _selectedGroupId;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.select_group.tr(), style: textTheme.titleMedium),
          SizedBox(height: 12.h),
          BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return DropdownMenu<int?>(
                    width: constraints.maxWidth,
                    initialSelection: _selectedGroupId,
                    label: Text(LocaleKeys.select_group.tr()),
                    leadingIcon: const Icon(Icons.groups),
                    enableSearch: true,
                    enableFilter: true,
                    dropdownMenuEntries: state.groups
                        .map(
                          (g) => DropdownMenuEntry<int?>(
                            value: g['id'] as int,
                            label: g['name'] as String,
                          ),
                        )
                        .toList(),
                    onSelected: (v) {
                      if (v != null) setState(() => _selectedGroupId = v);
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height: 16.h),
          Text(LocaleKeys.filter_date_range.tr(), style: textTheme.titleMedium),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _fromDate != null
                        ? DateFormat('MM/yyyy').format(_fromDate!)
                        : LocaleKeys.from_date.tr(),
                  ),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _fromDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (d != null) setState(() => _fromDate = d);
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _toDate != null
                        ? DateFormat('MM/yyyy').format(_toDate!)
                        : LocaleKeys.to_date.tr(),
                  ),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _toDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (d != null) setState(() => _toDate = d);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          BlocBuilder<ReportCubit, ReportState>(
            builder: (context, state) {
              final isReady =
                  _selectedGroupId != null &&
                  _fromDate != null &&
                  _toDate != null;
              return SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton.icon(
                  onPressed: !isReady || state.isLoading
                      ? null
                      : () {
                          final groupState = context.read<GroupCubit>().state;
                          final groupName =
                              groupState.groups.firstWhere(
                                    (g) => g['id'] == _selectedGroupId,
                                  )['name']
                                  as String;
                          context
                              .read<ReportCubit>()
                              .generateGroupPaymentsReport(
                                groupId: _selectedGroupId!,
                                groupName: groupName,
                                fromDate: _fromDate!,
                                toDate: _toDate!,
                              );
                        },
                  icon: state.isLoading
                      ? SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(LocaleKeys.generate_report.tr()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
