import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../groups/cubits/group_cubit.dart';

/// Academic fields: grade, student status, group, attendance day.
class StudentAcademicSection extends StatelessWidget {
  final String? selectedGrade;
  final String selectedStatus;
  final int? selectedGroupId;
  final String? selectedAttendanceDay;
  final ValueChanged<String?> onGradeChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<int?> onGroupChanged;
  final ValueChanged<String?> onAttendanceDayChanged;

  const StudentAcademicSection({
    super.key,
    required this.selectedGrade,
    required this.selectedStatus,
    required this.selectedGroupId,
    required this.selectedAttendanceDay,
    required this.onGradeChanged,
    required this.onStatusChanged,
    required this.onGroupChanged,
    required this.onAttendanceDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grade Dropdown
        DropdownButtonFormField<String>(
          key: ValueKey('grade_${selectedGrade ?? 'sec_1'}'),
          initialValue: selectedGrade ?? 'sec_1',
          decoration: InputDecoration(
            labelText: LocaleKeys.grade.tr(),
            prefixIcon: const Icon(Icons.school),
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? LocaleKeys.required_field.tr()
              : null,
          items: [
            DropdownMenuItem<String>(
              value: 'sec_1',
              child: Text(LocaleKeys.sec_1.tr()),
            ),
            DropdownMenuItem<String>(
              value: 'sec_2',
              child: Text(LocaleKeys.sec_2.tr()),
            ),
            DropdownMenuItem<String>(
              value: 'sec_3',
              child: Text(LocaleKeys.sec_3.tr()),
            ),
          ],
          onChanged: (v) {
            if (v != null) onGradeChanged(v);
          },
        ),
        const SizedBox(height: 24),

        // Student Status Dropdown
        DropdownButtonFormField<String>(
          key: ValueKey('status_$selectedStatus'),
          initialValue: selectedStatus,
          decoration: InputDecoration(
            labelText: LocaleKeys.student_status.tr(),
            prefixIcon: const Icon(Icons.verified_user_outlined),
          ),
          items: [
            DropdownMenuItem<String>(
              value: 'normal',
              child: Text(LocaleKeys.normal.tr()),
            ),
            DropdownMenuItem<String>(
              value: 'free',
              child: Text(LocaleKeys.free.tr()),
            ),
          ],
          onChanged: (v) => onStatusChanged(v!),
        ),
        const SizedBox(height: 24),

        // Group Dropdown
        BlocBuilder<GroupCubit, GroupState>(
          builder: (BuildContext context, GroupState groupState) {
            final bool valueExists = groupState.groups.any(
              (g) => g['id'] == selectedGroupId,
            );

            return DropdownButtonFormField<int?>(
              key: ValueKey('group_$selectedGroupId'),
              initialValue: valueExists ? selectedGroupId : null,
              decoration: InputDecoration(
                labelText: LocaleKeys.groups.tr(),
                prefixIcon: const Icon(Icons.groups_outlined),
              ),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text(LocaleKeys.no_group.tr()),
                ),
                ...groupState.groups.map(
                  (Map<String, Object?> g) => DropdownMenuItem<int?>(
                    value: g['id'] as int,
                    child: Text(_cleanGroupName(g['name']?.toString() ?? '')),
                  ),
                ),
              ],
              onChanged: onGroupChanged,
            );
          },
        ),
        const SizedBox(height: 24),

        // Attendance Day Dropdown
        DropdownButtonFormField<String?>(
          key: ValueKey('day_$selectedAttendanceDay'),
          initialValue: selectedAttendanceDay,
          decoration: InputDecoration(
            labelText: LocaleKeys.attendance_day.tr(),
            prefixIcon: const Icon(Icons.calendar_today_outlined),
          ),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(LocaleKeys.not_specified.tr()),
            ),
            DropdownMenuItem<String?>(
              value: 'Monday',
              child: Text(LocaleKeys.monday.tr()),
            ),
            DropdownMenuItem<String?>(
              value: 'Tuesday',
              child: Text(LocaleKeys.tuesday.tr()),
            ),
            DropdownMenuItem<String?>(
              value: 'Wednesday',
              child: Text(LocaleKeys.wednesday.tr()),
            ),
            DropdownMenuItem<String?>(
              value: 'Thursday',
              child: Text(LocaleKeys.thursday.tr()),
            ),
            DropdownMenuItem<String?>(
              value: 'Friday',
              child: Text(LocaleKeys.friday.tr()),
            ),
            DropdownMenuItem<String?>(
              value: 'Saturday',
              child: Text(LocaleKeys.saturday.tr()),
            ),
            DropdownMenuItem<String?>(
              value: 'Sunday',
              child: Text(LocaleKeys.sunday.tr()),
            ),
          ],
          onChanged: onAttendanceDayChanged,
        ),
        SizedBox(height: AppDimens.h32),
      ],
    );
  }

  String _cleanGroupName(String name) {
    String n = name.trim();
    n = n.replaceAll('الثللاثاء', 'الثلاثاء');
    n = n.replaceAll(RegExp(r'\s*[123]\s*ث\s*'), ' ');
    n = n.replaceAll(RegExp(r'\s+'), ' ').trim();
    return n;
  }
}
