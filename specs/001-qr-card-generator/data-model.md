# Data Model: QR Card Generator

## 1. QRCardSelectionMode (Enum)

Defines the active filter mode selected in the dropdown menu.

```dart
enum QRCardSelectionMode {
  student, // Single student search & pick mode
  group,   // Filter by specific study group
  stage,   // Filter by educational stage / grade level
  all,     // Select all active students
}
```

## 2. StudentCardData (Data Entity)

Normalized model carrying student information required for card template rendering.

| Attribute | Type | Description | Example |
|-----------|------|-------------|---------|
| `studentId` | `int` | Primary key identifier | `42` |
| `studentCode` | `String` | Formatted unique student code | `"EM000001"` |
| `fullName` | `String` | Full name in Arabic/English | `"إياد أحمد صبري"` |
| `stageName` | `String` | Educational stage / grade | `"الصف الأول الإعدادي"` |
| `groupName` | `String` | Study group title | `"المجموعة أ"` |
| `groupSchedule` | `String` | Group days & time schedule | `"السبت و الثلاثاء الساعة 12"` |
| `qrPayload` | `String` | Scannable payload encoded into QR code | `"EM000001"` |

## 3. QRCardConfig (Configuration State)

Represents the user's active session state in the generator tab.

| Attribute | Type | Description | Default |
|-----------|------|-------------|---------|
| `selectionMode` | `QRCardSelectionMode` | Active dropdown selection filter | `QRCardSelectionMode.student` |
| `searchQuery` | `String` | Text typed into the search bar | `""` |
| `selectedGroupId` | `int?` | Filter ID when mode is `group` | `null` |
| `selectedStageId` | `int?` | Filter ID when mode is `stage` | `null` |
| `selectedStudentIds` | `Set<int>` | Set of student IDs selected for batch generation | `{}` |
| `activePreviewStudentId` | `int?` | ID of the student currently shown in left preview panel | `null` |
| `isExporting` | `bool` | True while generating/exporting card images | `false` |
| `exportProgress` | `double` | Progress ratio (0.0 to 1.0) during batch export | `0.0` |

## 4. Relationships

- `StudentCardData` is synthesized from the existing `Student` model combined with relational data from `Group` and `Stage`.
- `QRCardConfig` manages UI state and selection vectors for `StudentCardData` items loaded from `DatabaseService`.
