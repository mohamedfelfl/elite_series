# Implementation Plan: QR Card Generator

**Branch**: `001-qr-card-generator` | **Date**: 2026-08-01 | **Spec**: [spec.md](file:///c:/Projects/student_management_system/specs/001-qr-card-generator/spec.md)

**Input**: Feature specification from `/specs/001-qr-card-generator/spec.md`

## Summary

Implement a new **QR Card Generator** feature for student ID cards in the Student Management System.
The feature introduces a new navigation tab containing a split-screen interface:
- **Left Panel**: Live interactive preview of the student QR ID card matching the brand template (Eagle Monitor brand header, teacher name, student Arabic details, stage, group schedule, dynamic scannable QR code, and navy code banner).
- **Right Panel**: Selectable list of students supporting single, group, stage, or all-student filtering with real-time search.
- **Top Controls & Action Buttons**: Dropdown filter, search bar, select-all controls, and high-resolution PNG image batch export.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x (SDK ^3.11.1)

**Primary Dependencies**: `flutter_bloc`, `qr_flutter`, `auto_route`, `get_it`, `easy_localization`, `flutter_screenutil`, `path_provider`, `file_picker`, `sqflite_sqlcipher`

**Storage**: Local SQLite encrypted database (`DatabaseService` / `sqflite_sqlcipher`)

**Testing**: `flutter_test` (Unit tests for Cubit state management & model parsing)

**Target Platform**: Windows Desktop / Desktop-focused Flutter application

**Project Type**: Mobile/Desktop Cross-Platform Flutter App (Clean Architecture + Feature-First)

**Performance Goals**: Generate and export 50 student card PNG images in under 3 seconds; Live preview updates under 50ms upon student selection.

**Constraints**: Adhere 100% to existing `AppTheme` colors/styles and brand card design template.

**Scale/Scope**: Supports batch card rendering for stages and groups up to 1000+ students.

## Constitution Check

*GATE: Passed. Feature adheres to modular Clean Architecture and reusable BLoC/Cubit state management.*

- **Library-First / Modular**: Feature isolated cleanly under `lib/features/qr_card_generator/`.
- **State Management**: BLoC/Cubit pattern (`QrCardCubit`) registered in `MultiBlocProvider` (`app.dart`).
- **Testability**: Independent unit tests for Cubit state transitions and card data mapper.

## Project Structure

### Documentation (this feature)

```text
specs/001-qr-card-generator/
├── spec.md              # Feature specification
├── plan.md              # Implementation plan (this file)
├── research.md          # Architectural decisions & research
├── data-model.md        # Enums, Data Entities, and State models
├── quickstart.md        # End-to-end verification guide
└── contracts/           # Cubit & Export Service interface contracts
    └── qr_card_cubit_contract.md
```

### Source Code Structure

```text
lib/
├── app/
│   ├── app.dart                                    # MultiBlocProvider registration
│   ├── cubits/
│   │   └── shell_navigation_cubit.dart            # Add QR Card Generator tab index
│   └── router/
│       ├── app_router.dart                         # AutoRoute route definitions
│       └── app_router.gr.dart                      # Generated router code
└── features/
    └── qr_card_generator/                          # [NEW FEATURE MODULE]
        ├── cubits/
        │   ├── qr_card_cubit.dart
        │   └── qr_card_state.dart
        ├── models/
        │   ├── qr_card_config.dart
        │   └── student_card_data.dart
        ├── presentation/
        │   ├── screens/
        │   │   └── qr_card_generator_screen.dart
        │   └── widgets/
        │       ├── qr_card_preview_panel.dart
        │       ├── qr_card_template_widget.dart
        │       ├── student_selection_panel.dart
        │       └── qr_card_control_bar.dart
        └── services/
            └── qr_card_export_service.dart
```

## Structure Decision

Feature-First Architecture inside `lib/features/qr_card_generator/` maintaining complete architectural consistency with existing app modules (`lib/features/students`, `lib/features/groups`, `lib/features/attendance`).

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| *None* | N/A | Fully aligned with existing architecture |
