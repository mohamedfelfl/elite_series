import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_management_system/app/router/app_router.gr.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';
import 'student_ui_helper.dart';

class StudentDataTable extends StatefulWidget {
  final List<Map<String, Object?>> students;
  final Set<int> selectedIds;
  final VoidCallback onToggleAll;
  final ValueChanged<int> onToggleSelection;
  final ValueChanged<Map<String, Object?>> onDeleteStudent;
  final int rowsPerPage;
  final bool isDense;

  const StudentDataTable({
    super.key,
    required this.students,
    required this.selectedIds,
    required this.onToggleAll,
    required this.onToggleSelection,
    required this.onDeleteStudent,
    this.rowsPerPage = 10,
    this.isDense = true,
  });

  @override
  State<StudentDataTable> createState() => _StudentDataTableState();
}

class _StudentDataTableState extends State<StudentDataTable> {
  _StudentDataSource? _dataSource;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  List<Map<String, Object?>> _sortedStudents = [];

  void _applySort() {
    _sortedStudents = List<Map<String, Object?>>.from(widget.students);
    if (_sortColumnIndex != null) {
      _sortedStudents.sort((a, b) {
        int result = 0;
        switch (_sortColumnIndex) {
          case 1: // ID / Serial
            final aVal = a['serial_number']?.toString() ?? '';
            final bVal = b['serial_number']?.toString() ?? '';
            result = aVal.compareTo(bVal);
            break;
          case 2: // Name
            final aVal = a['name']?.toString() ?? '';
            final bVal = b['name']?.toString() ?? '';
            result = aVal.compareTo(bVal);
            break;
          case 4: // Grade
            final aVal = a['grade']?.toString() ?? '';
            final bVal = b['grade']?.toString() ?? '';
            result = aVal.compareTo(bVal);
            break;
          case 5: // Group
            final aVal = a['group_name']?.toString() ?? '';
            final bVal = b['group_name']?.toString() ?? '';
            result = aVal.compareTo(bVal);
            break;
          default:
            result = 0;
        }
        return _sortAscending ? result : -result;
      });
    }
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _applySort();
      _dataSource?.updateData(_sortedStudents, widget.selectedIds, widget.isDense);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applySort();
    if (_dataSource == null) {
      _dataSource = _StudentDataSource(
        context: context,
        students: _sortedStudents,
        selectedIds: widget.selectedIds,
        onToggleSelection: widget.onToggleSelection,
        onDeleteStudent: widget.onDeleteStudent,
        textTheme: Theme.of(context).textTheme,
        colorScheme: Theme.of(context).colorScheme,
        isDense: widget.isDense,
      );
    } else {
      _dataSource!.updateData(_sortedStudents, widget.selectedIds, widget.isDense);
    }
  }

  @override
  void didUpdateWidget(covariant StudentDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.students != oldWidget.students ||
        widget.selectedIds != oldWidget.selectedIds ||
        widget.isDense != oldWidget.isDense) {
      _applySort();
      _dataSource?.updateData(_sortedStudents, widget.selectedIds, widget.isDense);
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: colorScheme.outlineVariant.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: isDark ? 0.2 : 0.4),
          width: 0.8,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: PaginatedDataTable2(
          key: ValueKey('${widget.rowsPerPage}_${widget.isDense}_${_sortColumnIndex}_$_sortAscending'),
          horizontalMargin: 12,
          columnSpacing: 10,
          minWidth: 780, // Fixed logical pixels to avoid desktop scaling overflow
          dataRowHeight: widget.isDense ? 46.0 : 56.0,
          headingRowHeight: 40.0,
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
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
              label: Checkbox(
                value: widget.students.isNotEmpty &&
                    widget.selectedIds.length == widget.students.length,
                tristate: widget.selectedIds.isNotEmpty &&
                    widget.selectedIds.length < widget.students.length,
                onChanged: (_) => widget.onToggleAll(),
              ),
              fixedWidth: 42,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.id_serial.tr(),
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
              fixedWidth: 80,
              onSort: _onSort,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.name.tr(),
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
              size: ColumnSize.L,
              onSort: _onSort,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.phone_number.tr(),
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
              fixedWidth: 145,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.grade.tr(),
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
              fixedWidth: 90,
              onSort: _onSort,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.groups.tr(),
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
              size: ColumnSize.M,
              onSort: _onSort,
            ),
            DataColumn2(
              label: Text(
                LocaleKeys.student_status.tr(),
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
              fixedWidth: 75,
            ),
            const DataColumn2(
              label: Text(''),
              fixedWidth: 95,
            ),
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
  bool isDense;
  int? _recentlyCopiedId;

  _StudentDataSource({
    required this.context,
    required this.students,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onDeleteStudent,
    required this.textTheme,
    required this.colorScheme,
    this.isDense = true,
  });

  void updateData(
    List<Map<String, Object?>> newStudents,
    Set<int> newSelectedIds,
    bool newIsDense,
  ) {
    students = newStudents;
    selectedIds = newSelectedIds;
    isDense = newIsDense;
    notifyListeners();
  }

  void _copyPhone(int studentId, String phone) {
    Clipboard.setData(ClipboardData(text: phone));
    _recentlyCopiedId = studentId;
    notifyListeners();

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              '$phone ${LocaleKeys.delivery_success.tr()}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 1600),
        behavior: SnackBarBehavior.floating,
        width: 280,
      ),
    );

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (_recentlyCopiedId == studentId) {
        _recentlyCopiedId = null;
        notifyListeners();
      }
    });
  }

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) return null;
    final s = students[index];
    final int id = s['id'] as int;
    final bool isSelected = selectedIds.contains(id);
    final String name = s['name']?.toString() ?? '';
    final String serial = s['serial_number']?.toString() ?? '';
    final String phone1 = s['phone1']?.toString() ?? '';
    final String phone2 = s['phone2']?.toString() ?? '';
    final String grade = s['grade']?.toString() ?? '';
    final String groupName = s['group_name']?.toString() ?? '';
    final String school = s['school']?.toString() ?? '';
    final String status = s['student_status']?.toString() ?? 'normal';
    final bool isFree = status == 'free';
    final bool isCopied = _recentlyCopiedId == id;

    final avatarColor = StudentUIHelper.getAvatarColor(name, fallbackId: id);
    final double avatarRadius = isDense ? 13.0 : 16.0;

    return DataRow2(
      selected: isSelected,
      onTap: () => context.router.push(StudentDetailRoute(id: id)),
      cells: [
        // ── 1. Checkbox ──
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (_) => onToggleSelection(id),
          ),
        ),

        // ── 2. Serial Number (Compact Monospace Badge) ──
        DataCell(
          Tooltip(
            message: serial,
            waitDuration: const Duration(milliseconds: 500),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                serial,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),

        // ── 3. Name & Avatar ──
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: avatarColor.withValues(alpha: 0.18),
                child: Text(
                  StudentUIHelper.getInitials(name),
                  style: TextStyle(
                    fontSize: isDense ? 10 : 11,
                    fontWeight: FontWeight.bold,
                    color: avatarColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Tooltip(
                  message: school.isNotEmpty ? '$name\n$school' : name,
                  waitDuration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: isDense ? 12.5 : 13.5,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (school.isNotEmpty && !isDense) ...[
                        const SizedBox(height: 1),
                        Text(
                          school,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 10.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── 4. Phone & Quick Copy ──
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Tooltip(
                  message: phone2.isNotEmpty ? '$phone1\n$phone2' : phone1,
                  waitDuration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phone1.isNotEmpty ? phone1 : LocaleKeys.na.tr(),
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: isDense ? 11.5 : 12.5,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (phone2.isNotEmpty && !isDense)
                        Text(
                          phone2,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
              if (phone1.isNotEmpty) ...[
                const SizedBox(width: 4),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(22, 22),
                  ),
                  icon: Icon(
                    isCopied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 14,
                    color: isCopied ? Colors.green : colorScheme.primary,
                  ),
                  tooltip: phone1,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                  onPressed: () => _copyPhone(id, phone1),
                ),
              ],
            ],
          ),
        ),

        // ── 5. Grade (Dedicated Tonal Chip) ──
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              StudentUIHelper.getGradeLabel(grade),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),

        // ── 6. Group ──
        DataCell(
          Tooltip(
            message: groupName.isNotEmpty ? groupName : LocaleKeys.unassigned.tr(),
            waitDuration: const Duration(milliseconds: 500),
            child: Text(
              groupName.isNotEmpty ? groupName : LocaleKeys.unassigned.tr(),
              style: textTheme.bodySmall?.copyWith(
                color: groupName.isNotEmpty
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 11.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // ── 7. Status ──
        DataCell(
          isFree
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.45),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    LocaleKeys.free.tr(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    LocaleKeys.normal.tr(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
        ),

        // ── 8. Actions ──
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(24, 24),
                ),
                icon: Icon(
                  Icons.visibility_outlined,
                  size: 15,
                  color: colorScheme.primary,
                ),
                tooltip: LocaleKeys.view_all.tr(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                onPressed: () =>
                    context.router.push(StudentDetailRoute(id: id)),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(24, 24),
                ),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 15,
                  color: colorScheme.onSurfaceVariant,
                ),
                tooltip: LocaleKeys.edit.tr(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                onPressed: () =>
                    context.router.push(StudentFormRoute(id: id)),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(24, 24),
                ),
                icon: Icon(
                  Icons.delete_outline,
                  size: 15,
                  color: colorScheme.error,
                ),
                tooltip: LocaleKeys.delete.tr(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
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
}
