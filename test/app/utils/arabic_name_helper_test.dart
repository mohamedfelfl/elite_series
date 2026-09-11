import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/app/utils/arabic_name_helper.dart';

void main() {
  group('ArabicNameHelper Normalization Tests', () {
    test('Alif variations normalize to bare alif (ا)', () {
      expect(ArabicNameHelper.normalize('أحمد'), equals('احمد'));
      expect(ArabicNameHelper.normalize('إبراهيم'), equals('ابراهيم'));
      expect(ArabicNameHelper.normalize('آدم'), equals('ادم'));
      expect(ArabicNameHelper.normalize('ٱسماعيل'), equals('اسماعيل'));
    });

    test('Ta Marbuta (ة) normalizes to Ha (ه)', () {
      expect(ArabicNameHelper.normalize('فاطمة'), equals('فاطمه'));
      expect(ArabicNameHelper.normalize('أسامة'), equals('اسامه'));
      expect(ArabicNameHelper.normalize('حمزة'), equals('حمزه'));
      expect(ArabicNameHelper.normalize('حبيبة'), equals('حبيبه'));
    });

    test('Ya (ي) and Alif Maqsura (ى) and Hamza on Nabrah (ئ) normalize to (ي)', () {
      expect(ArabicNameHelper.normalize('مصطفى'), equals('مصطفي'));
      expect(ArabicNameHelper.normalize('يحيى'), equals('يحيي'));
      expect(ArabicNameHelper.normalize('علي'), equals('علي'));
      expect(ArabicNameHelper.normalize('على'), equals('علي'));
      expect(ArabicNameHelper.normalize('منى'), equals('مني'));
      expect(ArabicNameHelper.normalize('وائل'), equals('وايل'));
    });

    test('Waw with Hamza (ؤ) normalizes to Waw (و)', () {
      expect(ArabicNameHelper.normalize('مؤمن'), equals('مومن'));
      expect(ArabicNameHelper.normalize('لؤي'), equals('لوي'));
    });

    test('Tashkeel and Tatweel are stripped cleanly', () {
      expect(ArabicNameHelper.normalize('مُحَمَّدٌ'), equals('محمد'));
      expect(ArabicNameHelper.normalize('عَبْدُ الرَّحْمَنِ'), equals('عبدالرحمن'));
      expect(ArabicNameHelper.normalize('مـحـمـد'), equals('محمد'));
    });

    test('Compound prefix (عبد) spacing variations are unified', () {
      // User specific example: عبد المنعم / عبدالمنعم
      expect(ArabicNameHelper.normalize('عبد المنعم'), equals('عبدالمنعم'));
      expect(ArabicNameHelper.normalize('عبدالمنعم'), equals('عبدالمنعم'));
      expect(
        ArabicNameHelper.areNormalizedExact('عبد المنعم محمد أحمد', 'عبدالمنعم محمد احمد'),
        isTrue,
      );

      // Other abd compounds
      expect(
        ArabicNameHelper.areNormalizedExact('عبد الله', 'عبدالله'),
        isTrue,
      );
      expect(
        ArabicNameHelper.areNormalizedExact('عبد الرحمن', 'عبدالرحمن'),
        isTrue,
      );
      expect(
        ArabicNameHelper.areNormalizedExact('عبد العزيز', 'عبدالعزيز'),
        isTrue,
      );
    });

    test('Compound prefix (ابو / أبو) spacing variations are unified', () {
      expect(ArabicNameHelper.normalize('أبو بكر'), equals('ابوبكر'));
      expect(ArabicNameHelper.normalize('ابوبكر'), equals('ابوبكر'));
      expect(
        ArabicNameHelper.areNormalizedExact('أبو بكر الصديق', 'ابوبكر الصديق'),
        isTrue,
      );
    });

    test('Compound suffix (الدين / الله) spacing variations are unified', () {
      expect(ArabicNameHelper.normalize('علاء الدين'), equals('علاءالدين'));
      expect(ArabicNameHelper.normalize('علاءالدين'), equals('علاءالدين'));
      expect(
        ArabicNameHelper.areNormalizedExact('علاء الدين يحيى', 'علاءالدين يحيي'),
        isTrue,
      );

      expect(ArabicNameHelper.normalize('سيف الدين'), equals('سيفالدين'));
      expect(ArabicNameHelper.normalize('جاد الله'), equals('جادالله'));
    });

    test('Multiple whitespaces are collapsed to single space', () {
      expect(
        ArabicNameHelper.normalize('  أحمد     محمد     علي  '),
        equals('احمد محمد علي'),
      );
    });
  });

  group('ArabicNameHelper checkDuplicates Tests', () {
    final existingStudents = [
      {
        'id': 1,
        'name': 'عبدالمنعم محمد أحمد',
        'serial_number': '101',
        'group_name': 'Group A',
        'phone1': '01000000001',
      },
      {
        'id': 2,
        'name': 'أحمد محمد علي حسن',
        'serial_number': '102',
        'group_name': 'Group B',
        'phone1': '01000000002',
      },
      {
        'id': 3,
        'name': 'فاطمة مصطفى',
        'serial_number': '103',
        'group_name': 'Group C',
        'phone1': '01000000003',
      },
    ];

    test('detects normalized exact duplicate for "عبد المنعم محمد احمد"', () {
      final matches = ArabicNameHelper.checkDuplicates(
        'عبد المنعم محمد احمد',
        existingStudents,
      );

      expect(matches, isNotEmpty);
      expect(matches.first.student['id'], equals(1));
      expect(matches.first.matchLevel, equals(NameMatchLevel.normalizedExact));
    });

    test('detects normalized exact duplicate for "فاطمه مصطفي"', () {
      final matches = ArabicNameHelper.checkDuplicates(
        'فاطمه مصطفي',
        existingStudents,
      );

      expect(matches, isNotEmpty);
      expect(matches.first.student['id'], equals(3));
      expect(matches.first.matchLevel, equals(NameMatchLevel.normalizedExact));
    });

    test('detects prefix match when student has first 3 names identical', () {
      final matches = ArabicNameHelper.checkDuplicates(
        'احمد محمد علي',
        existingStudents,
      );

      expect(matches, isNotEmpty);
      final match = matches.firstWhere((m) => m.student['id'] == 2);
      expect(match.matchLevel, equals(NameMatchLevel.highSimilarity));
      expect(match.reasonKey, equals('prefix_name_match'));
    });

    test('excludes the student being edited by excludeId', () {
      final matches = ArabicNameHelper.checkDuplicates(
        'عبد المنعم محمد احمد',
        existingStudents,
        excludeId: 1,
      );

      expect(matches.where((m) => m.student['id'] == 1), isEmpty);
    });

    test('ignores very short input (< 2 characters)', () {
      final matches = ArabicNameHelper.checkDuplicates('أ', existingStudents);
      expect(matches, isEmpty);
    });
  });
}
