# Contract: Update Service and UI Interface

**Feature**: Remote Application Updates via Velopack
**Branch**: `003-velopack-remote-updates`
**Date**: 2026-08-14

## 1. `UpdateService` Interface Contract

```dart
abstract class UpdateService {
  /// Initializes the Velopack runtime or platform-specific update manager.
  Future<void> initialize();

  /// Gets the currently running semantic version of the application.
  Future<String> getCurrentVersion();

  /// Checks whether an update is available on the remote repository.
  /// Returns [AppUpdateInfo] if a newer version exists, or `null` if up-to-date.
  Future<AppUpdateInfo?> checkForUpdate({bool allowDowngrade = false});

  /// Downloads the update package with continuous progress updates (0.0 to 1.0).
  Stream<double> downloadUpdate(AppUpdateInfo info);

  /// Applies downloaded update and restarts the application immediately.
  Future<void> applyUpdateAndRestart();

  /// Applies downloaded update on next application exit/launch.
  Future<void> applyUpdateOnExit();
}
```

---

## 2. `UpdateCubit` Contract

```dart
class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit({required UpdateService updateService});

  /// Checks for update in background or manually.
  Future<void> checkForUpdates({bool isManual = false});

  /// Starts downloading the detected update.
  Future<void> downloadUpdate();

  /// Restarts the application to apply the downloaded update.
  Future<void> restartAndApply();

  /// Dismisses the update banner/dialog for the current session.
  void dismissUpdate();
}
```

---

## 3. UI Component Contracts

### A. `UpdateNotificationBanner` / `UpdateDialog`
- **Trigger**: Displayed when `UpdateState` enters `UpdateAvailable` or `UpdateReadyToInstall`.
- **Props**:
  - `info`: `AppUpdateInfo`
  - `onDownload`: `VoidCallback`
  - `onDismiss`: `VoidCallback`
  - `onRestart`: `VoidCallback`
- **Actions**:
  - "Download & Update" -> Triggers `UpdateCubit.downloadUpdate()`
  - "Dismiss" -> Triggers `UpdateCubit.dismissUpdate()`
  - "Restart Now" -> Triggers `UpdateCubit.restartAndApply()`

### B. `SettingsUpdateTile`
- **Location**: `SettingsScreen` (under About / System section).
- **Display**: Current version (e.g. `v1.0.0`), "Check for Updates" button, inline loading spinner, and status text.
- **Actions**: Click triggers `UpdateCubit.checkForUpdates(isManual: true)`.
