import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_schedule.freezed.dart';
part 'group_schedule.g.dart';

@freezed
abstract class GroupSchedule with _$GroupSchedule {
  const factory GroupSchedule({
    int? id,
    int? groupId,
    required String dayOfWeek,
    required String time,
  }) = _GroupSchedule;

  factory GroupSchedule.fromJson(Map<String, dynamic> json) =>
      _$GroupScheduleFromJson(json);
}
