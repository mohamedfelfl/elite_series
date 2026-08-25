import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/constants/dimens.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/student_card_data.dart';
import '../../data/services/qr_card_export_service.dart';
import '../../domain/services/iqr_card_export_service.dart';
import '../cubits/qr_card_cubit.dart';
import '../cubits/qr_card_state.dart';
import '../widgets/qr_card_control_bar.dart';
import '../widgets/qr_card_preview_panel.dart';
import '../widgets/qr_card_template_widget.dart';
import '../widgets/student_selection_panel.dart';

@RoutePage()
class QrCardGeneratorScreen extends StatefulWidget {
  const QrCardGeneratorScreen({super.key});

  @override
  State<QrCardGeneratorScreen> createState() => _QrCardGeneratorScreenState();
}

class _QrCardGeneratorScreenState extends State<QrCardGeneratorScreen> {
  final GlobalKey _previewBoundaryKey = GlobalKey();
  final IQrCardExportService _exportService = QrCardExportService();

  @override
  void initState() {
    super.initState();
    context.read<QrCardCubit>().loadInitialData();
  }

  Future<void> _handleSingleExport(StudentCardData student) async {
    final cubit = context.read<QrCardCubit>();
    cubit.updateExportProgress(
      AppDimens.opacityHalf,
      LocaleKeys.creating_image_progress.tr(),
    );

    final String? savedPath = await _exportService.saveSingleCardImage(
      boundaryKey: _previewBoundaryKey,
      student: student,
    );

    if (savedPath != null) {
      final msg = LocaleKeys.student_card_saved_success.tr(args: [savedPath]);
      cubit.finishExport(successMessage: msg);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg, style: AppTypography.cairo()),
            backgroundColor: AppCardColors.successGreen,
          ),
        );
      }
    } else {
      cubit.finishExport();
    }
  }

  Future<void> _handleBatchExport(
    List<StudentCardData> allFiltered,
    Set<int> selectedIds,
  ) async {
    final cubit = context.read<QrCardCubit>();
    final targetStudents = allFiltered
        .where((s) => selectedIds.contains(s.id))
        .toList();

    if (targetStudents.isEmpty) return;

    final String? resultDir = await _exportService.exportBatchCardsToDirectory(
      students: targetStudents,
      cardWidgetBuilder: (student) => QrCardTemplateWidget(student: student),
      onProgress: (current, total, name) {
        cubit.updateExportProgress(
          current / total,
          LocaleKeys.exporting_cards_progress.tr(
            args: [current.toString(), total.toString(), name],
          ),
        );
      },
    );

    if (resultDir != null) {
      final msg = LocaleKeys.cards_exported_success.tr(
        args: [targetStudents.length.toString(), resultDir],
      );
      cubit.finishExport(successMessage: msg);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg, style: AppTypography.cairo()),
            backgroundColor: AppCardColors.successGreen,
          ),
        );
      }
    } else {
      cubit.finishExport();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocConsumer<QrCardCubit, QrCardState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!, style: AppTypography.cairo()),
                backgroundColor: colorScheme.error,
              ),
            );
            context.read<QrCardCubit>().clearMessages();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.all(AppDimens.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QrCardControlBar(
                  selectionMode: state.selectionMode,
                  onSelectionModeChanged: (mode) {
                    if (mode != null) {
                      context.read<QrCardCubit>().setSelectionMode(mode);
                    }
                  },
                  searchQuery: state.searchQuery,
                  onSearchChanged: (q) =>
                      context.read<QrCardCubit>().updateSearchQuery(q),
                  availableGroups: state.availableGroups,
                  selectedGroupId: state.selectedGroupId,
                  onGroupChanged: (gId) =>
                      context.read<QrCardCubit>().selectGroupFilter(gId),
                  availableStages: state.availableStages,
                  selectedStage: state.selectedStage,
                  onStageChanged: (stage) =>
                      context.read<QrCardCubit>().selectStageFilter(stage),
                  selectedStartDate: state.selectedStartDate,
                  selectedEndDate: state.selectedEndDate,
                  onDateRangeChanged: (start, end) =>
                      context.read<QrCardCubit>().selectDateRangeFilter(start, end),
                ),

                SizedBox(height: AppDimens.h16),

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: AppDimens.previewFlex,
                        child: QrCardPreviewPanel(
                          student: state.activePreviewStudent,
                          boundaryKey: _previewBoundaryKey,
                          isExporting: state.isExporting,
                          onExportSingle: () {
                            if (state.activePreviewStudent != null) {
                              _handleSingleExport(state.activePreviewStudent!);
                            }
                          },
                        ),
                      ),

                      SizedBox(width: AppDimens.w16),

                      Expanded(
                        flex: AppDimens.selectionFlex,
                        child: StudentSelectionPanel(
                          students: state.filteredStudents,
                          selectedStudentIds: state.selectedStudentIds,
                          activePreviewStudent: state.activePreviewStudent,
                          onStudentSelectedForPreview: (student) {
                            context
                                .read<QrCardCubit>()
                                .selectStudentForPreview(student);
                          },
                          onToggleSelection: (sId) {
                            context
                                .read<QrCardCubit>()
                                .toggleStudentSelection(sId);
                          },
                          onToggleSelectAll: (val) {
                            context.read<QrCardCubit>().toggleSelectAll(val);
                          },
                          onBatchExport: () {
                            _handleBatchExport(
                              state.filteredStudents,
                              state.selectedStudentIds,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
