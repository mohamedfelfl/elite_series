import '../constants/app_constants.dart';

/// Helper utility for extracting and normalizing student serial numbers
/// from raw QR code data, barcode scanner inputs, and printed ID card payloads.
class QrCodeHelper {
  // Regex matching standard serials like EL-01-00003, EL-02-00001, EL-000001
  static final RegExp _serialPattern = RegExp(
    r'EL-\d+(?:-\d+)*',
    caseSensitive: false,
  );

  // Regex matching reversed serials (e.g. 00202-03-EL, 000001-EL) caused by RTL text flow
  static final RegExp _reversedSerialPattern = RegExp(
    r'(\d+(?:-\d+)*)-EL',
    caseSensitive: false,
  );

  // Regex matching a fully formed standard serial (e.g. EL-01-00003)
  static final RegExp _completeStandardSerial = RegExp(
    r'EL-\d{2}-\d{5}',
    caseSensitive: false,
  );

  // Regex matching a fully formed reversed standard serial (e.g. 00003-01-EL)
  static final RegExp _completeReversedStandardSerial = RegExp(
    r'\d{5}-\d{2}-EL',
    caseSensitive: false,
  );

  // Regex matching legacy 6-digit serial (e.g. EL-000001)
  static final RegExp _completeLegacySerial = RegExp(
    r'EL-\d{6}',
    caseSensitive: false,
  );

  // Regex matching reversed legacy serial (e.g. 000001-EL)
  static final RegExp _completeReversedLegacySerial = RegExp(
    r'\d{6}-EL',
    caseSensitive: false,
  );

  /// Normalizes input strings by converting Arabic numerals to ASCII digits,
  /// correcting Arabic keyboard layout keypresses (e.g. 'ثم' -> 'EL'),
  /// and stripping directional isolate control marks.
  static String normalizeInput(String? rawInput) {
    if (rawInput == null) return '';
    var text = rawInput.trim();
    if (text.isEmpty) return '';

    // 1. Convert Eastern Arabic numerals (٠-٩) to ASCII digits (0-9)
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    for (int i = 0; i < arabicDigits.length; i++) {
      text = text.replaceAll(arabicDigits[i], i.toString());
    }

    // 2. Normalize common Arabic keyboard layout typing:
    // Key 'E' is 'ث', Key 'L' is 'م' on standard Arabic 101/102 keyboards.
    text = text.replaceAll('ثم-', 'EL-');
    text = text.replaceAll('ثم', 'EL');
    text = text.replaceAll('-ثم', '-EL');

    // 3. Strip invisible directional isolate and formatting marks
    text = text.replaceAll(
      RegExp(r'[\u200E\u200F\u202A-\u202E\u2066-\u2069\uFEFF]'),
      '',
    );

    return text.trim();
  }

  /// Checks if the input already contains a complete standard or legacy serial.
  /// Used for early trigger in hardware scanner streams before trailing characters arrive.
  static bool hasCompleteSerial(String? rawInput) {
    if (rawInput == null || rawInput.isEmpty) return false;
    final normalized = normalizeInput(rawInput);
    return _completeStandardSerial.hasMatch(normalized) ||
        _completeLegacySerial.hasMatch(normalized) ||
        _completeReversedStandardSerial.hasMatch(normalized) ||
        _completeReversedLegacySerial.hasMatch(normalized);
  }

  /// Extracts the primary clean student serial number from scanned QR code data or user input.
  /// Handles forward serials, RTL-reversed serials, delimited tokens, and Arabic numeral inputs.
  static String extractSerialNumber(String? rawInput) {
    if (rawInput == null) return '';
    final trimmed = normalizeInput(rawInput);
    if (trimmed.isEmpty) return '';

    // 1. Check for standard EL-XX-XXXXX or EL-XXXXXX match anywhere in the string
    final match = _serialPattern.firstMatch(trimmed);
    if (match != null) {
      return match.group(0)!.toUpperCase();
    }

    // 2. Check for RTL-reversed serial (e.g. 00202-03-EL -> EL-03-00202)
    final revMatch = _reversedSerialPattern.firstMatch(trimmed);
    if (revMatch != null) {
      final segments = revMatch.group(1)!.split('-').reversed.toList();
      return 'EL-${segments.join('-')}'.toUpperCase();
    }

    // 3. If delimited by pipe, semicolon, colon, or comma, check segments
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
        final segRevMatch = _reversedSerialPattern.firstMatch(segment);
        if (segRevMatch != null) {
          final segs = segRevMatch.group(1)!.split('-').reversed.toList();
          return 'EL-${segs.join('-')}'.toUpperCase();
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

  /// Extracts the sequence number or numeric student ID from the input if present.
  static int? extractNumericId(String? rawInput) {
    if (rawInput == null) return null;
    final clean = normalizeInput(rawInput);
    if (clean.isEmpty) return null;

    final primary = extractSerialNumber(clean);
    if (primary.contains('-')) {
      final lastPart = primary.split('-').last;
      final parsed = int.tryParse(lastPart);
      if (parsed != null && parsed > 0) return parsed;
    }

    // Try pure numeric
    final pure = int.tryParse(clean);
    if (pure != null && pure > 0) return pure;

    // Check last digits in string
    final match = RegExp(r'\d+').allMatches(clean);
    if (match.isNotEmpty) {
      return int.tryParse(match.last.group(0)!);
    }

    return null;
  }

  /// Extracts all candidate tokens from the scanned payload in order of priority.
  /// Generates forward, reversed, padded, unpadded, legacy, and casing variations
  /// to guarantee 100% database match reliability regardless of how the student was saved.
  static List<String> extractAllCandidates(String? rawInput) {
    if (rawInput == null) return const [];
    final normalized = normalizeInput(rawInput);
    if (normalized.isEmpty) return const [];

    final Set<String> candidates = {};

    // 1. Primary extracted serial (normalized & reversed if needed)
    final primary = extractSerialNumber(normalized);
    if (primary.isNotEmpty) {
      candidates.add(primary);
      candidates.add(primary.toLowerCase());
    }

    // 2. Any other EL- matches in the normalized string
    for (final m in _serialPattern.allMatches(normalized)) {
      final s = m.group(0)?.toUpperCase();
      if (s != null && s.isNotEmpty) {
        candidates.add(s);
        candidates.add(s.toLowerCase());
      }
    }

    // 3. Any reversed XXXXX-XX-EL matches in the normalized string
    for (final m in _reversedSerialPattern.allMatches(normalized)) {
      final rev = m.group(0)?.toUpperCase();
      if (rev != null && rev.isNotEmpty) {
        candidates.add(rev);
        candidates.add(rev.toLowerCase());
        final parts = m.group(1)!.split('-').reversed.toList();
        final corrected = 'EL-${parts.join('-')}'.toUpperCase();
        candidates.add(corrected);
        candidates.add(corrected.toLowerCase());
      }
    }

    // 4. Synthesize all padding & format permutations for standard serial: EL-XX-XXXXX
    final standardParts = RegExp(r'^EL-(\d+)-(\d+)$', caseSensitive: false)
        .firstMatch(primary);
    if (standardParts != null) {
      final stageInt = int.tryParse(standardParts.group(1)!);
      final seqInt = int.tryParse(standardParts.group(2)!);
      if (stageInt != null && seqInt != null) {
        final pStage = stageInt.toString().padLeft(2, '0');
        final uStage = stageInt.toString();
        final pSeq5 = seqInt.toString().padLeft(5, '0');
        final pSeq6 = seqInt.toString().padLeft(6, '0');
        final uSeq = seqInt.toString();

        // Standard forms
        candidates.add('EL-$pStage-$pSeq5');
        candidates.add('EL-$uStage-$pSeq5');
        candidates.add('EL-$pStage-$uSeq');
        candidates.add('EL-$uStage-$uSeq');
        candidates.add('EL-$pStage-$pSeq6');

        // Legacy forms
        candidates.add('EL-$pSeq6');
        candidates.add('EL-$pSeq5');
        candidates.add('EL-$uSeq');
        candidates.add('EL$pSeq6');
        candidates.add('EL$pStage$pSeq5');

        // Reversed forms (RTL visual permutations)
        candidates.add('$pSeq5-$pStage-EL');
        candidates.add('$uSeq-$pStage-EL');
        candidates.add('$pSeq5-$uStage-EL');
        candidates.add('$uSeq-$uStage-EL');
        candidates.add('$pSeq6-EL');

        // Numeric tokens
        candidates.add(pSeq5);
        candidates.add(pSeq6);
        candidates.add(uSeq);
      }
    }

    // 5. Synthesize permutations for legacy serial: EL-XXXXXX
    final legacyParts = RegExp(r'^EL-(\d+)$', caseSensitive: false)
        .firstMatch(primary);
    if (legacyParts != null) {
      final seqInt = int.tryParse(legacyParts.group(1)!);
      if (seqInt != null) {
        final pSeq6 = seqInt.toString().padLeft(6, '0');
        final pSeq5 = seqInt.toString().padLeft(5, '0');
        final uSeq = seqInt.toString();

        candidates.add('EL-$pSeq6');
        candidates.add('EL-$pSeq5');
        candidates.add('EL-$uSeq');
        candidates.add('EL$pSeq6');
        candidates.add('$pSeq6-EL');

        // Also generate for stages 01, 02, 03 in case student was entered with a stage
        for (final stage in ['01', '02', '03', '1', '2', '3']) {
          candidates.add('EL-$stage-$pSeq5');
          candidates.add('EL-$stage-$uSeq');
        }

        candidates.add(pSeq6);
        candidates.add(pSeq5);
        candidates.add(uSeq);
      }
    }

    // 6. If purely numeric token
    final pureInt = int.tryParse(normalized);
    if (pureInt != null) {
      final p5 = pureInt.toString().padLeft(5, '0');
      final p6 = pureInt.toString().padLeft(6, '0');
      final u = pureInt.toString();
      candidates.add(u);
      candidates.add(p5);
      candidates.add(p6);
      candidates.add('EL-$p6');
      candidates.add('EL-$p5');
      candidates.add('EL-$u');
      for (final stage in ['01', '02', '03']) {
        candidates.add('EL-$stage-$p5');
        candidates.add('EL-$stage-$u');
      }
    }

    // 7. Delimited segments
    final delimiterRegex = RegExp(r'[|:;,\-\s]');
    final parts = normalized
        .split(delimiterRegex)
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    for (final p in parts) {
      if (p.startsWith('stu_') || p.startsWith('STU_')) {
        candidates.add(p);
      } else if (p.toUpperCase().startsWith('EL-')) {
        candidates.add(p.toUpperCase());
        candidates.add(p.toLowerCase());
      }
    }

    // 8. Raw trimmed string and normalized string
    candidates.add(normalized);
    candidates.add(normalized.toUpperCase());
    candidates.add(normalized.toLowerCase());
    if (rawInput.trim() != normalized) {
      candidates.add(rawInput.trim());
    }

    // Add all lowercase versions
    final allLower = candidates.map((c) => c.toLowerCase()).toList();
    candidates.addAll(allLower);

    return candidates.where((c) => c.isNotEmpty).toList();
  }
}
