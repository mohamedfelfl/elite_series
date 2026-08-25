import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../generated/locale_keys.g.dart';

class InfoTab extends StatelessWidget {
  final Map<String, dynamic> student;

  const InfoTab({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _infoRow(
                LocaleKeys.grade.tr(),
                _getGradeLabel(student['grade']?.toString()),
                Icons.school,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.student_status.tr(),
                student['student_status']?.toString() == 'free'
                    ? LocaleKeys.free.tr()
                    : LocaleKeys.normal.tr(),
                Icons.verified_user_outlined,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.attendance_day.tr(),
                _getDayLabel(student['attendance_day']?.toString()),
                Icons.calendar_today_outlined,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.address.tr(),
                student['address']?.toString() ?? '-',
                Icons.location_on_outlined,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.phone1.tr(),
                student['phone1']?.toString() ?? '-',
                Icons.phone,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.phone2.tr(),
                student['phone2']?.toString() ?? '-',
                Icons.phone,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.father_job.tr(),
                student['father_job']?.toString() ?? '-',
                Icons.work_outline,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.school_group.tr(),
                student['school']?.toString() ?? '-',
                Icons.school_outlined,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.previous_teacher.tr(),
                student['previous_teacher']?.toString() ?? '-',
                Icons.person_search_outlined,
                textTheme,
                colorScheme,
                isDark,
              ),
              _divider(),
              _infoRow(
                LocaleKeys.student_notes.tr(),
                (student['notes'] != null && student['notes'].toString().trim().isNotEmpty)
                    ? student['notes'].toString()
                    : '-',
                Icons.note_alt_outlined,
                textTheme,
                colorScheme,
                isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Divider(height: 1, thickness: 0.5),
  );

  String _getGradeLabel(String? grade) {
    if (grade == 'sec_1') return LocaleKeys.sec_1.tr();
    if (grade == 'sec_2') return LocaleKeys.sec_2.tr();
    if (grade == 'sec_3') return LocaleKeys.sec_3.tr();
    return LocaleKeys.na.tr();
  }

  String _getDayLabel(String? day) {
    if (day == 'Monday') return LocaleKeys.monday.tr();
    if (day == 'Tuesday') return LocaleKeys.tuesday.tr();
    if (day == 'Wednesday') return LocaleKeys.wednesday.tr();
    if (day == 'Thursday') return LocaleKeys.thursday.tr();
    if (day == 'Friday') return LocaleKeys.friday.tr();
    if (day == 'Saturday') return LocaleKeys.saturday.tr();
    if (day == 'Sunday') return LocaleKeys.sunday.tr();
    return LocaleKeys.na.tr();
  }

  Widget _infoRow(
    String label,
    String value,
    IconData icon,
    TextTheme textTheme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: isDark ? Colors.white70 : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                  color: isDark ? Colors.white : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
