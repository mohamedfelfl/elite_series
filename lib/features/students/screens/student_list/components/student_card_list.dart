import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_management_system/app/router/app_router.gr.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';
import 'student_ui_helper.dart';

class StudentCardList extends StatefulWidget {
  final List<Map<String, Object?>> students;
  final Set<int> selectedIds;
  final ValueChanged<int> onToggleSelection;
  final ValueChanged<Map<String, Object?>> onDeleteStudent;
  final int rowsPerPage;

  const StudentCardList({
    super.key,
    required this.students,
    required this.selectedIds,
    required this.onToggleSelection,
    required this.onDeleteStudent,
    this.rowsPerPage = 10,
  });

  @override
  State<StudentCardList> createState() => _StudentCardListState();
}

class _StudentCardListState extends State<StudentCardList> {
  int _currentPage = 0;
  int? _copiedId;

  void _copyPhone(int studentId, String phone) {
    Clipboard.setData(ClipboardData(text: phone));
    setState(() => _copiedId = studentId);

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text('$phone ${LocaleKeys.delivery_success.tr()}', style: const TextStyle(fontSize: 12)),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _copiedId == studentId) {
        setState(() => _copiedId = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final totalStudents = widget.students.length;
    final totalPages = (totalStudents / widget.rowsPerPage).ceil();
    final safePage = _currentPage.clamp(0, totalPages > 0 ? totalPages - 1 : 0);

    final startIndex = safePage * widget.rowsPerPage;
    final endIndex = (startIndex + widget.rowsPerPage).clamp(0, totalStudents);
    final pageStudents = totalStudents > 0
        ? widget.students.sublist(startIndex, endIndex)
        : <Map<String, Object?>>[];

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: pageStudents.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final s = pageStudents[index];
              final int id = s['id'] as int;
              final bool isSelected = widget.selectedIds.contains(id);
              final String name = s['name']?.toString() ?? '';
              final String serial = s['serial_number']?.toString() ?? '';
              final String phone1 = s['phone1']?.toString() ?? '';
              final String grade = s['grade']?.toString() ?? '';
              final String groupName = s['group_name']?.toString() ?? '';
              final String school = s['school']?.toString() ?? '';
              final bool isFree = s['student_status']?.toString() == 'free';
              final bool isCopied = _copiedId == id;
              final avatarColor = StudentUIHelper.getAvatarColor(name, fallbackId: id);

              return Material(
                color: isDark
                    ? colorScheme.surfaceContainerLow
                    : colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.router.push(StudentDetailRoute(id: id)),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withValues(alpha: isDark ? 0.2 : 0.4),
                        width: isSelected ? 1.5 : 0.8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Header: Checkbox, Avatar, Name, Serial ──
                        Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (_) => widget.onToggleSelection(id),
                            ),
                            const SizedBox(width: 4),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: avatarColor.withValues(alpha: 0.2),
                              child: Text(
                                StudentUIHelper.getInitials(name),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: avatarColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (school.isNotEmpty)
                                    Text(
                                      school,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                serial,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // ── Tags: Grade, Group, Status ──
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                StudentUIHelper.getGradeLabel(grade),
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                groupName.isNotEmpty
                                    ? groupName
                                    : LocaleKeys.unassigned.tr(),
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            if (isFree)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.amber.withValues(alpha: 0.5),
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
                              ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // ── Footer: Phone + Actions ──
                        Row(
                          children: [
                            if (phone1.isNotEmpty)
                              Expanded(
                                child: InkWell(
                                  onTap: () => _copyPhone(id, phone1),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isCopied
                                              ? Icons.check_rounded
                                              : Icons.copy_rounded,
                                          size: 14,
                                          color: isCopied
                                              ? Colors.green
                                              : colorScheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            phone1,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurface,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.visibility_outlined,
                                    size: 16,
                                    color: colorScheme.primary,
                                  ),
                                  tooltip: LocaleKeys.view_all.tr(),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                  onPressed: () => context.router
                                      .push(StudentDetailRoute(id: id)),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    size: 16,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  tooltip: LocaleKeys.edit.tr(),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                  onPressed: () => context.router
                                      .push(StudentFormRoute(id: id)),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 16,
                                    color: colorScheme.error,
                                  ),
                                  tooltip: LocaleKeys.delete.tr(),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                  onPressed: () => widget.onDeleteStudent(s),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Mobile Pagination Bar ──
        if (totalPages > 1) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme.surfaceContainerLow
                  : colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, size: 20),
                  onPressed: safePage > 0
                      ? () => setState(() => _currentPage = safePage - 1)
                      : null,
                ),
                Text(
                  '${startIndex + 1}–$endIndex / $totalStudents',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, size: 20),
                  onPressed: safePage < totalPages - 1
                      ? () => setState(() => _currentPage = safePage + 1)
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}
