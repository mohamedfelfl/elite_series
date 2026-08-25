import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/router/app_router.gr.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/group_cubit.dart';

/// Section showing linked students with add/remove capabilities.
class StudentLinkingSection extends StatelessWidget {
  final bool isEditing;
  final int? groupId;
  final String? selectedGrade;
  final List<int> selectedStudentIds;
  final List<Map<String, dynamic>> selectedStudentsData;
  final VoidCallback onChanged;

  const StudentLinkingSection({
    super.key,
    required this.isEditing,
    this.groupId,
    this.selectedGrade,
    required this.selectedStudentIds,
    required this.selectedStudentsData,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        final List<Map<String, dynamic>> students =
            isEditing ? state.groupStudents : selectedStudentsData;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: colorScheme.primary, size: 28),
                SizedBox(width: 8.w),
                Text(
                  LocaleKeys.linked_students.tr(
                    args: [students.length.toString()],
                  ),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _showAddStudentDialog(context, colorScheme),
                  icon: const Icon(Icons.person_add, size: 20),
                  label: Text(LocaleKeys.add_students_to_group.tr()),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            if (students.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32.r),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.group_off,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      LocaleKeys.no_students_in_group.tr(),
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: students.map((s) {
                  return InputChip(
                    avatar: CircleAvatar(
                      backgroundColor: colorScheme.primary,
                      child: Text(
                        (s['name']?.toString() ?? '?')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    label: Text(
                      s['name']?.toString() ?? '',
                      style: textTheme.bodyLarge,
                    ),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    deleteButtonTooltipMessage:
                        LocaleKeys.remove_from_group.tr(),
                    onDeleted: () {
                      if (isEditing) {
                        context.read<GroupCubit>().unlinkStudentFromGroup(
                          s['id'] as int,
                          groupId!,
                          grade: selectedGrade,
                        );
                      } else {
                        selectedStudentIds.remove(s['id'] as int);
                        selectedStudentsData.removeWhere(
                          (item) => item['id'] == s['id'],
                        );
                        onChanged();
                      }
                    },
                    onPressed: () {
                      context.router.push(
                        StudentDetailRoute(id: s['id'] as int),
                      );
                    },
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }

  void _showAddStudentDialog(BuildContext context, ColorScheme colorScheme) {
    if (selectedGrade == null || selectedGrade!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.please_select_stage_first.tr()),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<GroupCubit>().loadAvailableStudents(grade: selectedGrade);

    showDialog(
      context: context,
      builder: (dialogContext) {
        final searchController = TextEditingController();

        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            return AlertDialog(
              title: Text(LocaleKeys.add_students_to_group.tr()),
              content: SizedBox(
                width: 500,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.search_students.tr(),
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        context.read<GroupCubit>().loadAvailableStudents(
                          search: query,
                          grade: selectedGrade,
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: BlocBuilder<GroupCubit, GroupState>(
                        bloc: context.read<GroupCubit>(),
                        builder: (blocContext, state) {
                          final available = state.availableStudents.where((s) {
                            final id = s['id'] as int;
                            if (isEditing) {
                              // If editing, exclude students already in this group 
                              // (safeguard for immediate UI update before DB reload completes)
                              return !state.groupStudents.any((gs) => gs['id'] == id);
                            } else {
                              // If creating, exclude students in the local selection
                              return !selectedStudentIds.contains(id);
                            }
                          }).toList();

                          if (available.isEmpty) {
                            return Center(
                              child: Text(
                                LocaleKeys.no_students_found.tr(),
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: available.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final s = available[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      colorScheme.primaryContainer,
                                  child: Text(
                                    (s['name']?.toString() ?? '?')[0]
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  s['name']?.toString() ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  s['serial_number']?.toString() ?? '',
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    if (isEditing) {
                                      context
                                          .read<GroupCubit>()
                                          .linkStudentToGroup(
                                            s['id'] as int,
                                            groupId!,
                                            grade: selectedGrade,
                                          );
                                    } else {
                                      if (!selectedStudentIds.contains(
                                        s['id'] as int,
                                      )) {
                                        selectedStudentIds.add(
                                          s['id'] as int,
                                        );
                                        selectedStudentsData.add(s);
                                        onChanged();
                                        setDialogState(() {});
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(LocaleKeys.cancel.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
