import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/locale_keys.g.dart';

/// An interactive multi-select field for exams with search, quick actions,
/// and removable chips.
class MultiExamSelector extends StatelessWidget {
  final List<Map<String, dynamic>> exams;
  final Set<int> selectedExamIds;
  final ValueChanged<Set<int>> onSelectionChanged;
  final String? label;
  final bool enabled;
  final bool showChips;

  const MultiExamSelector({
    super.key,
    required this.exams,
    required this.selectedExamIds,
    required this.onSelectionChanged,
    this.label,
    this.enabled = true,
    this.showChips = true,
  });

  String _getSummaryText(BuildContext context) {
    if (selectedExamIds.isEmpty) {
      return label ?? LocaleKeys.select_exams_hint.tr();
    }
    if (selectedExamIds.length == exams.length && exams.isNotEmpty) {
      return '${LocaleKeys.all_exams.tr()} (${exams.length})';
    }
    if (selectedExamIds.length == 1) {
      final exam = exams.firstWhere(
        (e) => (e['id'] as int) == selectedExamIds.first,
        orElse: () => {'name': ''},
      );
      return exam['name'] as String;
    }
    return LocaleKeys.selected_exams_count.tr(
      args: [selectedExamIds.length.toString()],
    );
  }

  void _openSelectionDialog(BuildContext context) {
    if (!enabled || exams.isEmpty) return;

    showDialog<Set<int>>(
      context: context,
      builder: (ctx) => _MultiExamSelectionDialog(
        exams: exams,
        initialSelected: selectedExamIds,
        title: label ?? LocaleKeys.select_exams_hint.tr(),
      ),
    ).then((result) {
      if (result != null) {
        onSelectionChanged(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = selectedExamIds.isNotEmpty;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: enabled ? () => _openSelectionDialog(context) : null,
          borderRadius: BorderRadius.circular(16.r),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label ?? LocaleKeys.select_exams_hint.tr(),
              prefixIcon: Icon(Icons.quiz, color: theme.colorScheme.primary),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasSelection && enabled)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      tooltip: LocaleKeys.deselect_all.tr(),
                      onPressed: () => onSelectionChanged({}),
                    ),
                  const Icon(Icons.arrow_drop_down),
                  SizedBox(width: 8.w),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              filled: true,
              fillColor: isDark
                  ? theme.colorScheme.surfaceContainerLow
                  : Colors.grey[50],
            ),
            child: Text(
              _getSummaryText(context),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasSelection
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: hasSelection ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (showChips && hasSelection) ...[
          SizedBox(height: 8.h),
          _buildChips(context, theme),
        ],
      ],
    );
  }

  Widget _buildChips(BuildContext context, ThemeData theme) {
    final selectedList = exams
        .where((e) => selectedExamIds.contains(e['id'] as int))
        .toList();

    const maxVisibleChips = 4;
    final visibleList = selectedList.take(maxVisibleChips).toList();
    final remainingCount = selectedList.length - maxVisibleChips;

    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: [
        ...visibleList.map((exam) {
          final id = exam['id'] as int;
          final name = exam['name'] as String;
          return InputChip(
            label: Text(
              name,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
            deleteIconColor: theme.colorScheme.primary,
            onDeleted: enabled
                ? () {
                    final updated = Set<int>.from(selectedExamIds)..remove(id);
                    onSelectionChanged(updated);
                  }
                : null,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
          );
        }),
        if (remainingCount > 0)
          ActionChip(
            label: Text(
              '+$remainingCount ${LocaleKeys.remaining.tr()}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHigh,
            onPressed: () => _openSelectionDialog(context),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
          ),
      ],
    );
  }
}

class _MultiExamSelectionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> exams;
  final Set<int> initialSelected;
  final String title;

  const _MultiExamSelectionDialog({
    required this.exams,
    required this.initialSelected,
    required this.title,
  });

  @override
  State<_MultiExamSelectionDialog> createState() =>
      _MultiExamSelectionDialogState();
}

class _MultiExamSelectionDialogState extends State<_MultiExamSelectionDialog> {
  late Set<int> _currentSelection;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _currentSelection = Set<int>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredExams {
    if (_searchQuery.trim().isEmpty) return widget.exams;
    final query = _searchQuery.toLowerCase();
    return widget.exams.where((e) {
      final name = (e['name'] as String?)?.toLowerCase() ?? '';
      final date = (e['date'] as String?)?.toLowerCase() ?? '';
      return name.contains(query) || date.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredExams;
    final allFilteredSelected = filtered.isNotEmpty &&
        filtered.every((e) => _currentSelection.contains(e['id'] as int));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500.w,
          maxHeight: 600.h,
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                    child: Icon(Icons.quiz, color: theme.colorScheme.primary),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          LocaleKeys.selected_count.tr(
                            args: [_currentSelection.length.toString()],
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Search Box
              TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: LocaleKeys.search_student_or_code_hint
                      .tr()
                      .replaceAll('student name or code', 'exam'),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(height: 12.h),

              // Quick Actions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (allFilteredSelected) {
                          for (final e in filtered) {
                            _currentSelection.remove(e['id'] as int);
                          }
                        } else {
                          for (final e in filtered) {
                            _currentSelection.add(e['id'] as int);
                          }
                        }
                      });
                    },
                    icon: Icon(
                      allFilteredSelected
                          ? Icons.deselect
                          : Icons.select_all,
                      size: 18.r,
                    ),
                    label: Text(
                      allFilteredSelected
                          ? LocaleKeys.deselect_all.tr()
                          : LocaleKeys.select_all_count.tr(
                              args: [filtered.length.toString()],
                            ),
                    ),
                  ),
                  if (_currentSelection.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(() => _currentSelection.clear()),
                      child: Text(
                        LocaleKeys.deselect_all.tr(),
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                ],
              ),
              const Divider(),

              // Exam List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          LocaleKeys.no_exams.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final exam = filtered[index];
                          final id = exam['id'] as int;
                          final isSelected = _currentSelection.contains(id);
                          final fullMark = exam['full_mark'];
                          final date = exam['date'] as String?;

                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: (bool? checked) {
                              setState(() {
                                if (checked == true) {
                                  _currentSelection.add(id);
                                } else {
                                  _currentSelection.remove(id);
                                }
                              });
                            },
                            title: Text(
                              exam['name'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              [
                                if (fullMark != null)
                                  '${LocaleKeys.full_mark.tr()}: $fullMark',
                                if (date != null && date.isNotEmpty) date,
                              ].join(' | '),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: theme.colorScheme.primary,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          );
                        },
                      ),
              ),
              const Divider(),
              SizedBox(height: 8.h),

              // Bottom Confirmation Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(LocaleKeys.cancel.tr()),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_currentSelection),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      '${LocaleKeys.save.tr()} (${_currentSelection.length})',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
