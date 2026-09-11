import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/app_theme.dart';
import '../../../../../generated/locale_keys.g.dart';

/// A dashboard hero card displayed at the top of the Mark Entry Screen,
/// showing exam metadata (Name, Date, Full Mark) and live statistical KPIs
/// (Total Students, Graded count with progress bar, Average Score, Highest Score).
class ExamMarkSummaryCard extends StatelessWidget {
  final String examName;
  final String examDate;
  final double fullMark;
  final int totalStudents;
  final int gradedCount;
  final double averageScore;
  final double? highestScore;

  const ExamMarkSummaryCard({
    super.key,
    required this.examName,
    required this.examDate,
    required this.fullMark,
    required this.totalStudents,
    required this.gradedCount,
    required this.averageScore,
    this.highestScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final double progress = totalStudents > 0
        ? (gradedCount / totalStudents).clamp(0.0, 1.0)
        : 0.0;
    final int progressPercent = (progress * 100).round();

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
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header: Exam Identity & Metadata ───
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Academic Badge Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.assignment_turned_in_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examName.isNotEmpty
                          ? examName
                          : LocaleKeys.exam_name.tr(),
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (examDate.isNotEmpty)
                          _buildTagChip(
                            context: context,
                            icon: Icons.calendar_today_rounded,
                            label: examDate,
                          ),
                        _buildTagChip(
                          context: context,
                          icon: Icons.stars_rounded,
                          label: '${LocaleKeys.full_mark.tr()}: ${fullMark.toStringAsFixed(fullMark.truncateToDouble() == fullMark ? 0 : 1)}',
                          accentColor: colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 18),

          // ─── Live Statistical KPIs Grid ───
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              return isWide
                  ? Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            context: context,
                            icon: Icons.groups_rounded,
                            label: LocaleKeys.total_students.tr(),
                            value: '$totalStudents',
                            iconBgColor: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                            iconColor: colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            context: context,
                            icon: Icons.check_circle_outline_rounded,
                            label: LocaleKeys.graded_students.tr(),
                            value: '$gradedCount / $totalStudents',
                            subtitle: '$progressPercent%',
                            progressBarRatio: progress,
                            iconBgColor: Colors.teal.withValues(alpha: 0.15),
                            iconColor: Colors.teal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            context: context,
                            icon: Icons.analytics_rounded,
                            label: LocaleKeys.average_score.tr(),
                            value: gradedCount > 0
                                ? averageScore.toStringAsFixed(1)
                                : '—',
                            subtitle: gradedCount > 0
                                ? '${((averageScore / (fullMark > 0 ? fullMark : 1)) * 100).round()}%'
                                : null,
                            iconBgColor: Colors.indigo.withValues(alpha: 0.15),
                            iconColor: Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            context: context,
                            icon: Icons.emoji_events_rounded,
                            label: LocaleKeys.highest_score.tr(),
                            value: highestScore != null
                                ? highestScore!.toStringAsFixed(
                                    highestScore!.truncateToDouble() == highestScore ? 0 : 1,
                                  )
                                : '—',
                            iconBgColor: Colors.amber.withValues(alpha: 0.2),
                            iconColor: Colors.amber.shade800,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricTile(
                                context: context,
                                icon: Icons.groups_rounded,
                                label: LocaleKeys.total_students.tr(),
                                value: '$totalStudents',
                                iconBgColor: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                                iconColor: colorScheme.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMetricTile(
                                context: context,
                                icon: Icons.check_circle_outline_rounded,
                                label: LocaleKeys.graded_students.tr(),
                                value: '$gradedCount / $totalStudents',
                                subtitle: '$progressPercent%',
                                progressBarRatio: progress,
                                iconBgColor: Colors.teal.withValues(alpha: 0.15),
                                iconColor: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricTile(
                                context: context,
                                icon: Icons.analytics_rounded,
                                label: LocaleKeys.average_score.tr(),
                                value: gradedCount > 0
                                    ? averageScore.toStringAsFixed(1)
                                    : '—',
                                subtitle: gradedCount > 0
                                    ? '${((averageScore / (fullMark > 0 ? fullMark : 1)) * 100).round()}%'
                                    : null,
                                iconBgColor: Colors.indigo.withValues(alpha: 0.15),
                                iconColor: Colors.indigo,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMetricTile(
                                context: context,
                                icon: Icons.emoji_events_rounded,
                                label: LocaleKeys.highest_score.tr(),
                                value: highestScore != null
                                    ? highestScore!.toStringAsFixed(
                                        highestScore!.truncateToDouble() == highestScore ? 0 : 1,
                                      )
                                    : '—',
                                iconBgColor: Colors.amber.withValues(alpha: 0.2),
                                iconColor: Colors.amber.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    Color? accentColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = accentColor ?? colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
    double? progressBarRatio,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          if (progressBarRatio != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressBarRatio,
                minHeight: 4,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressBarRatio >= 1.0 ? Colors.teal : colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
