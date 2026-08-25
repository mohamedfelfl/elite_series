import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_exam_result.freezed.dart';
part 'student_exam_result.g.dart';

@freezed
abstract class StudentExamResult with _$StudentExamResult {
  const factory StudentExamResult({
    required int studentId,
    required String studentName,
    required String serialNumber,
    required double totalMarks,
    required double totalFullMarks,
    required double percentage,
    @Default(0) int examCount,
  }) = _StudentExamResult;

  factory StudentExamResult.fromJson(Map<String, dynamic> json) =>
      _$StudentExamResultFromJson(json);
}
