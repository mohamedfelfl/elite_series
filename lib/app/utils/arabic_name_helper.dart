import 'dart:math';

enum NameMatchLevel {
  exact,           // 100% identical raw trimmed string
  normalizedExact, // Identical after Arabic normalization and space unification
  highSimilarity,  // High similarity (prefix match, reordered tokens, or Jaro-Winkler >= 0.85)
}

class NameDuplicateMatch {
  final Map<String, dynamic> student;
  final NameMatchLevel matchLevel;
  final double similarity; // 0.0 to 1.0
  final String reasonKey;
  final List<String> reasonArgs;

  const NameDuplicateMatch({
    required this.student,
    required this.matchLevel,
    required this.similarity,
    required this.reasonKey,
    this.reasonArgs = const [],
  });
}

class ArabicNameHelper {
  ArabicNameHelper._();

  // Arabic Tashkeel / Harakat regex
  static final RegExp _tashkeelRegex =
      RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]');

  // Tatweel / Kashida
  static final RegExp _tatweelRegex = RegExp(r'\u0640');

  // Whitespace collapse
  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  /// Normalizes Arabic text for name comparison:
  /// 1. Strips Tashkeel (harakat) and Tatweel (kashida).
  /// 2. Normalizes all Alif forms (أ, إ, آ, ٱ) -> ا.
  /// 3. Normalizes Ta Marbuta (ة) -> ه.
  /// 4. Normalizes Ya / Alif Maqsura (ى, ئ) -> ي.
  /// 5. Normalizes Waw with Hamza (ؤ) -> و.
  /// 6. Unifies common compound prefixes (عبد, ابو, ام, ابن) and suffixes (الدين, الله, الاسلام).
  /// 7. Collapses all multiple whitespaces into a single space.
  static String normalize(String text) {
    if (text.isEmpty) return '';

    String cleaned = text.trim();

    // Remove tashkeel and tatweel
    cleaned = cleaned.replaceAll(_tashkeelRegex, '');
    cleaned = cleaned.replaceAll(_tatweelRegex, '');

    // Normalize characters
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      final char = cleaned[i];
      switch (char) {
        case 'أ':
        case 'إ':
        case 'آ':
        case 'ٱ':
          buffer.write('ا');
          break;
        case 'ة':
          buffer.write('ه');
          break;
        case 'ى':
        case 'ئ':
          buffer.write('ي');
          break;
        case 'ؤ':
          buffer.write('و');
          break;
        default:
          buffer.write(char.toLowerCase());
      }
    }

    String result = buffer.toString();

    // Collapse multiple spaces before handling compound names
    result = result.replaceAll(_whitespaceRegex, ' ');

    // Normalize compound prefixes: e.g. "عبد المنعم" -> "عبدالمنعم", "ابو بكر" -> "ابوبكر"
    result = result.replaceAllMapped(RegExp(r'(^|\s+)عبد\s+'), (m) => '${m[1]}عبد');
    result = result.replaceAllMapped(RegExp(r'(^|\s+)ابو\s+'), (m) => '${m[1]}ابو');
    result = result.replaceAllMapped(RegExp(r'(^|\s+)ام\s+'), (m) => '${m[1]}ام');
    result = result.replaceAllMapped(RegExp(r'(^|\s+)ابن\s+'), (m) => '${m[1]}ابن');
    result = result.replaceAllMapped(RegExp(r'(^|\s+)بن\s+'), (m) => '${m[1]}ابن');

    // Normalize compound suffixes: e.g. "علاء الدين" -> "علاءالدين", "جاد الله" -> "جادالله"
    result = result.replaceAllMapped(RegExp(r'\s+الدين(?=\s|$)'), (m) => 'الدين');
    result = result.replaceAllMapped(RegExp(r'\s+الله(?=\s|$)'), (m) => 'الله');
    result = result.replaceAllMapped(RegExp(r'\s+الاسلام(?=\s|$)'), (m) => 'الاسلام');

    return result.trim();
  }

  /// Removes all whitespace from normalized string.
  /// Used to detect spacing discrepancies anywhere in compound or split names.
  static String normalizeWithoutSpaces(String text) {
    return normalize(text).replaceAll(_whitespaceRegex, '');
  }

  /// Checks if two names are exact or normalized identical.
  static bool areNormalizedExact(String a, String b) {
    final normA = normalize(a);
    final normB = normalize(b);
    if (normA == normB) return true;
    return normalizeWithoutSpaces(a) == normalizeWithoutSpaces(b);
  }

  /// Calculates Jaro-Winkler similarity between two strings (0.0 to 1.0).
  static double jaroWinklerSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final matchDistance = (max(s1.length, s2.length) ~/ 2) - 1;
    final s1Matches = List<bool>.filled(s1.length, false);
    final s2Matches = List<bool>.filled(s2.length, false);

    int matches = 0;
    for (int i = 0; i < s1.length; i++) {
      final start = max(0, i - matchDistance);
      final end = min(i + matchDistance + 1, s2.length);

      for (int j = start; j < end; j++) {
        if (s2Matches[j]) continue;
        if (s1[i] != s2[j]) continue;
        s1Matches[i] = true;
        s2Matches[j] = true;
        matches++;
        break;
      }
    }

    if (matches == 0) return 0.0;

    int transpositions = 0;
    int k = 0;
    for (int i = 0; i < s1.length; i++) {
      if (!s1Matches[i]) continue;
      while (!s2Matches[k]) {
        k++;
      }
      if (s1[i] != s2[k]) {
        transpositions++;
      }
      k++;
    }

    final jaro = (matches / s1.length +
            matches / s2.length +
            (matches - (transpositions / 2)) / matches) /
        3;

    // Winkler prefix bonus
    int prefixLength = 0;
    for (int i = 0; i < min(min(s1.length, s2.length), 4); i++) {
      if (s1[i] == s2[i]) {
        prefixLength++;
      } else {
        break;
      }
    }

    return jaro + prefixLength * 0.1 * (1.0 - jaro);
  }

  /// Inspects candidate [inputName] against [existingStudents],
  /// ignoring any student with [excludeId].
  ///
  /// Returns a sorted list of potential duplicate matches (highest match first).
  static List<NameDuplicateMatch> checkDuplicates(
    String inputName,
    List<Map<String, dynamic>> existingStudents, {
    int? excludeId,
    int maxResults = 5,
  }) {
    final rawInput = inputName.trim();
    if (rawInput.isEmpty) return const [];

    final normInput = normalize(rawInput);
    final spacelessInput = normalizeWithoutSpaces(rawInput);
    final inputTokens = normInput
        .split(' ')
        .where((t) => t.isNotEmpty)
        .toList();

    // If input is very short (less than 2 characters), don't trigger
    if (normInput.length < 2) return const [];

    final matches = <NameDuplicateMatch>[];

    for (final student in existingStudents) {
      if (excludeId != null && student['id'] == excludeId) {
        continue;
      }

      final studentName = student['name']?.toString().trim() ?? '';
      if (studentName.isEmpty) continue;

      // 1. Raw exact match
      if (studentName.toLowerCase() == rawInput.toLowerCase()) {
        matches.add(
          NameDuplicateMatch(
            student: student,
            matchLevel: NameMatchLevel.exact,
            similarity: 1.0,
            reasonKey: 'exact_name_match',
          ),
        );
        continue;
      }

      final normStudent = normalize(studentName);
      final spacelessStudent = normalizeWithoutSpaces(studentName);

      // 2. Normalized exact match (handles alif, ta marbuta, ya, compound spaces)
      if (normInput == normStudent || spacelessInput == spacelessStudent) {
        matches.add(
          NameDuplicateMatch(
            student: student,
            matchLevel: NameMatchLevel.normalizedExact,
            similarity: 1.0,
            reasonKey: 'normalized_exact_name_match',
          ),
        );
        continue;
      }

      // If input is just 1 word, only check for exact or spaceless matches
      // to avoid matching against every student sharing a single common first name.
      if (inputTokens.length < 2 && normInput.length < 6) {
        continue;
      }

      final studentTokens = normStudent
          .split(' ')
          .where((t) => t.isNotEmpty)
          .toList();

      if (studentTokens.isEmpty) continue;

      // 3. Prefix match (e.g. "أحمد محمد علي" vs "أحمد محمد علي حسن")
      final minTokenCount = min(inputTokens.length, studentTokens.length);
      if (minTokenCount >= 2) {
        bool isPrefixMatch = true;
        for (int i = 0; i < minTokenCount; i++) {
          if (inputTokens[i] != studentTokens[i]) {
            isPrefixMatch = false;
            break;
          }
        }
        if (isPrefixMatch) {
          final maxTokens = max(inputTokens.length, studentTokens.length);
          final sim = minTokenCount / maxTokens;
          matches.add(
            NameDuplicateMatch(
              student: student,
              matchLevel: NameMatchLevel.highSimilarity,
              similarity: sim >= 0.8 ? sim : 0.85,
              reasonKey: 'prefix_name_match',
              reasonArgs: [minTokenCount.toString()],
            ),
          );
          continue;
        }
      }

      // 4. Reordered tokens check (all words in one match the other in different order)
      if (inputTokens.length >= 2 &&
          inputTokens.length == studentTokens.length) {
        final setA = inputTokens.toSet();
        final setB = studentTokens.toSet();
        if (setA.length == setB.length && setA.containsAll(setB)) {
          matches.add(
            NameDuplicateMatch(
              student: student,
              matchLevel: NameMatchLevel.highSimilarity,
              similarity: 0.95,
              reasonKey: 'reordered_name_match',
            ),
          );
          continue;
        }
      }

      // 5. Jaro-Winkler string similarity
      final similarity = jaroWinklerSimilarity(normInput, normStudent);
      if (similarity >= 0.85) {
        matches.add(
          NameDuplicateMatch(
            student: student,
            matchLevel: NameMatchLevel.highSimilarity,
            similarity: similarity,
            reasonKey: 'high_name_similarity',
            reasonArgs: [(similarity * 100).toStringAsFixed(0)],
          ),
        );
      }
    }

    // Sort: exact first, then normalizedExact, then by similarity descending
    matches.sort((a, b) {
      if (a.matchLevel != b.matchLevel) {
        return a.matchLevel.index.compareTo(b.matchLevel.index);
      }
      return b.similarity.compareTo(a.similarity);
    });

    return matches.take(maxResults).toList();
  }
}
