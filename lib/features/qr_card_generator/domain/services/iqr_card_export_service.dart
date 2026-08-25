import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/models/student_card_data.dart';

abstract class IQrCardExportService {
  Future<Uint8List?> captureBoundaryToPng(
    GlobalKey boundaryKey, {
    double pixelRatio = 3.0,
  });

  Future<String?> saveSingleCardImage({
    required GlobalKey boundaryKey,
    required StudentCardData student,
  });

  Future<String?> exportBatchCardsToDirectory({
    required List<StudentCardData> students,
    required Widget Function(StudentCardData student) cardWidgetBuilder,
    required void Function(int current, int total, String name) onProgress,
  });
}
