import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/app/utils/qr_code_helper.dart';

void main() {
  group('QrCodeHelper Tests', () {
    test('extracts direct standard serial number', () {
      expect(QrCodeHelper.extractSerialNumber('EL-01-00003'), 'EL-01-00003');
      expect(QrCodeHelper.extractSerialNumber('EL-02-00015'), 'EL-02-00015');
      expect(QrCodeHelper.extractSerialNumber('EL-03-00099'), 'EL-03-00099');
      expect(QrCodeHelper.extractSerialNumber('EL-000001'), 'EL-000001');
    });

    test('extracts serial from printed card pipe pattern', () {
      expect(
        QrCodeHelper.extractSerialNumber(
          'ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003',
        ),
        'EL-01-00003',
      );
      expect(
        QrCodeHelper.extractSerialNumber(
          'ELITE|stu_abc123def456|EL-02-00100',
        ),
        'EL-02-00100',
      );
      expect(
        QrCodeHelper.extractSerialNumber('ELITE|EL-01-00003'),
        'EL-01-00003',
      );
    });

    test('extracts serial from printed card hyphen pattern', () {
      expect(
        QrCodeHelper.extractSerialNumber(
          'ELITE-stu_bd02c7b92a2b49da8a-EL-01-00003',
        ),
        'EL-01-00003',
      );
    });

    test('handles whitespace and newlines from hardware barcode scanners', () {
      expect(
        QrCodeHelper.extractSerialNumber('  EL-01-00003  \n\r'),
        'EL-01-00003',
      );
      expect(
        QrCodeHelper.extractSerialNumber(
          '  ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003\r\n',
        ),
        'EL-01-00003',
      );
    });

    test('normalizes lowercase inputs to uppercase', () {
      expect(QrCodeHelper.extractSerialNumber('el-01-00003'), 'EL-01-00003');
      expect(
        QrCodeHelper.extractSerialNumber(
          'elite|stu_bd02c7b92a2b49da8a|el-01-00003',
        ),
        'EL-01-00003',
      );
    });

    test('handles empty and null inputs safely', () {
      expect(QrCodeHelper.extractSerialNumber(null), '');
      expect(QrCodeHelper.extractSerialNumber(''), '');
      expect(QrCodeHelper.extractSerialNumber('   '), '');
    });

    test('returns trimmed fallback if no EL- match found', () {
      expect(QrCodeHelper.extractSerialNumber('CUSTOM-999'), 'CUSTOM-999');
      expect(QrCodeHelper.extractSerialNumber('stu_12345'), 'stu_12345');
    });

    test('hasCompleteSerial detects completed serial numbers accurately', () {
      // Complete standard format
      expect(QrCodeHelper.hasCompleteSerial('EL-01-00003'), isTrue);
      expect(QrCodeHelper.hasCompleteSerial('EL-02-00045'), isTrue);
      expect(QrCodeHelper.hasCompleteSerial('ELITE|stu_123|EL-01-00003'), isTrue);

      // Complete legacy format
      expect(QrCodeHelper.hasCompleteSerial('EL-000001'), isTrue);

      // Incomplete / partial strings
      expect(QrCodeHelper.hasCompleteSerial('EL-01-'), isFalse);
      expect(QrCodeHelper.hasCompleteSerial('EL-01-000'), isFalse);
      expect(QrCodeHelper.hasCompleteSerial('EL-'), isFalse);
      expect(QrCodeHelper.hasCompleteSerial('EL'), isFalse);
      expect(QrCodeHelper.hasCompleteSerial(''), isFalse);
      expect(QrCodeHelper.hasCompleteSerial(null), isFalse);
      expect(QrCodeHelper.hasCompleteSerial('random text'), isFalse);
    });

    test('extractAllCandidates extracts serial, legacy ids, and segments in priority order', () {
      final candidates = QrCodeHelper.extractAllCandidates(
        'ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003',
      );
      expect(candidates, contains('EL-01-00003'));
      expect(candidates, contains('stu_bd02c7b92a2b49da8a'));
      expect(candidates.first, equals('EL-01-00003'));
    });

    test('extracts and corrects RTL-reversed serial numbers', () {
      expect(QrCodeHelper.extractSerialNumber('00202-03-EL'), 'EL-03-00202');
      expect(QrCodeHelper.extractSerialNumber('00045-02-EL'), 'EL-02-00045');
      expect(QrCodeHelper.extractSerialNumber('202-03-EL'), 'EL-03-202');
      expect(QrCodeHelper.extractSerialNumber('000001-EL'), 'EL-000001');
      expect(
        QrCodeHelper.extractSerialNumber('ELITE|stu_123|00202-03-EL'),
        'EL-03-00202',
      );
    });

    test('normalizes Eastern Arabic numerals to ASCII digits', () {
      expect(QrCodeHelper.extractSerialNumber('EL-٠٣-٠٠٢٠٢'), 'EL-03-00202');
      expect(QrCodeHelper.extractSerialNumber('٠٠٢٠٢-٠٣-EL'), 'EL-03-00202');
      expect(QrCodeHelper.extractSerialNumber('EL-٠١-٠٠٠٠٣'), 'EL-01-00003');
    });

    test('normalizes Arabic keyboard layout keystrokes (ثم -> EL)', () {
      expect(QrCodeHelper.extractSerialNumber('ثم-03-00202'), 'EL-03-00202');
      expect(QrCodeHelper.extractSerialNumber('00202-03-ثم'), 'EL-03-00202');
      expect(QrCodeHelper.extractSerialNumber('ثم-٠٣-٠٠٢٠٢'), 'EL-03-00202');
    });

    test('hasCompleteSerial detects reversed serial numbers and Arabic layout', () {
      expect(QrCodeHelper.hasCompleteSerial('00202-03-EL'), isTrue);
      expect(QrCodeHelper.hasCompleteSerial('000001-EL'), isTrue);
      expect(QrCodeHelper.hasCompleteSerial('ثم-03-00202'), isTrue);
      expect(QrCodeHelper.hasCompleteSerial('00202-03-ثم'), isTrue);
      expect(QrCodeHelper.hasCompleteSerial('EL-٠٣-٠٠٢٠٢'), isTrue);
    });

    test('extractNumericId extracts correct number from any format', () {
      expect(QrCodeHelper.extractNumericId('EL-03-00202'), 202);
      expect(QrCodeHelper.extractNumericId('00202-03-EL'), 202);
      expect(QrCodeHelper.extractNumericId('EL-000202'), 202);
      expect(QrCodeHelper.extractNumericId('202'), 202);
      expect(QrCodeHelper.extractNumericId('00202'), 202);
      expect(QrCodeHelper.extractNumericId('EL-٠٣-٠٠٢٠٢'), 202);
    });

    test('extractAllCandidates generates unpadded, padded, reversed, and legacy permutations', () {
      final candidates = QrCodeHelper.extractAllCandidates('EL-03-00202');
      expect(candidates, contains('EL-03-00202'));
      expect(candidates, contains('EL-03-202'));
      expect(candidates, contains('EL-3-00202'));
      expect(candidates, contains('EL-3-202'));
      expect(candidates, contains('00202-03-EL'));
      expect(candidates, contains('202-03-EL'));
      expect(candidates, contains('EL-000202'));
      expect(candidates, contains('202'));
      expect(candidates, contains('00202'));
      expect(candidates, contains('el-03-00202'));

      // If scanned reversed
      final revCandidates = QrCodeHelper.extractAllCandidates('00202-03-EL');
      expect(revCandidates, contains('EL-03-00202'));
      expect(revCandidates, contains('EL-03-202'));
      expect(revCandidates, contains('00202-03-EL'));
      expect(revCandidates, contains('202'));
    });
  });
}
