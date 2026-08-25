import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_management_system/app/router/app_router.gr.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

class StudentDataTable extends StatefulWidget {
  final List<Map<String, Object?>> students;
  final Set<int> selectedIds;
  final VoidCallback onToggleAll;
  final ValueChanged<int> onToggleSelection;
  final ValueChanged<Map<String, Object?>> onDeleteStudent;
  final int rowsPerPage;

  const StudentDataTable({
    super.key,
    required this.students,
    required this.selectedIds,
    required this.onToggleAll,
    required this.onToggleSelection,
    required this.onDeleteStudent,
    this.rowsPerPage = 10,
  });

  @override
  State<StudentDataTable> createState() => _StudentDataTableState();
}

class _StudentDataTableState extends State<StudentDataTable> {
  _StudentDataSource? _dataSource;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dataSource == null) {
      _dataSource = _StudentDataSource(
        context: context,
        students: widget.students,
        selectedIds: widget.selectedIds,
        onToggleSelection: widget.onToggleSelection,
        onDeleteStudent: widget.onDeleteStudent,
        textTheme: Theme.of(context).textTheme,
        colorScheme: Theme.of(context).colorScheme,
      );
    } else {
      _dataSource!.updateData(widget.students, widget.selectedIds);
    }
  }

  @override
  void didUpdateWidget(covariant StudentDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.students != oldWidget.students ||
        widget.selectedIds != oldWidget.selectedIds) {
      _dataSource?.updateData(widget.students, widget.selectedIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    if (_dataSource == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerLow
            : colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: colorScheme.outlineVariant.withValues(alpha: 0.1),
              blurRadius: 16.r,
              offset: Offset(0, 4.h),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: PaginatedDataTable2(
          key: ValueKey(widget.rowsPerPage),
          horizontalMargin: 20.w,
          columnSpacing: 18.w,
          minWidth: 700.w,
          dataRowHeight: 120.h,
          headingRowHeight: 60.h,
          headingRowColor: WidgetStateProperty.all(
            isDark
                ? colorScheme.surfaceContainer
                : colorScheme.surfaceContainerLow,
          ),
          showCheckboxColumn: false,
          rowsPerPage: widget.rowsPerPage,
          availableRowsPerPage: const [10, 20, 50, 100],
          source: _dataSource!,
          wrapInCard: false,
          renderEmptyRowsInTheEnd: false,
          columns: [
            DataColumn2(
              label: Transform.scale(
                scale: 1.4,
                child: Checkbox(
                  value:
                      widget.students.isNotEmpty &&
                      widget.selectedIds.length == widget.students.length,
                  tristate: true,
                  onChanged: (_) => widget.onToggleAll(),
                ),
              ),
              fixedWidth: 60,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.id_serial.tr(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.name.tr(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.school_group.tr(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              size: ColumnSize.M,
            ),
            const DataColumn2(label: Text(''), fixedWidth: 120),
          ],
        ),
      ),
    );
  }
}

class _StudentDataSource extends DataTableSource {
  final BuildContext context;
  List<Map<String, Object?>> students;
  Set<int> selectedIds;
  final ValueChanged<int> onToggleSelection;
  final ValueChanged<Map<String, Object?>> onDeleteStudent;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  _StudentDataSource({
    required this.context,
    required this.students,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onDeleteStudent,
    required this.textTheme,
    required this.colorScheme,
  });

  void updateData(
    List<Map<String, Object?>> newStudents,
    Set<int> newSelectedIds,
  ) {
    students = newStudents;
    selectedIds = newSelectedIds;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) return null;
    final s = students[index];
    final int id = s['id'] as int;
    final bool isSelected = selectedIds.contains(id);

    return DataRow2(
      selected: isSelected,
      onTap: () => context.router.push(StudentDetailRoute(id: id)),
      cells: [
        DataCell(
          Transform.scale(
            scale: 1.4,
            child: Checkbox(
              value: isSelected,
              onChanged: (_) => onToggleSelection(id),
            ),
          ),
        ),
        DataCell(
          Text(
            s['serial_number']?.toString() ?? '',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['name']?.toString() ?? '',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s['phone1']?.toString() ?? '',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        DataCell(
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${s['school']?.toString() ?? LocaleKeys.na.tr()} (${_getGradeLabel(s['grade']?.toString())})',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  s['group_name']?.toString() ?? LocaleKeys.unassigned.tr(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20.r,
                  color: colorScheme.onSurfaceVariant,
                ),
                tooltip: LocaleKeys.edit.tr(),
                onPressed: () => context.router.push(StudentFormRoute(id: id)),
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.delete_outline,
                  size: 20.r,
                  color: colorScheme.error,
                ),
                tooltip: LocaleKeys.delete.tr(),
                onPressed: () => onDeleteStudent(s),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => students.length;

  @override
  int get selectedRowCount => selectedIds.length;

  String _getGradeLabel(String? grade) {
    if (grade == 'sec_1') return LocaleKeys.sec_1.tr();
    if (grade == 'sec_2') return LocaleKeys.sec_2.tr();
    if (grade == 'sec_3') return LocaleKeys.sec_3.tr();
    return LocaleKeys.na.tr();
  }
}
