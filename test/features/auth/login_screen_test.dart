import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/app/cubits/locale_cubit.dart';
import 'package:student_management_system/app/shared/widgets/theme_mask/animated_theme_switch.dart';
import 'package:student_management_system/app/services/database_service.dart';
import 'package:student_management_system/features/settings/services/settings_service.dart';

class FakeSettingsService extends SettingsService {
  final Map<String, String> _storage = {};

  FakeSettingsService() : super(databaseService: _FakeDatabaseService());

  @override
  Future<String?> get(String key) async => _storage[key];

  @override
  Future<String> getOrDefault(String key, String defaultValue) async =>
      _storage[key] ?? defaultValue;

  @override
  Future<void> set(String key, String value) async {
    _storage[key] = value;
  }
}

class _FakeDatabaseService implements DatabaseService {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Login Screen Options Tests', () {
    testWidgets('LocaleCubit toggles language and theme cleanly',
        (tester) async {
      final fakeSettings = FakeSettingsService();
      final localeCubit = LocaleCubit(settingsService: fakeSettings);

      expect(localeCubit.state.languageCode, 'ar');
      await localeCubit.toggleLanguage();
      expect(localeCubit.state.languageCode, 'en');

      expect(localeCubit.state.themeMode, ThemeMode.system);
      await localeCubit.setThemeMode(ThemeMode.dark);
      expect(localeCubit.state.themeMode, ThemeMode.dark);

      await localeCubit.close();
    });

    testWidgets('Login top bar renders AnimatedThemeSwitch and Language button',
        (tester) async {
      final fakeSettings = FakeSettingsService();
      final localeCubit = LocaleCubit(settingsService: fakeSettings);

      await tester.pumpWidget(
        BlocProvider<LocaleCubit>.value(
          value: localeCubit,
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    top: 16,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<LocaleCubit, LocaleState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: () =>
                                  context.read<LocaleCubit>().toggleLanguage(),
                              child: Text(
                                state.languageCode == 'ar'
                                    ? 'English'
                                    : 'العربية',
                              ),
                            );
                          },
                        ),
                        BlocBuilder<LocaleCubit, LocaleState>(
                          builder: (context, state) {
                            return AnimatedThemeSwitch(
                              isDark: state.themeMode == ThemeMode.dark,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('English'), findsOneWidget);
      expect(find.byType(AnimatedThemeSwitch), findsOneWidget);

      // Tap language switch
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(find.text('العربية'), findsOneWidget);

      await localeCubit.close();
    });
  });
}
