# Tasks: Auto-Generated Student Serial Number by Grade

**Input**: Design documents from `/specs/002-auto-student-serial/`

**Prerequisites**: [plan.md](file:///c:/Projects/student_management_system/specs/002-auto-student-serial/plan.md), [spec.md](file:///c:/Projects/student_management_system/specs/002-auto-student-serial/spec.md), [research.md](file:///c:/Projects/student_management_system/specs/002-auto-student-serial/research.md), [data-model.md](file:///c:/Projects/student_management_system/specs/002-auto-student-serial/data-model.md), [student_serial_contract.md](file:///c:/Projects/student_management_system/specs/002-auto-student-serial/contracts/student_serial_contract.md)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Includes exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Infrastructure setup for auto-serial calculations

- [x] T001 Define base serial counter map (`kGradeBaseSerials`) in `lib/features/students/cubits/student_cubit.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core calculation and helper methods required before UI binding

- [x] T002 Implement `getNextSerialNumber` method in `lib/features/students/cubits/student_cubit.dart` to calculate max numeric serial + 1 starting from base counter `X0777` for the specified grade

---

## Phase 3: User Story 1 - Auto-generating Student Serial Number on Add (Priority: P1) 🎯 MVP

**Goal**: Auto-generate and display the next available 5-digit serial number based on grade in the Add Student form.

**Independent Test**: Open Add Student form, verify serial field at the bottom displays `10777` for default Grade `prep_1`. Switch Grade to `prep_2` and verify the serial field dynamically updates to `20777`.

- [x] T003 [US1] Update `lib/features/students/screens/student_form/student_form_screen.dart` state initialization to automatically trigger `getNextSerialNumber` for the initial grade selection
- [x] T004 [US1] Position serial number text field at the bottom of the form layout in `lib/features/students/screens/student_form/student_form_screen.dart`
- [x] T005 [US1] Configure serial number text field in `lib/features/students/screens/student_form/student_form_screen.dart` to be read-only with auto-generated value display
- [x] T006 [US1] Add listener/callback in `lib/features/students/screens/student_form/student_form_screen.dart` to recalculate and refresh serial number preview dynamically when grade changes

---

## Phase 4: User Story 2 - Mandatory Grade Selection & Mandatory Form Validation (Priority: P2)

**Goal**: Ensure Grade is a mandatory field with default `prep_1` and no "Not Specified" option.

**Independent Test**: Expand grade dropdown in Add Student form, confirm "Not Specified" option is absent and default selection is `prep_1`.

- [x] T007 [P] [US2] Update `lib/features/students/screens/student_form/components/student_academic_section.dart` to remove the `null` ("Not Specified") `DropdownMenuItem`
- [x] T008 [P] [US2] Set default selected grade value to `'prep_1'` in `lib/features/students/screens/student_form/student_form_screen.dart` when opening form for a new student
- [x] T009 [US2] Add form validation in `lib/features/students/screens/student_form/student_form_screen.dart` to enforce non-null grade selection on submit

---

## Phase 5: User Story 3 - Distinct Grade Serial Ranges (Priority: P3)

**Goal**: Validate unique starting serial counters across all 6 grades (`10777` to `60777`).

**Independent Test**: Cycle through all 6 grades (`prep_1`..`sec_3`) in the form and verify initial serial counters start at `10777`, `20777`, `30777`, `40777`, `50777`, `60777`.

- [x] T010 [US3] Verify serial prefix mapping for `prep_1` (10777), `prep_2` (20777), `prep_3` (30777), `sec_1` (40777), `sec_2` (50777), `sec_3` (60777) in `lib/features/students/cubits/student_cubit.dart`

---

## Phase 6: Polish & Verification

**Purpose**: Static analysis and quickstart validation

- [x] T011 Run `flutter analyze` to confirm zero static analysis errors
- [x] T012 Run [quickstart.md](file:///c:/Projects/student_management_system/specs/002-auto-student-serial/quickstart.md) manual validation scenarios

---

## Dependencies & Execution Order

### Phase Dependencies
- **Setup (Phase 1)**: Can start immediately.
- **Foundational (Phase 2)**: Depends on Phase 1 completion.
- **User Story 1 (Phase 3)**: Depends on Phase 2 completion.
- **User Story 2 (Phase 4)**: Can run in parallel with or after US1.
- **User Story 3 (Phase 5)**: Depends on US1 & US2 completion.
- **Polish (Phase 6)**: Depends on all user stories completion.

---

## Implementation Strategy

### MVP First (User Story 1 Only)
1. Complete Phase 1 & Phase 2.
2. Implement Phase 3 (User Story 1).
3. Test auto-generation of serial numbers on Add Student form.

### Incremental Delivery
1. Add Phase 4 (User Story 2: Mandatory Grade & default `prep_1`).
2. Add Phase 5 (User Story 3: Verify all 6 grade ranges).
3. Run Phase 6 (Polish & Verification).
