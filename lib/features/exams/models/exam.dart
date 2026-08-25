import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam.freezed.dart';
part 'exam.g.dart';

@freezed
abstract class Exam with _$Exam {
  const factory Exam({
    int? id,
    required String name,
    required double fullMark,
    required DateTime date,
  }) = _Exam;

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
}
