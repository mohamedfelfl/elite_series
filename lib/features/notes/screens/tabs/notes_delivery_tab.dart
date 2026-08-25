import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../auth/cubits/auth_cubit.dart';
import '../../../auth/models/user.dart';
import '../../../groups/cubits/group_cubit.dart';
import '../../../students/cubits/student_cubit.dart';
import '../../cubits/notes_cubit.dart';
import '../../cubits/notes_state.dart';
import '../../models/note.dart';

class NotesDeliveryTab extends StatefulWidget {
  const NotesDeliveryTab({super.key});

  @override
  State<NotesDeliveryTab> createState() => _NotesDeliveryTabState();
}

class _NotesDeliveryTabState extends State<NotesDeliveryTab> {
  int? _selectedGroupId;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final NotesCubit _notesCubit;

  @override
  void initState() {
    super.initState();
    _notesCubit = context.read<NotesCubit>();

    // Sync initial state from StudentCubit
    final studentState = context.read<StudentCubit>().state;
    _selectedGroupId = studentState.selectedGroupId;
    _searchController.text = studentState.searchQuery;

    context.read<GroupCubit>().loadGroups();
    context.read<StudentCubit>().loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _notesCubit.clearPendingDeliveries();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    final canManageNodes = user?.can(UserPermission.manageNotes) ?? false;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Filter Section
          Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Note Selection
                BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, state) {
                    return DropdownButtonFormField<int>(
                      key: ValueKey('note_selection_${state.selectedNoteId}'),
                      initialValue: state.selectedNoteId,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.select_note.tr(),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.menu_book),
                      ),
                      items: state.notes.map((Note note) {
                        return DropdownMenuItem<int>(
                          value: note.id,
                          child: Text(
                            '${note.name} - ${note.price} ${LocaleKeys.currency_symbol.tr()}',
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        context.read<NotesCubit>().selectNoteForDelivery(val);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Group / Search Selection
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<GroupCubit, GroupState>(
                        builder: (context, groupState) {
                          return DropdownButtonFormField<int?>(
                            key: ValueKey('group_selection_$_selectedGroupId'),
                            initialValue: _selectedGroupId,
                            decoration: InputDecoration(
                              labelText: LocaleKeys.school_group.tr(),
                              border: const OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem<int?>(
                                value: null,
                                child: Text(LocaleKeys.all_students.tr()),
                              ),
                              ...groupState.groups.map((g) {
                                return DropdownMenuItem<int?>(
                                  value: g['id'] as int,
                                  child: Text(g['name'] as String),
                                );
                              }),
                            ],
                            onChanged: (val) {
                              setState(() => _selectedGroupId = val);
                              context.read<StudentCubit>().filterByGroup(val);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.search_hint.tr(),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<StudentCubit>().search('');
                                  },
                                )
                              : null,
                        ),
                        onChanged: (val) {
                          context.read<StudentCubit>().search(val);
                          setState(() {}); // Update suffix icon
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Students List
          Expanded(
            child: BlocListener<NotesCubit, NotesState>(
              listenWhen: (prev, curr) =>
                  prev.lastSaveTimestamp != curr.lastSaveTimestamp ||
                  (prev.error != curr.error && curr.error != null),
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (state.lastSaveTimestamp != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.delivery_success.tr()),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: BlocBuilder<NotesCubit, NotesState>(
                builder: (context, noteState) {
                  if (noteState.selectedNoteId == null) {
                    return Center(
                      child: Text(
                        'Please select a note first.',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  // Only show full-screen spinner on initial load (when currentDeliveries is empty)
                  if (noteState.isLoading &&
                      noteState.currentDeliveries.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return BlocBuilder<StudentCubit, StudentState>(
                    builder: (context, studentState) {
                      if (studentState.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final visibleStudentIds = studentState.students
                          .map((s) => s['id'] as int)
                          .toList();

                      // effective selection for visible students
                      final allPending =
                          visibleStudentIds.isNotEmpty &&
                          visibleStudentIds.every(
                            (id) =>
                                noteState.pendingDeliveries[id] ??
                                noteState.currentDeliveries[id] == true,
                          );

                      // Compute summary counts
                      final deliveredCount = visibleStudentIds.where((id) {
                        final eff = noteState.pendingDeliveries[id] ??
                            (noteState.currentDeliveries[id] == true);
                        return eff;
                      }).length;
                      final notDeliveredCount =
                          visibleStudentIds.length - deliveredCount;
                      final pendingCount = visibleStudentIds.where((id) {
                        final isCurrent =
                            noteState.currentDeliveries[id] == true;
                        return noteState.pendingDeliveries.containsKey(id) &&
                            noteState.pendingDeliveries[id] != isCurrent;
                      }).length;

                      return Column(
                        children: [
                          // ── Summary Header ──
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.25),
                              border: Border(
                                bottom: BorderSide(
                                  color: theme.dividerColor,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Delivered count chip
                                _SummaryChip(
                                  icon: Icons.check_circle,
                                  label: '$deliveredCount',
                                  color: Colors.green.shade600,
                                  bgColor:
                                      Colors.green.withValues(alpha: 0.1),
                                ),
                                const SizedBox(width: 8),
                                // Not delivered count chip
                                _SummaryChip(
                                  icon: Icons.cancel,
                                  label: '$notDeliveredCount',
                                  color: Colors.red.shade400,
                                  bgColor:
                                      Colors.red.withValues(alpha: 0.08),
                                ),
                                if (pendingCount > 0) ...[
                                  const SizedBox(width: 8),
                                  _SummaryChip(
                                    icon: Icons.pending_actions,
                                    label: '$pendingCount',
                                    color: Colors.orange.shade700,
                                    bgColor: Colors.orange
                                        .withValues(alpha: 0.1),
                                  ),
                                ],
                                const Spacer(),
                                // Select All / Deselect All button
                                FilledButton.tonalIcon(
                                  onPressed: canManageNodes &&
                                          visibleStudentIds.isNotEmpty
                                      ? () {
                                          context
                                              .read<NotesCubit>()
                                              .updateBatchDeliveryLocal(
                                                visibleStudentIds,
                                                !allPending,
                                              );
                                        }
                                      : null,
                                  icon: Icon(
                                    allPending
                                        ? Icons.deselect
                                        : Icons.select_all,
                                    size: 18,
                                  ),
                                  label: Text(
                                    allPending
                                        ? LocaleKeys.deselect_all.tr()
                                        : LocaleKeys.select_all.tr(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  style: FilledButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ── Student List ──
                          Expanded(
                            child: Scrollbar(
                              controller: _scrollController,
                              interactive: true,
                              thickness: 8,
                              radius: const Radius.circular(4),
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: studentState.students.length,
                                itemBuilder: (context, index) {
                                  final student =
                                      studentState.students[index];
                                  final studentId = student['id'] as int;

                                  final isDelivered = noteState
                                          .currentDeliveries[studentId] ==
                                      true;
                                  final effectiveDelivered =
                                      noteState.pendingDeliveries[
                                              studentId] ??
                                          isDelivered;

                                  final hasPendingChange = noteState
                                          .pendingDeliveries
                                          .containsKey(studentId) &&
                                      noteState
                                              .pendingDeliveries[studentId] !=
                                          isDelivered;

                                  // Colors for the left accent strip
                                  final Color stripColor;
                                  if (hasPendingChange) {
                                    stripColor = Colors.orange.shade600;
                                  } else if (isDelivered) {
                                    stripColor = Colors.green.shade500;
                                  } else {
                                    stripColor = Colors.transparent;
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: hasPendingChange
                                          ? Colors.orange
                                              .withValues(alpha: 0.04)
                                          : null,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: theme.dividerColor
                                              .withValues(alpha: 0.3),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          // Left accent strip
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            width: 4,
                                            decoration: BoxDecoration(
                                              color: stripColor,
                                              borderRadius:
                                                  const BorderRadiusDirectional
                                                      .only(
                                                topEnd: Radius.circular(2),
                                                bottomEnd:
                                                    Radius.circular(2),
                                              ),
                                            ),
                                          ),
                                          // Content
                                          Expanded(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: CheckboxListTile(
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                value: effectiveDelivered,
                                                onChanged: canManageNodes
                                                    ? (bool? val) {
                                                        if (val != null) {
                                                          context
                                                              .read<
                                                                NotesCubit
                                                              >()
                                                              .updateDeliveryStatusLocal(
                                                                studentId,
                                                                val,
                                                              );
                                                        }
                                                      }
                                                    : null,
                                                title: Text(
                                                  student['name'] as String,
                                                  style: theme
                                                      .textTheme.bodyLarge
                                                      ?.copyWith(
                                                    fontWeight:
                                                        hasPendingChange
                                                            ? FontWeight.w600
                                                            : FontWeight
                                                                .normal,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  student['group_name']
                                                          ?.toString() ??
                                                      LocaleKeys.no_group
                                                          .tr(),
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: theme.colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                ),
                                                secondary:
                                                    _buildStatusIndicator(
                                                  theme: theme,
                                                  isDelivered: isDelivered,
                                                  effectiveDelivered:
                                                      effectiveDelivered,
                                                  hasPendingChange:
                                                      hasPendingChange,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          if (canManageNodes &&
                              noteState.selectedNoteId != null)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: (noteState.isLoading ||
                                          noteState.pendingDeliveries.isEmpty)
                                      ? null
                                      : () => context
                                            .read<NotesCubit>()
                                            .saveDeliveries(),
                                  icon: noteState.isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.save),
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        LocaleKeys.save_all.tr().toUpperCase(),
                                      ),
                                      if (noteState.pendingDeliveries.isNotEmpty) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.onPrimary
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${noteState.pendingDeliveries.length} ${LocaleKeys.pending_changes.tr()}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a rich status indicator showing saved state + pending transition.
  Widget _buildStatusIndicator({
    required ThemeData theme,
    required bool isDelivered,
    required bool effectiveDelivered,
    required bool hasPendingChange,
  }) {
    if (hasPendingChange) {
      // Show: [old badge] → [new badge]
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DeliveryChip(delivered: isDelivered, dimmed: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.arrow_forward,
              size: 14,
              color: Colors.orange.shade700,
            ),
          ),
          _DeliveryChip(delivered: effectiveDelivered, dimmed: false),
        ],
      );
    }

    return _DeliveryChip(delivered: isDelivered, dimmed: false);
  }
}

/// A compact chip showing "Delivered" or "Not Delivered" status.
class _DeliveryChip extends StatelessWidget {
  final bool delivered;
  final bool dimmed;

  const _DeliveryChip({
    required this.delivered,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final double opacity = dimmed ? 0.45 : 1.0;

    final Color bgColor;
    final Color fgColor;
    final IconData icon;
    final String label;

    if (delivered) {
      bgColor = Colors.green.withValues(alpha: 0.12 * opacity);
      fgColor = Colors.green.shade700.withValues(alpha: opacity);
      icon = Icons.check_circle;
      label = LocaleKeys.delivered.tr();
    } else {
      bgColor = Colors.red.withValues(alpha: 0.08 * opacity);
      fgColor = Colors.red.shade400.withValues(alpha: opacity);
      icon = Icons.cancel_outlined;
      label = LocaleKeys.not_delivered.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: fgColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: fgColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact summary chip for the header bar showing count + icon.
class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
