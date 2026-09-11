import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/utils/arabic_name_helper.dart';
import '../../../../../../generated/locale_keys.g.dart';

/// Warning widget displayed below the student name field when potential
/// duplicates are detected based on Arabic normalization, spaces, or high similarity.
class StudentDuplicateWarningCard extends StatefulWidget {
  final List<NameDuplicateMatch> matches;

  const StudentDuplicateWarningCard({
    super.key,
    required this.matches,
  });

  @override
  State<StudentDuplicateWarningCard> createState() =>
      _StudentDuplicateWarningCardState();
}

class _StudentDuplicateWarningCardState
    extends State<StudentDuplicateWarningCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.matches.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasExactMatch = widget.matches.any(
      (m) =>
          m.matchLevel == NameMatchLevel.exact ||
          m.matchLevel == NameMatchLevel.normalizedExact,
    );

    // Styling based on severity
    final containerColor = hasExactMatch
        ? colorScheme.errorContainer.withValues(alpha: 0.18)
        : Colors.amber.withValues(alpha: 0.12);
    final borderColor = hasExactMatch
        ? colorScheme.error.withValues(alpha: 0.4)
        : Colors.amber.shade700.withValues(alpha: 0.4);
    final iconColor = hasExactMatch ? colorScheme.error : Colors.amber.shade800;

    final displayMatches = _expanded
        ? widget.matches
        : widget.matches.take(3).toList();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                hasExactMatch
                    ? Icons.warning_rounded
                    : Icons.info_outline_rounded,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  LocaleKeys.possible_name_duplicates.tr(
                    args: [widget.matches.length.toString()],
                  ),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: hasExactMatch
                        ? colorScheme.error
                        : (theme.brightness == Brightness.dark
                            ? Colors.amber.shade300
                            : Colors.amber.shade900),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Matches List
          ...displayMatches.map((match) {
            final student = match.student;
            final studentName = student['name']?.toString() ?? '';
            final serialNumber = student['serial_number']?.toString() ?? '';
            final groupName = student['group_name']?.toString() ?? '';
            final phone = student['phone1']?.toString() ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        studentName,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      _buildMatchBadge(match, colorScheme, textTheme),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      if (serialNumber.isNotEmpty)
                        _buildDetailChip(
                          icon: Icons.tag_rounded,
                          text: '${LocaleKeys.serial_number.tr()}: $serialNumber',
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                      if (groupName.isNotEmpty)
                        _buildDetailChip(
                          icon: Icons.group_outlined,
                          text: groupName,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                      if (phone.isNotEmpty)
                        _buildDetailChip(
                          icon: Icons.phone_outlined,
                          text: phone,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),

          // Expand / Collapse if more than 3 matches
          if (widget.matches.length > 3)
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                ),
                label: Text(
                  _expanded
                      ? LocaleKeys.show_less.tr()
                      : LocaleKeys.view_all_duplicates.tr(
                          args: [widget.matches.length.toString()],
                        ),
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                  ),
                ),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMatchBadge(
    NameDuplicateMatch match,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    Color badgeColor;
    Color textColor;
    String badgeText;

    switch (match.matchLevel) {
      case NameMatchLevel.exact:
        badgeColor = colorScheme.errorContainer;
        textColor = colorScheme.onErrorContainer;
        badgeText = LocaleKeys.exact_name_match.tr();
        break;
      case NameMatchLevel.normalizedExact:
        badgeColor = Colors.orange.withValues(alpha: 0.2);
        textColor = Colors.orange.shade900;
        badgeText = LocaleKeys.normalized_exact_name_match.tr();
        break;
      case NameMatchLevel.highSimilarity:
        badgeColor = colorScheme.secondaryContainer.withValues(alpha: 0.6);
        textColor = colorScheme.onSecondaryContainer;
        badgeText = match.reasonKey.tr(args: match.reasonArgs);
        break;
    }

    return Tooltip(
      message: badgeText,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          badgeText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String text,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Tooltip(
      message: text,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
