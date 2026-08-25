# Feature Specification: Auto-Generated Student Serial Number by Grade

**Feature Branch**: `002-auto-student-serial`

**Created**: 2026-08-02

**Status**: Draft

**Input**: User description: "I want to apply auto generated serial number for this app when adding new students . First each grade from prep1 to sec3 has uniques code for the serial . use 10777 as a starting counter for prep1 -- prep2 will use 20777 as a starting serial and so on . so for example when adding new student for prepartion1 grade his serial will be 10777 and when adding another student it will be 10778 and so on . this example applies for all grades. so in add student form the serial will be auto generated and the serial number will be the last field . now the grade will be mandatory field and make the deafult selection is prep 1 and remove non specified option from the list . so when adding new student the serial will be on the bottom telling the new serial of the student based on grade and the student order (which has started from 777)"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Auto-generating Student Serial Number on Add (Priority: P1)

As an administrator adding a new student to the system, I want the system to automatically generate and display the next available serial number based on the selected grade so that I do not need to manually calculate or type serial numbers.

**Why this priority**: Core value of the feature, eliminating manual serial number entry errors and ensuring unique structured student identification.

**Independent Test**: Open the Add Student form, observe that Grade defaults to Prep 1 and the serial number field at the bottom displays `10777`. Change grade to Prep 2 and verify the serial number field automatically updates to `20777`. Submit the form and verify the student is saved with the displayed serial.

**Acceptance Scenarios**:

1. **Given** an admin opens the Add Student form, **When** the form loads, **Then** Grade is mandatory, defaults to "Prep 1", the "Not Specified" option is absent from the grade list, and the bottom serial field displays `10777` (or `10777 + existing Prep 1 student count`).
2. **Given** an admin is on the Add Student form, **When** the admin changes the selected grade from "Prep 1" to "Prep 2", **Then** the auto-generated serial number field at the bottom dynamically updates to `20777` (or `20777 + existing Prep 2 student count`).
3. **Given** an admin fills in mandatory student details with Grade "Prep 1", **When** the student is saved, **Then** the student receives serial `10777`, and opening the Add Student form again for Prep 1 shows `10778` as the next serial number.

---

### User Story 2 - Mandatory Grade Selection & Mandatory Form Validation (Priority: P2)

As an administrator, I want Grade to be a mandatory field without an unspecified option so that every student is explicitly assigned to a valid academic grade.

**Why this priority**: Prevents invalid database states where a student has no grade or an uncalculated serial prefix.

**Independent Test**: Attempt to submit the Add Student form without selecting a grade (or check dropdown options) to ensure only valid grades (`Prep 1` to `Sec 3`) exist in the selection list.

**Acceptance Scenarios**:

1. **Given** the grade dropdown menu in the student form, **When** an admin expands the dropdown, **Then** only valid academic grades (`Prep 1`, `Prep 2`, `Prep 3`, `Sec 1`, `Sec 2`, `Sec 3`) are listed, and "Not Specified" is not available.
2. **Given** the student creation form, **When** a user attempts to clear the grade, **Then** validation prevents submission and enforces choosing a valid grade.

---

### User Story 3 - Distinct Grade Serial Ranges (Priority: P3)

As an administrator, I want each grade from Prep 1 through Sec 3 to have its own unique starting serial counter (Prep 1: 10777, Prep 2: 20777, Prep 3: 30777, Sec 1: 40777, Sec 2: 50777, Sec 3: 60777) so that student serials visually identify their grade and sequential enrollment order.

**Why this priority**: Provides clear organizational structure across different academic stages and prevents serial collisions between grades.

**Independent Test**: Select each grade in turn in the Add Student form and verify the prefix and base order start at `X0777` (where X is 1 for Prep 1, 2 for Prep 2, 3 for Prep 3, 4 for Sec 1, 5 for Sec 2, and 6 for Sec 3).

**Acceptance Scenarios**:

1. **Given** grade selection values, **When** evaluating the starting serial for each grade, **Then** Prep 1 starts at `10777`, Prep 2 starts at `20777`, Prep 3 starts at `30777`, Sec 1 starts at `40777`, Sec 2 starts at `50777`, and Sec 3 starts at `60777`.

---

### Edge Cases

- **Existing Students in DB**: If students already exist in the database for a grade, the generated serial MUST find the highest numerical serial in that grade range or use `(BaseSerial + count)` such that no duplicate serial numbers are generated.
- **Editing Existing Students**: When editing an existing student, their existing serial number MUST be preserved and read-only, and changing grade in edit mode should prompt/handle serial updates cleanly according to system rules.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST automatically generate student serial numbers based on the selected academic grade.
- **FR-002**: Each grade MUST have a predefined starting serial counter:
  - `Prep 1`: Starting serial `10777`
  - `Prep 2`: Starting serial `20777`
  - `Prep 3`: Starting serial `30777`
  - `Sec 1`: Starting serial `40777`
  - `Sec 2`: Starting serial `50777`
  - `Sec 3`: Starting serial `60777`
- **FR-003**: The generated serial number for a grade MUST increment sequentially for each new student added to that grade (e.g., 10777, 10778, 10779...).
- **FR-004**: In the Add Student form, the Serial Number field MUST be located as the last (bottom) field on the form.
- **FR-005**: In the Add Student form, the Serial Number field MUST be read-only and automatically updated whenever the selected grade changes.
- **FR-006**: The Grade field MUST be mandatory in student creation.
- **FR-007**: The default grade selection on opening the Add Student form MUST be `Prep 1`.
- **FR-008**: The "Not Specified" ("غير محدد") option MUST be removed from the grade selection list.

### Key Entities *(include if feature involves data)*

- **Student**: Represents an enrolled student.
  - `serial_number`: Unique String code identifying the student (e.g. "10777").
  - `grade`: Mandatory String key representing the academic stage (`prep_1`, `prep_2`, `prep_3`, `sec_1`, `sec_2`, `sec_3`).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of newly created students receive a valid, unique auto-generated serial number matching their grade's sequence.
- **SC-002**: 0% of student creation attempts result in missing or "Not Specified" grade values.
- **SC-003**: Selecting a different grade in the form updates the displayed serial number in under 200 milliseconds.

## Assumptions

- Grade sequence starts at base `X0777` where `X` is 1 for Prep 1 through 6 for Sec 3.
- Existing database records with custom or existing serial numbers are respected, and new serials increment from max existing serial or starting base `X0777`.
- The serial number field is read-only for automatic generation during new student creation.
