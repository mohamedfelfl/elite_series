import '../models/app_update_info.dart';

/// Base state for application update lifecycle.
abstract class UpdateState {
  const UpdateState();
}

/// Initial state prior to any check.
class UpdateInitial extends UpdateState {
  final String currentVersion;
  const UpdateInitial({this.currentVersion = '1.0.0'});
}

/// Actively checking remote repository for updates.
class UpdateChecking extends UpdateState {
  final bool isManual;
  const UpdateChecking({this.isManual = false});
}

/// App is on the latest version.
class UpdateUpToDate extends UpdateState {
  final String currentVersion;
  final bool isManual;
  const UpdateUpToDate({required this.currentVersion, this.isManual = false});
}

/// An update is available on remote repository.
class UpdateAvailable extends UpdateState {
  final AppUpdateInfo info;
  final bool isManual;
  const UpdateAvailable({required this.info, this.isManual = false});
}

/// Downloading update package with live progress.
class UpdateDownloading extends UpdateState {
  final AppUpdateInfo info;
  final double progress; // 0.0 to 1.0
  const UpdateDownloading({required this.info, required this.progress});
}

/// Update downloaded and verified, ready for restart.
class UpdateReadyToInstall extends UpdateState {
  final AppUpdateInfo info;
  const UpdateReadyToInstall({required this.info});
}

/// Application is restarting to apply the update.
class UpdateRestarting extends UpdateState {
  final AppUpdateInfo info;
  const UpdateRestarting({required this.info});
}

/// An error occurred during check or download.
class UpdateError extends UpdateState {
  final String message;
  final bool isManual;
  const UpdateError({required this.message, this.isManual = false});
}
