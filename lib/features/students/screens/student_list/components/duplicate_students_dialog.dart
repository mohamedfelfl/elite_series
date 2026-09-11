import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:student_management_system/generated/locale_keys.g.dart';
import 'package:student_management_system/features/students/cubits/student_cubit.dart';
import 'package:student_management_system/features/students/services/student_merge_service.dart';
import 'student_merge_confirm_dialog.dart';

/// Dialog that scans and displays all detected duplicate student clusters
/// and provides a direct path to review and merge each cluster.
class DuplicateStudentsDialog extends StatefulWidget {
  const DuplicateStudentsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const DuplicateStudentsDialog(),
    );
  }

  @override
  State<DuplicateStudentsDialog> createState() =>
      _DuplicateStudentsDialogState();
}

class _DuplicateStudentsDialogState extends State<DuplicateStudentsDialog> {
  final TextEditingController _filterController = TextEditingController();
  List<DuplicateStudentGroup> _groups = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _filterQuery = '';

  @override
  void initState() {
    super.initState();
    _scanDuplicates();
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  Future<void> _scanDuplicates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cubit = context.read<StudentCubit>();
      final groups = await cubit.findDuplicates();
      if (mounted) {
        setState(() {
          _groups = groups;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<DuplicateStudentGroup> get _filteredGroups {
    if (_filterQuery.trim().isEmpty) return _groups;
    final q = StudentMergeService.normalizeName(_filterQuery);
    return _groups.where((g) {
      if (g.key.contains(q) || g.displayName.contains(_filterQuery)) {
        return true;
      }
      return g.students.any((s) =>
          s.serialNumber.contains(_filterQuery) ||
          s.phone1.contains(_filterQuery) ||
          s.phone2.contains(_filterQuery));
    }).toList();
  }

  Future<void> _openMergeForGroup(DuplicateStudentGroup group) async {
    final candidateIds = group.students.map((s) => s.id).toList();
    final merged = await StudentMergeConfirmDialog.show(
      context,
      candidateStudentIds: candidateIds,
    );

    if (merged == true && mounted) {
      _scanDuplicates();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filtered = _filteredGroups;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 860,
          maxHeight: 750,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.people_alt_outlined,
                      color: colorScheme.onPrimaryContainer,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.manage_duplicates.tr(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isLoading
                              ? LocaleKeys.loading.tr()
                              : LocaleKeys.duplicate_groups_count.tr(
                                  args: ['${_groups.length}'],
                                ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : _scanDuplicates,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: LocaleKeys.scan_duplicates.tr(),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: LocaleKeys.cancel.tr(),
                  ),
                ],
              ),
              const Divider(height: 20),

              // ── Search / Filter Bar ──
              if (!_isLoading && _groups.isNotEmpty) ...[
                TextField(
                  controller: _filterController,
                  onChanged: (val) => setState(() => _filterQuery = val),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.search_hint.tr(),
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _filterQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _filterController.clear();
                              setState(() => _filterQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // ── Body ──
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Scanning for duplicate student records...'),
                          ],
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  color: colorScheme.error,
                                  size: 36,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(color: colorScheme.error, fontSize: 13),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: _scanDuplicates,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : filtered.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_outlined,
                                      size: 48,
                                      color: Colors.green.shade600,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      LocaleKeys.no_duplicates_found.tr(),
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (ctx, idx) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (ctx, idx) {
                                  final group = filtered[idx];
                                  return _buildGroupCard(
                                    group: group,
                                    theme: theme,
                                    colorScheme: colorScheme,
                                  );
                                },
                              ),
              ),

              const Divider(height: 20),

              // ── Close ──
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(LocaleKeys.cancel.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard({
    required DuplicateStudentGroup group,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(120),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Group header
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        group.displayName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.amber.shade400),
                        ),
                        child: Text(
                          '${group.students.length} records',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openMergeForGroup(group),
                  icon: const Icon(Icons.merge_type_rounded, size: 16),
                  label: Text(
                    LocaleKeys.review_and_merge.tr(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Students in group
            ...group.students.map(
              (student) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withAlpha(80),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        student.serialNumber,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (student.groupName != null &&
                        student.groupName!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        student.groupName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (student.phone1.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        student.phone1,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(width: 10),
                    // Mini stat badges
                    _buildMiniBadge('${student.marksCount} 📝'),
                    const SizedBox(width: 4),
                    _buildMiniBadge('${student.attendanceCount} 📅'),
                    const SizedBox(width: 4),
                    _buildMiniBadge('${student.paymentsCount} 💳'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
