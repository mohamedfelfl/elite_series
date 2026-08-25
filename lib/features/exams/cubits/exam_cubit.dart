import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';
import '../models/student_exam_result.dart';

part 'exam_cubit.freezed.dart';

@freezed
abstract class ExamState with _$ExamState {
  const factory ExamState({
    @Default([]) List<Map<String, dynamic>> exams,
    @Default([]) List<Map<String, dynamic>> marks,
    @Default([]) List<Map<String, dynamic>> studentMarks,
    @Default([]) List<Map<String, dynamic>> groups,
    @Default([]) List<Map<String, dynamic>> groupStudents,
    @Default({}) Map<String, List<Map<String, dynamic>>> groupedExamStudents,
    @Default([]) List<StudentExamResult> topStudents,
    @Default(0.0) double averageScore,
    @Default(false) bool isLoading,
    String? error,
  }) = _ExamState;
}

class ExamCubit extends Cubit<ExamState> {
  final DatabaseService _databaseService;

  ExamCubit({required DatabaseService databaseService})
    : _databaseService = databaseService,
      super(const ExamState());

  void resetTopStudents() {
    emit(state.copyWith(topStudents: []));
  }

  Future<void> loadInitialData({DateTime? startDate, DateTime? endDate}) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await loadExams();
      await loadGroups();
      await calculateAverageScore();
      await getTopStudents(startDate: startDate, endDate: endDate);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> loadExams() async {
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.query(
        DBQueries.tableExams,
        orderBy: 'date DESC',
      );
      emit(state.copyWith(exams: results));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadGroups() async {
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.query(
        DBQueries.tableGroups,
        orderBy: 'name ASC',
      );
      final List<Map<String, dynamic>> groups = results.map((e) => Map<String, dynamic>.from(e)).toList();
      emit(state.copyWith(groups: groups));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> createExam(
    Map<String, dynamic> data, {
    List<int>? groupIds,
  }) async {
    try {
      final Database db = await _databaseService.database;
      await db.transaction((txn) async {
        final id = await txn.insert(DBQueries.tableExams, data);
        if (groupIds != null && groupIds.isNotEmpty) {
          for (final groupId in groupIds) {
            await txn.insert(DBQueries.tableExamGroups, {
              'exam_id': id,
              'group_id': groupId,
            });
          }
        }
      });
      await loadInitialData();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> updateExam(
    int id,
    Map<String, dynamic> data, {
    List<int>? groupIds,
  }) async {
    try {
      final Database db = await _databaseService.database;
      await db.transaction((txn) async {
        await txn.update(
          DBQueries.tableExams,
          data,
          where: 'id = ?',
          whereArgs: <Object?>[id],
        );
        if (groupIds != null) {
          await txn.delete(
            DBQueries.tableExamGroups,
            where: 'exam_id = ?',
            whereArgs: [id],
          );
          for (final groupId in groupIds) {
            await txn.insert(DBQueries.tableExamGroups, {
              'exam_id': id,
              'group_id': groupId,
            });
          }
        }
      });
      await loadInitialData();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteExam(int id) async {
    try {
      final Database db = await _databaseService.database;
      await db.delete(DBQueries.tableExams, where: 'id = ?', whereArgs: <Object?>[id]);
      await loadInitialData();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> calculateAverageScore() async {
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> totalMarksResult = await db.rawQuery(
        DBQueries.calculateAverageScoreTotalMarks,
      );
      final List<Map<String, Object?>> totalExamsResult = await db.rawQuery(
        DBQueries.calculateAverageScoreCountExams,
      );

      final double totalScore =
          (totalMarksResult.first['total'] as num?)?.toDouble() ?? 0.0;
      final int totalExams = (totalExamsResult.first['count'] as int?) ?? 1;

      final double average = totalExams > 0 ? totalScore / totalExams : 0.0;
      emit(state.copyWith(averageScore: average));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> getTopStudents({
    DateTime? startDate,
    DateTime? endDate,
    int? examId,
    int? groupId,
    int? limit,
  }) async {
    try {
      final Database db = await _databaseService.database;
      final List<String> conditions = [];
      List<Object?> args = [];

      if (startDate != null && endDate != null) {
        conditions.add(DBQueries.examDateRangeCondition);
        args.addAll([
          startDate.toIso8601String().split('T').first,
          endDate.toIso8601String().split('T').first,
        ]);
      }
      if (examId != null) {
        conditions.add(DBQueries.examIdCondition);
        args.add(examId);
      }

      String joinClause = DBQueries.getTopStudentsJoin;

      if (groupId != null) {
        conditions.add(DBQueries.studentGroupCondition);
        args.add(groupId);
 
        // If filtering by group but not a specific exam,
        // restrict results to exams explicitly assigned to this group via exam_groups.
        if (examId == null) {
          joinClause += '\n        ${DBQueries.examGroupJoinFragment}';
        }
      }

      final String whereClause = conditions.isNotEmpty
          ? 'WHERE ${conditions.join(' AND ')}'
          : '';

      String query =
          '''
        ${DBQueries.getTopStudentsSelect}
        $joinClause
        $whereClause
        GROUP BY s.id
        ORDER BY totalMarks DESC
      ''';

      if (limit != null) {
        query += '\n        LIMIT ?';
        args.add(limit);
      }

      final List<Map<String, Object?>> results = await db.rawQuery(query, args);

      final List<StudentExamResult> topStudents = results.map((r) {
        final double totalMarks = (r['totalMarks'] as num).toDouble();
        final double totalFullMarks = (r['totalFullMarks'] as num).toDouble();
        final double percentage = totalFullMarks > 0
            ? (totalMarks / totalFullMarks) * 100
            : 0.0;

        return StudentExamResult(
          studentId: r['studentId'] as int,
          studentName: r['studentName'] as String,
          serialNumber: r['serialNumber'] as String,
          totalMarks: totalMarks,
          totalFullMarks: totalFullMarks,
          percentage: percentage,
          examCount: r['examCount'] as int,
        );
      }).toList();

      emit(state.copyWith(topStudents: topStudents));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<List<int>> getExamGroups(int examId) async {
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.query(
        DBQueries.tableExamGroups,
        columns: ['group_id'],
        where: 'exam_id = ?',
        whereArgs: [examId],
      );
      return results.map((r) => r['group_id'] as int).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> loadGroupStudents(int groupId) async {
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.query(
        DBQueries.tableStudents,
        where: 'group_id = ?',
        whereArgs: [groupId],
        orderBy: 'name ASC',
      );
      emit(state.copyWith(groupStudents: results));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadExamStudents(int examId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;

      // Get all students from groups linked to this exam
      final List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.loadExamStudentsBase,
        [examId],
      );

      // Group them by group_name
      final Map<String, List<Map<String, dynamic>>> grouped = {};
      for (final student in results) {
        final groupName = student['group_name'] as String;
        if (!grouped.containsKey(groupName)) {
          grouped[groupName] = [];
        }
        grouped[groupName]!.add(student);
      }

      emit(state.copyWith(groupedExamStudents: grouped, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Load marks for a specific exam.
  Future<void> loadMarks(int examId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.loadMarksBase,
        <Object?>[examId],
      );
      emit(state.copyWith(marks: results, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Load all marks for a specific student.
  Future<void> loadStudentMarks(int studentId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final Database db = await _databaseService.database;
      final List<Map<String, Object?>> results = await db.rawQuery(
        DBQueries.loadStudentMarksBase,
        <Object?>[studentId],
      );

      final Set<int> seenExams = <int>{};
      final List<Map<String, Object?>> deduplicated = <Map<String, Object?>>[];
      for (final Map<String, Object?> row in results) {
        final int examId = row['exam_id'] as int;
        if (!seenExams.contains(examId)) {
          seenExams.add(examId);
          deduplicated.add(row);
        }
      }

      emit(state.copyWith(studentMarks: deduplicated, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  /// Save or update a mark for a student in an exam.
  Future<void> saveMark({
    required int examId,
    required int studentId,
    required double score,
  }) async {
    try {
      final Database db = await _databaseService.database;
      await db.insert('marks', <String, Object?>{
        'exam_id': examId,
        'student_id': studentId,
        'score': score,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      await calculateAverageScore();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Batch save marks for multiple students in an exam.
  Future<void> saveMarks(int examId, Map<int, double> studentScores) async {
    try {
      final Database db = await _databaseService.database;
      final Batch batch = db.batch();
      for (final MapEntry<int, double> entry in studentScores.entries) {
        batch.insert(DBQueries.tableMarks, <String, Object?>{
          'exam_id': examId,
          'student_id': entry.key,
          'score': entry.value,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      await loadMarks(examId);
      await calculateAverageScore();
      await getTopStudents();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Batch save marks without triggering state reloads.
  /// Used when saving before navigating away to avoid state churn.
  Future<void> saveMarksQuietly(
    int examId,
    Map<int, double> studentScores,
  ) async {
    try {
      final Database db = await _databaseService.database;
      final Batch batch = db.batch();
      for (final MapEntry<int, double> entry in studentScores.entries) {
        batch.insert(DBQueries.tableMarks, <String, Object?>{
          'exam_id': examId,
          'student_id': entry.key,
          'score': entry.value,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Get highest marks for an exam within a score range.
  Future<List<Map<String, Object?>>> getHighestMarks({
    int? examId,
    double? minScore,
    double? maxScore,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final Database db = await _databaseService.database;
      final List<String> conditions = <String>[];
      final List<Object?> args = <Object?>[];

      if (examId != null) {
        conditions.add(DBQueries.examIdCondition.replaceAll('e.id', 'm.exam_id'));
        args.add(examId);
      }
      if (minScore != null) {
        conditions.add(DBQueries.markScoreMinCondition);
        args.add(minScore);
      }
      if (maxScore != null) {
        conditions.add(DBQueries.markScoreMaxCondition);
        args.add(maxScore);
      }
      if (fromDate != null) {
        conditions.add(DBQueries.examFromDateCondition);
        args.add(fromDate.toIso8601String().split('T').first);
      }
      if (toDate != null) {
        conditions.add(DBQueries.examToDateCondition);
        args.add(toDate.toIso8601String().split('T').first);
      }

      final String whereClause = conditions.isEmpty
          ? ''
          : 'WHERE ${conditions.join(' AND ')}';

      return await db.rawQuery('''
        ${DBQueries.getHighestMarksBase}
        $whereClause
        ORDER BY m.score DESC
      ''', args);
    } catch (e) {
      return [];
    }
  }
}
