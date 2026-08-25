# Phase 0 Research: Auto-Generated Student Serial Number by Grade

## 1. Grade Prefix & Base Counter Mapping

### Decision
Each academic grade maps to a unique 5-digit starting serial counter:

| Grade Key | Grade Label (EN / AR) | Base Serial Counter | Prefix | Starting Order |
|---|---|---|---|---|
| `prep_1` | 1st Prep / الصف الأول الإعدادي | `10777` | 10 | 777 |
| `prep_2` | 2nd Prep / الصف الثاني الإعدادي | `20777` | 20 | 777 |
| `prep_3` | 3rd Prep / الصف الثالث الإعدادي | `30777` | 30 | 777 |
| `sec_1` | 1st Sec / الصف الأول الثانوي | `40777` | 40 | 777 |
| `sec_2` | 2nd Sec / الصف الثاني الثانوي | `50777` | 50 | 777 |
| `sec_3` | 3rd Sec / الصف الثالث الثانوي | `60777` | 60 | 777 |

### Rationale
- Uses a deterministic 5-digit number structure where the first 2 digits reflect the academic grade and the last 3 digits start at `777` and increment sequentially for each student added.
- Ensures instant visual recognition of student grade from their serial number.

---

## 2. Next Serial Calculation Algorithm

### Decision
When opening the Add Student form or switching the selected grade:
1. Retrieve existing serial numbers for the target grade from the SQLite database.
2. Filter for numeric serials belonging to the target prefix.
3. If no existing records are found for that grade, return the base starting serial (e.g., `10777` for `prep_1`).
4. If records exist, calculate `MAX(numeric_serial) + 1`. If the maximum existing serial is below the base starting serial, use base starting serial.
5. Format result as String and populate the read-only Serial Number field.

---

## 3. UI Form Layout & Mandatory Grade Rule

### Decision
1. **Grade Field**:
   - Mandatory input (cannot be null).
   - Default selection on new student form initialization: `prep_1`.
   - Remove `null` ("Not Specified" / "غير محدد") option from `DropdownMenuItem` list in `student_academic_section.dart`.
2. **Serial Number Field**:
   - Positioned as the **last (bottom)** field in `student_form_screen.dart`.
   - Set to `readOnly: true` or disabled text field with distinct auto-generated visual styling.
   - Automatically re-calculates and refreshes whenever `selectedGrade` changes.
