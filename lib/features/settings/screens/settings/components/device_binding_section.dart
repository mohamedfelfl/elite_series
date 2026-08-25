import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../app/di/injection.dart';
import '../../../cubits/settings_cubit.dart';
import '../../../services/device_binding_service.dart';

/// Device binding status and controls section.
class DeviceBindingSection extends StatelessWidget {
  const DeviceBindingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final colorScheme = Theme.of(context).colorScheme;

    final statusColor = state.deviceBindingStatus == DeviceBindingStatus.bound
        ? Colors.green
        : state.deviceBindingStatus == DeviceBindingStatus.mismatch
        ? colorScheme.error
        : Colors.orange;

    final statusText = state.deviceBindingStatus == DeviceBindingStatus.bound
        ? '✅ ${LocaleKeys.device_bound.tr()}'
        : state.deviceBindingStatus == DeviceBindingStatus.mismatch
        ? '❌ ${LocaleKeys.device_mismatch.tr()}'
        : '⚠️ ${LocaleKeys.device_not_bound.tr()}';

    return _buildSettingsCard(context, [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, LocaleKeys.device.tr(), state.deviceName),
            const SizedBox(height: 8),
            _buildInfoRow(context, LocaleKeys.os.tr(), state.osInfo),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              LocaleKeys.device_id.tr(),
              state.deviceFingerprint.length > 16
                  ? '${state.deviceFingerprint.substring(0, 16)}...'
                  : state.deviceFingerprint,
              copyText: state.deviceFingerprint,
            ),
            const SizedBox(height: 16),
            if (state.deviceBindingStatus == DeviceBindingStatus.unbound)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _bindDevice(context, state),
                  icon: const Icon(Icons.lock),
                  label: Text(LocaleKeys.bind_device.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ),
            if (state.deviceBindingStatus == DeviceBindingStatus.bound)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showTransferDialog(context, state),
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(LocaleKeys.transfer_device.tr()),
                ),
              ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    String? copyText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          ),
        ),
        if (copyText != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: copyText));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(LocaleKeys.copied_to_clipboard.tr()),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: const Icon(Icons.copy, size: 16),
            tooltip: LocaleKeys.copy.tr(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: colorScheme.primary,
          ),
        ],
      ],
    );
  }

  Future<void> _bindDevice(BuildContext context, SettingsState state) async {
    final deviceBindingService = getIt<DeviceBindingService>();
    final fingerprint = await deviceBindingService.generateFingerprint();
    await deviceBindingService.bindDevice(fingerprint);

    final licenseKey = deviceBindingService.generateLicenseKey(fingerprint);
    await deviceBindingService.storeLicenseKey(licenseKey);

    if (context.mounted) {
      context.read<SettingsCubit>().loadSettings();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.device_binding_success.tr()),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _showTransferDialog(
    BuildContext context,
    SettingsState state,
  ) async {
    final codeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.transfer_device.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocaleKeys.transfer_desc.tr()),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: LocaleKeys.transfer_code.tr(),
                hintText: LocaleKeys.transfer_code_hint.tr(),
              ),
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              final deviceBindingService = getIt<DeviceBindingService>();
              debugPrint('Device Fingerprint: ${state.deviceFingerprint}');
              final isValid = deviceBindingService.validateTransferCode(
                codeController.text,
                state.deviceFingerprint,
              );

              if (isValid) {
                await deviceBindingService.unbindDevice();
                if (dialogContext.mounted) Navigator.pop(dialogContext);
                if (context.mounted) {
                  context.read<SettingsCubit>().loadSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.device_unbound_success.tr()),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.invalid_transfer_code.tr()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(LocaleKeys.transfer.tr()),
          ),
        ],
      ),
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
