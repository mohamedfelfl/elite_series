import '../constants/app_constants.dart';

/// Helper utility for extracting and normalizing student serial numbers
/// from raw QR code data, barcode scanner inputs, and printed ID card payloads.
class QrCodeHelper {
  // Regex matching standard serials like EL-01-00003, EL-02-00001, EL-000001
  static final RegExp _serialPattern = RegExp(
    r'EL-\d+(?:-\d+)*',
    caseSensitive: false,
  );

  /// Extracts the clean student serial number from scanned QR code data or user input.
  ///
  /// Supports:
  /// - Direct serial numbers (e.g. `EL-01-00003`, `EL-02-00015`)
  /// - Printed card payloads with pipe or hyphen delimiters:
  ///   - `ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003`
  ///   - `ELITE-stu_bd02c7b92a2b49da8a-EL-01-00003`
  /// - Case insensitivity (`el-01-00003` -> `EL-01-00003`)
  /// - Trailing whitespaces and newlines from hardware barcode scanners
  /// - Fallback to raw trimmed string if no standard pattern match is found
  static String extractSerialNumber(String? rawInput) {
    if (rawInput == null) return '';
    final trimmed = rawInput.trim();
    if (trimmed.isEmpty) return '';

    // 1. Check for standard EL-XX-XXXXX or EL-XXXXXX match anywhere in the string
    final match = _serialPattern.firstMatch(trimmed);
    if (match != null) {
      return match.group(0)!.toUpperCase();
    }

    // 2. If pipe-delimited, check segments
    if (trimmed.contains('|')) {
      final segments = trimmed
          .split('|')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      for (final segment in segments) {
        final segMatch = _serialPattern.firstMatch(segment);
        if (segMatch != null) {
          return segMatch.group(0)!.toUpperCase();
        }
        if (segment.toUpperCase().startsWith('${AppConstants.studentCodePrefix}-') ||
            segment.toUpperCase().startsWith(AppConstants.studentCodePrefix.toUpperCase())) {
          return segment.toUpperCase();
        }
      }

      if (segments.isNotEmpty) {
        return segments.last;
      }
    }

    return trimmed;
  }
}
