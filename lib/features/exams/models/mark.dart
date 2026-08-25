import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark.freezed.dart';
part 'mark.g.dart';

@freezed
abstract class Mark with _$Mark {
  const factory Mark({
    int? id,
    required int examId,
    required int studentId,
    required double score,

    /// Populated via join — not stored in marks table
    String? studentName,

    /// Populated via join — not stored in marks table
    String? examName,

    /// Populated via join — not stored in marks table
    double? examFullMark,
  }) = _Mark;

  factory Mark.fromJson(Map<String, dynamic> json) => _$MarkFromJson(json);
}

/// Extension for computed mark properties.
extension MarkGrade on Mark {
  /// Percentage score relative to full mark.
  double get percentage => examFullMark != null && examFullMark! > 0
      ? (score / examFullMark!) * 100
      : 0;
}
