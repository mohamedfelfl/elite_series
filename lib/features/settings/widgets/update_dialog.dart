import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/update_cubit.dart';
import '../cubits/update_state.dart';
import '../models/app_update_info.dart';

/// Modal dialog providing detailed update notes, live download progress, and restart actions.
class UpdateDialog extends StatelessWidget {
  final AppUpdateInfo info;

  const UpdateDialog({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 12,
      backgroundColor: const Color(0xFF1E293B),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<UpdateCubit, UpdateState>(
          listener: (context, state) {
            if (state is UpdateUpToDate && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            final isDownloading = state is UpdateDownloading;
            final isReady = state is UpdateReadyToInstall;
            final isRestarting = state is UpdateRestarting;
            final progress = isDownloading ? state.progress : (isReady ? 1.0 : 0.0);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.system_update_alt_rounded,
                        color: Color(0xFF38BDF8),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isReady ? 'update_ready_title'.tr() : 'update_available'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${'current_version_label'.tr(args: [info.currentVersion])}  →  ${'latest_version_label'.tr(args: [info.targetVersion])}',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isDownloading && !isRestarting)
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, color: Colors.white54),
                        tooltip: 'dismiss'.tr(),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Release Notes Section
                if (info.releaseNotes != null && info.releaseNotes!.isNotEmpty) ...[
                  Text(
                    'release_notes'.tr(),
                    style: const TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 180),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        info.releaseNotes!,
                        style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Download Progress (when downloading or ready)
                if (isDownloading || isReady) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isReady ? 'update_ready_title'.tr() : 'downloading_update'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isReady ? const Color(0xFF10B981) : const Color(0xFF0284C7),
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Actions Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isDownloading && !isRestarting) ...[
                      TextButton(
                        onPressed: () {
                          if (isReady) {
                            context.read<UpdateCubit>().applyOnExit();
                            Navigator.of(context).pop();
                          } else {
                            context.read<UpdateCubit>().dismissUpdate();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          isReady ? 'apply_on_exit'.tr() : 'dismiss'.tr(),
                          style: const TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (isReady)
                      FilledButton.icon(
                        onPressed: isRestarting
                            ? null
                            : () => context.read<UpdateCubit>().restartAndApply(),
                        icon: const Icon(Icons.restart_alt_rounded, size: 18),
                        label: Text('restart_now'.tr()),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      )
                    else if (isDownloading || isRestarting)
                      FilledButton.icon(
                        onPressed: null,
                        icon: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                          ),
                        ),
                        label: Text(
                          isRestarting ? 'restart_now'.tr() : 'downloading_update'.tr(),
                        ),
                      )
                    else
                      FilledButton.icon(
                        onPressed: () => context.read<UpdateCubit>().downloadUpdate(),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: Text('download_and_update'.tr()),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
