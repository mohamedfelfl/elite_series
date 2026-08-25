import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../../app/constants/db_queries.dart';
import '../../../../app/services/database_service.dart';
import '../../domain/repositories/iqr_card_repository.dart';
import '../models/student_card_data.dart';

class QrCardRepository implements IQrCardRepository {
  final DatabaseService _databaseService;

  QrCardRepository({required DatabaseService databaseService})
      : _databaseService = databaseService;

  @override
  Future<List<StudentCardData>> getStudentsForCards() async {
    final Database db = await _databaseService.database;
    final List<Map<String, Object?>> studentsRaw = await db.rawQuery(
      '''
      ${DBQueries.getStudentsBase}
      ORDER BY s.name ASC
      ''',
    );
    return studentsRaw.map((s) => StudentCardData.fromMap(s)).toList();
  }

  @override
  Future<List<Map<String, Object?>>> getGroups() async {
    final Database db = await _databaseService.database;
    return await db.rawQuery(DBQueries.loadGroupsWithStudentCount);
  }

  @override
  Future<List<String>> getStages() async {
    final Database db = await _databaseService.database;
    final List<Map<String, Object?>> stagesRaw = await db.rawQuery(
      'SELECT DISTINCT grade FROM ${DBQueries.tableStudents} WHERE grade IS NOT NULL AND grade != "" ORDER BY grade ASC',
    );
    return stagesRaw
        .map((s) => (s['grade'] as String?)?.trim())
        .whereType<String>()
        .toList();
  }
}
