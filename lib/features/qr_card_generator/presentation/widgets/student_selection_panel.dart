import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/constants/dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/student_card_data.dart';

class StudentSelectionPanel extends StatelessWidget {
  final List<StudentCardData> students;
  final Set<int> selectedStudentIds;
  final StudentCardData? activePreviewStudent;
  final ValueChanged<StudentCardData> onStudentSelectedForPreview;
  final ValueChanged<int> onToggleSelection;
  final ValueChanged<bool?> onToggleSelectAll;
  final VoidCallback onBatchExport;

  const StudentSelectionPanel({
    super.key,
    required this.students,
    required this.selectedStudentIds,
    required this.activePreviewStudent,
    required this.onStudentSelectedForPreview,
    required this.onToggleSelection,
    required this.onToggleSelectAll,
    required this.onBatchExport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isAllSelected =
        students.isNotEmpty && selectedStudentIds.length == students.length;

    return Container(
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
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.p16,
              vertical: AppDimens.p12,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppDimens.p8,
              runSpacing: AppDimens.p8,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isAllSelected,
                        onChanged: onToggleSelectAll,
                      ),
                      Text(
                        LocaleKeys.select_all_count.tr(
                          args: [students.length.toString()],
                        ),
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedStudentIds.isNotEmpty) ...[
                        SizedBox(width: AppDimens.w8),
                        Chip(
                          label: Text(
                            LocaleKeys.selected_count.tr(
                              args: [selectedStudentIds.length.toString()],
                            ),
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          backgroundColor: colorScheme.primaryContainer,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: selectedStudentIds.isEmpty ? null : onBatchExport,
                  icon: Icon(
                    Icons.drive_folder_upload_rounded,
                    size: AppDimens.iconSize18,
                    color: Colors.white,
                  ),
                  label: Text(
                    LocaleKeys.export_selected_png.tr(),
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.r10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Text(
                      LocaleKeys.no_students_available_filter.tr(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.p8),
                    itemCount: students.length,
                    separatorBuilder: (ctx, idx) => Divider(
                      height: 1,
                      indent: AppDimens.p16,
                      endIndent: AppDimens.p16,
                    ),
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final isSelected = selectedStudentIds.contains(
                        student.id,
                      );
                      final isPreviewed =
                          activePreviewStudent?.id == student.id;

                      final groupText = student.groupName.isNotEmpty
                          ? ' • ${student.groupName}'
                          : '';
                      final dateText = student.createdAt != null
                          ? ' • ${DateFormat('yyyy-MM-dd').format(student.createdAt!)}'
                          : '';

                      return Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(AppDimens.r8),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          selected: isPreviewed,
                          selectedTileColor: colorScheme.primaryContainer
                              .withValues(alpha: AppDimens.opacitySoft),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimens.r8),
                          ),
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (_) => onToggleSelection(student.id),
                          ),
                          title: Text(
                            student.fullName,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: isPreviewed
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${student.studentCode} • ${student.stageName}$groupText$dateText',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: isPreviewed
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () =>
                                onStudentSelectedForPreview(student),
                            tooltip:
                                LocaleKeys.preview_student_card_tooltip.tr(),
                          ),
                          onTap: () => onStudentSelectedForPreview(student),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
