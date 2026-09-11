import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

class StudentUIHelper {
  StudentUIHelper._();

  static String getGradeLabel(String? grade) {
    if (grade == null || grade.isEmpty) return LocaleKeys.na.tr();
    switch (grade.toLowerCase().trim()) {
      case 'prep_1':
        return LocaleKeys.prep_1.tr();
      case 'prep_2':
        return LocaleKeys.prep_2.tr();
      case 'prep_3':
        return LocaleKeys.prep_3.tr();
      case 'sec_1':
        return LocaleKeys.sec_1.tr();
      case 'sec_2':
        return LocaleKeys.sec_2.tr();
      case 'sec_3':
        return LocaleKeys.sec_3.tr();
      default:
        return grade;
    }
  }

  static String getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].characters.first;
    }
    return '${parts[0].characters.first}${parts[1].characters.first}';
  }

  static const List<Color> _avatarColors = [
    Color(0xFF2563EB), // Blue
    Color(0xFF7C3AED), // Violet
    Color(0xFF0D9488), // Teal
    Color(0xFFD97706), // Amber
    Color(0xFF0284C7), // Sky
    Color(0xFF4F46E5), // Indigo
    Color(0xFF059669), // Emerald
    Color(0xFF9333EA), // Purple
    Color(0xFFEA580C), // Orange
  ];

  static Color getAvatarColor(String seed, {int fallbackId = 0}) {
    final int hash = seed.isNotEmpty
        ? seed.codeUnits.fold(0, (prev, elem) => prev + elem)
        : fallbackId;
    return _avatarColors[hash.abs() % _avatarColors.length];
  }
}
