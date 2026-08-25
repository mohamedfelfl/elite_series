# Contract: QR Card Cubit & Export Service

## 1. QrCardCubit State Management Contract

### State Definitions
```dart
abstract class QrCardState {}

class QrCardInitial extends QrCardState {}
class QrCardLoading extends QrCardState {}
class QrCardLoaded extends QrCardState {
  final QRCardSelectionMode selectionMode;
  final String searchQuery;
  final List<StudentCardData> students;
  final Set<int> selectedStudentIds;
  final StudentCardData? activePreviewStudent;
  final List<GroupModel> availableGroups;
  final List<StageModel> availableStages;
  final int? selectedGroupId;
  final int? selectedStageId;

  QrCardLoaded({...});
}
class QrCardExporting extends QrCardState {
  final int totalCount;
  final int completedCount;
  final String currentStudentName;

  QrCardExporting({...});
}
class QrCardExportSuccess extends QrCardState {
  final String exportPath;
  final int exportedCount;

  QrCardExportSuccess({...});
}
class QrCardError extends QrCardState {
  final String message;

  QrCardError(this.message);
}
```

### Cubit Methods
- `void loadInitialData()`: Fetches initial student, group, and stage list.
- `void setSelectionMode(QRCardSelectionMode mode)`: Updates active selection mode filter.
- `void updateSearchQuery(String query)`: Filters student list by search text.
- `void selectGroupFilter(int? groupId)`: Filters list by group.
- `void selectStageFilter(int? stageId)`: Filters list by stage.
- `void selectStudentForPreview(StudentCardData student)`: Sets active student for left preview panel.
- `void toggleStudentSelection(int studentId)`: Toggles selection checkbox for a student.
- `void toggleSelectAll(bool selectAll)`: Selects/deselects all currently filtered students.
- `Future<void> exportCards({required String outputFolderPath})`: Triggers image export for selected students.

## 2. QrCardExportService Contract

```dart
abstract class IQrCardExportService {
  /// Renders a single student card to PNG bytes at 300 DPI
  Future<Uint8List> renderCardToPngBytes(StudentCardData studentData);

  /// Batch exports multiple student cards to specified folder
  Future<List<String>> batchExportToFolder({
    required List<StudentCardData> students,
    required String outputFolder,
    required void Function(int current, int total, String studentName) onProgress,
  });
}
```
