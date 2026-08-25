import '../../data/models/student_card_data.dart';

abstract class IQrCardRepository {
  Future<List<StudentCardData>> getStudentsForCards();
  Future<List<Map<String, Object?>>> getGroups();
  Future<List<String>> getStages();
}
