# Contract: Lesson Management Cubit & API

**Component**: `LessonCubit` (`lib/features/attendance/cubits/lesson_cubit.dart`)

---

## 1. State Definition

```dart
@freezed
abstract class LessonState with _$LessonState {
  const factory LessonState({
    @Default([]) List<Lesson> dailyLessons,
    Lesson? activeLesson,
    @Default([]) List<Map<String, dynamic>> attendedRoster,
    @Default([]) List<Map<String, dynamic>> absentRoster,
    @Default(false) bool isLoading,
    @Default(false) bool scanSuccess,
    String? lastScannedStudent,
    String? error,
    DateTime? selectedDate,
  }) = _LessonState;
}
```

---

## 2. Public Methods

### `loadLessonsForDate(DateTime date)`
* **Description**: Queries `lessons` table for existing sessions on `date` and merges with dynamic unstarted slots from `group_schedules` for that day of the week.
* **Emits**: `state.copyWith(dailyLessons: mergedLessons, selectedDate: date, isLoading: false)`

### `startLesson(Lesson lesson)`
* **Description**: If `lesson.id == null`, inserts a new row into `lessons` table with `status = 'in_progress'`. If `lesson.id != null`, updates status to `'in_progress'`. Sets `activeLesson`.
* **Emits**: `state.copyWith(activeLesson: startedLesson, scanSuccess: false, error: null)`
* **Triggers**: `loadRosterForActiveLesson()`

### `loadRosterForActiveLesson()`
* **Description**:
  1. Queries all students enrolled in `activeLesson.groupId`.
  2. Queries all attendance records for `activeLesson.id`.
  3. Derives `attendedRoster` (scanned + other group) and `absentRoster` (enrolled minus attended).
* **Emits**: `state.copyWith(attendedRoster: attended, absentRoster: absent)`

### `recordScanInActiveLesson(String serialNumber)`
* **Description**:
  1. Validates `activeLesson != null`.
  2. Finds student by `serialNumber`.
  3. Verifies student is not already recorded in `activeLesson.id`.
  4. Determines status: `attended` (if in group) or `otherLesson` (if another group).
  5. Inserts into `attendance` table with `lesson_id = activeLesson.id`.
  6. Reloads live roster.
* **Emits**: `state.copyWith(scanSuccess: true, lastScannedStudent: studentName, error: null)` or `error` if duplicate/not found.

### `toggleManualAttendance(int studentId, AttendanceStatus status, {String notes = ''})`
* **Description**: Allows 1-tap marking present for an absent student from the live absent tab.
* **Action**: Inserts into `attendance` table and refreshes active roster.

### `endLesson(int lessonId)`
* **Description**: Updates `lessons SET status = 'completed' WHERE id = ?`.
* **Emits**: `state.copyWith(activeLesson: null)` and refreshes daily lessons.

### `reopenLesson(int lessonId)`
* **Description**: Updates `lessons SET status = 'in_progress' WHERE id = ?` and sets `activeLesson`.
