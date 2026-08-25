# Research & Architectural Decisions: Lesson-Based Attendance System

**Feature**: `004-lesson-based-attendance`  
**Date**: 2026-08-25  
**Spec**: [spec.md](file:///c:/Projects/student_management_system/specs/004-lesson-based-attendance/spec.md)

---

## 1. Research Questions & Technology Decisions

### R-001: Data Modeling & Schema Strategy for Lessons and Multi-Session Attendance
- **Problem**: Previously, attendance was keyed purely on `(student_id, date)`. This prevented teachers from having multiple lessons per day (e.g. Morning Class and Evening Class, or distinct groups meeting on the same date) and failed to track session-level metadata (such as lesson status and absentee rosters).
- **Decision**: Introduce a first-class `lessons` table (`id`, `group_id`, `date`, `start_time`, `end_time`, `title`, `status`, `created_at`) and add a foreign key `lesson_id` to the `attendance` table.
- **Rationale**:
  - Normalized structure enables clean one-to-many relationship: One Lesson has many Student Attendance records.
  - Allows multiple sessions for different groups (or even the same group) on the same date without primary key/uniqueness collisions.
  - Enables live attendance rate calculation per lesson and dynamic absentee rosters.
- **Alternatives Considered**:
  - *Tagging attendance with `group_id` and `time_slot` directly without a `lessons` table*: Rejected because it lacks session lifecycle management (`scheduled`, `in_progress`, `completed`), cannot store lesson topics/notes, and cannot represent a lesson with zero scans.

---

### R-002: Lesson Materialization vs. Dynamic Schedule Generation
- **Problem**: Groups meet on specific recurring weekly schedules (stored in `group_schedules`). Persisting empty `lessons` rows in advance for months into the future would clutter the database with unused entries on holidays, exam weeks, or off-days.
- **Decision**: On-Demand Materialization. When the teacher views the daily timetable for a date, scheduled lessons are computed dynamically from `group_schedules`. When the teacher taps "Start Lesson" (or manually creates an ad-hoc session), a physical row is inserted into `lessons` table with `status = 'in_progress'`.
- **Rationale**: Zero database bloat. Matches real classroom operation while preserving historical records once a session has actually started or completed.
- **Alternatives Considered**:
  - *Pre-inserting `lessons` rows for every schedule on every date*: Rejected due to database pollution and complex cleanup for cancellations/holidays.

---

### R-003: Real-Time Live Roster & Absentee Derivation Strategy
- **Problem**: Teachers need immediate visibility into which enrolled students have arrived and which are missing without having to manually calculate diffs or write hundreds of absent rows to disk upfront.
- **Decision**: Dynamic Set Diffing in `AttendanceCubit`.
  - Enrolled group roster is loaded from `students WHERE group_id = active_lesson.group_id`.
  - Attended set is queried from `attendance WHERE lesson_id = active_lesson.id`.
  - Absent roster is derived in memory: `enrolled_students.where((s) => !attended_student_ids.contains(s.id))`.
  - When the teacher taps "Mark Present" on an absent student, a standard attendance record is inserted into SQLite and the UI state refreshes reactively.
- **Rationale**: Sub-millisecond computation in Dart, zero disk I/O overhead during high-speed QR scanning, and immediate reactive updates.

---

### R-004: Backward Compatibility & Historical Data Migration Strategy
- **Problem**: Existing production databases contain historical attendance records stored with `(student_id, date, status, notes)` where `lesson_id` is null.
- **Decision**: Idempotent SQL Migration in `DatabaseService._onOpen`.
  1. Add `lessons` table and `idx_lessons_group`, `idx_lessons_date`, `idx_attendance_lesson`.
  2. Add `lesson_id` column to `attendance` via `ALTER TABLE attendance ADD COLUMN lesson_id INTEGER;`.
  3. Execute migration script: For each unique `(date, student.group_id)` combination in legacy attendance records, find or insert a baseline `lessons` row (`status = 'completed'`, `start_time = '00:00'`) and update existing `attendance.lesson_id`.
- **Rationale**: Ensures existing PDF reports, student profile history, and stats continue to operate without null pointer exceptions or separate legacy query branches.

---

### R-005: 5-Part Reporting Engine Architecture
- **Problem**: The new lesson-based attendance model requires 5 distinct reporting outputs with Arabic RTL layout, PDF generation, and CSV exports:
  1. Per-Lesson Session PDF Report
  2. Group Multi-Lesson Summary Report
  3. Absentee Follow-Up Phone Sheet (with `phone1`, `phone2`)
  4. Updated Individual Student Profile Report
  5. Enhanced CSV Export
- **Decision**: Centralize queries in `DBQueries` and document builders in `ReportCubit` and `ReportService`.
  - Use `pdf` package (`pw.Document`, `pw.TableHelper.fromTextArray`, `PdfPageFormat.a4`) with Amiri Arabic font support.
  - Add summary KPI cards (`pw.Container` with badges) for Enrolled, Present, Other Group, Absent, and Attendance %.
- **Rationale**: Clean separation of data retrieval and PDF layout composition, fully reusable across mobile and desktop.
