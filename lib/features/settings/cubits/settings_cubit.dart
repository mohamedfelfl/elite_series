import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/di/injection.dart';
import '../../../app/services/data_migration_service.dart';
import '../services/settings_service.dart';
import '../services/backup_service.dart';
import '../services/device_binding_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import '../../../generated/locale_keys.g.dart';

part 'settings_cubit.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    // General
    @Default('system') String themeMode,
    @Default('ar') String language,

    // Security

    // Backup
    @Default(false) bool autoBackupEnabled,
    @Default('weekly') String autoBackupSchedule,
    @Default(5) int maxBackups,

    // Device Binding
    @Default(DeviceBindingStatus.unbound)
    DeviceBindingStatus deviceBindingStatus,
    @Default('') String deviceName,
    @Default('') String deviceFingerprint,
    @Default('') String osInfo,

    // Database Info
    @Default(0) int databaseSize,
    @Default({}) Map<String, int> recordCounts,
    @Default('') String integrityStatus,

    // Backup Info
    @Default([]) List<BackupInfo> backups,

    // UI State
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? successMessage,
    String? errorMessage,
  }) = _SettingsState;
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService _settingsService;
  final BackupService _backupService;
  final DeviceBindingService _deviceBindingService;

  SettingsCubit({
    required SettingsService settingsService,
    required BackupService backupService,
    required DeviceBindingService deviceBindingService,
  }) : _settingsService = settingsService,
       _backupService = backupService,
       _deviceBindingService = deviceBindingService,
       super(const SettingsState());

  /// Load all settings from the database.
  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final themeMode = await _settingsService.getOrDefault(
        SettingsKeys.themeMode,
        'system',
      );
      final language = await _settingsService.getOrDefault(
        SettingsKeys.language,
        'ar',
      );

      final autoBackupEnabled = await _settingsService.getBool(
        SettingsKeys.autoBackupEnabled,
      );
      final autoBackupSchedule = await _settingsService.getOrDefault(
        SettingsKeys.autoBackupSchedule,
        'weekly',
      );
      final maxBackups = await _settingsService.getInt(
        SettingsKeys.maxBackups,
        defaultValue: 5,
      );

      // Device info
      final deviceBindingStatus = await _deviceBindingService.verifyBinding();
      final deviceName = _deviceBindingService.getDeviceName();
      final osInfo = _deviceBindingService.getOsInfo();
      final fingerprint = await _deviceBindingService.generateFingerprint();

      // Database info
      final dbSize = await _backupService.getDatabaseSize();
      final recordCounts = await _backupService.getRecordCounts();

      // Backups
      final backups = await _backupService.listBackups();

      emit(
        state.copyWith(
          isLoading: false,
          themeMode: themeMode,
          language: language,

          autoBackupEnabled: autoBackupEnabled,
          autoBackupSchedule: autoBackupSchedule,
          maxBackups: maxBackups,
          deviceBindingStatus: deviceBindingStatus,
          deviceName: deviceName,
          deviceFingerprint: fingerprint,
          osInfo: osInfo,
          databaseSize: dbSize,
          recordCounts: recordCounts,
          backups: backups,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ─── GENERAL SETTINGS ───

  Future<void> setThemeMode(String mode) async {
    await _settingsService.set(SettingsKeys.themeMode, mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLanguage(String lang) async {
    await _settingsService.set(SettingsKeys.language, lang);
    emit(state.copyWith(language: lang));
  }

  // ─── SECURITY SETTINGS ───

  // ─── BACKUP SETTINGS ───

  Future<void> setAutoBackup(bool enabled) async {
    await _settingsService.setBool(SettingsKeys.autoBackupEnabled, enabled);
    if (enabled) {
      await _settingsService.set(SettingsKeys.autoBackupSchedule, 'on_close');
    }
    emit(
      state.copyWith(
        autoBackupEnabled: enabled,
        autoBackupSchedule: enabled ? 'on_close' : state.autoBackupSchedule,
      ),
    );
  }

  Future<void> setMaxBackups(int max) async {
    await _settingsService.setInt(SettingsKeys.maxBackups, max);
    emit(state.copyWith(maxBackups: max));
  }

  // ─── BACKUP ACTIONS ───

  Future<void> createBackup() async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      final path = await _backupService.createBackup();

      // Prune old backups
      await _backupService.pruneBackups(state.maxBackups);

      // Refresh backup list
      final backups = await _backupService.listBackups();
      final dbSize = await _backupService.getDatabaseSize();

      emit(
        state.copyWith(
          isSaving: false,
          backups: backups,
          databaseSize: dbSize,
          successMessage: LocaleKeys.backup_created.tr(args: [path]),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: LocaleKeys.backup_failed.tr(args: [e.toString()]),
        ),
      );
    }
  }

  Future<void> restoreBackup(String path) async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      await _backupService.restoreFromBackup(path);

      emit(
        state.copyWith(
          isSaving: false,
          successMessage: LocaleKeys.restore_success.tr(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: LocaleKeys.restore_failed.tr(args: [e.toString()]),
        ),
      );
    }
  }

  Future<void> importBackupFromFile() async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        await _backupService.restoreFromBackup(path);

        emit(
          state.copyWith(
            isSaving: false,
            successMessage: LocaleKeys.restore_success.tr(),
          ),
        );
      } else {
        emit(state.copyWith(isSaving: false));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: LocaleKeys.restore_failed.tr(args: [e.toString()]),
        ),
      );
    }
  }

  Future<void> deleteBackup(String path) async {
    await _backupService.deleteBackup(path);
    final backups = await _backupService.listBackups();
    emit(state.copyWith(backups: backups));
  }

  // ─── DATABASE ACTIONS ───

  Future<void> optimizeDatabase() async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      await _backupService.optimizeDatabase();
      final dbSize = await _backupService.getDatabaseSize();
      emit(
        state.copyWith(
          isSaving: false,
          databaseSize: dbSize,
          successMessage: LocaleKeys.optimize_success.tr(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: LocaleKeys.optimize_failed.tr(args: [e.toString()]),
        ),
      );
    }
  }

  Future<void> checkIntegrity() async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      final result = await _backupService.checkIntegrity();
      emit(
        state.copyWith(
          isSaving: false,
          integrityStatus: result,
          successMessage: LocaleKeys.integrity_check_result.tr(args: [result]),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: LocaleKeys.integrity_check_failed.tr(
            args: [e.toString()],
          ),
        ),
      );
    }
  }

  Future<void> exportCsv(String type) async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      String csv;
      switch (type) {
        case 'students':
          csv = await _backupService.exportStudentsCsv();
          break;
        case 'payments':
          csv = await _backupService.exportPaymentsCsv();
          break;
        case 'attendance':
          csv = await _backupService.exportAttendanceCsv();
          break;
        case 'marks':
          csv = await _backupService.exportMarksCsv();
          break;
        default:
          throw Exception('Unknown export type: $type');
      }

      final path = await _backupService.saveCsvFile(csv, type);
      emit(
        state.copyWith(
          isSaving: false,
          successMessage: LocaleKeys.exported_to.tr(args: [path]),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: LocaleKeys.export_failed.tr(args: [e.toString()]),
        ),
      );
    }
  }

  Future<void> purgeOldData(int years) async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      final counts = await _backupService.purgeOldData(years);
      final recordCounts = await _backupService.getRecordCounts();
      final dbSize = await _backupService.getDatabaseSize();

      emit(
        state.copyWith(
          isSaving: false,
          recordCounts: recordCounts,
          databaseSize: dbSize,
          successMessage: LocaleKeys.purge_success.tr(
            args: [
              (counts['attendance'] ?? 0).toString(),
              (counts['payments'] ?? 0).toString(),
            ],
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: LocaleKeys.purge_failed.tr(args: [e.toString()]),
        ),
      );
    }
  }

  Future<void> resetAllData() async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      await _backupService.resetAllData();
      final recordCounts = await _backupService.getRecordCounts();
      final dbSize = await _backupService.getDatabaseSize();

      emit(
        state.copyWith(
          isSaving: false,
          recordCounts: recordCounts,
          databaseSize: dbSize,
          successMessage: LocaleKeys.reset_success.tr(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: LocaleKeys.reset_failed.tr(args: [e.toString()]),
        ),
      );
    }
  }

  /// Import students and groups from elite.db
  Future<void> importFromEliteDb({String? path}) async {
    emit(
      state.copyWith(isSaving: true, errorMessage: null, successMessage: null),
    );
    try {
      String? targetPath = path;
      if (targetPath == null) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['db', 'sqlite', 'sqlite3'],
          dialogTitle: 'اختر ملف قاعدة بيانات Elite Series (elite.db)',
        );
        if (result != null && result.files.single.path != null) {
          targetPath = result.files.single.path!;
        } else {
          // Check default path
          const defaultPath = DataMigrationService.defaultSourceDbPath;
          if (File(defaultPath).existsSync()) {
            targetPath = defaultPath;
          } else {
            emit(state.copyWith(isSaving: false));
            return;
          }
        }
      }

      final migrationService = getIt<DataMigrationService>();
      final migrationResult =
          await migrationService.migrateFromEliteDb(targetPath);

      if (migrationResult.success) {
        await loadSettings();
        emit(
          state.copyWith(
            isSaving: false,
            successMessage:
                'تم استيراد ${migrationResult.studentsImported} طالب و ${migrationResult.groupsImported} مجموعة بنجاح!',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isSaving: false,
            errorMessage:
                migrationResult.errorMessage ?? 'فشل استيراد قاعدة البيانات',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }

  /// Clear the success/error message.
  void clearMessage() {
    emit(state.copyWith(successMessage: null, errorMessage: null));
  }

  /// Refresh database stats.
  Future<void> refreshDbStats() async {
    final dbSize = await _backupService.getDatabaseSize();
    final recordCounts = await _backupService.getRecordCounts();
    final backups = await _backupService.listBackups();
    emit(
      state.copyWith(
        databaseSize: dbSize,
        recordCounts: recordCounts,
        backups: backups,
      ),
    );
  }
}
