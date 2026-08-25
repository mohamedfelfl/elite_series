import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
abstract class Student with _$Student {
  const factory Student({
    int? id,
    required String serialNumber,
    required String name,
    @Default('') String address,
    @Default('') String phone1,
    @Default('') String phone2,
    @Default('') String fatherJob,
    @Default('') String school,
    @Default('') String previousTeacher,
    String? grade,

    /// Foreign key to the Group table
    int? groupId,

    /// Populated as a join field — not stored in student table
    String? groupName,
    @Default('normal') String studentStatus,
    String? attendanceDay,
    @Default('') String notes,
    DateTime? createdAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
