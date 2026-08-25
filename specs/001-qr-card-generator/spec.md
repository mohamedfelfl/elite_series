# Feature Specification: QR Card Generator

**Feature Branch**: `001-qr-card-generator`

**Created**: 2026-08-01

**Status**: Draft

**Input**: User description: "Analyze the current project regarding architecture , design pattern , project structure . I want to add new feature which is QR card generator. Add new tab for this feature . this feature will allow to generate QR for student , group, stage or all students with dropdown menu options for these selections and also search bar beside it to search for a specific student. the screen should also contain a preiview panel to the left which will show the card with student data on it . also the right panel should show the right list of the chosen students . use the same design system of this app. the card design is attached below which will be used as template for generating the data for the student or more than one student. the screen should also contain buttons for generating these cards"

## Clarifications

### Session 2026-08-01

- Q: What export formats should be provided when generating student QR cards? → A: Option C - Individual PNG / JPEG image files only.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Single Student QR Card Preview and Generation (Priority: P1)

As an administrator or assistant, I want to search for a specific student or pick a student from the student list so that I can immediately view their personalized QR card preview and generate/print/export their individual QR ID card as an image.

**Why this priority**: Core value of the feature is rendering and exporting accurate student QR ID cards. Single student selection provides the foundational preview and single-card export capability.

**Independent Test**: Select a specific student using the search bar or list, verify that the left panel updates with their data (Name, Stage, Group, ID, generated QR code, branding elements), and verify that clicking the generate button produces the exportable/printable PNG image card.

**Acceptance Scenarios**:

1. **Given** the user is on the QR Card Generator screen, **When** they select "Student" from the dropdown and type a student's name/ID in the search bar, **Then** the right panel displays matching students.
2. **Given** a list of matching students in the right panel, **When** the user clicks on a student item, **Then** the left panel immediately updates to display a live preview of that student's QR ID card following the designated template layout.
3. **Given** a selected student with a valid preview, **When** the user clicks the "Generate/Export Card" button, **Then** the system generates a high-resolution PNG image file of the student card.

---

### User Story 2 - Bulk QR Card Selection by Group, Stage, or All Students (Priority: P2)

As an administrator or assistant, I want to select cards by Group, Stage, or All Students using the dropdown filter so that I can generate QR cards in batch for entire classes or stages without manually selecting each student.

**Why this priority**: Essential efficiency feature for bulk operations (e.g. start of term card printing for an entire grade or group).

**Independent Test**: Change the dropdown selection to "Group" or "Stage" or "All Students", verify that the right panel populates all students belonging to that selection, check multi-selection capability, and verify batch generation triggers card image generation for all selected items into a specified output folder.

**Acceptance Scenarios**:

1. **Given** the user is on the QR Card Generator screen, **When** they select "Group" from the selection dropdown and select a specific group (or stage), **Then** the right panel lists all active students belonging to that group/stage.
2. **Given** a batch of students loaded in the right panel, **When** the user toggles individual or "Select All" checkboxes in the list, **Then** the card count badge and generation buttons update to show the total selected cards to generate.
3. **Given** multiple students selected in the list, **When** the user clicks "Generate Batch Cards", **Then** the system exports high-resolution individual PNG image files for all selected student cards.

---

### User Story 3 - Visual Template Compliance and Live Card Preview (Priority: P3)

As an administrator, I want the live card preview on the left panel to precisely match the app's brand identity and card design template so that generated cards maintain professional layout standards.

**Why this priority**: Ensures brand consistency, readability, and correct alignment of QR code scanners with printed badges.

**Independent Test**: Inspect the left preview panel to ensure all elements (Brand Header logo, "The Legendary Eagle", Teacher Name "Ali Sabry", "EAGLE MONITOR ID" badge, Arabic Student Name, Stage, Group Schedule, QR Code, "SCAN FOR ATTENDANCE" caption, and Bottom Navy Banner with Student Code and "بطاقة تعريف الطالب") are rendered accurately according to the design tokens.

**Acceptance Scenarios**:

1. **Given** any student selected in the system, **When** viewing the left preview panel, **Then** the card layout shows the split layout with the dark/light blue branding column on the left and the white information/QR card panel on the right.
2. **Given** a student with dynamic data (Name, Stage, Group schedule, Code ID), **When** loaded into the preview, **Then** all textual fields automatically format and fit within the designated template boundaries without overflowing.
3. **Given** the student's unique attendance identifier/code, **When** rendered on the card, **Then** a valid, scannable QR code encoding the student identifier is dynamically generated and displayed alongside the student code banner.

---

### Edge Cases

- **Missing or Long Student Data**: What happens when a student's name is exceptionally long or group/stage data is missing? The text scales down or truncates gracefully without breaking card layout.
- **Empty Search / No Selection**: What happens when search returns zero results or no student is selected? The preview panel shows a subtle placeholder state prompting the user to select a student.
- **Large Batch Export Performance**: How does the system handle batch generating 500+ card image files at once? The system displays a progress dialog/indicator and processes image rendering asynchronously in background batches.
- **RTL / Localization Support**: How does the card layout handle Arabic text layout and system language switching? The card template maintains consistent Arabic right-to-left field positioning regardless of system language while preserving fixed brand identifiers.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST add a new "QR Card Generator" tab to the primary application navigation shell.
- **FR-002**: System MUST provide a top control bar containing a selection mode dropdown (Options: "Student", "Group", "Stage", "All Students") and a live search input field to filter students by name, code, or phone number.
- **FR-003**: System MUST provide a split-view layout featuring a live Card Preview Panel on the left side and a Selection/Student List Panel on the right side.
- **FR-004**: System MUST render an accurate live preview of the student card in the preview panel based on the specified design template:
  - Left brand banner with logo, "The Legendary Eagle", teacher/owner name ("Ali Sabry"), and "EAGLE MONITOR ID" badge.
  - Main student info card displaying Arabic student name, grade/stage ("المرحلة"), group schedule details ("المجموعة"), dynamic QR code, and bottom navy bar with student code ("EM000001") and label ("بطاقة تعريف الطالب").
- **FR-005**: System MUST dynamically generate a valid scannable QR code representing the student's unique identification code for attendance scanning.
- **FR-006**: System MUST allow selecting single, multiple, or all listed students via checkboxes in the right-side student list panel.
- **FR-007**: System MUST provide action buttons ("Generate Selected Cards", "Export Images") to export high-resolution PNG image files for single or batch student selections.
- **FR-008**: System MUST integrate seamlessly with the app's existing Clean Architecture, BLoC/Cubit state management, theme system (AppTheme), and injection container (GetIt).

### Key Entities

- **QRCardConfig**: Represents configuration settings for card generation (e.g. selection mode, target filter ID, selected student IDs, output image format, destination folder).
- **StudentCardData**: Data model containing formatted attributes required for rendering the card template (Student ID/Code, Full Name, Stage Name, Group Name & Schedule, Scannable QR Data Payload).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Administrator can search, preview, and initiate image export of a single student QR card in under 5 seconds.
- **SC-002**: System can generate 50 student QR card PNG images in under 3 seconds without UI unresponsiveness.
- **SC-003**: Generated QR codes achieve 100% scan success rate when scanned by the application's attendance scanner.
- **SC-004**: 100% adherence to existing app design system, colors, typography, and responsive split-screen layout constraints.

## Assumptions

- Student records already possess unique student codes/IDs suitable for QR payload encoding.
- Card image resolution will be calibrated for standard printing quality (300 DPI equivalent).
- Existing DatabaseService and Student/Group Cubits provide access to necessary student, group, and stage data.
