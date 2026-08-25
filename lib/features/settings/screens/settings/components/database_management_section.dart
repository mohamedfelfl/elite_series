import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/settings_cubit.dart';

/// Database management section: info, stats, backup, export, and danger zone.
class DatabaseManagementSection extends StatelessWidget {
  const DatabaseManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDatabaseInfoCard(context, state),
        const SizedBox(height: 12),
        _buildBackupCard(context, state),
        const SizedBox(height: 12),
        _buildExportCard(context, state),
        const SizedBox(height: 12),
        _buildDangerZoneCard(context, state),
      ],
    );
  }

  // ─── DATABASE INFO CARD ───
  Widget _buildDatabaseInfoCard(BuildContext context, SettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final sizeStr = _formatBytes(state.databaseSize);

    return _buildSettingsCard(context, [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.database_status.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🔒 ${LocaleKeys.encrypted.tr()}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _buildStatChip(
                  context,
                  LocaleKeys.size.tr(),
                  sizeStr,
                  Icons.sd_storage,
                ),
                _buildStatChip(
                  context,
                  LocaleKeys.students_stat.tr(),
                  '${state.recordCounts['students'] ?? 0}',
                  Icons.people,
                ),
                _buildStatChip(
                  context,
                  LocaleKeys.groups_stat.tr(),
                  '${state.recordCounts['groups'] ?? 0}',
                  Icons.groups,
                ),
                _buildStatChip(
                  context,
                  LocaleKeys.payments_stat.tr(),
                  '${state.recordCounts['payments'] ?? 0}',
                  Icons.payment,
                ),
                _buildStatChip(
                  context,
                  LocaleKeys.attendance_stat.tr(),
                  '${state.recordCounts['attendance'] ?? 0}',
                  Icons.fact_check,
                ),
                _buildStatChip(
                  context,
                  LocaleKeys.exams_stat.tr(),
                  '${state.recordCounts['exams'] ?? 0}',
                  Icons.quiz,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.read<SettingsCubit>().optimizeDatabase(),
                    icon: const Icon(Icons.auto_fix_high, size: 18),
                    label: Text(LocaleKeys.optimize.tr()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.read<SettingsCubit>().checkIntegrity(),
                    icon: const Icon(Icons.health_and_safety, size: 18),
                    label: Text(LocaleKeys.integrity_check.tr()),
                  ),
                ),
              ],
            ),
            if (state.integrityStatus.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: state.integrityStatus == 'ok'
                      ? Colors.green.withValues(alpha: 0.1)
                      : colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  LocaleKeys.integrity.tr(args: [state.integrityStatus]),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: state.integrityStatus == 'ok'
                        ? Colors.green
                        : colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ]);
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ─── BACKUP CARD ───
  Widget _buildBackupCard(BuildContext context, SettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return _buildSettingsCard(context, [
      SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.backup, color: colorScheme.primary, size: 20),
        ),
        title: Text(
          LocaleKeys.auto_backup.tr(),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(LocaleKeys.auto_backup_desc.tr()),
        value: state.autoBackupEnabled,
        onChanged: (v) => context.read<SettingsCubit>().setAutoBackup(v),
      ),
      const Divider(height: 1),
      ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.inventory, color: colorScheme.primary, size: 20),
        ),
        title: Text(
          LocaleKeys.max_backups.tr(),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          LocaleKeys.max_backups_desc.tr(args: [state.maxBackups.toString()]),
        ),
        trailing: DropdownButton<int>(
          value: state.maxBackups,
          underline: const SizedBox.shrink(),
          items: [
            DropdownMenuItem(value: 3, child: Text('3')),
            DropdownMenuItem(value: 5, child: Text('5')),
            DropdownMenuItem(value: 10, child: Text('10')),
            DropdownMenuItem(value: 20, child: Text('20')),
          ],
          onChanged: (v) {
            if (v != null) context.read<SettingsCubit>().setMaxBackups(v);
          },
        ),
      ),
      const Divider(height: 1),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: state.isSaving
                        ? null
                        : () => context.read<SettingsCubit>().createBackup(),
                    icon: state.isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save, size: 18),
                    label: Text(LocaleKeys.create_backup_now.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: state.isSaving
                        ? null
                        : () => _confirmAction(
                            context,
                            title: LocaleKeys.import_backup.tr(),
                            message: LocaleKeys.confirm_restore_from_file.tr(),
                            onConfirm: () => context
                                .read<SettingsCubit>()
                                .importBackupFromFile(),
                          ),
                    icon: const Icon(Icons.file_upload, size: 18),
                    label: Text(LocaleKeys.import_backup.tr()),
                  ),
                ),
              ],
            ),
            if (state.backups.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '${LocaleKeys.recent_backups.tr()} (${state.backups.length})',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...state.backups
                  .take(5)
                  .map(
                    (backup) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_present,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              backup.name,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            backup.formattedSize,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _confirmAction(
                              context,
                              title: LocaleKeys.restore_backup.tr(),
                              message: LocaleKeys.restore_backup_msg.tr(
                                args: [backup.name],
                              ),
                              onConfirm: () => context
                                  .read<SettingsCubit>()
                                  .restoreBackup(backup.path),
                            ),
                            child: Icon(
                              Icons.restore,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => _confirmAction(
                              context,
                              title: LocaleKeys.delete_backup.tr(),
                              message: LocaleKeys.delete_backup_confirm.tr(
                                args: [backup.name],
                              ),
                              onConfirm: () => context
                                  .read<SettingsCubit>()
                                  .deleteBackup(backup.path),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    ]);
  }

  // ─── EXPORT CARD ───
  Widget _buildExportCard(BuildContext context, SettingsState state) {
    return _buildSettingsCard(context, [
      _buildActionTile(
        context,
        icon: Icons.people,
        title: LocaleKeys.export_students.tr(),
        subtitle: LocaleKeys.export_students_desc.tr(),
        onTap: () => context.read<SettingsCubit>().exportCsv('students'),
      ),
      const Divider(height: 1),
      _buildActionTile(
        context,
        icon: Icons.payment,
        title: LocaleKeys.export_payments.tr(),
        subtitle: LocaleKeys.export_payments_desc.tr(),
        onTap: () => context.read<SettingsCubit>().exportCsv('payments'),
      ),
      const Divider(height: 1),
      _buildActionTile(
        context,
        icon: Icons.fact_check,
        title: LocaleKeys.export_attendance.tr(),
        subtitle: LocaleKeys.export_attendance_desc.tr(),
        onTap: () => context.read<SettingsCubit>().exportCsv('attendance'),
      ),
      const Divider(height: 1),
      _buildActionTile(
        context,
        icon: Icons.quiz,
        title: LocaleKeys.export_marks.tr(),
        subtitle: LocaleKeys.export_marks_desc.tr(),
        onTap: () => context.read<SettingsCubit>().exportCsv('marks'),
      ),
    ]);
  }

  // ─── DANGER ZONE CARD ───
  Widget _buildDangerZoneCard(BuildContext context, SettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: colorScheme.error, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.danger_zone.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            _buildActionTile(
              context,
              icon: Icons.delete_sweep,
              title: LocaleKeys.purge_old_data.tr(),
              subtitle: LocaleKeys.purge_old_data_desc.tr(),
              iconColor: Colors.orange,
              onTap: () => _showPurgeDialog(context),
            ),
            const Divider(height: 1),
            _buildActionTile(
              context,
              icon: Icons.delete_forever,
              title: LocaleKeys.reset_all_data.tr(),
              subtitle: LocaleKeys.reset_all_data_desc.tr(),
              iconColor: colorScheme.error,
              onTap: () => _showResetConfirmDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SHARED HELPERS ───

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: iconColor),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(children: children),
      ),
    );
  }

  void _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onConfirm();
            },
            child: Text(LocaleKeys.yes.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _showPurgeDialog(BuildContext context) async {
    int years = 2;
    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(LocaleKeys.purge_old_data.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LocaleKeys.purge_old_data_msg.tr()),
              const SizedBox(height: 16),
              DropdownButton<int>(
                value: years,
                items: [
                  DropdownMenuItem(
                    value: 1,
                    child: Text('1 ${LocaleKeys.year.tr()}'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('2 ${LocaleKeys.years.tr()}'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('3 ${LocaleKeys.years.tr()}'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('5 ${LocaleKeys.years.tr()}'),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => years = v);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                if (context.mounted) {
                  context.read<SettingsCubit>().purgeOldData(years);
                }
              },
              child: Text(LocaleKeys.purge.tr()),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context) {
    context.read<SettingsCubit>().resetAllData();
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
