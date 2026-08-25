# Contract: 5-Part Reporting Service & Report Cubit API

**Component**: `ReportCubit` (`lib/features/reports/cubits/report_cubit.dart`)

---

## 1. Public Report Generation Methods

### `generateLessonSessionReport(int lessonId)`
* **Description**: Generates a detailed PDF report for a single completed or active lesson session.
* **Outputs**:
  - Header: Group Name, Date, Time Slot, Lesson Topic/Title.
  - KPI Cards: Enrolled Students, Present Count, Other Group Count, Absent Count, Attendance Rate %.
  - Roster Table: Serial #, Student Name, Status (`حضر` / `درس آخر` / `غائب`), Notes.
* **Emits**: `ReportState(isGenerated: true, pdfDocument: doc)`

### `generateAbsenteeFollowUpReport({int? lessonId, int? groupId, DateTime? fromDate, DateTime? toDate})`
* **Description**: Generates a dedicated contact sheet PDF for absent students.
* **Outputs**:
  - Filter description (Lesson date/time or date range).
  - Absentee List Table:
    - Serial #
    - Student Name
    - Group Name
    - Parent Phone 1 (`phone1`)
    - Parent Phone 2 (`phone2`)
    - Father's Occupation (`father_job`)
* **Emits**: `ReportState(isGenerated: true, pdfDocument: doc)`

### `generateGroupAttendanceSummaryReport({required int groupId, DateTime? fromDate, DateTime? toDate})`
* **Description**: Aggregates multi-lesson attendance for a specific group across a date range.
* **Outputs**:
  - Group details and total lessons held.
  - Summary stats: Total Sessions, Average Attendance Rate.
  - Student breakdown table: Student Name, Total Attended, Total Absent, Attendance %.
* **Emits**: `ReportState(isGenerated: true, pdfDocument: doc)`

### `generateStudentReport(int studentId)` *(Updated)*
* **Description**: Updates the existing student comprehensive profile report to include lesson-specific attendance entries (`lesson_date`, `group_name`, `start_time`, `status`, `notes`) and student overall attendance %.
* **Emits**: `ReportState(isGenerated: true, pdfDocument: doc)`

### `exportAttendanceCsv({int? groupId, DateTime? fromDate, DateTime? toDate})`
* **Description**: Exports attendance records to CSV formatted with lesson columns:
  - Columns: `Lesson Date, Lesson Time, Lesson Group, Student Serial, Student Name, Student Group, Status, Notes`
* **Returns**: `String` (CSV formatted string) or saves file directly to device.
