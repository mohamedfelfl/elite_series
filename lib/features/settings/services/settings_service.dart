import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';

/// Reads and writes app settings from the `app_settings` key-value table.
class SettingsService {
  final DatabaseService _databaseService;

  SettingsService({required DatabaseService databaseService})
    : _databaseService = databaseService;

  /// Get a setting value by key.
  Future<String?> get(String key) async {
    try {
      final Database db = await _databaseService.database;
      final results = await db.query(
        DBQueries.tableAppSettings,
        where: 'key = ?',
        whereArgs: [key],
      );
      if (results.isNotEmpty) {
        return results.first['value'] as String?;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('SettingsService: Error reading setting "$key": $e');
      }
      return null;
    }
  }

  /// Get a setting value with a default fallback.
  Future<String> getOrDefault(String key, String defaultValue) async {
    return await get(key) ?? defaultValue;
  }

  /// Get a boolean setting.
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final value = await get(key);
    if (value == null) return defaultValue;
    return value == 'true' || value == '1';
  }

  /// Get an integer setting.
  Future<int> getInt(String key, {int defaultValue = 0}) async {
    final value = await get(key);
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  /// Set a setting value.
  Future<void> set(String key, String value) async {
    try {
      final Database db = await _databaseService.database;
      await db.insert(DBQueries.tableAppSettings, {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      if (kDebugMode) {
        print('SettingsService: Error writing setting "$key": $e');
      }
    }
  }

  /// Set a boolean setting.
  Future<void> setBool(String key, bool value) async {
    await set(key, value.toString());
  }

  /// Set an integer setting.
  Future<void> setInt(String key, int value) async {
    await set(key, value.toString());
  }

  /// Get all settings as a map.
  Future<Map<String, String>> getAll() async {
    try {
      final Database db = await _databaseService.database;
      final results = await db.query(DBQueries.tableAppSettings);
      return Map.fromEntries(
        results.map(
          (row) => MapEntry(row['key'] as String, row['value'] as String),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('SettingsService: Error reading all settings: $e');
      }
      return {};
    }
  }

  /// Delete a setting.
  Future<void> delete(String key) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(DBQueries.tableAppSettings, where: 'key = ?', whereArgs: [key]);
    } catch (e) {
      if (kDebugMode) {
        print('SettingsService: Error deleting setting "$key": $e');
      }
    }
  }
}

/// Well-known setting keys.
abstract class SettingsKeys {
  // General
  static const themeMode = 'theme_mode'; // 'light', 'dark', 'system'
  static const language = 'language'; // 'en', 'ar'
  static const defaultPaymentAmount = 'default_payment_amount';
  static const academicYear = 'academic_year';
  static const dateFormat = 'date_format';
  static const currencyDisplay = 'currency_display';
  static const fontSize = 'font_size'; // 'small', 'normal', 'large'

  // Security
  static const autoLogoutOnClose = 'auto_logout_on_close';
  static const appLockEnabled = 'app_lock_enabled';

  // Backup
  static const autoBackupEnabled = 'auto_backup_enabled';
  static const autoBackupSchedule =
      'auto_backup_schedule'; // 'daily', 'weekly', 'on_close'
  static const maxBackups = 'max_backups';

  // Privacy
  static const screenLockOnMinimize = 'screen_lock_on_minimize';
  static const dataMasking = 'data_masking';

  // Device
  static const deviceBound = 'device_bound';

  // First Launch
  static const setupCompleted = 'setup_completed';
}
