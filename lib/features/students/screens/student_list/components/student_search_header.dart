import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

class StudentSearchHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddPressed;
  final VoidCallback? onBulkDeletePressed;
  final int? selectedCount;

  final int rowsPerPage;
  final ValueChanged<int?> onRowsPerPageChanged;

  const StudentSearchHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAddPressed,
    required this.rowsPerPage,
    required this.onRowsPerPageChanged,
    this.onBulkDeletePressed,
    this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasSelection = selectedCount != null && selectedCount! > 0;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: LocaleKeys.search_hint.tr(),
              prefixIcon: const Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 16.w,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // ── Rows Per Page Dropdown ──
        Container(
          height: 60.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                isExpanded: true,
                itemHeight: 60.h,
                borderRadius: BorderRadius.circular(12.r),
                value: rowsPerPage,
                items: [10, 20, 50, 100].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      '$value',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                onChanged: onRowsPerPageChanged,
                icon: const Icon(Icons.format_list_numbered, size: 20),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        if (hasSelection && onBulkDeletePressed != null) ...[
          ElevatedButton.icon(
            onPressed: onBulkDeletePressed,
            icon: const Icon(Icons.delete_sweep),
            label: Text('${LocaleKeys.delete_selected.tr()} ($selectedCount)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            ),
          ),
          SizedBox(width: 12.w),
        ],
        ElevatedButton.icon(
          onPressed: onAddPressed,
          icon: const Icon(Icons.person_add),
          label: Text(LocaleKeys.add_new.tr()),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          ),
        ),
      ],
    );
  }
}
