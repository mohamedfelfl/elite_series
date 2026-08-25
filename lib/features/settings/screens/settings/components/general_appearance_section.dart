import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../app/cubits/locale_cubit.dart';
import '../../../../../app/shared/widgets/theme_mask/circular_reveal_theme_wrapper.dart';
import '../../../cubits/settings_cubit.dart';

/// General & Appearance settings section (theme + language).
class GeneralAppearanceSection extends StatelessWidget {
  const GeneralAppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;

    return _buildSettingsCard(context, [
      _buildThemeModeTile(context, state),
      const Divider(height: 1),
      _buildLanguageTile(context, state),
    ]);
  }

  Widget _buildThemeModeTile(BuildContext context, SettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final localeMode = context.watch<LocaleCubit>().state.themeMode.name;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.dark_mode, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        LocaleKeys.theme.tr(),
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        localeMode == 'dark'
            ? LocaleKeys.dark.tr()
            : localeMode == 'light'
            ? LocaleKeys.light.tr()
            : LocaleKeys.system.tr(),
      ),
      trailing: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'light', icon: Icon(Icons.light_mode, size: 18)),
          ButtonSegment(
            value: 'system',
            icon: Icon(Icons.settings_suggest, size: 18),
          ),
          ButtonSegment(value: 'dark', icon: Icon(Icons.dark_mode, size: 18)),
        ],
        selected: {localeMode},
        onSelectionChanged: (set) {
          final mode = set.first;
          context.read<SettingsCubit>().setThemeMode(mode);
          final themeMode = mode == 'dark'
              ? ThemeMode.dark
              : mode == 'light'
                  ? ThemeMode.light
                  : ThemeMode.system;
          ThemeMaskController.setThemeMode(context, themeMode);
        },
        showSelectedIcon: false,
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, SettingsState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.language, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        LocaleKeys.language.tr(),
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        state.language == 'ar'
            ? LocaleKeys.arabic.tr()
            : LocaleKeys.english.tr(),
      ),
      trailing: SegmentedButton<String>(
        segments: [
          ButtonSegment(
            value: 'ar',
            label: Text(LocaleKeys.arabic.tr()),
          ),
          ButtonSegment(
            value: 'en',
            label: Text(LocaleKeys.english.tr()),
          ),
        ],
        selected: {state.language},
        onSelectionChanged: (set) {
          final lang = set.first;
          context.read<SettingsCubit>().setLanguage(lang);
          context.read<LocaleCubit>().setLanguage(lang);
          context.setLocale(Locale(lang));
        },
        showSelectedIcon: false,
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
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
