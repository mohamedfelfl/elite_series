import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../groups/cubits/group_cubit.dart';

/// Academic & Enrollment section card:
/// Covers Academic Grade, Group assignment, Serial Number (locked auto-generator),
/// Student Status (Normal / Free), and Preferred Attendance Day.
class StudentAcademicSection extends StatelessWidget {
  final String? selectedGrade;
  final String selectedStatus;
  final int? selectedGroupId;
  final String? selectedAttendanceDay;
  final TextEditingController? serialController;
  final bool isEditing;
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
    this.serialController,
    this.isEditing = false,
    required this.onGradeChanged,
    required this.onStatusChanged,
    required this.onGroupChanged,
    required this.onAttendanceDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.academic_info_section.tr(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      LocaleKeys.select_group.tr(),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // 1. Grade Dropdown & Auto Serial Number (Side by side on wider spaces)
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              final gradeField = DropdownButtonFormField<String>(
                key: ValueKey('grade_${selectedGrade ?? 'prep_1'}'),
                initialValue: selectedGrade ?? 'prep_1',
                decoration: InputDecoration(
                  labelText: LocaleKeys.grade.tr(),
                  prefixIcon: const Icon(Icons.menu_book_rounded),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? LocaleKeys.required_field.tr()
                    : null,
                items: [
                  DropdownMenuItem(value: 'prep_1', child: Text(LocaleKeys.prep_1.tr())),
                  DropdownMenuItem(value: 'prep_2', child: Text(LocaleKeys.prep_2.tr())),
                  DropdownMenuItem(value: 'prep_3', child: Text(LocaleKeys.prep_3.tr())),
                  DropdownMenuItem(value: 'sec_1', child: Text(LocaleKeys.sec_1.tr())),
                  DropdownMenuItem(value: 'sec_2', child: Text(LocaleKeys.sec_2.tr())),
                  DropdownMenuItem(value: 'sec_3', child: Text(LocaleKeys.sec_3.tr())),
                ],
                onChanged: (v) {
                  if (v != null) onGradeChanged(v);
                },
              );

              final serialField = serialController != null
                  ? TextFormField(
                      controller: serialController,
                      readOnly: true,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                      ),
                      decoration: InputDecoration(
                        labelText: LocaleKeys.serial_number.tr(),
                        prefixIcon: const Icon(Icons.tag_rounded),
                        suffixIcon: Tooltip(
                          message: isEditing
                              ? LocaleKeys.serial_number.tr()
                              : 'توليد تلقائي للمرحلة',
                          child: const Icon(Icons.lock_outline_rounded, size: 18),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
                    )
                  : const SizedBox.shrink();

              if (!isWide || serialController == null) {
                return Column(
                  children: [
                    gradeField,
                    if (serialController != null) ...[
                      const SizedBox(height: 18),
                      serialField,
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: gradeField),
                  const SizedBox(width: 14),
                  Expanded(flex: 2, child: serialField),
                ],
              );
            },
          ),

          const SizedBox(height: 18),

          // 2. Group Dropdown with Group info
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
                  prefixIcon: const Icon(Icons.groups_rounded),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.inputRadius),
                  ),
                ),
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text(
                      LocaleKeys.no_group.tr(),
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  ...groupState.groups.map(
                    (Map<String, Object?> g) => DropdownMenuItem<int?>(
                      value: g['id'] as int,
                      child: Text(g['name']?.toString() ?? ''),
                    ),
                  ),
                ],
                onChanged: onGroupChanged,
              );
            },
          ),

          const SizedBox(height: 18),

          // 3. Student Status Toggle (عادي / معفي)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.student_status.tr(),
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildStatusChoiceCard(
                      context,
                      label: LocaleKeys.normal.tr(),
                      isSelected: selectedStatus == 'normal',
                      icon: Icons.verified_user_rounded,
                      activeColor: Colors.teal,
                      onTap: () => onStatusChanged('normal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusChoiceCard(
                      context,
                      label: LocaleKeys.free.tr(),
                      isSelected: selectedStatus == 'free',
                      icon: Icons.card_giftcard_rounded,
                      activeColor: Colors.amber.shade800,
                      onTap: () => onStatusChanged('free'),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 4. Preferred Attendance Day Dropdown
          DropdownButtonFormField<String?>(
            key: ValueKey('day_$selectedAttendanceDay'),
            initialValue: selectedAttendanceDay,
            decoration: InputDecoration(
              labelText: LocaleKeys.attendance_day.tr(),
              prefixIcon: const Icon(Icons.event_available_rounded),
              filled: true,
              fillColor: colorScheme.surfaceContainerLowest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.inputRadius),
              ),
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(
                  LocaleKeys.not_specified.tr(),
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
              DropdownMenuItem(value: 'Saturday', child: Text(LocaleKeys.saturday.tr())),
              DropdownMenuItem(value: 'Sunday', child: Text(LocaleKeys.sunday.tr())),
              DropdownMenuItem(value: 'Monday', child: Text(LocaleKeys.monday.tr())),
              DropdownMenuItem(value: 'Tuesday', child: Text(LocaleKeys.tuesday.tr())),
              DropdownMenuItem(value: 'Wednesday', child: Text(LocaleKeys.wednesday.tr())),
              DropdownMenuItem(value: 'Thursday', child: Text(LocaleKeys.thursday.tr())),
              DropdownMenuItem(value: 'Friday', child: Text(LocaleKeys.friday.tr())),
            ],
            onChanged: onAttendanceDayChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChoiceCard(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required IconData icon,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.12)
                : colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
            border: Border.all(
              color: isSelected ? activeColor : colorScheme.outlineVariant.withValues(alpha: 0.35),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? activeColor : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? activeColor : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
