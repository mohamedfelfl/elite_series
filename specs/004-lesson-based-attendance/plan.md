# Implementation Plan: Lesson-Based Attendance System

**Branch**: `004-lesson-based-attendance` | **Date**: 2026-08-25 | **Spec**: [spec.md](file:///c:/Projects/student_management_system/specs/004-lesson-based-attendance/spec.md)

**Input**: Feature specification from [`specs/004-lesson-based-attendance/spec.md`](file:///c:/Projects/student_management_system/specs/004-lesson-based-attendance/spec.md)

---

## Summary

Upgrade the attendance system from flat daily records to a session-based **Lesson Attendance Architecture**. The system dynamically computes daily lessons from weekly group schedules (`group_schedules`), supports on-demand lesson activation (`status = 'in_progress'`), locks the QR scanner to the active session, derives real-time attended vs. absent rosters with 1-tap manual toggling, presents a summary dialog on "End Lesson", migrates legacy attendance data seamlessly, and delivers a comprehensive 5-part reporting suite (Per-Lesson PDF, Group Summary, Absentee Phone Sheet, Student Profile Log, and CSV Export).

---

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x  
**Primary Dependencies**: `flutter_bloc` / `freezed`, `sqflite_sqlcipher` / `sqflite_common_ffi`, `mobile_scanner`, `pdf` / `printing`, `easy_localization`, `auto_route`  
**Storage**: Encrypted SQLite (`student_management.db`) via `DatabaseService`  
**Testing**: `flutter_test` / widget & unit tests  
**Target Platform**: Windows (Desktop), Android, iOS, macOS, Linux  
**Project Type**: Flutter Multi-Platform Application  
**Performance Goals**: <300ms QR scan processing & roster refresh; <3s PDF report generation for 1,000+ records  
**Constraints**: 100% offline-capable, encrypted database, zero data loss migration for legacy records  
**Scale/Scope**: ~10-20 lessons per day, hundreds of students, multi-year historical records  

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] Architecture complies with single encrypted local database model (`DatabaseService`).
- [x] State management uses established BLoC / Cubit patterns with Freezed states.
- [x] Database changes are idempotent and backward-compatible (`_onOpen` migration scripts).
- [x] Localization follows EasyLocalization standard (`LocaleKeys`, Arabic & English).
- [x] Responsive layout complies with `AppDimens` and `ScreenUtil`.

---

## Project Structure

### Documentation (this feature)

```text
specs/004-lesson-based-attendance/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (architectural decisions)
├── data-model.md        # Phase 1 output (schema, entities, lifecycle)
├── quickstart.md        # Phase 1 output (validation & run guide)
├── contracts/           # Phase 1 output (cubit & reporting service contracts)
│   ├── lesson-cubit-contract.md
│   └── report-service-contract.md
└── tasks.md             # Phase 2 output (/speckit-tasks command)
```

### Source Code Impact & Directory Layout

```text
lib/
├── app/
│   ├── constants/
│   │   └── db_queries.dart                 # [MODIFY] Add lessons DDL, migration queries, lesson-attendance joins
│   └── services/
│       └── database_service.dart           # [MODIFY] Add lessons table creation and legacy data migration in _onOpen
├── features/
│   ├── attendance/
│   │   ├── cubits/
│   │   │   ├── attendance_cubit.dart       # [MODIFY] Update for lesson_id linking, scan validation, and live roster
│   │   │   └── lesson_cubit.dart           # [NEW] Daily lessons timeline, session start/end, and ad-hoc lessons
│   │   ├── models/
│   │   │   ├── attendance.dart             # [MODIFY] Add lessonId, groupName, serialNumber fields
│   │   │   └── lesson.dart                 # [NEW] Lesson entity model (Freezed)
│   │   └── screens/
│   │       ├── attendance_list/
│   │       │   ├── attendance_list_screen.dart # [MODIFY] Update to display lesson breakdowns & timeline
│   │       │   └── components/
│   │       │       └── lesson_card.dart    # [NEW] Lesson session card with status and attendee counts
│   │       └── qr_scanner/
│   │           ├── qr_scanner_screen.dart  # [MODIFY] Active lesson header, live counter, and Start/End actions
│   │           └── components/
│   │               ├── active_lesson_banner.dart # [NEW] Active lesson info and live roster tabs
│   │               ├── end_lesson_dialog.dart    # [NEW] Summary confirmation dialog
│   │               └── live_roster_view.dart     # [NEW] Attended & Absent tabs with 1-tap toggle
│   └── reports/
│       ├── cubits/
│       │   └── report_cubit.dart           # [MODIFY] 5-part reporting engine (per-lesson, absentee, group summary)
│       └── screens/
│           └── report/
│               └── components/
│                   ├── attendance_date_report_form.dart # [MODIFY] Add group & lesson selectors
│                   └── absentee_report_form.dart        # [NEW] Dedicated absentee contact sheet generator
└── generated/
    ├── locale_keys.g.dart                  # [MODIFY] Add Arabic & English translation keys for lessons & reports
    └── codegen_loader.g.dart               # [MODIFY] Translations
```

---

## Verification Plan

### Automated Unit & Widget Tests
- Database migration test verifying `lessons` table creation and legacy `attendance.lesson_id` population.
- `AttendanceCubit` & `LessonCubit` tests for starting sessions, scanning enrolled vs. other-group students, duplicate rejection, and ending sessions.
- Report generation test verifying PDF document layout and CSV format.

### Manual Verification
- Execute all 5 end-to-end scenarios documented in [`quickstart.md`](file:///c:/Projects/student_management_system/specs/004-lesson-based-attendance/quickstart.md).
