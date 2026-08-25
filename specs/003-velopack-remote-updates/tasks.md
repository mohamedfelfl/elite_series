# Tasks: Remote Application Updates via Velopack

**Input**: Design documents from `specs/003-velopack-remote-updates/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/update-service-contract.md](contracts/update-service-contract.md)

## Format: `- [ ] [ID] [P?] [Story?] Description with file path`

- **[P]**: Can run in parallel (different files, no blocking dependencies)
- **[Story]**: User story label (`[US1]`, `[US2]`, `[US3]`) mapping directly to `spec.md`
- Exact file paths provided for every task

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project dependency initialization, localization keys, and release packaging tooling.

- [x] T001 Add `velopack_flutter` dependency and configure build settings in [pubspec.yaml](file:///c:/Projects/student_management_system/pubspec.yaml)
- [x] T002 [P] Add update localization keys (en & ar) in [assets/translations/en.json](file:///c:/Projects/student_management_system/assets/translations/en.json) and [assets/translations/ar.json](file:///c:/Projects/student_management_system/assets/translations/ar.json)
- [x] T003 [P] Create packaging and distribution script for Windows releases in [scripts/package-release.ps1](file:///c:/Projects/student_management_system/scripts/package-release.ps1)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core update models, service interfaces, dependency injection, and state management required by all stories.

**⚠️ CRITICAL**: Must complete before user story implementation begins.

- [x] T004 Create `AppUpdateInfo` model and `UpdateState` definitions in [lib/features/settings/models/app_update_info.dart](file:///c:/Projects/student_management_system/lib/features/settings/models/app_update_info.dart)
- [x] T005 Create abstract `UpdateService` interface and `VelopackUpdateService` in [lib/app/services/update_service.dart](file:///c:/Projects/student_management_system/lib/app/services/update_service.dart)
- [x] T006 [P] Create `MockUpdateService` for debug mode and test environments in [lib/app/services/mock_update_service.dart](file:///c:/Projects/student_management_system/lib/app/services/mock_update_service.dart)
- [x] T007 Register `UpdateService` and `UpdateCubit` in [lib/app/di/injection.dart](file:///c:/Projects/student_management_system/lib/app/di/injection.dart)
- [x] T008 Create `UpdateCubit` and `UpdateState` classes in [lib/features/settings/cubits/update_cubit.dart](file:///c:/Projects/student_management_system/lib/features/settings/cubits/update_cubit.dart) and [lib/features/settings/cubits/update_state.dart](file:///c:/Projects/student_management_system/lib/features/settings/cubits/update_state.dart)

**Checkpoint**: Foundation ready — user story implementation can begin.

---

## Phase 3: User Story 1 - Automatic Update Detection and Notification (Priority: P1) 🎯 MVP

**Goal**: Automatically detect remote updates in the background on startup and display a non-intrusive notification banner.

**Independent Test**: Launch application with mock or remote release available, verify startup check runs without UI lag, and verify dismissible banner displays new version with "Download & Update" action.

### Tests for User Story 1
- [x] T009 [P] [US1] Create unit tests for startup update check and state transitions in [test/features/settings/cubits/update_cubit_test.dart](file:///c:/Projects/student_management_system/test/features/settings/cubits/update_cubit_test.dart)

### Implementation for User Story 1
- [x] T010 [US1] Handle Velopack startup CLI hooks and trigger initial background update check in [lib/main.dart](file:///c:/Projects/student_management_system/lib/main.dart)
- [x] T011 [P] [US1] Create `UpdateNotificationBanner` widget in [lib/features/settings/widgets/update_banner.dart](file:///c:/Projects/student_management_system/lib/features/settings/widgets/update_banner.dart)
- [x] T012 [US1] Integrate `UpdateNotificationBanner` into main application layout in [lib/app/app.dart](file:///c:/Projects/student_management_system/lib/app/app.dart)

**Checkpoint**: User Story 1 fully functional and independently testable as MVP.

---

## Phase 4: User Story 2 - Manual Update Check and Progress Feedback (Priority: P2)

**Goal**: Allow manual update checks from Settings, display current version info, show release notes, and track live download progress.

**Independent Test**: Navigate to Settings → click "Check for Updates" → verify inline spinner and status → click download → verify live progress percentage bar.

### Tests for User Story 2
- [x] T013 [P] [US2] Create unit tests for manual update check and progress stream in [test/features/settings/cubits/update_cubit_test.dart](file:///c:/Projects/student_management_system/test/features/settings/cubits/update_cubit_test.dart)

### Implementation for User Story 2
- [x] T014 [P] [US2] Create `UpdateDialog` displaying changelog, download button, and live progress bar in [lib/features/settings/widgets/update_dialog.dart](file:///c:/Projects/student_management_system/lib/features/settings/widgets/update_dialog.dart)
- [x] T015 [US2] Add version info display and manual "Check for Updates" action tile in [lib/features/settings/screens/settings_screen.dart](file:///c:/Projects/student_management_system/lib/features/settings/screens/settings_screen.dart)

**Checkpoint**: User Stories 1 and 2 work independently and harmoniously.

---

## Phase 5: User Story 3 - Safe Update Application and Restart (Priority: P3)

**Goal**: Apply downloaded update packages and restart the application cleanly while guaranteeing zero data loss for local SQLite databases.

**Independent Test**: Trigger "Restart Now" after download completes → verify app restarts into new version → verify all database records and user settings remain intact.

### Tests for User Story 3
- [x] T016 [P] [US3] Create unit tests for restart and exit-to-update actions in [test/features/settings/cubits/update_cubit_test.dart](file:///c:/Projects/student_management_system/test/features/settings/cubits/update_cubit_test.dart)

### Implementation for User Story 3
- [x] T017 [US3] Implement `applyUpdateAndRestart` and `applyUpdateOnExit` with graceful database flushing in [lib/app/services/update_service.dart](file:///c:/Projects/student_management_system/lib/app/services/update_service.dart)
- [x] T018 [US3] Wire "Restart Now" and "Apply on Next Launch" buttons in [lib/features/settings/widgets/update_dialog.dart](file:///c:/Projects/student_management_system/lib/features/settings/widgets/update_dialog.dart)

**Checkpoint**: Complete update lifecycle functional from check to restart.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Localization generation, end-to-end testing, and validation against quickstart scenarios.

- [x] T019 [P] Generate updated localization keys in [lib/generated/locale_keys.g.dart](file:///c:/Projects/student_management_system/lib/generated/locale_keys.g.dart)
- [x] T020 Run full test suite and quickstart validation guide in [specs/003-velopack-remote-updates/quickstart.md](file:///c:/Projects/student_management_system/specs/003-velopack-remote-updates/quickstart.md)

---

## Dependencies & Execution Order

### Phase Dependencies
- **Setup (Phase 1)**: Can start immediately.
- **Foundational (Phase 2)**: Depends on Phase 1 (T001-T003) — BLOCKS all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational phase completion (T004-T008).
- **User Story 2 (Phase 4)**: Depends on Foundational phase completion; integrates with US1 widgets.
- **User Story 3 (Phase 5)**: Depends on US1 and US2 download flows.
- **Polish (Phase 6)**: Runs after all user stories are complete.

### Parallel Opportunities

- **Phase 1**: `T002` (translations) and `T003` (packaging script) can run in parallel.
- **Phase 2**: `T006` (mock service) can run in parallel with `T005` (update service).
- **Phase 3**: `T009` (tests) and `T011` (banner widget) can run in parallel.
- **Phase 4**: `T013` (tests) and `T014` (update dialog) can run in parallel.
- **Phase 5**: `T016` (tests) can run in parallel with `T017` (service restart methods).

---

## Implementation Strategy

### MVP Scope (User Story 1 Only)
1. Complete **Phase 1: Setup** (T001 - T003).
2. Complete **Phase 2: Foundational** (T004 - T008).
3. Complete **Phase 3: User Story 1** (T009 - T012).
4. Validate MVP: Application launches, checks remote releases in background without lag, and presents non-intrusive update banner.

### Incremental Delivery
- Deliver MVP (US1) for automatic update discovery.
- Add US2 for manual checks in Settings with live download progress.
- Add US3 for seamless restart and packaging automation.
