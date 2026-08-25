import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/update_cubit.dart';
import '../cubits/update_state.dart';
import 'update_dialog.dart';

/// Non-intrusive notification banner displayed when an update is available or ready.
class UpdateNotificationBanner extends StatelessWidget {
  const UpdateNotificationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateCubit, UpdateState>(
      builder: (context, state) {
        if (state is UpdateAvailable) {
          return _buildBanner(
            context: context,
            backgroundColor: const Color(0xFF1E293B),
            borderColor: const Color(0xFF38BDF8),
            icon: Icons.system_update_rounded,
            iconColor: const Color(0xFF38BDF8),
            title: 'update_available'.tr(),
            subtitle: 'update_available_msg'.tr(args: [state.info.targetVersion]),
            actions: [
              TextButton(
                onPressed: () => context.read<UpdateCubit>().dismissUpdate(),
                child: Text(
                  'dismiss'.tr(),
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => BlocProvider.value(
                      value: context.read<UpdateCubit>(),
                      child: UpdateDialog(info: state.info),
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text('download_and_update'.tr()),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        } else if (state is UpdateDownloading) {
          final pct = (state.progress * 100).toInt();
          return _buildBanner(
            context: context,
            backgroundColor: const Color(0xFF0F172A),
            borderColor: const Color(0xFF6366F1),
            icon: Icons.downloading_rounded,
            iconColor: const Color(0xFF818CF8),
            title: 'downloading_update'.tr(),
            subtitle: '$pct% completed',
            trailingWidget: SizedBox(
              width: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF818CF8)),
                  minHeight: 8,
                ),
              ),
            ),
          );
        } else if (state is UpdateReadyToInstall) {
          return _buildBanner(
            context: context,
            backgroundColor: const Color(0xFF064E3B),
            borderColor: const Color(0xFF34D399),
            icon: Icons.check_circle_outline_rounded,
            iconColor: const Color(0xFF34D399),
            title: 'update_ready_title'.tr(),
            subtitle: 'update_ready_msg'.tr(),
            actions: [
              TextButton(
                onPressed: () => context.read<UpdateCubit>().applyOnExit(),
                child: Text(
                  'apply_on_exit'.tr(),
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => context.read<UpdateCubit>().restartAndApply(),
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: Text('restart_now'.tr()),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBanner({
    required BuildContext context,
    required Color backgroundColor,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    List<Widget>? actions,
    Widget? trailingWidget,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(color: borderColor.withAlpha(128), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(40),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ?trailingWidget,
          ...?actions,
        ],
      ),
    );
  }
}
