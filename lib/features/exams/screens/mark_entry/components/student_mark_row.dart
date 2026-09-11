import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../generated/locale_keys.g.dart';

/// An organized, responsive gradebook row for a single student.
/// Features serial badge, student name, group indicator, keyboard traversal,
/// and live grade evaluation pills (Excellent, Very Good, Good, Pass, Below Pass).
class StudentMarkRow extends StatelessWidget {
  final Map<String, Object?> student;
  final TextEditingController scoreController;
  final GlobalKey studentKey;
  final bool isHighlighted;
  final double? fullMark;
  final String? groupName;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final bool isEvenRow;

  const StudentMarkRow({
    super.key,
    required this.student,
    required this.scoreController,
    required this.studentKey,
    required this.isHighlighted,
    this.fullMark,
    this.groupName,
    this.focusNode,
    this.onSubmitted,
    this.isEvenRow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final String serialNumber = student['serial_number']?.toString() ?? '—';
    final String studentName = student['name']?.toString() ?? '';
    final String effectiveGroup = groupName ?? (student['group_name']?.toString() ?? '');

    Color rowBackground = Colors.transparent;
    if (isHighlighted) {
      rowBackground = colorScheme.primaryContainer.withValues(alpha: 0.35);
    } else if (isEvenRow) {
      rowBackground = colorScheme.surfaceContainerHighest.withValues(alpha: 0.2);
    }

    return AnimatedContainer(
      key: studentKey,
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        color: rowBackground,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            width: 0.8,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildSerialBadge(context, serialNumber),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        studentName,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (effectiveGroup.isNotEmpty) ...[
                      _buildGroupChip(context, effectiveGroup),
                      const Spacer(),
                    ] else
                      const Spacer(),
                    _buildScoreInputField(context),
                    const SizedBox(width: 8),
                    _buildEvaluationBadge(context),
                  ],
                ),
              ],
            );
          }

          // Desktop & Tablet table row layout
          return Row(
            children: [
              // Serial Number Column
              SizedBox(
                width: 90,
                child: _buildSerialBadge(context, serialNumber),
              ),
              const SizedBox(width: 12),

              // Student Name Column
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        studentName.isNotEmpty ? studentName[0] : '?',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        studentName,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Group Column
              if (effectiveGroup.isNotEmpty) ...[
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _buildGroupChip(context, effectiveGroup),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Score Input Field
              SizedBox(
                width: 120,
                child: _buildScoreInputField(context),
              ),
              const SizedBox(width: 14),

              // Grade Evaluation Badge
              SizedBox(
                width: 125,
                child: _buildEvaluationBadge(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSerialBadge(BuildContext context, String serial) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Text(
        serial,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildGroupChip(BuildContext context, String group) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        group,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildScoreInputField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String suffix = fullMark != null
        ? '/${fullMark!.toStringAsFixed(fullMark!.truncateToDouble() == fullMark ? 0 : 1)}'
        : '';

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: scoreController,
      builder: (context, value, _) {
        final double? parsed = double.tryParse(value.text);
        final bool isExceeding = fullMark != null && parsed != null && parsed > fullMark!;

        return TextField(
          controller: scoreController,
          focusNode: focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          onSubmitted: onSubmitted,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: isExceeding ? colorScheme.error : colorScheme.onSurface,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: LocaleKeys.score.tr(),
            hintStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'مسح الدرجة',
                    onPressed: () => scoreController.clear(),
                  )
                : (suffix.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: Center(
                          widthFactor: 1.0,
                          child: Text(
                            suffix,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : null),
            isDense: true,
            filled: true,
            fillColor: isExceeding
                ? colorScheme.errorContainer.withValues(alpha: 0.3)
                : colorScheme.surfaceContainerLowest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.inputRadius),
              borderSide: BorderSide(
                color: isExceeding ? colorScheme.error : colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.inputRadius),
              borderSide: BorderSide(
                color: isExceeding
                    ? colorScheme.error
                    : colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.inputRadius),
              borderSide: BorderSide(
                color: isExceeding ? colorScheme.error : colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEvaluationBadge(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: scoreController,
      builder: (context, value, _) {
        final text = value.text.trim();
        if (text.isEmpty) {
          return _statusPill(
            context,
            label: LocaleKeys.grade_status_pending.tr(),
            bgColor: Colors.grey.withValues(alpha: 0.12),
            fgColor: Colors.grey.shade600,
            icon: Icons.hourglass_empty_rounded,
          );
        }

        final score = double.tryParse(text);
        if (score == null) {
          return const SizedBox.shrink();
        }

        if (fullMark != null && score > fullMark!) {
          return _statusPill(
            context,
            label: '> ${fullMark!.toStringAsFixed(0)}',
            bgColor: Colors.red.withValues(alpha: 0.15),
            fgColor: Colors.red.shade700,
            icon: Icons.warning_amber_rounded,
          );
        }

        final ratio = fullMark != null && fullMark! > 0 ? (score / fullMark!) : 0.0;

        if (ratio >= 0.85) {
          return _statusPill(
            context,
            label: LocaleKeys.grade_status_excellent.tr(),
            bgColor: const Color(0xFF10B981).withValues(alpha: 0.15),
            fgColor: const Color(0xFF047857),
            icon: Icons.star_rounded,
          );
        } else if (ratio >= 0.75) {
          return _statusPill(
            context,
            label: LocaleKeys.grade_status_very_good.tr(),
            bgColor: Colors.teal.withValues(alpha: 0.15),
            fgColor: const Color(0xFF0F766E),
            icon: Icons.thumb_up_alt_rounded,
          );
        } else if (ratio >= 0.65) {
          return _statusPill(
            context,
            label: LocaleKeys.grade_status_good.tr(),
            bgColor: Colors.blue.withValues(alpha: 0.15),
            fgColor: const Color(0xFF1D4ED8),
            icon: Icons.check_circle_outline_rounded,
          );
        } else if (ratio >= 0.50) {
          return _statusPill(
            context,
            label: LocaleKeys.grade_status_pass.tr(),
            bgColor: Colors.amber.withValues(alpha: 0.18),
            fgColor: const Color(0xFFB45309),
            icon: Icons.remove_circle_outline_rounded,
          );
        } else {
          return _statusPill(
            context,
            label: LocaleKeys.grade_status_below_pass.tr(),
            bgColor: const Color(0xFFF43F5E).withValues(alpha: 0.15),
            fgColor: const Color(0xFFBE123C),
            icon: Icons.error_outline_rounded,
          );
        }
      },
    );
  }

  Widget _statusPill(
    BuildContext context, {
    required String label,
    required Color bgColor,
    required Color fgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 12, color: fgColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: fgColor,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
