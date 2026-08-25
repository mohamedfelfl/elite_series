import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../auth/cubits/auth_cubit.dart';
import '../../auth/models/user.dart';
import '../cubits/settings_cubit.dart';
import 'settings/components/about_section.dart';
import 'settings/components/database_management_section.dart';
import 'settings/components/device_binding_section.dart';
import 'settings/components/general_appearance_section.dart';
import 'settings/components/security_section.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<SettingsCubit>().clearMessage();
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<SettingsCubit>().clearMessage();
        }
      },
      builder: (context, state) {
        final authState = context.watch<AuthCubit>().state;
        final isAdmin = authState.maybeWhen(
          authenticated: (user) => user.role == UserRole.admin,
          orElse: () => false,
        );
        final currentUser = authState.maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

        return Scaffold(
          appBar: context.router.canPop()
              ? AppBar(
                  title: Text(LocaleKeys.settings.tr()),
                  centerTitle: true,
                )
              : null,
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: [

                    // ── GENERAL & APPEARANCE ──
                    _buildSectionHeader(
                      context,
                      icon: Icons.palette_outlined,
                      title: LocaleKeys.general_appearance.tr(),
                      subtitle: LocaleKeys.theme_lang_desc.tr(),
                    ),
                    const SizedBox(height: 12),
                    const GeneralAppearanceSection(),

                    // Admin-only sections
                    if (isAdmin) ...[
                      const SizedBox(height: 32),

                      // ── SECURITY ──
                      _buildSectionHeader(
                        context,
                        icon: Icons.shield_outlined,
                        title: LocaleKeys.security.tr(),
                        subtitle: LocaleKeys.security_desc.tr(),
                      ),
                      const SizedBox(height: 12),
                      SecuritySection(currentUser: currentUser),

                      const SizedBox(height: 32),

                      // ── DEVICE BINDING ──
                      _buildSectionHeader(
                        context,
                        icon: Icons.devices,
                        title: LocaleKeys.device_binding.tr(),
                        subtitle: LocaleKeys.device_binding_desc.tr(),
                      ),
                      const SizedBox(height: 12),
                      const DeviceBindingSection(),

                      const SizedBox(height: 32),

                      // ── DATABASE MANAGEMENT ──
                      _buildSectionHeader(
                        context,
                        icon: Icons.storage,
                        title: LocaleKeys.database_management.tr(),
                        subtitle: LocaleKeys.database_management_desc.tr(),
                      ),
                      const SizedBox(height: 12),
                      const DatabaseManagementSection(),
                    ],

                    const SizedBox(height: 32),

                    // ── ABOUT ──
                    _buildSectionHeader(
                      context,
                      icon: Icons.info_outline,
                      title: LocaleKeys.about_system_info.tr(),
                      subtitle: LocaleKeys.about_system_info_desc.tr(),
                    ),
                    const SizedBox(height: 12),
                    const AboutSection(),

                    const SizedBox(height: 48),
                  ],
                ),
        );
      },
    );
  }
  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
