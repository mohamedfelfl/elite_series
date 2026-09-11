import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';
import 'student_ui_helper.dart';

class StudentSearchHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final String? selectedGrade;
  final ValueChanged<String?> onGradeChanged;
  final int? selectedGroupId;
  final ValueChanged<int?> onGroupChanged;
  final List<Map<String, dynamic>> groups;
  final int rowsPerPage;
  final ValueChanged<int?> onRowsPerPageChanged;
  final VoidCallback onResetAllFilters;
  final bool hasActiveFilters;
  final bool isDense;
  final ValueChanged<bool>? onDensityChanged;

  const StudentSearchHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.selectedGrade,
    required this.onGradeChanged,
    required this.selectedGroupId,
    required this.onGroupChanged,
    required this.groups,
    required this.rowsPerPage,
    required this.onRowsPerPageChanged,
    required this.onResetAllFilters,
    required this.hasActiveFilters,
    this.isDense = true,
    this.onDensityChanged,
  });

  static const List<String> grades = [
    'prep_1',
    'prep_2',
    'prep_3',
    'sec_1',
    'sec_2',
    'sec_3',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Top Row: Search Input + Group Filter + Rows Per Page ──
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 650;

            final searchField = SizedBox(
              height: 40,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: LocaleKeys.search_hint.tr(),
                  hintStyle: TextStyle(
                    fontSize: 12.5,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16),
                          tooltip: LocaleKeys.cancel.tr(),
                          onPressed: onClearSearch,
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? colorScheme.surfaceContainerLow
                      : colorScheme.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            );

            final groupDropdown = Container(
              height: 40,
              constraints: const BoxConstraints(minWidth: 120, maxWidth: 170),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainerLow
                    : colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int?>(
                  isExpanded: true,
                  value: selectedGroupId,
                  hint: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_work_outlined,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        LocaleKeys.groups.tr(),
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                  borderRadius: BorderRadius.circular(10),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(
                        LocaleKeys.all_students.tr(),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: selectedGroupId == null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    ...groups.map((g) {
                      final id = g['id'] as int;
                      final name = g['name']?.toString() ?? '';
                      return DropdownMenuItem<int?>(
                        value: id,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: selectedGroupId == id
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: onGroupChanged,
                ),
              ),
            );

            final rowsPerPageSelector = Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainerLow
                    : colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: rowsPerPage,
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  borderRadius: BorderRadius.circular(10),
                  items: const [10, 20, 50, 100].map((int val) {
                    return DropdownMenuItem<int>(
                      value: val,
                      child: Text(
                        isNarrow ? '$val' : '$val / page',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: onRowsPerPageChanged,
                ),
              ),
            );

            final densityToggle = Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainerLow
                    : colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDense
                      ? colorScheme.primary.withValues(alpha: 0.5)
                      : colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: isDense ? 1.2 : 1.0,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  isDense ? Icons.density_small_rounded : Icons.density_medium_rounded,
                  size: 18,
                  color: isDense ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                tooltip: context.locale.languageCode == 'ar'
                    ? (isDense ? 'عرض مريح' : 'عرض مكثف')
                    : (isDense ? 'Comfortable view' : 'Compact view'),
                onPressed: onDensityChanged != null
                    ? () => onDensityChanged!(!isDense)
                    : null,
                padding: EdgeInsets.zero,
              ),
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  searchField,
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: groupDropdown),
                      const SizedBox(width: 8),
                      rowsPerPageSelector,
                      const SizedBox(width: 8),
                      densityToggle,
                    ],
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: searchField),
                const SizedBox(width: 10),
                SizedBox(width: 150, child: groupDropdown),
                const SizedBox(width: 10),
                rowsPerPageSelector,
                const SizedBox(width: 8),
                densityToggle,
              ],
            );
          },
        ),

        const SizedBox(height: 8),

        // ── Bottom Row: Grade Filter Chips + Clear All ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: Text(LocaleKeys.all_students.tr()),
                selected: selectedGrade == null,
                onSelected: (_) => onGradeChanged(null),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: isDark
                    ? colorScheme.surfaceContainerLow
                    : colorScheme.surfaceContainerLowest,
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  fontSize: 11.5,
                  fontWeight: selectedGrade == null
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: selectedGrade == null
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 6),
              ...grades.map((g) {
                final isSelected = selectedGrade == g;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(StudentUIHelper.getGradeLabel(g)),
                    selected: isSelected,
                    onSelected: (selected) {
                      onGradeChanged(selected ? g : null);
                    },
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: isDark
                        ? colorScheme.surfaceContainerLow
                        : colorScheme.surfaceContainerLowest,
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  ),
                );
              }),
              if (hasActiveFilters) ...[
                const SizedBox(width: 6),
                ActionChip(
                  avatar: const Icon(Icons.filter_alt_off_rounded, size: 14),
                  label: Text(
                    LocaleKeys.cancel.tr(),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.error,
                    ),
                  ),
                  onPressed: onResetAllFilters,
                  backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.3),
                  side: BorderSide(
                    color: colorScheme.error.withValues(alpha: 0.4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
