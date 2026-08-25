import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/features/groups/models/group.dart';
import 'package:student_management_system/features/groups/models/group_schedule.dart';

void main() {
  group('Group Model Tests', () {
    test('Group and GroupSchedule JSON serialization', () {
      final schedule = GroupSchedule(dayOfWeek: 'Saturday', time: '10:00 AM');

      final group = Group(
        id: 1,
        name: 'Physics Group A',
        grade: 'prep_1',
        schedules: [schedule],
      );

      final json = group.toJson();
      expect(json['name'], 'Physics Group A');
      expect(json['grade'], 'prep_1');
      expect(json['schedules'], isA<List>());

      final firstSchedule = json['schedules'][0];
      Map<String, dynamic> scheduleMap;
      if (firstSchedule is Map) {
        scheduleMap = Map<String, dynamic>.from(firstSchedule);
      } else {
        scheduleMap = firstSchedule.toJson();
      }
      expect(scheduleMap['dayOfWeek'] ?? scheduleMap['day_of_week'], 'Saturday');

      // Ensure the JSON is in a format fromJson expects (all Maps)
      final jsonForDeserialization = Map<String, dynamic>.from(json);
      jsonForDeserialization['schedules'] = (json['schedules'] as List)
          .map((s) => s is Map ? s : s.toJson())
          .toList();

      final fromJson = Group.fromJson(jsonForDeserialization);
      expect(fromJson.name, group.name);
      expect(fromJson.grade, 'prep_1');
      expect(fromJson.schedules.length, 1);
      expect(fromJson.schedules[0].dayOfWeek, 'Saturday');
    });
  });
}
