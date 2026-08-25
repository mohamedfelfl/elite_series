import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

/// Status of a classroom lesson session.
enum LessonStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}

@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    int? id,
    required int groupId,
    required String date, // 'YYYY-MM-DD'
    required String startTime,
    String? endTime,
    @Default('') String title,
    @Default(LessonStatus.scheduled) LessonStatus status,
    String? groupName,
    @Default(0) int enrolledCount,
    @Default(0) int attendedCount,
    @Default(0) int otherGroupCount,
    @Default(0) int absentCount,
    DateTime? createdAt,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
