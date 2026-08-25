# Feature Specification: Lesson-Based Attendance System

**Feature Branch**: `004-lesson-based-attendance`

**Created**: 2026-08-25

**Status**: Ready for Planning

**Input**: User description: "the teacher should have number of lessons per day and attendance should be recorded for each lessons and the lesson is specified for a group .tell me the best way for applying this attendance and suggest me if you have options. I want also to address reporting system regarding this attendance update"

## Clarifications

### Session 2026-08-25
- Q: When a teacher finishes a class and taps "End Lesson", what UX flow should occur? → A: Option A (Summary Confirmation Dialog showing present, other-group, and absent totals with a "Confirm End Lesson" action, allowing reopening the lesson later if needed).
- Q: When the teacher views the daily timetable or opens the attendance screen for a date, how should scheduled lessons be persisted in the database? → A: Option A (On-Demand Record Creation: Daily schedules are shown dynamically from group schedules; a `lessons` database record is created once the teacher taps "Start Lesson" or manually adds a custom session).
- Q: How should existing attendance records be migrated to the new schema? → A: Option A (Unified Auto-Migration: Automatically creates historical lesson sessions for past attendance dates/groups and links existing records so all historical reports work seamlessly).
- Q: Which reporting features should be included for the lesson-based attendance system? → A: Option 1 (Full Reporting Suite: Per-Lesson Session PDF Report, Group Multi-Lesson Summary, Absentee Follow-Up Phone Sheet, Student Profile Report Attendance Log, and Enhanced CSV Export).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Start Lesson Session & QR Attendance Scanning (Priority: P1)

As a teacher or assistant running classes, I want to start a lesson session for a specific group (chosen from today's scheduled classes or created ad-hoc) so that the attendance scanner is explicitly locked to that active lesson, ensuring all student scans are recorded for that specific session.

**Why this priority**: Core value of the feature. Introduces structured session-based attendance where attendance records are tied to distinct lesson sessions rather than flat calendar dates.

**Independent Test**:
Can be fully tested by selecting a group scheduled for today, clicking "Start Lesson", scanning a student belonging to that group, and verifying the student is recorded as "Attended in Group" for this active session.

**Acceptance Scenarios**:

1. **Given** a group has a scheduled lesson or an ad-hoc lesson is created for today, **When** the teacher initiates the session by tapping "Start Lesson", **Then** a lesson record is created in the database with status `in_progress`, the active lesson header displays the group name, schedule time, and live attendance counter (e.g., `0/25`), and the scanner is enabled for that session.
2. **Given** an active lesson session is running, **When** an enrolled student from that lesson's group is scanned via QR code or manual serial entry, **Then** the student's attendance is recorded as `attended` ("Attended in Group") for that specific lesson instance and the student cannot be scanned twice for the same lesson.
3. **Given** an active lesson session is running, **When** a student belonging to a different group (or with no assigned group) is scanned, **Then** the attendance is recorded as `otherLesson` linked to the active lesson with a note indicating attendance in this lesson.
4. **Given** a student is already marked present in the active lesson, **When** the same student's QR code is scanned again in the same lesson, **Then** the system displays a warning message stating attendance is already recorded for this lesson and does not create a duplicate record.

---

### User Story 2 - End Lesson Session & Live Roster / Absentee Review (Priority: P2)

As a teacher or assistant, I want to see a live roster of attended vs. absent students during the session, with the ability to manually mark present, and tap "End Lesson" to view a summary confirmation dialog before concluding the session.

**Why this priority**: Provides instant visibility over who is present and who is missing, enables quick manual overrides for students who forgot their cards, and provides a clear summary before locking the session.

**Independent Test**:
Can be tested by opening an active lesson with 10 enrolled students, scanning 7 students, verifying that the "Absent" tab lists the remaining 3 students, manually toggling 1 student to present, and tapping "End Lesson" to view the summary dialog and complete the session.

**Acceptance Scenarios**:

1. **Given** an active lesson session, **When** the teacher views the lesson roster, **Then** the roster displays two tabs: "Attended" (scanned and other-lesson students) and "Absent" (enrolled students who have not yet been scanned).
2. **Given** a student is displayed in the "Absent" list, **When** the teacher taps "Mark Present" or enters an excuse note for that student, **Then** the student is recorded as attended for this lesson and moves to the "Attended" list immediately.
3. **Given** class has concluded, **When** the teacher taps "End Lesson", **Then** a Summary Confirmation Dialog is displayed showing total present, other-group attendees, and absent counts with a "Confirm End Lesson" action.
4. **Given** the teacher confirms the end of the lesson, **When** the dialog action is triggered, **Then** the session status is set to `completed`, the session is locked against further scans, and the teacher can reopen the lesson later from the daily schedule if an adjustment is needed.

---

### User Story 3 - Daily Lessons Schedule & Multi-Lesson Support (Priority: P3)

As a teacher or administrator, I want to view all scheduled lessons for any given day dynamically from weekly schedules, see which lessons are scheduled, in-progress, or completed, and add extra/revision lessons on the fly.

**Why this priority**: Enables teachers with multiple classes per day to organize their daily timetable and accommodate extra sessions without database clutter.

**Independent Test**:
Can be tested by scheduling two lessons on the same day for Group A and Group B, completing Group A's lesson, starting Group B's lesson, and verifying that a student can attend both lessons if needed without cross-lesson conflicts.

**Acceptance Scenarios**:

1. **Given** group schedules exist, **When** navigating to the attendance / lesson screen for any date, **Then** scheduled lessons are computed dynamically from `group_schedules` alongside already instantiated lessons with status indicators (`scheduled`, `in_progress`, `completed`).
2. **Given** an extra revision class or make-up session is needed, **When** the teacher taps "Add Lesson" and selects a group, date, and time, **Then** the new lesson is instantiated in the daily schedule ready to be started.
3. **Given** a student is enrolled in or attends two different lessons on the same day, **When** attendance is recorded in each lesson session, **Then** both attendance records exist independently without date-level duplication errors.

---

### User Story 4 - Comprehensive Lesson & Absentee Reporting Suite (Priority: P4)

As an administrator, teacher, or assistant, I want a complete reporting suite with Per-Lesson breakdown reports, Group Attendance Summaries, Absentee Contact Follow-Up sheets, and updated student profiles to communicate with parents and archive classroom statistics.

**Why this priority**: Directly addresses parental communication, administrative oversight, and student progress tracking.

**Independent Test**:
Can be tested by generating:
1. A Per-Lesson PDF report showing KPI summary cards and student roster.
2. An Absentee Follow-Up PDF sheet listing absentees with parent phone numbers.
3. An updated Student Profile PDF report showing lesson attendance logs and rate %.
4. An exported CSV containing lesson date, group, and time columns.

**Acceptance Scenarios**:

1. **Given** a completed lesson, **When** generating a Per-Lesson Report, **Then** the PDF contains the lesson header (group, date, time slot, title), summary statistics (enrolled, present, other group, absent, attendance rate %), and the full student attendance roster.
2. **Given** an active or completed lesson, **When** generating an Absentee Follow-Up Sheet, **Then** the report lists all absent students along with their parent contact numbers (`phone1`, `phone2`) and father's occupation for follow-up calls.
3. **Given** a group and date range, **When** generating a Group Attendance Summary Report, **Then** the PDF shows aggregate session statistics and student participation rates across the period.
4. **Given** a student profile report is requested, **When** the report is generated, **Then** the attendance section includes lesson details (group, date, time, status) alongside overall attendance rate percentage.
5. **Given** the attendance data export is requested, **When** exporting to CSV, **Then** the output contains lesson-specific columns (`lesson_date`, `lesson_time`, `lesson_group`, `student_serial`, `student_name`, `status`, `notes`).

---

### Edge Cases

- **Multiple lessons in a day for the same group**: The system allows distinct lesson sessions for the same group on the same day (e.g. Morning Session and Evening Revision), each with its own independent attendance roster.
- **Student attends multiple lessons on the same day**: System records attendance per lesson session, allowing attendance in both Lesson 1 and Lesson 2 on the same calendar date.
- **Accidental re-scan in the same lesson**: System alerts user that the student is already checked into the active lesson and prevents duplicate record creation.
- **Lesson ended accidentally**: System allows a completed lesson to be reopened or edited from the daily schedule view if attendance needs adjustment.
- **Student with no assigned group**: System records attendance under the active lesson with status `otherLesson` and note indicating student has no assigned group.
- **Scanning while no lesson is active**: If scanner is opened without an active lesson, the system prompts the teacher to select and start a lesson first or offers 1-click start for the current scheduled group.
- **Generating Absentee Sheet for 100% Attendance**: When all enrolled students attended, the absentee sheet indicates "Zero absences recorded for this session".

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support a session-based lesson entity where each lesson is tied to a specific `group_id`, `date`, `start_time`, optional `end_time`, optional `title`, and session `status` (`scheduled`, `in_progress`, `completed`, `cancelled`).
- **FR-002**: System MUST dynamically display daily lesson slots derived from weekly group schedules (`group_schedules`) and only persist a database row in `lessons` table upon explicit session activation ("Start Lesson") or ad-hoc lesson creation.
- **FR-003**: System MUST allow teachers to manually create, edit, or cancel individual ad-hoc lesson sessions on any date.
- **FR-004**: System MUST require an explicit "Start Lesson" action to activate a lesson session (`status = 'in_progress'`) before QR/manual scanning begins for that session.
- **FR-005**: Scanner screen MUST lock to the active `in_progress` lesson, displaying group name, schedule time, and live attendance counter (`[attended_count] / [enrolled_count]`).
- **FR-006**: System MUST link all student attendance records directly to the active `lesson_id` rather than only to a calendar date.
- **FR-007**: System MUST prevent duplicate attendance records for the same `student_id` in the same `lesson_id`.
- **FR-008**: System MUST allow a student to have valid attendance records in multiple distinct lessons on the same date.
- **FR-009**: System MUST support the three standard attendance statuses:
  - `attended`: Student is enrolled in the active lesson's group and checked in.
  - `otherLesson`: Student belongs to a different group (or has no group) and checked into this active lesson.
  - `missed`: Enrolled student who did not attend the lesson.
- **FR-010**: System MUST provide a real-time Lesson Roster view featuring:
  - **Attended Tab**: All students scanned or marked present in this lesson.
  - **Absent Tab**: All enrolled group students who have not yet been scanned, with a 1-tap "Mark Present" toggle.
- **FR-011**: System MUST show a Lesson Summary Dialog upon tapping "End Lesson", presenting total present, other-group, and absent student counts before confirming completion, transitioning status to `completed`, and allowing reopening if needed.
- **FR-012**: System MUST allow teachers to view historical lessons, reopen or adjust attendance if needed, and view completed lesson summaries.
- **FR-013**: System MUST generate a **Per-Lesson Session PDF Report** displaying:
  - Header: Group Name, Date, Time Slot, Lesson Title/Topic.
  - Summary KPI Cards: Enrolled Students, Present Count, Other Group Count, Absent Count, Attendance Rate %.
  - Roster Table: Serial Number, Student Name, Status (`حضر` / `درس آخر` / `غائب`), Notes.
- **FR-014**: System MUST generate an **Absentee Follow-Up Sheet PDF** filtered by lesson or date range, listing all absent students with their parent phone numbers (`phone1`, `phone2`) and father's occupation for follow-up communication.
- **FR-015**: System MUST generate a **Group Multi-Lesson Summary PDF Report** showing aggregated lesson attendance statistics and student attendance rates across a selected date range.
- **FR-016**: System MUST update the **Individual Student Profile Report** to display detailed lesson session attendance logs (group, date, start time, status) alongside overall attendance rate %.
- **FR-017**: System MUST update the **Attendance CSV Export** to include lesson-specific columns (`lesson_date`, `lesson_time`, `lesson_group`, `student_serial`, `student_name`, `status`, `notes`).
- **FR-018**: System MUST execute a clean database migration from the legacy flat `attendance` table to the new session-linked lesson attendance schema by creating baseline historical `lessons` entries for past attendance dates/groups and linking legacy records seamlessly.

### Key Entities

- **Lesson (`lessons`)**:
  - Represents a specific classroom lesson session.
  - *Attributes*: `id` (INTEGER PK), `group_id` (INTEGER FK), `date` (TEXT 'YYYY-MM-DD'), `start_time` (TEXT), `end_time` (TEXT), `title` (TEXT), `status` (TEXT: 'scheduled', 'in_progress', 'completed', 'cancelled'), `created_at` (TEXT).
- **Lesson Attendance (`attendance` / `lesson_attendance`)**:
  - Represents an individual student's attendance record in a specific lesson.
  - *Attributes*: `id` (INTEGER PK), `lesson_id` (INTEGER FK), `student_id` (INTEGER FK), `date` (TEXT 'YYYY-MM-DD'), `status` (TEXT: 'attended', 'otherLesson', 'missed'), `notes` (TEXT), `created_at` (TEXT).
- **Group (`groups`)**:
  - Represents a class/batch of students with associated weekly schedules (`group_schedules`).
- **Student (`students`)**:
  - Represents an enrolled student with unique `serial_number`, parent phone contacts (`phone1`, `phone2`), father's job, and assigned `group_id`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Teachers can launch a scheduled lesson session and begin scanning in under 2 clicks / under 3 seconds.
- **SC-002**: Scanning a student QR code processes, validates against the active lesson, and updates the live roster in under 300 milliseconds.
- **SC-003**: 100% prevention of duplicate attendance scans within the same lesson while supporting multiple distinct lesson attendances on the same day.
- **SC-004**: Real-time absent student list is derived automatically with zero manual calculation, allowing 1-tap manual present toggle.
- **SC-005**: All 5 reporting types (Per-Lesson Report, Group Summary, Absentee Follow-Up Sheet, Student Report, and CSV Export) generate in under 3 seconds for datasets up to 1,000 records.
- **SC-006**: All historical attendance records remain accessible and accurately represented after database schema migration.

## Assumptions

- A teacher runs one active lesson session at a time on a single scanning device.
- Standard student QR cards containing `serial_number` will continue to be used without requiring any card reprinting.
- Lessons for any given date are calculated dynamically from `group_schedules` when viewing that date, eliminating manual recurring data entry.
- Existing historical attendance records will be linked to automatically generated baseline lessons during migration.
