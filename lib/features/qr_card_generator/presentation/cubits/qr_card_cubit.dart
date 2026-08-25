import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/qr_card_config.dart';
import '../../data/models/student_card_data.dart';
import '../../domain/repositories/iqr_card_repository.dart';
import 'qr_card_state.dart';

class QrCardCubit extends Cubit<QrCardState> {
  final IQrCardRepository _repository;

  QrCardCubit({required IQrCardRepository repository})
      : _repository = repository,
        super(const QrCardState());

  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final groups = await _repository.getGroups();
      final stages = await _repository.getStages();
      final studentList = await _repository.getStudentsForCards();

      final activePreview = studentList.isNotEmpty ? studentList.first : null;

      emit(
        state.copyWith(
          allStudents: studentList,
          filteredStudents: studentList,
          availableGroups: groups,
          availableStages: stages,
          activePreviewStudent: activePreview,
          isLoading: false,
        ),
      );
      _applyFilters();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void setSelectionMode(QRCardSelectionMode mode) {
    emit(
      state.copyWith(
        selectionMode: mode,
        selectedGroupId: null,
        selectedStage: null,
        selectedStartDate: null,
        selectedEndDate: null,
      ),
    );
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void selectGroupFilter(int? groupId) {
    emit(state.copyWith(selectedGroupId: groupId));
    _applyFilters();
  }

  void selectStageFilter(String? stage) {
    emit(state.copyWith(selectedStage: stage));
    _applyFilters();
  }

  void selectDateRangeFilter(DateTime? startDate, DateTime? endDate) {
    emit(
      state.copyWith(
        selectedStartDate: startDate,
        selectedEndDate: endDate,
      ),
    );
    _applyFilters();
  }

  void clearDateFilter() {
    emit(
      state.copyWith(
        selectedStartDate: null,
        selectedEndDate: null,
      ),
    );
    _applyFilters();
  }

  void selectStudentForPreview(StudentCardData student) {
    emit(state.copyWith(activePreviewStudent: student));
  }

  void toggleStudentSelection(int studentId) {
    final updated = Set<int>.from(state.selectedStudentIds);
    if (updated.contains(studentId)) {
      updated.remove(studentId);
    } else {
      updated.add(studentId);
    }
    emit(state.copyWith(selectedStudentIds: updated));
  }

  void toggleSelectAll(bool? selectAll) {
    if (selectAll == true) {
      final allFilteredIds = state.filteredStudents.map((s) => s.id).toSet();
      emit(state.copyWith(selectedStudentIds: allFilteredIds));
    } else {
      emit(state.copyWith(selectedStudentIds: const {}));
    }
  }

  void updateExportProgress(double progress, String statusText) {
    emit(
      state.copyWith(
        isExporting: true,
        exportProgress: progress,
        exportStatusText: statusText,
      ),
    );
  }

  void finishExport({String? successMessage, String? errorMessage}) {
    emit(
      state.copyWith(
        isExporting: false,
        exportProgress: 1.0,
        exportStatusText: '',
        successMessage: successMessage,
        error: errorMessage,
      ),
    );
  }

  void clearMessages() {
    emit(state.copyWith(successMessage: null, error: null));
  }

  void _applyFilters() {
    List<StudentCardData> results = List.from(state.allStudents);

    switch (state.selectionMode) {
      case QRCardSelectionMode.group:
        if (state.selectedGroupId != null) {
          final selectedGroup = state.availableGroups.firstWhere(
            (g) => g['id'] == state.selectedGroupId,
            orElse: () => <String, Object?>{},
          );
          final groupName = selectedGroup['name'] as String? ?? '';
          results = results.where((s) => s.groupName == groupName).toList();
        }
        break;
      case QRCardSelectionMode.stage:
        if (state.selectedStage != null && state.selectedStage!.isNotEmpty) {
          final targetFormatted =
              StudentCardData.formatStageArabic(state.selectedStage);
          results = results.where((s) {
            return s.stageName == state.selectedStage ||
                s.stageName == targetFormatted;
          }).toList();
        }
        break;
      case QRCardSelectionMode.date:
        if (state.selectedStartDate != null) {
          final startBoundary = DateTime(
            state.selectedStartDate!.year,
            state.selectedStartDate!.month,
            state.selectedStartDate!.day,
            0,
            0,
            0,
          );
          final end = state.selectedEndDate ?? state.selectedStartDate!;
          final endBoundary = DateTime(
            end.year,
            end.month,
            end.day,
            23,
            59,
            59,
            999,
          );

          results = results.where((s) {
            if (s.createdAt == null) return false;
            return !s.createdAt!.isBefore(startBoundary) &&
                !s.createdAt!.isAfter(endBoundary);
          }).toList();
        }
        break;
      case QRCardSelectionMode.student:
      case QRCardSelectionMode.all:
        break;
    }

    if (state.searchQuery.trim().isNotEmpty) {
      final q = state.searchQuery.trim().toLowerCase();
      results = results.where((s) {
        final nameMatch = s.fullName.toLowerCase().contains(q);
        final codeMatch = s.studentCode.toLowerCase().contains(q);
        final groupMatch = s.groupName.toLowerCase().contains(q);
        final stageMatch = s.stageName.toLowerCase().contains(q);
        return nameMatch || codeMatch || groupMatch || stageMatch;
      }).toList();
    }

    StudentCardData? preview = state.activePreviewStudent;
    if (preview != null && !results.any((s) => s.id == preview!.id)) {
      preview = results.isNotEmpty ? results.first : null;
    } else if (preview == null && results.isNotEmpty) {
      preview = results.first;
    }

    emit(
      state.copyWith(
        filteredStudents: results,
        activePreviewStudent: preview,
      ),
    );
  }
}
