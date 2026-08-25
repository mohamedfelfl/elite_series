import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/app/utils/time_helper.dart';

void main() {
  group('TimeHelper Tests', () {
    test('normalizeDigits converts Eastern Arabic numerals to ASCII', () {
      expect(TimeHelper.normalizeDigits('٠١٢٣٤٥٦٧٨٩'), '0123456789');
      expect(TimeHelper.normalizeDigits('٠٢:٣٠ مساءً'), '02:30 مساءً');
    });

    test('parseTime parses 12-hour English time strings correctly', () {
      // PM times
      final pm1 = TimeHelper.parseTime('2:00 PM');
      expect(pm1, isNotNull);
      expect(pm1!.hour, 14);
      expect(pm1.minute, 0);

      final pm2 = TimeHelper.parseTime('02:30 pm');
      expect(pm2, isNotNull);
      expect(pm2!.hour, 14);
      expect(pm2.minute, 30);

      final pm12 = TimeHelper.parseTime('12:00 PM');
      expect(pm12, isNotNull);
      expect(pm12!.hour, 12);
      expect(pm12.minute, 0);

      // AM times
      final am1 = TimeHelper.parseTime('2:00 AM');
      expect(am1, isNotNull);
      expect(am1!.hour, 2);
      expect(am1.minute, 0);

      final am2 = TimeHelper.parseTime('09:45 am');
      expect(am2, isNotNull);
      expect(am2!.hour, 9);
      expect(am2.minute, 45);

      final am12 = TimeHelper.parseTime('12:00 AM');
      expect(am12, isNotNull);
      expect(am12!.hour, 0);
      expect(am12.minute, 0);
    });

    test('parseTime parses 12-hour Arabic time strings correctly', () {
      // Arabic PM (مساءً, مساء, م)
      final arPm1 = TimeHelper.parseTime('2:00 مساءً');
      expect(arPm1, isNotNull);
      expect(arPm1!.hour, 14);
      expect(arPm1.minute, 0);

      final arPm2 = TimeHelper.parseTime('02:30 مساء');
      expect(arPm2, isNotNull);
      expect(arPm2!.hour, 14);
      expect(arPm2.minute, 30);

      final arPm3 = TimeHelper.parseTime('5:15 م');
      expect(arPm3, isNotNull);
      expect(arPm3!.hour, 17);
      expect(arPm3.minute, 15);

      final arPm12 = TimeHelper.parseTime('12:00 مساءً');
      expect(arPm12, isNotNull);
      expect(arPm12!.hour, 12);
      expect(arPm12.minute, 0);

      // Arabic AM (صباحاً, صباح, ص)
      final arAm1 = TimeHelper.parseTime('2:00 صباحاً');
      expect(arAm1, isNotNull);
      expect(arAm1!.hour, 2);
      expect(arAm1.minute, 0);

      final arAm2 = TimeHelper.parseTime('08:45 صباح');
      expect(arAm2, isNotNull);
      expect(arAm2!.hour, 8);
      expect(arAm2.minute, 45);

      final arAm3 = TimeHelper.parseTime('10:00 ص');
      expect(arAm3, isNotNull);
      expect(arAm3!.hour, 10);
      expect(arAm3.minute, 0);

      final arAm12 = TimeHelper.parseTime('12:00 صباحاً');
      expect(arAm12, isNotNull);
      expect(arAm12!.hour, 0);
      expect(arAm12.minute, 0);

      // Eastern Arabic Digits
      final easternAr = TimeHelper.parseTime('٠٢:٠٠ مساءً');
      expect(easternAr, isNotNull);
      expect(easternAr!.hour, 14);
      expect(easternAr.minute, 0);
    });

    test('parseTime parses 24-hour time strings correctly', () {
      final t24_1 = TimeHelper.parseTime('14:00');
      expect(t24_1, isNotNull);
      expect(t24_1!.hour, 14);
      expect(t24_1.minute, 0);

      final t24_2 = TimeHelper.parseTime('08:30');
      expect(t24_2, isNotNull);
      expect(t24_2!.hour, 8);
      expect(t24_2.minute, 30);

      final t24_3 = TimeHelper.parseTime('00:00');
      expect(t24_3, isNotNull);
      expect(t24_3!.hour, 0);
      expect(t24_3.minute, 0);

      final t24_4 = TimeHelper.parseTime('23:59');
      expect(t24_4, isNotNull);
      expect(t24_4!.hour, 23);
      expect(t24_4.minute, 59);
    });

    test('parseTime returns null on invalid inputs', () {
      expect(TimeHelper.parseTime(null), isNull);
      expect(TimeHelper.parseTime(''), isNull);
      expect(TimeHelper.parseTime('   '), isNull);
      expect(TimeHelper.parseTime('invalid'), isNull);
      expect(TimeHelper.parseTime('25:00'), isNull);
      expect(TimeHelper.parseTime('12:60'), isNull);
    });

    test('formatForDb formats time in standard format', () {
      expect(
        TimeHelper.formatForDb(const TimeOfDay(hour: 14, minute: 0)),
        '2:00 PM',
      );
      expect(
        TimeHelper.formatForDb(const TimeOfDay(hour: 2, minute: 0)),
        '2:00 AM',
      );
      expect(
        TimeHelper.formatForDb(const TimeOfDay(hour: 0, minute: 0)),
        '12:00 AM',
      );
      expect(
        TimeHelper.formatForDb(const TimeOfDay(hour: 12, minute: 0)),
        '12:00 PM',
      );
      expect(
        TimeHelper.formatForDb(const TimeOfDay(hour: 9, minute: 5)),
        '9:05 AM',
      );
    });

    test('round-trip parsing and formatting works seamlessly', () {
      const times = [
        TimeOfDay(hour: 0, minute: 0),
        TimeOfDay(hour: 2, minute: 30),
        TimeOfDay(hour: 12, minute: 0),
        TimeOfDay(hour: 14, minute: 0),
        TimeOfDay(hour: 23, minute: 45),
      ];

      for (final t in times) {
        final dbString = TimeHelper.formatForDb(t);
        final parsed = TimeHelper.parseTime(dbString);
        expect(parsed, isNotNull);
        expect(parsed!.hour, t.hour);
        expect(parsed.minute, t.minute);
      }
    });
  });
}
