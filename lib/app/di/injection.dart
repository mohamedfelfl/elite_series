import 'package:get_it/get_it.dart';

import '../services/database_service.dart';
import '../services/data_migration_service.dart';
import '../services/encryption_service.dart';
import '../../features/settings/services/settings_service.dart';
import '../../features/settings/services/backup_service.dart';
import '../../features/settings/services/device_binding_service.dart';
import '../services/update_service.dart';
import '../../features/settings/cubits/update_cubit.dart';

final getIt = GetIt.instance;

/// Initialize all service dependencies.
Future<void> configureDependencies() async {
  // Encryption
  getIt.registerLazySingleton<EncryptionService>(() => EncryptionService());

  // Database
  getIt.registerLazySingleton<DatabaseService>(
    () => DatabaseService(encryptionService: getIt<EncryptionService>()),
  );

  // Settings
  getIt.registerLazySingleton<SettingsService>(
    () => SettingsService(databaseService: getIt<DatabaseService>()),
  );

  // Backup
  getIt.registerLazySingleton<BackupService>(
    () => BackupService(databaseService: getIt<DatabaseService>()),
  );

  // Device Binding
  getIt.registerLazySingleton<DeviceBindingService>(
    () => DeviceBindingService(),
  );

  // Data Migration (from legacy / external elite.db)
  getIt.registerLazySingleton<DataMigrationService>(
    () => DataMigrationService(databaseService: getIt<DatabaseService>()),
  );

  // Software Updates (Velopack)
  getIt.registerLazySingleton<UpdateService>(
    () => VelopackUpdateService(),
  );

  getIt.registerFactory<UpdateCubit>(
    () => UpdateCubit(updateService: getIt<UpdateService>()),
  );
}
