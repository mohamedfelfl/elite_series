import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/qr_card_config.dart';
import '../../data/models/student_card_data.dart';

part 'qr_card_state.freezed.dart';

@freezed
abstract class QrCardState with _$QrCardState {
  const factory QrCardState({
    @Default(QRCardSelectionMode.student) QRCardSelectionMode selectionMode,
    @Default('') String searchQuery,
    int? selectedGroupId,
    String? selectedStage,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    @Default([]) List<StudentCardData> allStudents,
    @Default([]) List<StudentCardData> filteredStudents,
    @Default({}) Set<int> selectedStudentIds,
    StudentCardData? activePreviewStudent,
    @Default([]) List<Map<String, dynamic>> availableGroups,
    @Default([]) List<String> availableStages,
    @Default(false) bool isLoading,
    @Default(false) bool isExporting,
    @Default(0.0) double exportProgress,
    @Default('') String exportStatusText,
    String? error,
    String? successMessage,
  }) = _QrCardState;
}
