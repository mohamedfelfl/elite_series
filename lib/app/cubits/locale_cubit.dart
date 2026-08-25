import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../features/settings/services/settings_service.dart';

part 'locale_cubit.freezed.dart';

@freezed
abstract class LocaleState with _$LocaleState {
  const factory LocaleState({
    @Default('ar') String languageCode,
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _LocaleState;
}

/// Manages app-wide locale (language) and theme mode.
class LocaleCubit extends Cubit<LocaleState> {
  final SettingsService _settingsService;

  LocaleCubit({required SettingsService settingsService})
    : _settingsService = settingsService,
      super(const LocaleState());

  Future<void> loadInitialSettings() async {
    final themeStr = await _settingsService.getOrDefault(
      SettingsKeys.themeMode,
      'system',
    );
    final lang = await _settingsService.getOrDefault(
      SettingsKeys.language,
      'ar',
    );

    Intl.defaultLocale = lang;

    ThemeMode mode;
    switch (themeStr) {
      case 'dark':
        mode = ThemeMode.dark;
        break;
      case 'light':
        mode = ThemeMode.light;
        break;
      default:
        mode = ThemeMode.system;
    }

    emit(state.copyWith(themeMode: mode, languageCode: lang));
  }

  Future<void> setLanguage(String languageCode) async {
    await _settingsService.set(SettingsKeys.language, languageCode);
    Intl.defaultLocale = languageCode;
    emit(state.copyWith(languageCode: languageCode));
  }

  Future<void> toggleLanguage() async {
    final newLang = state.languageCode == 'en' ? 'ar' : 'en';
    await setLanguage(newLang);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String modeStr;
    switch (mode) {
      case ThemeMode.dark:
        modeStr = 'dark';
        break;
      case ThemeMode.light:
        modeStr = 'light';
        break;
      case ThemeMode.system:
        modeStr = 'system';
        break;
    }
    await _settingsService.set(SettingsKeys.themeMode, modeStr);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> toggleThemeMode() async {
    final newMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
