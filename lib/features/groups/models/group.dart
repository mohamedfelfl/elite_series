import 'package:freezed_annotation/freezed_annotation.dart';
import 'group_schedule.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
abstract class Group with _$Group {
  const factory Group({
    int? id,
    required String name,
    String? grade,
    @Default([]) List<GroupSchedule> schedules,
    DateTime? createdAt,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
