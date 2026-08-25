# Interface Contract: Student Serial Number Auto-Generation

## Service & Helper Contract

### `StudentSerialHelper`

#### Method: `getNextSerialNumber(String grade)`
- **Input**: `grade` (String, required - must be one of `['prep_1', 'prep_2', 'prep_3', 'sec_1', 'sec_2', 'sec_3']`).
- **Output**: `Future<String>` - Returns the next auto-incremented 5-digit serial string for the specified grade.
- **Behavior**:
  - Queries `students` table where `grade = ?`.
  - Parses numeric serials and computes `max(serial) + 1` relative to `kGradeBaseSerials[grade]`.
  - Returns formatted serial string (e.g. `"10777"`).

---

## Form Component Contract

### `StudentFormScreen` & `StudentAcademicSection`
- **Default Grade State**: `prep_1`
- **Grade Items**: Excludes `null` / "Not Specified". Lists 6 valid grades (`prep_1`..`sec_3`).
- **Form Layout**: Serial Number TextField placed at the bottom of the form body.
- **Serial Field Mode**: Read-only, disabled for user input, displaying current calculated next serial.
