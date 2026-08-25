import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../exams/cubits/exam_cubit.dart';
import '../../../../groups/cubits/group_cubit.dart';
import '../../../cubits/report_cubit.dart';

enum HRFilterType { exam, group }

const List<int> _limitOptions = [3, 5, 10, 20, 50, 100];

/// Highest marks report form: select exam/group, limit → generate PDF.
class HighestMarksReportForm extends StatefulWidget {
  const HighestMarksReportForm({super.key});

  @override
  State<HighestMarksReportForm> createState() => _HighestMarksReportFormState();
}

class _HighestMarksReportFormState extends State<HighestMarksReportForm> {
  HRFilterType _hMarksFilterType = HRFilterType.exam;
  int? _hMarksExamId;
  int? _hMarksGroupId;
  int _hMarksLimit = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Type Toggle
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: SegmentedButton<HRFilterType>(
              segments: [
                ButtonSegment(
                  value: HRFilterType.exam,
                  label: Text(LocaleKeys.exam.tr()),
                  icon: const Icon(Icons.quiz),
                ),
                ButtonSegment(
                  value: HRFilterType.group,
                  label: Text(LocaleKeys.groups.tr()),
                  icon: const Icon(Icons.groups),
                ),
              ],
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.comfortable,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              selected: {_hMarksFilterType},
              onSelectionChanged: (set) {
                setState(() {
                  _hMarksFilterType = set.first;
                  _hMarksExamId = null;
                  _hMarksGroupId = null;
                });
              },
            ),
          ),
        ),

        // Specific Selection Dropdown
        if (_hMarksFilterType == HRFilterType.exam)
          BlocBuilder<ExamCubit, ExamState>(
            builder: (context, state) {
              return _buildReportDropdown<int?>(
                label: LocaleKeys.select_exam_hint.tr(),
                value: _hMarksExamId,
                items: state.exams
                    .map(
                      (e) => DropdownMenuItem(
                        value: e['id'] as int,
                        child: Text(e['name'] as String),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _hMarksExamId = v),
                icon: Icons.description,
              );
            },
          )
        else
          BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              return _buildReportDropdown<int?>(
                label: LocaleKeys.select_group_hint.tr(),
                value: _hMarksGroupId,
                items: state.groups
                    .map(
                      (g) => DropdownMenuItem(
                        value: g['id'] as int,
                        child: Text(g['name'] as String),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _hMarksGroupId = v),
                icon: Icons.groups,
              );
            },
          ),

        SizedBox(height: 16.h),

        // Limit Dropdown
        _buildReportDropdown<int>(
          label: LocaleKeys.limit.tr(),
          value: _hMarksLimit,
          items: _limitOptions
              .map((n) => DropdownMenuItem(value: n, child: Text(n.toString())))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _hMarksLimit = v);
          },
          icon: Icons.format_list_numbered,
        ),

        const Spacer(),

        // Generate Button
        BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            final hasSelection = (_hMarksFilterType == HRFilterType.exam
                ? _hMarksExamId != null
                : _hMarksGroupId != null);

            return SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: state.isLoading || !hasSelection
                    ? null
                    : () => context
                          .read<ReportCubit>()
                          .generateHighestMarksReport(
                            examId: _hMarksExamId,
                            groupId: _hMarksGroupId,
                            limit: _hMarksLimit,
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

  Widget _buildReportDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.brightness == Brightness.dark
            ? theme.colorScheme.surfaceContainerLow
            : Colors.grey[50],
      ),
      icon: const Icon(Icons.arrow_drop_down),
      dropdownColor: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
    );
  }
}
