import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';

/// Helper utility for parsing, formatting, and localizing schedule times.
class TimeHelper {
  const TimeHelper._();

  /// Converts Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩) to standard ASCII numerals (0-9).
  static String normalizeDigits(String input) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = input;
    for (int i = 0; i < arabicDigits.length; i++) {
      result = result.replaceAll(arabicDigits[i], i.toString());
    }
    return result;
  }

  /// Parses any time string into a [TimeOfDay].
  ///
  /// Supports:
  /// - 12-hour English: "2:00 PM", "02:00 AM", "2:00 pm", "2:00 am"
  /// - 12-hour Arabic: "2:00 مساءً", "2:00 صباحاً", "2:00 م", "2:00 ص", "2:00 مساء", "2:00 صباح"
  /// - 24-hour format: "14:00", "09:30", "00:00"
  /// - Eastern Arabic numerals: "٠٢:٠٠ مساءً"
  static TimeOfDay? parseTime(String? text) {
    if (text == null || text.trim().isEmpty) return null;

    final normalized = normalizeDigits(text.trim());

    try {
      final RegExp timePattern = RegExp(r'(\d{1,2})\s*[:\.]\s*(\d{2})');
      final match = timePattern.firstMatch(normalized);
      if (match == null) return null;

      int hour = int.parse(match.group(1)!);
      final int minute = int.parse(match.group(2)!);

      if (minute < 0 || minute > 59) return null;

      final lower = normalized.toLowerCase();

      // Check for PM indicators (English and Arabic)
      final bool isPm = lower.contains('pm') ||
          lower.contains('p.m') ||
          lower.contains('مساء') ||
          lower.contains('مسائا') ||
          RegExp(r'(?:^|\s)م(?:\.|\s|$)').hasMatch(lower);

      // Check for AM indicators (English and Arabic)
      final bool isAm = lower.contains('am') ||
          lower.contains('a.m') ||
          lower.contains('صباح') ||
          RegExp(r'(?:^|\s)ص(?:\.|\s|$)').hasMatch(lower);

      if (isPm) {
        if (hour < 12) hour += 12;
      } else if (isAm) {
        if (hour == 12) hour = 0;
      }

      if (hour < 0 || hour > 23) return null;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  /// Formats a [TimeOfDay] into a localized string for display in UI (e.g., "2:00 مساءً" or "2:00 PM").
  static String formatTime(TimeOfDay time) {
    final int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period =
        time.period == DayPeriod.am ? LocaleKeys.am.tr() : LocaleKeys.pm.tr();
    return '$hour:$minute $period';
  }

  /// Formats a [TimeOfDay] into a standard format for database storage (e.g., "2:00 PM", "10:30 AM").
  static String formatForDb(TimeOfDay time) {
    final int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Takes any stored time string and formats it for current locale display.
  static String localizeTimeString(String timeString) {
    final parsed = parseTime(timeString);
    if (parsed != null) {
      return formatTime(parsed);
    }
    return timeString;
  }
}
