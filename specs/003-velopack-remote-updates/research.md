# Technical Research: Remote Application Updates with Velopack

**Feature**: Remote Application Updates via Velopack
**Branch**: `003-velopack-remote-updates`
**Date**: 2026-08-14

## Research Overview

This document investigates the integration of Velopack auto-update capabilities into the Flutter Windows desktop application, detailing update delivery via public GitHub Releases, background startup checks, download progress tracking, and safe process restarts.

---

## 1. Velopack Integration Strategy in Flutter Desktop

### Decision
Use `velopack_flutter` (or native FFI/process management with Velopack Rust/C++ runtime) with a clean service abstraction `UpdateService` and a robust debug-safe fallback.

### Rationale
- `velopack_flutter` wraps Velopack's native core using `flutter_rust_bridge`, providing direct Dart bindings to `initializeVelopack`, `isUpdateAvailable`, `getLatestUpdateInfo`, `checkAndDownloadUpdatesWithProgress`, and `updateAndRestart`.
- In non-packaged development/debug runs (`flutter run`), Velopack APIs throw or return unavailable because the app was not executed from an installed `vpk` bundle. An abstraction layer (`UpdateService` / `MockUpdateService`) prevents crashes during local development and testing while seamlessly functioning in production release builds.
- Startup CLI hooks (`--veloapp-install`, `--veloapp-updated`, etc.) can be handled cleanly at the entry point of `main.dart`.

### Alternatives Considered
- **Direct C++ Runner Hook (`windows/runner/main.cpp`)**: Uses `vpk/Velopack.hpp` in the C++ runner. Effective for pure C++ startup hooks, but lacks convenient progress streams and in-app UI bindings directly in Dart.
- **Custom HTTP Poll + InnoSetup Installer**: Requires manual process killing, elevation prompts, and full re-download of installer binaries without delta compression.

---

## 2. Remote Distribution via GitHub Releases

### Decision
Target public GitHub Releases using the GitHub tag/release download URL scheme (`https://github.com/{owner}/{repo}/releases/download/{tag}/` or standard GitHub release endpoint) and query `releases.win.json`.

### Rationale
- Zero additional hosting infrastructure or server maintenance costs.
- Velopack's `vpk download github` and `vpk upload github` CLI tools natively handle uploading delta packages and `releases.win.json` to GitHub release tags.
- Public repositories allow unauthenticated HTTP GET requests from installed client applications to fetch release manifests and download update packages.

### Alternatives Considered
- **AWS S3 / Cloudflare R2 Bucket**: Requires managing credentials and custom bucket hosting policies.
- **Dedicated Custom Update Server**: Unnecessary maintenance overhead for a standalone client application.

---

## 3. UI/UX and State Management Integration

### Decision
Implement an `UpdateCubit` (using `flutter_bloc`) that manages the reactive `UpdateState` across the application lifecycle:
1. **Startup Check**: Triggered shortly after app initialization. If an update is detected, emits `UpdateAvailable` which displays a non-blocking toast/banner or dialog.
2. **Manual Check**: Triggered from the Settings / About screen, showing an inline spinner, version info, or "Up to date" confirmation.
3. **Download Progress**: Emits `UpdateDownloading(progress)` to render a linear progress bar and downloaded percentage.
4. **Restart Confirmation**: Emits `UpdateReadyToInstall`, offering "Restart Now" (calls `updateAndRestart()`) or "Apply on Exit".

### Rationale
- Fully aligns with existing project architecture (`flutter_bloc`, `GetIt` dependency injection).
- Provides testable state transitions and isolates update logic from widget trees.

---

## 4. Packaging and Release Workflow

### Decision
Provide a standardized PowerShell build/packaging script (`scripts/package-release.ps1`) executing:
1. `flutter build windows --release`
2. `vpk download github --repoUrl <repo_url>` (to pull previous release for delta package generation)
3. `vpk pack --packId StudentManagementSystem --packVersion <version> --packDir build/windows/x64/runner/Release --mainExe student_management_system.exe`
4. `vpk upload github --repoUrl <repo_url> --publish --tag v<version> --token <token>`

---

## Summary of Technical Decisions

| Area | Selection | Rationale |
|------|-----------|-----------|
| **Core Framework** | Velopack (`velopack_flutter` + `vpk` CLI) | Industry-standard delta updates, fast restarts, seamless Windows packaging |
| **Hosting Source** | Public GitHub Releases | Free, reliable, tag-based release distribution without custom servers |
| **State Management** | `UpdateCubit` / `flutter_bloc` | Consistent with codebase architecture and reactive UI streams |
| **Development Mode** | Graceful simulation / No-op in debug | Prevents crash in `flutter run` when outside packaged directory |
| **Packaging Script** | PowerShell `package-release.ps1` | Turnkey release generation and delta computation |
