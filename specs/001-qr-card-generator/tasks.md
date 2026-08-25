# Tasks: QR Card Generator

**Input**: Design documents from `/specs/001-qr-card-generator/`

**Prerequisites**: [plan.md](file:///c:/Projects/student_management_system/specs/001-qr-card-generator/plan.md), [spec.md](file:///c:/Projects/student_management_system/specs/001-qr-card-generator/spec.md), [research.md](file:///c:/Projects/student_management_system/specs/001-qr-card-generator/research.md), [data-model.md](file:///c:/Projects/student_management_system/specs/001-qr-card-generator/data-model.md), [contracts/qr_card_cubit_contract.md](file:///c:/Projects/student_management_system/specs/001-qr-card-generator/contracts/qr_card_cubit_contract.md)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Feature directory initialization and file structure setup

- [x] T001 Create feature directory structure in `lib/features/qr_card_generator/` (cubits, models, presentation, services)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T002 [P] Create `StudentCardData` and `QRCardConfig` models in `lib/features/qr_card_generator/models/student_card_data.dart` and `qr_card_config.dart`
- [x] T003 [P] Create `IQrCardExportService` interface and implementation in `lib/features/qr_card_generator/services/qr_card_export_service.dart`
- [x] T004 Implement `QrCardCubit` state machine in `lib/features/qr_card_generator/cubits/qr_card_cubit.dart` and `qr_card_state.dart`
- [x] T005 Register `QrCardCubit` provider in `lib/app/app.dart`
- [x] T006 Add "QR Card Generator" tab item to `lib/app/cubits/shell_navigation_cubit.dart` and navigation shell routing

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Single Student QR Card Preview and Generation (Priority: P1) 🎯 MVP

**Goal**: Search or pick a single student, view live card preview matching template, and export single PNG image card.

**Independent Test**: Select a student, verify live card preview renders all brand elements & dynamic student data correctly, and export a high-resolution PNG image file.

### Implementation for User Story 1

- [x] T007 [P] [US1] Create `QrCardTemplateWidget` in `lib/features/qr_card_generator/presentation/widgets/qr_card_template_widget.dart` reproducing brand header, Arabic student info, stage/group details, dynamic `QrImageView`, and navy code banner
- [x] T008 [P] [US1] Create `QrCardPreviewPanel` widget in `lib/features/qr_card_generator/presentation/widgets/qr_card_preview_panel.dart` wrapping template in RepaintBoundary with scale/zoom controls
- [x] T009 [US1] Implement single student selection and search logic in `QrCardCubit` (`selectStudentForPreview`, `updateSearchQuery`)
- [x] T010 [US1] Implement single card PNG image export method in `QrCardExportService` (`renderCardToPngBytes`) with file picker output save flow
- [x] T011 [US1] Assemble split layout screen in `lib/features/qr_card_generator/presentation/screens/qr_card_generator_screen.dart` connecting preview panel and single card export action

**Checkpoint**: At this point, User Story 1 (MVP) is fully functional and testable independently.

---

## Phase 4: User Story 2 - Bulk QR Card Selection by Group, Stage, or All Students (Priority: P2)

**Goal**: Filter students by Group, Stage, or All Students using dropdown, toggle checkboxes, and batch export PNG images.

**Independent Test**: Select a group or stage from dropdown, toggle selection checkboxes or "Select All", and batch export PNG images into a target directory.

### Implementation for User Story 2

- [x] T012 [P] [US2] Create `QrCardControlBar` widget in `lib/features/qr_card_generator/presentation/widgets/qr_card_control_bar.dart` with selection mode dropdown ("Student", "Group", "Stage", "All Students") and search input field
- [x] T013 [P] [US2] Create `StudentSelectionPanel` widget in `lib/features/qr_card_generator/presentation/widgets/student_selection_panel.dart` with checkbox list, "Select All" toggle, and selected count badge
- [x] T014 [US2] Implement bulk filtering, group/stage data fetching, and multi-selection logic in `QrCardCubit`
- [x] T015 [US2] Implement `batchExportToFolder` with progress callbacks in `QrCardExportService`
- [x] T016 [US2] Integrate batch export progress dialog and batch action buttons into `QrCardGeneratorScreen`

**Checkpoint**: At this point, User Stories 1 AND 2 work independently and in combination.

---

## Phase 5: User Story 3 - Visual Template Compliance and Live Card Preview (Priority: P3)

**Goal**: Ensure 100% brand consistency, Arabic text layout alignment, long text scaling, and scannable QR payload integrity.

**Independent Test**: Toggle application theme and locale; verify card template maintains exact Arabic RTL field positioning and scannability.

### Implementation for User Story 3

- [x] T017 [P] [US3] Add text auto-scaling and fallback handling for long student names or missing stage/group data in `QrCardTemplateWidget`
- [x] T018 [US3] Verify scannable QR payload encoding consistency and test QR code scan reliability with attendance scanner

**Checkpoint**: All user stories are independently functional and visually verified.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Testing, localization, and end-to-end verification

- [x] T019 [P] Create unit tests for `QrCardCubit` state transitions in `test/features/qr_card_generator/cubits/qr_card_cubit_test.dart`
- [x] T020 [P] Add localization keys for QR Card Generator tab & actions in `assets/translations/ar.json` and `en.json`
- [x] T021 Execute quickstart validation guide in `specs/001-qr-card-generator/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational (Phase 2) completion
- **Polish (Phase 6)**: Depends on User Stories completion

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - MVP Focus
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Enhances selection & batch export
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - Fine-tunes styling & QR scan reliability

---

## Parallel Opportunities

- **Phase 2 Foundational**: T002 and T003 can be built in parallel.
- **Phase 3 (US1)**: T007 (Card Template Widget) and T008 (Preview Panel Widget) can be built in parallel.
- **Phase 4 (US2)**: T012 (Control Bar) and T013 (Selection List Panel) can be built in parallel.
- **Phase 6 Polish**: T019 (Unit tests) and T020 (Localization keys) can run in parallel.

---

## Implementation Strategy

### MVP First (User Story 1 Only)
1. Complete Phase 1 & Phase 2 (Setup & Foundational).
2. Complete Phase 3 (User Story 1).
3. **STOP and VALIDATE**: Search a student, preview card, and export single PNG image.

### Incremental Delivery
1. Deliver MVP (User Story 1) -> Single student preview & export.
2. Add User Story 2 -> Group/Stage filtering & batch image export.
3. Add User Story 3 -> Dynamic text scaling & QR scan verification.
