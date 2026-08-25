# Implementation Plan: Remote Application Updates via Velopack

**Branch**: `003-velopack-remote-updates` | **Date**: 2026-08-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/003-velopack-remote-updates/spec.md`

## Summary

Implement remote automatic and manual software updates for the Windows desktop Student Management System using the Velopack distribution framework and public GitHub Releases. The solution provides non-blocking startup update checks, an inline manual update action in Settings, live download progress tracking, and seamless, safe app restarts while guaranteeing zero data loss for local encrypted SQLite databases.

## Technical Context

**Language/Version**: Dart 3.11+ / Flutter 3.x (Windows Desktop)

**Primary Dependencies**: `velopack_flutter` (^0.3.2), `flutter_bloc` (^9.1.0), `get_it` (^8.0.3), `easy_localization` (^3.0.7)

**Storage**: Local SQLite (`sqflite_sqlcipher` / `sqlite3_flutter_libs`) stored outside application install directory in AppData; `flutter_secure_storage` for encryption keys

**Testing**: `flutter_test` (unit and bloc tests for `UpdateCubit` and `UpdateService` mock/interface)

**Target Platform**: Windows 10/11 Desktop (x64)

**Project Type**: Desktop Application

**Performance Goals**: Startup background check completed within 2 seconds without UI freeze; app restart under 15 seconds

**Constraints**: Non-blocking asynchronous checks; zero local data loss across updates; offline-tolerant graceful error handling; dismissible update notifications

**Scale/Scope**: Single client installer package; delta package support for compact bandwidth downloads

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **No Breaking Core Storage**: User SQLite database resides in standard OS user data directory, unaffected by binary replacement.
- [x] **Separation of Concerns**: Update logic encapsulated in `UpdateService` and `UpdateCubit`, decoupling native Velopack calls from UI widgets.
- [x] **Testability**: `UpdateService` interface allows full mockability and unit test verification without requiring actual Velopack packages in CI/test environments.
- [x] **Localization**: All update messages, button labels, and error strings localized in `ar.json` and `en.json`.

## Project Structure

### Documentation (this feature)

```text
specs/003-velopack-remote-updates/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
│   └── update-service-contract.md
└── tasks.md             # Phase 2 output (/speckit-tasks command)
```

### Source Code (repository root)

```text
lib/
├── app/
│   ├── services/
│   │   ├── update_service.dart          # Update service interface & implementation
│   │   └── mock_update_service.dart     # Mock fallback for debug & test environments
│   └── di/
│       └── injection.dart               # Service registration in GetIt
├── features/
│   └── settings/
│       ├── cubits/
│       │   ├── update_cubit.dart        # UpdateCubit state management
│       │   └── update_state.dart        # Reactive update states
│       ├── screens/
│       │   └── settings_screen.dart     # Update tile & version info in Settings
│       └── widgets/
│           ├── update_dialog.dart       # Update release notes & prompt dialog
│           └── update_banner.dart       # Non-intrusive startup update banner
test/
└── features/
    └── settings/
        └── cubits/
            └── update_cubit_test.dart   # Unit tests for update cubit lifecycle
scripts/
└── package-release.ps1                  # PowerShell script for vpk packaging & release
```

**Structure Decision**: Integrated within existing `lib/app/services` and `lib/features/settings` modules, following the repository's modular BLoC and dependency injection architecture.

## Complexity Tracking

> *No constitutional violations detected. Design utilizes standard service abstraction and BLoC patterns.*
