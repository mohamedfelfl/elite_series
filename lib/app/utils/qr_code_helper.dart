import '../constants/app_constants.dart';

/// Helper utility for extracting and normalizing student serial numbers
/// from raw QR code data, barcode scanner inputs, and printed ID card payloads.
class QrCodeHelper {
  // Regex matching standard serials like EL-01-00003, EL-02-00001, EL-000001
  static final RegExp _serialPattern = RegExp(
    r'EL-\d+(?:-\d+)*',
    caseSensitive: false,
  );

  // Regex matching a fully formed standard serial (e.g. EL-01-00003)
  static final RegExp _completeStandardSerial = RegExp(
    r'EL-\d{2}-\d{5}',
    caseSensitive: false,
  );

  // Regex matching legacy 6-digit serial (e.g. EL-000001)
  static final RegExp _completeLegacySerial = RegExp(
    r'EL-\d{6}',
    caseSensitive: false,
  );

  /// Checks if the input already contains a complete standard or legacy serial.
  /// Used for early trigger in hardware scanner streams before trailing characters arrive.
  static bool hasCompleteSerial(String? rawInput) {
    if (rawInput == null || rawInput.isEmpty) return false;
    return _completeStandardSerial.hasMatch(rawInput) ||
        _completeLegacySerial.hasMatch(rawInput);
  }

  /// Extracts the primary clean student serial number from scanned QR code data or user input.
  static String extractSerialNumber(String? rawInput) {
    if (rawInput == null) return '';
    final trimmed = rawInput.trim();
    if (trimmed.isEmpty) return '';

    // 1. Check for standard EL-XX-XXXXX or EL-XXXXXX match anywhere in the string
    final match = _serialPattern.firstMatch(trimmed);
    if (match != null) {
      return match.group(0)!.toUpperCase();
    }

    // 2. If delimited by pipe, semicolon, colon, or comma, check segments
    final delimiterRegex = RegExp(r'[|:;,]');
    if (delimiterRegex.hasMatch(trimmed)) {
      final segments = trimmed
          .split(delimiterRegex)
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

      // If no prefix match, check if any segment looks like stu_ legacy id
      for (final segment in segments) {
        if (segment.startsWith('stu_') || segment.startsWith('STU_')) {
          return segment;
        }
      }

      if (segments.isNotEmpty) {
        return segments.last;
      }
    }

    return trimmed;
  }

  /// Extracts all candidate tokens from the scanned payload in order of priority.
  /// For instance: `ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003` -> `['EL-01-00003', 'stu_bd02c7b92a2b49da8a', 'ELITE']`.
  static List<String> extractAllCandidates(String? rawInput) {
    if (rawInput == null) return const [];
    final trimmed = rawInput.trim();
    if (trimmed.isEmpty) return const [];

    final Set<String> candidates = {};

    // 1. Primary extracted serial
    final primary = extractSerialNumber(trimmed);
    if (primary.isNotEmpty) candidates.add(primary);

    // 2. Any other EL- matches in the raw string
    for (final m in _serialPattern.allMatches(trimmed)) {
      final s = m.group(0)?.toUpperCase();
      if (s != null && s.isNotEmpty) candidates.add(s);
    }

    // 3. Delimited segments
    final delimiterRegex = RegExp(r'[|:;,\-\s]');
    final parts = trimmed
        .split(delimiterRegex)
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    for (final p in parts) {
      if (p.startsWith('stu_') || p.startsWith('STU_')) {
        candidates.add(p);
      } else if (p.toUpperCase().startsWith('EL-')) {
        candidates.add(p.toUpperCase());
      }
    }

    // 4. Raw trimmed string
    candidates.add(trimmed);

    return candidates.toList();
  }
}
