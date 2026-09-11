import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../generated/locale_keys.g.dart';

/// A prominent header card for the Student Add/Edit form.
/// Displays breadcrumb navigation, dynamic student avatar preview,
/// and live status / stage / serial number badges.
class StudentFormHeader extends StatelessWidget {
  final bool isEditing;
  final String studentName;
  final String selectedGrade;
  final String selectedStatus;
  final String serialNumber;
  final VoidCallback onBack;

  const StudentFormHeader({
    super.key,
    required this.isEditing,
    required this.studentName,
    required this.selectedGrade,
    required this.selectedStatus,
    required this.serialNumber,
    required this.onBack,
  });

  String _getGradeLabel(String gradeKey) {
    switch (gradeKey) {
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
        return gradeKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final String displayName = studentName.trim().isNotEmpty
        ? studentName.trim()
        : (isEditing ? LocaleKeys.student.tr() : LocaleKeys.new_student.tr());

    final String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    final bool isFree = selectedStatus == 'free';

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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation Row
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, size: 20),
                tooltip: LocaleKeys.go_back.tr(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing
                          ? LocaleKeys.edit_student.tr()
                          : LocaleKeys.add_student.tr(),
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      isEditing
                          ? displayName
                          : LocaleKeys.scanner_hint.tr(),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 18),

          // Profile Preview Banner
          Row(
            children: [
              // Avatar Preview with Grade color
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Badges and Meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        // Grade Badge
                        _badge(
                          context,
                          icon: Icons.school_rounded,
                          label: _getGradeLabel(selectedGrade),
                          bgColor: colorScheme.secondaryContainer.withValues(alpha: 0.6),
                          fgColor: colorScheme.onSecondaryContainer,
                        ),

                        // Status Badge (عادي / معفي)
                        _badge(
                          context,
                          icon: isFree ? Icons.card_giftcard_rounded : Icons.verified_user_rounded,
                          label: isFree ? LocaleKeys.free.tr() : LocaleKeys.normal.tr(),
                          bgColor: isFree
                              ? Colors.amber.withValues(alpha: 0.2)
                              : Colors.teal.withValues(alpha: 0.15),
                          fgColor: isFree ? Colors.amber.shade800 : Colors.teal.shade700,
                        ),

                        // Serial Number Badge
                        if (serialNumber.isNotEmpty)
                          _badge(
                            context,
                            icon: Icons.tag_rounded,
                            label: '${LocaleKeys.serial_number.tr()}: $serialNumber',
                            bgColor: colorScheme.surfaceContainerHighest,
                            fgColor: colorScheme.onSurfaceVariant,
                            isMonospace: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color fgColor,
    bool isMonospace = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fgColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w700,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }
}
