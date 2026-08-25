enum QRCardSelectionMode {
  student,
  group,
  stage,
  date,
  all,
}

class QRCardConfig {
  final QRCardSelectionMode selectionMode;
  final String searchQuery;
  final int? selectedGroupId;
  final String? selectedStage;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Set<int> selectedStudentIds;
  final int? activePreviewStudentId;
  final bool isExporting;
  final double exportProgress;

  const QRCardConfig({
    this.selectionMode = QRCardSelectionMode.student,
    this.searchQuery = '',
    this.selectedGroupId,
    this.selectedStage,
    this.selectedStartDate,
    this.selectedEndDate,
    this.selectedStudentIds = const {},
    this.activePreviewStudentId,
    this.isExporting = false,
    this.exportProgress = 0.0,
  });

  QRCardConfig copyWith({
    QRCardSelectionMode? selectionMode,
    String? searchQuery,
    int? selectedGroupId,
    String? selectedStage,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    Set<int>? selectedStudentIds,
    int? activePreviewStudentId,
    bool? isExporting,
    double? exportProgress,
  }) {
    return QRCardConfig(
      selectionMode: selectionMode ?? this.selectionMode,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedStage: selectedStage ?? this.selectedStage,
      selectedStartDate: selectedStartDate ?? this.selectedStartDate,
      selectedEndDate: selectedEndDate ?? this.selectedEndDate,
      selectedStudentIds: selectedStudentIds ?? this.selectedStudentIds,
      activePreviewStudentId:
          activePreviewStudentId ?? this.activePreviewStudentId,
      isExporting: isExporting ?? this.isExporting,
      exportProgress: exportProgress ?? this.exportProgress,
    );
  }
}
