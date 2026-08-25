import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/update_cubit.dart';
import '../../../cubits/update_state.dart';
import '../../../widgets/update_dialog.dart';

/// About & system information card with remote update actions.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<UpdateCubit, UpdateState>(
      listener: (context, state) {
        if (state is UpdateAvailable && state.isManual) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => BlocProvider.value(
              value: context.read<UpdateCubit>(),
              child: UpdateDialog(info: state.info),
            ),
          );
        } else if (state is UpdateUpToDate && state.isManual) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text('app_up_to_date'.tr()),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is UpdateError && state.isManual) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('update_error'.tr(args: [state.message])),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubitVersion = context.read<UpdateCubit>().currentVersion;
        final String currentVersion = (state is UpdateInitial)
            ? state.currentVersion
            : (state is UpdateUpToDate)
                ? state.currentVersion
                : (state is UpdateAvailable)
                    ? state.info.currentVersion
                    : cubitVersion;
        final bool isChecking = state is UpdateChecking;

        return _buildSettingsCard(context, [
          ListTile(
            leading: _buildLeading(context, Icons.apps),
            title: Text(
              LocaleKeys.app_version.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              currentVersion,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: _buildLeading(context, Icons.system_update_alt_rounded),
            title: Text(
              'check_for_updates'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              isChecking ? 'checking_for_updates'.tr() : 'update_settings_desc'.tr(),
              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
            ),
            trailing: isChecking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FilledButton.tonal(
                    onPressed: () => context.read<UpdateCubit>().checkForUpdates(isManual: true),
                    child: Text('check_for_updates'.tr()),
                  ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: _buildLeading(context, Icons.storage),
            title: Text(
              LocaleKeys.database_version.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              'v14',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: _buildLeading(context, Icons.person),
            title: Text(
              LocaleKeys.developer.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              LocaleKeys.developer_name.tr(),
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ]);
      },
    );
  }

  Widget _buildLeading(BuildContext context, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: colorScheme.primary, size: 20),
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
}
