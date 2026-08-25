import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/app_constants.dart';

part 'student_card_data.freezed.dart';
part 'student_card_data.g.dart';

@freezed
abstract class StudentCardData with _$StudentCardData {
  const factory StudentCardData({
    required int id,
    required String studentCode,
    required String fullName,
    @Default('') String stageName,
    @Default('') String groupName,
    @Default('') String groupSchedule,
    required String qrPayload,
    DateTime? createdAt,
  }) = _StudentCardData;

  factory StudentCardData.fromJson(Map<String, dynamic> json) =>
      _$StudentCardDataFromJson(json);

  static String formatStageArabic(String? grade) {
    if (grade == null || grade.trim().isEmpty) return 'الصف الأول الثانوي';
    switch (grade.trim()) {
      case 'sec_1':
      case '1':
      case 'stage_1':
        return 'الصف الأول الثانوي';
      case 'sec_2':
      case '2':
      case 'stage_2':
        return 'الصف الثاني الثانوي';
      case 'sec_3':
      case '3':
      case 'stage_3':
        return 'الصف الثالث الثانوي';
      default:
        return grade;
    }
  }

  static String cleanGroupName(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    String n = name.trim();
    n = n.replaceAll('الثللاثاء', 'الثلاثاء');
    n = n.replaceAll(RegExp(r'\s*[123]\s*ث\s*'), ' ');
    n = n.replaceAll(RegExp(r'\s+'), ' ').trim();
    return n;
  }

  factory StudentCardData.fromMap(Map<String, dynamic> map) {
    final serial = map['serial_number'] as String? ?? '';
    final code = serial.isNotEmpty
        ? serial
        : '${AppConstants.studentCodePrefix}${(map['id'] as int? ?? 0).toString().padLeft(6, '0')}';

    final rawGrade =
        map['grade'] as String? ?? map['stage_name'] as String? ?? '';

    final createdAtRaw = map['created_at'] as String?;
    DateTime? createdAt;
    if (createdAtRaw != null && createdAtRaw.isNotEmpty) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }

    return StudentCardData(
      id: map['id'] as int? ?? 0,
      studentCode: code,
      fullName: map['name'] as String? ?? 'Student',
      stageName: formatStageArabic(rawGrade),
      groupName: cleanGroupName(map['group_name'] as String? ?? ''),
      groupSchedule: map['attendance_day'] as String? ??
          map['group_schedule'] as String? ??
          '',
      qrPayload: code,
      createdAt: createdAt,
    );
  }
}
