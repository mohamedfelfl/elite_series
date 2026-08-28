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
  });
}
