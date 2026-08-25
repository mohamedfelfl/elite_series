import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/constants/dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/qr_card_config.dart';
import '../../data/models/student_card_data.dart';

class QrCardControlBar extends StatelessWidget {
  final QRCardSelectionMode selectionMode;
  final ValueChanged<QRCardSelectionMode?> onSelectionModeChanged;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final List<Map<String, dynamic>> availableGroups;
  final int? selectedGroupId;
  final ValueChanged<int?> onGroupChanged;
  final List<String> availableStages;
  final String? selectedStage;
  final ValueChanged<String?> onStageChanged;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final void Function(DateTime? startDate, DateTime? endDate) onDateRangeChanged;

  const QrCardControlBar({
    super.key,
    required this.selectionMode,
    required this.onSelectionModeChanged,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.availableGroups,
    required this.selectedGroupId,
    required this.onGroupChanged,
    required this.availableStages,
    required this.selectedStage,
    required this.onStageChanged,
    this.selectedStartDate,
    this.selectedEndDate,
    required this.onDateRangeChanged,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialRange = selectedStartDate != null
        ? DateTimeRange(
            start: selectedStartDate!,
            end: selectedEndDate ?? selectedStartDate!,
          )
        : null;

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      onDateRangeChanged(picked.start, picked.end);
    }
  }

  String _formatDateRangeText() {
    if (selectedStartDate == null) {
      return LocaleKeys.select_date_added.tr();
    }
    final formatter = DateFormat('yyyy-MM-dd');
    final startStr = formatter.format(selectedStartDate!);
    if (selectedEndDate == null || _isSameDay(selectedStartDate!, selectedEndDate!)) {
      return startStr;
    }
    final endStr = formatter.format(selectedEndDate!);
    return '$startStr  →  $endStr';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sevenDaysAgo = today.subtract(const Duration(days: 6));
    final firstOfMonth = DateTime(now.year, now.month, 1);

    final isTodaySelected = selectedStartDate != null &&
        selectedEndDate != null &&
        _isSameDay(selectedStartDate!, today) &&
        _isSameDay(selectedEndDate!, today);

    final isYesterdaySelected = selectedStartDate != null &&
        selectedEndDate != null &&
        _isSameDay(selectedStartDate!, yesterday) &&
        _isSameDay(selectedEndDate!, yesterday);

    final is7DaysSelected = selectedStartDate != null &&
        selectedEndDate != null &&
        _isSameDay(selectedStartDate!, sevenDaysAgo) &&
        _isSameDay(selectedEndDate!, today);

    final isMonthSelected = selectedStartDate != null &&
        selectedEndDate != null &&
        _isSameDay(selectedStartDate!, firstOfMonth) &&
        _isSameDay(selectedEndDate!, today);

    return Container(
      padding: EdgeInsets.all(AppDimens.p16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: AppDimens.opacityHalf,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<QRCardSelectionMode>(
                  isExpanded: true,
                  initialValue: selectionMode,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.select_by.tr(),
                    labelStyle: textTheme.bodyMedium,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimens.p12,
                      vertical: AppDimens.p10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.r10),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: QRCardSelectionMode.student,
                      child: Text(
                        LocaleKeys.student_selected_mode.tr(),
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    DropdownMenuItem(
                      value: QRCardSelectionMode.group,
                      child: Text(
                        LocaleKeys.group_mode.tr(),
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    DropdownMenuItem(
                      value: QRCardSelectionMode.stage,
                      child: Text(
                        LocaleKeys.stage_mode.tr(),
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    DropdownMenuItem(
                      value: QRCardSelectionMode.date,
                      child: Text(
                        LocaleKeys.date_mode.tr(),
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    DropdownMenuItem(
                      value: QRCardSelectionMode.all,
                      child: Text(
                        LocaleKeys.all_students_mode.tr(),
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                  onChanged: onSelectionModeChanged,
                ),
              ),

              if (selectionMode == QRCardSelectionMode.group) ...[
                SizedBox(width: AppDimens.p12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    initialValue: selectedGroupId,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.select_group.tr(),
                      labelStyle: textTheme.bodyMedium,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppDimens.p12,
                        vertical: AppDimens.p10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r10),
                      ),
                    ),
                    items: [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text(
                          LocaleKeys.all_groups.tr(),
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      ...availableGroups.map((g) {
                        final id = g['id'] as int;
                        final name = g['name'] as String? ?? '';
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(
                            _cleanGroupName(name),
                            style: textTheme.bodyMedium,
                          ),
                        );
                      }),
                    ],
                    onChanged: onGroupChanged,
                  ),
                ),
              ],

              if (selectionMode == QRCardSelectionMode.stage) ...[
                SizedBox(width: AppDimens.p12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: selectedStage,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.select_stage.tr(),
                      labelStyle: textTheme.bodyMedium,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppDimens.p12,
                        vertical: AppDimens.p10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r10),
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          LocaleKeys.all_stages.tr(),
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      ...availableStages.map((stage) {
                        return DropdownMenuItem<String>(
                          value: stage,
                          child: Text(
                            StudentCardData.formatStageArabic(stage),
                            style: textTheme.bodyMedium,
                          ),
                        );
                      }),
                    ],
                    onChanged: onStageChanged,
                  ),
                ),
              ],

              if (selectionMode == QRCardSelectionMode.date) ...[
                SizedBox(width: AppDimens.p12),
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () => _pickDateRange(context),
                    borderRadius: BorderRadius.circular(AppDimens.r10),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        filled: selectedStartDate != null,
                        fillColor: selectedStartDate != null
                            ? colorScheme.primaryContainer.withValues(alpha: 0.2)
                            : null,
                        labelText: LocaleKeys.date_mode.tr(),
                        labelStyle: textTheme.bodyMedium?.copyWith(
                          color: selectedStartDate != null
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: selectedStartDate != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_month_rounded,
                          size: AppDimens.iconSize20,
                          color: selectedStartDate != null
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppDimens.p12,
                          vertical: AppDimens.p10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimens.r10),
                          borderSide: BorderSide(
                            color: selectedStartDate != null
                                ? colorScheme.primary
                                : colorScheme.outlineVariant.withValues(
                                    alpha: AppDimens.opacityHalf,
                                  ),
                            width: selectedStartDate != null ? 1.5 : 1.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimens.r10),
                          borderSide: BorderSide(
                            color: selectedStartDate != null
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                            width: selectedStartDate != null ? 1.5 : 1.0,
                          ),
                        ),
                      ),
                      child: Text(
                        _formatDateRangeText(),
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: selectedStartDate != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedStartDate != null
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(width: AppDimens.p12),

              Expanded(
                flex: 3,
                child: TextField(
                  onChanged: onSearchChanged,
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.search_student_or_code_hint.tr(),
                    hintStyle: textTheme.bodyMedium,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: AppDimens.iconSize20,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimens.p12,
                      vertical: AppDimens.p10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.r10),
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (selectionMode == QRCardSelectionMode.date) ...[
            SizedBox(height: AppDimens.p10),
            Wrap(
              spacing: AppDimens.p8,
              runSpacing: AppDimens.p6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: Text(
                    LocaleKeys.filter_today.tr(),
                    style: TextStyle(
                      color: isTodaySelected
                          ? Colors.white
                          : colorScheme.onSurface,
                      fontWeight: isTodaySelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isTodaySelected,
                  selectedColor: colorScheme.primary,
                  showCheckmark: false,
                  side: BorderSide(
                    color: isTodaySelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withValues(
                            alpha: AppDimens.opacityHalf,
                          ),
                  ),
                  onSelected: (selected) => onDateRangeChanged(
                    selected ? today : null,
                    selected ? today : null,
                  ),
                  avatar: Icon(
                    Icons.today_rounded,
                    size: 16,
                    color: isTodaySelected
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                FilterChip(
                  label: Text(
                    LocaleKeys.filter_yesterday.tr(),
                    style: TextStyle(
                      color: isYesterdaySelected
                          ? Colors.white
                          : colorScheme.onSurface,
                      fontWeight: isYesterdaySelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isYesterdaySelected,
                  selectedColor: colorScheme.primary,
                  showCheckmark: false,
                  side: BorderSide(
                    color: isYesterdaySelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withValues(
                            alpha: AppDimens.opacityHalf,
                          ),
                  ),
                  onSelected: (selected) => onDateRangeChanged(
                    selected ? yesterday : null,
                    selected ? yesterday : null,
                  ),
                  avatar: Icon(
                    Icons.history_rounded,
                    size: 16,
                    color: isYesterdaySelected
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                FilterChip(
                  label: Text(
                    LocaleKeys.filter_last_7_days.tr(),
                    style: TextStyle(
                      color: is7DaysSelected
                          ? Colors.white
                          : colorScheme.onSurface,
                      fontWeight: is7DaysSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: is7DaysSelected,
                  selectedColor: colorScheme.primary,
                  showCheckmark: false,
                  side: BorderSide(
                    color: is7DaysSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withValues(
                            alpha: AppDimens.opacityHalf,
                          ),
                  ),
                  onSelected: (selected) => onDateRangeChanged(
                    selected ? sevenDaysAgo : null,
                    selected ? today : null,
                  ),
                  avatar: Icon(
                    Icons.date_range_rounded,
                    size: 16,
                    color: is7DaysSelected
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                FilterChip(
                  label: Text(
                    LocaleKeys.filter_this_month.tr(),
                    style: TextStyle(
                      color: isMonthSelected
                          ? Colors.white
                          : colorScheme.onSurface,
                      fontWeight: isMonthSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isMonthSelected,
                  selectedColor: colorScheme.primary,
                  showCheckmark: false,
                  side: BorderSide(
                    color: isMonthSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withValues(
                            alpha: AppDimens.opacityHalf,
                          ),
                  ),
                  onSelected: (selected) => onDateRangeChanged(
                    selected ? firstOfMonth : null,
                    selected ? today : null,
                  ),
                  avatar: Icon(
                    Icons.calendar_view_month_rounded,
                    size: 16,
                    color: isMonthSelected
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _cleanGroupName(String name) {
    String n = name.trim();
    n = n.replaceAll('الثللاثاء', 'الثلاثاء');
    n = n.replaceAll(RegExp(r'\s*[123]\s*ث\s*'), ' ');
    n = n.replaceAll(RegExp(r'\s+'), ' ').trim();
    return n;
  }
}
