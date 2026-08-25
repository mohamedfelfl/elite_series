import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/constants/dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/student_card_data.dart';
import 'qr_card_template_widget.dart';

class QrCardPreviewPanel extends StatefulWidget {
  final StudentCardData? student;
  final GlobalKey boundaryKey;
  final VoidCallback onExportSingle;
  final bool isExporting;

  const QrCardPreviewPanel({
    super.key,
    required this.student,
    required this.boundaryKey,
    required this.onExportSingle,
    this.isExporting = false,
  });

  @override
  State<QrCardPreviewPanel> createState() => _QrCardPreviewPanelState();
}

class _QrCardPreviewPanelState extends State<QrCardPreviewPanel> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: AppDimens.opacityHalf,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppDimens.opacitySubtle),
            blurRadius: AppDimens.r10,
            offset: Offset(0, AppDimens.h4),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppDimens.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDimens.p8,
            runSpacing: AppDimens.p8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.preview_rounded, color: colorScheme.primary),
                  SizedBox(width: AppDimens.w8),
                  Text(
                    LocaleKeys.card_preview.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              if (widget.student != null)
                FilledButton.icon(
                  onPressed: widget.isExporting ? null : widget.onExportSingle,
                  icon: Icon(
                    Icons.download_rounded,
                    size: AppDimens.iconSize18,
                    color: Colors.white,
                  ),
                  label: Text(
                    LocaleKeys.save_student_card.tr(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: colorScheme.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.p16,
                      vertical: AppDimens.p12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.r10),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: AppDimens.h16),
          const Divider(height: 1),
          SizedBox(height: AppDimens.h20),

          Expanded(
            child: Center(
              child: widget.student == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: AppDimens.iconSize64,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: AppDimens.opacityMedium,
                          ),
                        ),
                        SizedBox(height: AppDimens.h12),
                        Text(
                          LocaleKeys.select_student_preview_hint.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    )
                  : Scrollbar(
                      controller: _horizontalScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        controller: _horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(bottom: AppDimens.p12),
                        child: SingleChildScrollView(
                          controller: _verticalScrollController,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RepaintBoundary(
                              key: widget.boundaryKey,
                              child: QrCardTemplateWidget(
                                student: widget.student!,
                                width: AppDimens.cardDefaultWidth,
                                height: AppDimens.cardDefaultHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
