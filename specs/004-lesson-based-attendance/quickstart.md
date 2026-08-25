# Quickstart & Verification Guide: Lesson-Based Attendance System

**Feature**: `004-lesson-based-attendance`  
**Date**: 2026-08-25  
**Spec**: [spec.md](file:///c:/Projects/student_management_system/specs/004-lesson-based-attendance/spec.md)

---

## 1. Prerequisites & Setup

1. **Start Application**:
   ```bash
   flutter run -d windows # or target device
   ```
2. **Ensure Test Data Exists**:
   - At least 2 Groups (e.g. `Group A` and `Group B`) with scheduled days in `group_schedules`.
   - At least 3 Students in `Group A` and 1 Student in `Group B` with valid `serial_number`s.

---

## 2. End-to-End Validation Scenarios

### Scenario 1: Starting a Lesson Session & Locking Scanner
1. Navigate to **Attendance** from main navigation.
2. Select today's date on the daily lessons calendar/bar.
3. Observe scheduled lessons derived from `group_schedules`.
4. Tap **"Start Lesson"** for `Group A`.
5. **Expected Outcome**:
   - Session status changes to `In Progress`.
   - Top banner locks to `Group A` showing `0 / [Enrolled Students]`.
   - Scanner (Camera on mobile or hardware scanner input on desktop) is active.

---

### Scenario 2: Scanning QR Codes & Real-Time Roster Updates
1. Enter or scan a Student belonging to `Group A`.
   - **Expected Outcome**: Instant snackbar confirms attendance ("Attended in Group"), live counter increments to `1 / N`, student appears in **Attended** tab.
2. Enter or scan a Student belonging to `Group B` (different group).
   - **Expected Outcome**: Marked as `Other Lesson` with note `"حضر في مجموعة Group A"`.
3. Try re-scanning the same student.
   - **Expected Outcome**: Error snackbar warning that student is already recorded in this active lesson session.

---

### Scenario 3: Absentee Management & 1-Tap Manual Toggle
1. Tap the **"Absent"** tab on the live roster.
2. Observe all enrolled students from `Group A` who have not been scanned.
3. Tap **"Mark Present"** next to an absent student.
4. **Expected Outcome**: Student immediately moves from Absent to Attended list and counter increments.

---

### Scenario 4: Concluding Lesson & Summary Dialog
1. Tap **"End Lesson"**.
2. **Expected Outcome**: Summary Dialog pops up with:
   - Present Total
   - Other Group Total
   - Absent Total
   - Attendance Rate %
3. Tap **"Confirm End Lesson"**.
4. **Expected Outcome**: Lesson transitions to `Completed` and is saved to database.

---

### Scenario 5: 5-Part Reporting Engine Verification
1. Navigate to **Reports -> Attendance Reports**.
2. **Per-Lesson PDF Report**: Select the completed lesson and tap "Generate PDF" $\rightarrow$ Verify KPI cards and student roster table.
3. **Absentee Follow-Up Sheet**: Generate Absentee Sheet for `Group A` $\rightarrow$ Verify parent phone numbers (`phone1`, `phone2`) are displayed.
4. **Group Multi-Lesson Summary**: Generate group report for `Group A` over date range $\rightarrow$ Verify session aggregates.
5. **CSV Export**: Tap "Export Attendance CSV" $\rightarrow$ Verify CSV file contains `lesson_date`, `lesson_time`, `lesson_group`, `student_serial`, and `status`.
