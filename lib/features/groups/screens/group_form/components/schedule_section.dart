import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/utils/time_helper.dart';
import '../../../../../generated/locale_keys.g.dart';

/// Day and time selection section for group schedules.
class ScheduleSection extends StatelessWidget {
  final List<String> days;
  final List<String> selectedDays;
  final Map<String, TimeOfDay> dayTimes;
  final VoidCallback onChanged;
  final Future<void> Function(String day) onPickTime;

  const ScheduleSection({
    super.key,
    required this.days,
    required this.selectedDays,
    required this.dayTimes,
    required this.onChanged,
    required this.onPickTime,
  });

  String _translateDay(String day) {
    switch (day) {
      case 'Saturday':
        return LocaleKeys.saturday.tr();
      case 'Sunday':
        return LocaleKeys.sunday.tr();
      case 'Monday':
        return LocaleKeys.monday.tr();
      case 'Tuesday':
        return LocaleKeys.tuesday.tr();
      case 'Wednesday':
        return LocaleKeys.wednesday.tr();
      case 'Thursday':
        return LocaleKeys.thursday.tr();
      case 'Friday':
        return LocaleKeys.friday.tr();
      default:
        return day;
    }
  }

  String _formatTime(TimeOfDay time) {
    return TimeHelper.formatTime(time);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Days Selection (Chips)
        Text(
          LocaleKeys.day_of_week.tr(),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: days.map((day) {
            final isSelected = selectedDays.contains(day);
            return FilterChip(
              label: Text(_translateDay(day)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  selectedDays.add(day);
                  dayTimes[day] ??= const TimeOfDay(hour: 14, minute: 0);
                } else {
                  selectedDays.remove(day);
                  dayTimes.remove(day);
                }
                onChanged();
              },
            );
          }).toList(),
        ),
        if (selectedDays.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              LocaleKeys.select_day.tr(),
              style: TextStyle(
                color: colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),

        SizedBox(height: 24.h),

        // Time Selection for Each Day
        if (selectedDays.isNotEmpty) ...[
          Text(
            LocaleKeys.time.tr(),
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          ...selectedDays.map((day) {
            final time = dayTimes[day];
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    _translateDay(day),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: TextButton.icon(
                    onPressed: () => onPickTime(day),
                    icon: const Icon(Icons.access_time, size: 18),
                    label: Text(
                      time != null
                          ? _formatTime(time)
                          : LocaleKeys.time.tr(),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
