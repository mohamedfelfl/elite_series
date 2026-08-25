import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import '../generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../features/settings/services/settings_service.dart';
import 'cubits/locale_cubit.dart';
import 'cubits/shell_navigation_cubit.dart';
import 'di/injection.dart';
import 'router/app_router.dart';
import 'router/app_router.gr.dart';
import 'services/database_service.dart';
import 'shared/widgets/theme_mask/circular_reveal_theme_wrapper.dart';
import 'theme/app_theme.dart';
import '../features/auth/cubits/auth_cubit.dart';
import '../features/admin/cubits/admin_cubit.dart';
import '../features/dashboard/cubits/dashboard_cubit.dart';
import '../features/students/cubits/student_cubit.dart';
import '../features/groups/cubits/group_cubit.dart';
import '../features/payments/cubits/payment_cubit.dart';
import '../features/attendance/cubits/attendance_cubit.dart';
import '../features/attendance/cubits/lesson_cubit.dart';
import '../features/exams/cubits/exam_cubit.dart';
import '../features/reports/cubits/report_cubit.dart';
import '../features/assistants/cubits/assistant_cubit.dart';
import '../features/assistants/cubits/assistant_attendance_cubit.dart';
import '../features/notes/cubits/notes_cubit.dart';
import '../features/qr_card_generator/presentation/cubits/qr_card_cubit.dart';
import '../features/qr_card_generator/data/repositories/qr_card_repository.dart';
import '../features/settings/cubits/settings_cubit.dart';
import '../features/settings/cubits/update_cubit.dart';
import '../features/settings/services/backup_service.dart';
import '../features/settings/services/device_binding_service.dart';

class StudentsManagementApp extends StatefulWidget {
  const StudentsManagementApp({super.key});

  @override
  State<StudentsManagementApp> createState() => _StudentsManagementAppState();
}

class _StudentsManagementAppState extends State<StudentsManagementApp>
    with WidgetsBindingObserver {
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _handleAutoBackupOnClose();
    }
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await _handleAutoBackupOnClose();
    return AppExitResponse.exit;
  }

  Future<void> _handleAutoBackupOnClose() async {
    try {
      final settingsService = getIt<SettingsService>();
      final isAutoBackupEnabled = await settingsService.getBool(
        SettingsKeys.autoBackupEnabled,
      );

      if (isAutoBackupEnabled) {
        final backupService = getIt<BackupService>();
        final maxBackups = await settingsService.getInt(
          SettingsKeys.maxBackups,
          defaultValue: 5,
        );

        // This is a fire-and-forget but since it's "detached",
        // we hope it completes or we might need to use a more robust way
        // for background tasks if available.
        await backupService.createBackup(customName: 'auto_backup');
        await backupService.pruneBackups(maxBackups);
      }
    } catch (e) {
      debugPrint('Auto-backup on close failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbService = getIt<DatabaseService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              LocaleCubit(settingsService: getIt<SettingsService>())
                ..loadInitialSettings(),
        ),
        BlocProvider(
          create: (_) => AuthCubit(
            databaseService: dbService,
          ),
        ),
        BlocProvider(create: (_) => AdminCubit(databaseService: dbService)),
        BlocProvider(create: (_) => DashboardCubit(databaseService: dbService)),
        BlocProvider(create: (_) => StudentCubit(databaseService: dbService)),
        BlocProvider(create: (_) => GroupCubit(databaseService: dbService)),
        BlocProvider(create: (_) => PaymentCubit(databaseService: dbService)),
        BlocProvider(
          create: (_) => AttendanceCubit(databaseService: dbService),
        ),
        BlocProvider(
          create: (_) => LessonCubit(databaseService: dbService),
        ),
        BlocProvider(create: (_) => ExamCubit(databaseService: dbService)),
        BlocProvider(create: (_) => ReportCubit(databaseService: dbService)),
        BlocProvider(create: (_) => AssistantCubit(databaseService: dbService)),
        BlocProvider(
          create: (_) => AssistantAttendanceCubit(databaseService: dbService),
        ),
        BlocProvider(create: (_) => NotesCubit(databaseService: dbService)),
        BlocProvider(
          create: (_) => QrCardCubit(
            repository: QrCardRepository(databaseService: dbService),
          )..loadInitialData(),
        ),
        BlocProvider(create: (_) => ShellNavigationCubit()),
        BlocProvider(
          create: (_) => SettingsCubit(
            settingsService: getIt<SettingsService>(),
            backupService: getIt<BackupService>(),
            deviceBindingService: getIt<DeviceBindingService>(),
          ),
        ),
        BlocProvider(
          create: (_) => getIt<UpdateCubit>()..initialize(),
        ),
      ],
      child: BlocConsumer<LocaleCubit, LocaleState>(
        listener: (context, localeState) {
          if (context.locale.languageCode != localeState.languageCode) {
            context.setLocale(Locale(localeState.languageCode));
          }
        },
        builder: (context, localeState) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  state.maybeWhen(
                    authenticated: (_) =>
                        _appRouter.replaceAll([const ShellRoute()]),
                    initial: () => _appRouter.replaceAll([const LoginRoute()]),
                    orElse: () {},
                  );
                },
                child: MaterialApp.router(
                  title: LocaleKeys.app_title.tr(),
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: localeState.themeMode,
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  routerConfig: _appRouter.config(),
                  builder: (context, routerChild) {
                    return CircularRevealThemeWrapper(
                      child: routerChild ?? const SizedBox.shrink(),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
