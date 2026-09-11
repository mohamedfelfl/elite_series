import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../exams/cubits/exam_cubit.dart';
import '../../../../exams/widgets/multi_exam_selector.dart';
import '../../../../groups/cubits/group_cubit.dart';
import '../../../cubits/report_cubit.dart';

enum HRFilterType { exam, group }
enum HRMarksMode { topMarks, fullMark }

const List<int> _limitOptions = [3, 5, 10, 20, 50, 100, 500, 1000, 2000];

/// Highest marks report form: select exam/group, choose top marks (limit) or full mark (no limit) → generate PDF.
class HighestMarksReportForm extends StatefulWidget {
  const HighestMarksReportForm({super.key});

  @override
  State<HighestMarksReportForm> createState() => _HighestMarksReportFormState();
}

class _HighestMarksReportFormState extends State<HighestMarksReportForm> {
  HRFilterType _hMarksFilterType = HRFilterType.exam;
  HRMarksMode _hMarksMode = HRMarksMode.topMarks;
  Set<int> _selectedExamIds = {};
  int? _hMarksGroupId;
  int _hMarksLimit = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
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
                            _selectedExamIds = {};
                            _hMarksGroupId = null;
                          });
                        },
                      ),
                    ),
                  ),

                  // Specific Selection: MultiExamSelector or Group Dropdown
                  if (_hMarksFilterType == HRFilterType.exam)
                    BlocBuilder<ExamCubit, ExamState>(
                      builder: (context, state) {
                        return MultiExamSelector(
                          exams: state.exams,
                          selectedExamIds: _selectedExamIds,
                          onSelectionChanged: (set) {
                            setState(() => _selectedExamIds = set);
                          },
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

                  // Report Mode Toggle (Top Marks vs Full Mark Only)
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: SegmentedButton<HRMarksMode>(
                        segments: [
                          ButtonSegment(
                            value: HRMarksMode.topMarks,
                            label: Text(LocaleKeys.highest_marks.tr()),
                            icon: const Icon(Icons.leaderboard_outlined),
                          ),
                          ButtonSegment(
                            value: HRMarksMode.fullMark,
                            label: Text(LocaleKeys.full_mark.tr()),
                            icon: const Icon(Icons.workspace_premium_outlined),
                          ),
                        ],
                        style: SegmentedButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        selected: {_hMarksMode},
                        onSelectionChanged: (set) {
                          setState(() {
                            _hMarksMode = set.first;
                          });
                        },
                      ),
                    ),
                  ),

                  // Conditional: Limit Dropdown or Full Mark Info
                  if (_hMarksMode == HRMarksMode.topMarks)
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
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: theme.colorScheme.primary,
                            size: 28.r,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.all_full_mark_students.tr(),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  LocaleKeys.full_mark_no_limit_desc.tr(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),
                  SizedBox(height: 16.h),

                  // Generate Button
                  BlocBuilder<ReportCubit, ReportState>(
                    builder: (context, state) {
                      final hasSelection = (_hMarksFilterType == HRFilterType.exam
                          ? _selectedExamIds.isNotEmpty
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
                                      examIds: _selectedExamIds.toList(),
                                      groupId: _hMarksGroupId,
                                      limit: _hMarksMode == HRMarksMode.fullMark
                                          ? null
                                          : _hMarksLimit,
                                      fullMarkOnly: _hMarksMode == HRMarksMode.fullMark,
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
              ),
            ),
          ),
        );
      },
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
