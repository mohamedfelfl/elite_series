import 'dart:io';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/constants/dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/services/iqr_card_export_service.dart';
import '../models/student_card_data.dart';

class QrCardExportService implements IQrCardExportService {
  @override
  Future<Uint8List?> captureBoundaryToPng(
    GlobalKey boundaryKey, {
    double pixelRatio = 3.0,
  }) async {
    try {
      final boundary =
          boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing card boundary to PNG: $e');
      return null;
    }
  }

  @override
  Future<String?> saveSingleCardImage({
    required GlobalKey boundaryKey,
    required StudentCardData student,
  }) async {
    final pngBytes = await captureBoundaryToPng(boundaryKey, pixelRatio: 3.0);
    if (pngBytes == null) return null;

    final sanitizedName = student.fullName.replaceAll(
      RegExp(r'[\\/:*?"<>|]'),
      '_',
    );
    final defaultFileName = '${student.studentCode}_$sanitizedName.png';

    final String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: LocaleKeys.save_student_card.tr(),
      fileName: defaultFileName,
      type: FileType.custom,
      allowedExtensions: const [AppConstants.pngExtension],
    );

    if (outputFile != null) {
      final file = File(outputFile);
      await file.writeAsBytes(pngBytes);
      return file.path;
    }
    return null;
  }

  Future<Uint8List?> renderWidgetToPngBytes(
    Widget widget, {
    Size? logicalSize,
    double pixelRatio = 3.0,
  }) async {
    final targetSize =
        logicalSize ??
        Size(AppDimens.cardDefaultWidth, AppDimens.cardDefaultHeight);
    try {
      final repaintBoundary = RenderRepaintBoundary();
      final view =
          WidgetsBinding.instance.platformDispatcher.implicitView ??
          WidgetsBinding.instance.platformDispatcher.views.first;

      final renderView = RenderView(
        view: view,
        child: RenderPositionedBox(
          alignment: Alignment.center,
          child: repaintBoundary,
        ),
        configuration: ViewConfiguration(
          logicalConstraints: BoxConstraints.tight(targetSize),
          devicePixelRatio: pixelRatio,
        ),
      );

      final pipelineOwner = PipelineOwner();
      final buildOwner = BuildOwner(focusManager: FocusManager());

      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();

      final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: MediaQuery(
            data: MediaQueryData.fromView(view),
            child: Material(
              color: Colors.transparent,
              child: widget,
            ),
          ),
        ),
      ).attachToRenderTree(buildOwner);

      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();

      final ui.Image image = await repaintBoundary.toImage(
        pixelRatio: pixelRatio,
      );
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error rendering offscreen widget to PNG: $e');
      return null;
    }
  }

  @override
  Future<String?> exportBatchCardsToDirectory({
    required List<StudentCardData> students,
    required Widget Function(StudentCardData student) cardWidgetBuilder,
    required void Function(int current, int total, String name) onProgress,
  }) async {
    if (students.isEmpty) return null;

    final String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: LocaleKeys.export_selected_png.tr(),
    );

    if (selectedDirectory == null || selectedDirectory.isEmpty) return null;

    final outDir = Directory(selectedDirectory);
    if (!await outDir.exists()) {
      await outDir.create(recursive: true);
    }

    for (int i = 0; i < students.length; i++) {
      final student = students[i];
      onProgress(i + 1, students.length, student.fullName);

      final sanitizedName = student.fullName
          .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
          .trim();
      final fileName = '${student.studentCode}_$sanitizedName.png';
      final filePath = '${outDir.path}${Platform.pathSeparator}$fileName';

      final widget = cardWidgetBuilder(student);
      final pngBytes = await renderWidgetToPngBytes(widget);

      if (pngBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(pngBytes);
      }

      await Future.delayed(const Duration(milliseconds: 20));
    }

    return outDir.path;
  }
}
