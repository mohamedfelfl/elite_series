# Quickstart & Validation Guide: Remote Updates via Velopack

**Feature**: Remote Application Updates via Velopack
**Branch**: `003-velopack-remote-updates`
**Date**: 2026-08-14

## Prerequisites

1. Flutter SDK (3.11+) and Windows desktop build tools installed.
2. .NET 6.0+ SDK (for `vpk` tool) installed:
   ```powershell
   dotnet tool update -g vpk
   ```
3. Target GitHub repository for release deployment (or local mock update server).

---

## Validation Scenarios

### Scenario 1: Unit & Bloc Tests for Update Flow

Run unit tests verifying state transitions, progress emission, and error handling:

```powershell
flutter test test/features/settings/cubits/update_cubit_test.dart
```

**Expected Outcome**:
- All test cases pass.
- State progresses correctly from `UpdateInitial` → `UpdateChecking` → `UpdateAvailable` → `UpdateDownloading` → `UpdateReadyToInstall`.

---

### Scenario 2: Manual Update Check in Development Mode (UI Verification)

1. Launch application in debug mode:
   ```powershell
   flutter run -d windows
   ```
2. Navigate to **Settings** → **About / Version** section.
3. Observe the installed version displayed (e.g. `v1.0.0`).
4. Click **"Check for Updates"**.
5. Verify the loading spinner appears during check and returns the appropriate status (e.g., "You are running the latest version" or mock update notice).

---

### Scenario 3: End-to-End Velopack Release Packaging & Update Test

1. **Build initial release (v1.0.0)**:
   ```powershell
   flutter build windows --release
   vpk pack --packId StudentManagementSystem --packVersion 1.0.0 --packDir build/windows/x64/runner/Release --mainExe student_management_system.exe -o ./Releases
   ```
2. **Install v1.0.0**: Run `./Releases/StudentManagementSystem-Setup.exe` and verify app launch.
3. **Build updated release (v1.0.1)**:
   - Increment version in `pubspec.yaml` to `1.0.1`.
   - Rebuild and package:
     ```powershell
     flutter build windows --release
     vpk pack --packId StudentManagementSystem --packVersion 1.0.1 --packDir build/windows/x64/runner/Release --mainExe student_management_system.exe -o ./Releases
     ```
4. **Deploy & Validate**:
   - Host `./Releases` on GitHub Releases or a local HTTP server.
   - Open installed v1.0.0 app.
   - Click "Check for Updates" or observe startup update banner.
   - Click "Download & Update", observe progress bar.
   - Click "Restart Now", verify the app restarts cleanly into v1.0.1.
   - Verify all student, attendance, and database records remain intact.
