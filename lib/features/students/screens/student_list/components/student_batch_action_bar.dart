import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

class StudentBatchActionBar extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onToggleAll;
  final VoidCallback onClearSelection;
  final VoidCallback? onMergePressed;
  final VoidCallback? onDeletePressed;

  const StudentBatchActionBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onToggleAll,
    required this.onClearSelection,
    this.onMergePressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bool allSelected = totalCount > 0 && selectedCount == totalCount;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          alignment: Alignment.topCenter,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: selectedCount > 0
          ? Container(
              key: const ValueKey('batch_action_bar_visible'),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainerHigh
                    : colorScheme.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.25),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 750;

                  final selectionInfo = Row(
                    children: [
                      Checkbox(
                        value: allSelected ? true : (selectedCount > 0 ? null : false),
                        tristate: true,
                        onChanged: (_) => onToggleAll(),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '$selectedCount',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          allSelected
                              ? LocaleKeys.select_deselect_all.tr()
                              : LocaleKeys.delete_selected.tr().split(' ').first,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            fontSize: 12.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );

                  final clearButton = TextButton.icon(
                    onPressed: onClearSelection,
                    icon: const Icon(Icons.close_rounded, size: 15),
                    label: Text(
                      LocaleKeys.cancel.tr(),
                      style: const TextStyle(fontSize: 11.5),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );

                  final actionButtons = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedCount >= 2 && onMergePressed != null) ...[
                        FilledButton.tonalIcon(
                          onPressed: onMergePressed,
                          icon: const Icon(Icons.merge_type_rounded, size: 15),
                          label: Text(
                            '${LocaleKeys.merge_selected.tr()} ($selectedCount)',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      if (onDeletePressed != null)
                        FilledButton.icon(
                          onPressed: onDeletePressed,
                          icon: const Icon(Icons.delete_sweep_rounded, size: 15),
                          label: Text(
                            '${LocaleKeys.delete_selected.tr()} ($selectedCount)',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            foregroundColor: colorScheme.onError,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                    ],
                  );

                  if (isCompact) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: selectionInfo),
                            clearButton,
                          ],
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: actionButtons,
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: selectionInfo),
                      clearButton,
                      const SizedBox(width: 8),
                      actionButtons,
                    ],
                  );
                },
              ),
            )
          : const SizedBox.shrink(key: ValueKey('batch_action_bar_hidden')),
    );
  }
}
