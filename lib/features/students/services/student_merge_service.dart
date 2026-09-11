import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';
import '../../../app/utils/arabic_name_helper.dart';

/// Represents a single student record participating in a duplicate group or merge.
class DuplicateStudent {
  final int id;
  final String name;
  final String serialNumber;
  final String phone1;
  final String phone2;
  final String address;
  final String fatherJob;
  final String school;
  final String? groupName;
  final int? groupId;
  final String? grade;
  final String notes;
  final int marksCount;
  final int attendanceCount;
  final int paymentsCount;
  final int notesDeliveredCount;
  final Map<String, dynamic> rawData;

  const DuplicateStudent({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.phone1,
    required this.phone2,
    required this.address,
    required this.fatherJob,
    required this.school,
    required this.groupName,
    required this.groupId,
    required this.grade,
    required this.notes,
    required this.marksCount,
    required this.attendanceCount,
    required this.paymentsCount,
    required this.notesDeliveredCount,
    required this.rawData,
  });

  factory DuplicateStudent.fromMap(
    Map<String, dynamic> map, {
    int marksCount = 0,
    int attendanceCount = 0,
    int paymentsCount = 0,
    int notesDeliveredCount = 0,
  }) {
    return DuplicateStudent(
      id: map['id'] as int,
      name: (map['name'] as String?)?.trim() ?? '',
      serialNumber: (map['serial_number'] as String?)?.trim() ?? '',
      phone1: (map['phone1'] as String?)?.trim() ?? '',
      phone2: (map['phone2'] as String?)?.trim() ?? '',
      address: (map['address'] as String?)?.trim() ?? '',
      fatherJob: (map['father_job'] as String?)?.trim() ?? '',
      school: (map['school'] as String?)?.trim() ?? '',
      groupName: map['group_name'] as String?,
      groupId: map['group_id'] as int?,
      grade: map['grade'] as String?,
      notes: (map['notes'] as String?)?.trim() ?? '',
      marksCount: marksCount,
      attendanceCount: attendanceCount,
      paymentsCount: paymentsCount,
      notesDeliveredCount: notesDeliveredCount,
      rawData: map,
    );
  }
}

/// Represents a cluster of detected duplicate student records.
class DuplicateStudentGroup {
  final String key;
  final String displayName;
  final List<DuplicateStudent> students;

  const DuplicateStudentGroup({
    required this.key,
    required this.displayName,
    required this.students,
  });
}

/// Summary of records to be moved/consolidated when merging students.
class MergeSummary {
  final DuplicateStudent primaryStudent;
  final List<DuplicateStudent> duplicateStudents;
  final int marksToTransfer;
  final int marksConflictsResolved;
  final int attendanceToTransfer;
  final int attendanceConflictsResolved;
  final int paymentsToTransfer;
  final int notesToTransfer;
  final int notesConflictsResolved;
  final List<String> profileFieldsUpdated;

  const MergeSummary({
    required this.primaryStudent,
    required this.duplicateStudents,
    required this.marksToTransfer,
    required this.marksConflictsResolved,
    required this.attendanceToTransfer,
    required this.attendanceConflictsResolved,
    required this.paymentsToTransfer,
    required this.notesToTransfer,
    required this.notesConflictsResolved,
    required this.profileFieldsUpdated,
  });
}

/// Service providing duplicate student detection and transactional merging.
class StudentMergeService {
  final DatabaseService _databaseService;

  StudentMergeService({required DatabaseService databaseService})
      : _databaseService = databaseService;

  /// Normalizes Arabic and general text for accurate duplicate matching:
  /// - Strips diacritics (harakat)
  /// - Normalizes hamzas ('أ', 'إ', 'آ', 'ٱ' -> 'ا')
  /// - Normalizes taa marbuta ('ة' -> 'ه')
  /// - Normalizes yaa / alef maqsura ('ى' -> 'ي')
  /// - Removes tatweel ('ـ')
  /// - Trims and collapses multiple spaces
  static String normalizeName(String name) {
    return ArabicNameHelper.normalize(name);
  }

  /// Scans all students and detects duplicate clusters based on normalized name.
  Future<List<DuplicateStudentGroup>> findDuplicates() async {
    final db = await _databaseService.database;

    final studentRows = await db.rawQuery(DBQueries.getStudentsBase);
    if (studentRows.isEmpty) return [];

    final Map<String, List<Map<String, dynamic>>> groupsMap = {};

    for (final row in studentRows) {
      final name = (row['name'] as String?)?.trim() ?? '';
      if (name.isEmpty) continue;

      final normalized = normalizeName(name);
      if (normalized.isEmpty) continue;

      groupsMap.putIfAbsent(normalized, () => []).add(row);
    }

    final List<DuplicateStudentGroup> result = [];

    for (final entry in groupsMap.entries) {
      if (entry.value.length > 1) {
        final List<DuplicateStudent> studentList = [];

        for (final raw in entry.value) {
          final id = raw['id'] as int;
          final stats = await _fetchStudentStats(db, id);

          studentList.add(DuplicateStudent.fromMap(
            raw,
            marksCount: stats['marks'] ?? 0,
            attendanceCount: stats['attendance'] ?? 0,
            paymentsCount: stats['payments'] ?? 0,
            notesDeliveredCount: stats['notes'] ?? 0,
          ));
        }

        result.add(DuplicateStudentGroup(
          key: entry.key,
          displayName: studentList.first.name,
          students: studentList,
        ));
      }
    }

    return result;
  }

  /// Fetches data counts for a single student.
  Future<Map<String, int>> _fetchStudentStats(
    DatabaseExecutor executor,
    int studentId,
  ) async {
    final marksCount = Sqflite.firstIntValue(await executor.rawQuery(
          'SELECT COUNT(*) FROM ${DBQueries.tableMarks} WHERE student_id = ?',
          [studentId],
        )) ??
        0;

    final attendanceCount = Sqflite.firstIntValue(await executor.rawQuery(
          'SELECT COUNT(*) FROM ${DBQueries.tableAttendance} WHERE student_id = ?',
          [studentId],
        )) ??
        0;

    final paymentsCount = Sqflite.firstIntValue(await executor.rawQuery(
          'SELECT COUNT(*) FROM ${DBQueries.tablePayments} WHERE student_id = ?',
          [studentId],
        )) ??
        0;

    final notesCount = Sqflite.firstIntValue(await executor.rawQuery(
          'SELECT COUNT(*) FROM ${DBQueries.tableStudentNotes} WHERE student_id = ?',
          [studentId],
        )) ??
        0;

    return {
      'marks': marksCount,
      'attendance': attendanceCount,
      'payments': paymentsCount,
      'notes': notesCount,
    };
  }

  /// Calculates a preview summary of what data will be merged.
  Future<MergeSummary> previewMerge({
    required int primaryId,
    required List<int> duplicateIds,
  }) async {
    final db = await _databaseService.database;

    final primaryRows = await db.rawQuery(DBQueries.getStudentById, [primaryId]);
    if (primaryRows.isEmpty) {
      throw Exception('Primary student not found');
    }

    final primaryStats = await _fetchStudentStats(db, primaryId);
    final primaryStudent = DuplicateStudent.fromMap(
      primaryRows.first,
      marksCount: primaryStats['marks'] ?? 0,
      attendanceCount: primaryStats['attendance'] ?? 0,
      paymentsCount: primaryStats['payments'] ?? 0,
      notesDeliveredCount: primaryStats['notes'] ?? 0,
    );

    final List<DuplicateStudent> duplicates = [];
    int marksToTransfer = 0;
    int marksConflictsResolved = 0;
    int attendanceToTransfer = 0;
    int attendanceConflictsResolved = 0;
    int paymentsToTransfer = 0;
    int notesToTransfer = 0;
    int notesConflictsResolved = 0;
    final Set<String> profileFieldsUpdated = {};

    // Get primary existing exam IDs and attendance keys
    final primaryMarks = await db.query(
      DBQueries.tableMarks,
      columns: ['exam_id'],
      where: 'student_id = ?',
      whereArgs: [primaryId],
    );
    final primaryExamIds = primaryMarks.map((m) => m['exam_id'] as int).toSet();

    final primaryAttendance = await db.query(
      DBQueries.tableAttendance,
      columns: ['lesson_id', 'date'],
      where: 'student_id = ?',
      whereArgs: [primaryId],
    );
    final primaryLessons = primaryAttendance
        .where((a) => a['lesson_id'] != null)
        .map((a) => a['lesson_id'] as int)
        .toSet();
    final primaryDates = primaryAttendance
        .where((a) => a['lesson_id'] == null)
        .map((a) => a['date'] as String)
        .toSet();

    final primaryNotes = await db.query(
      DBQueries.tableStudentNotes,
      columns: ['note_id'],
      where: 'student_id = ?',
      whereArgs: [primaryId],
    );
    final primaryNoteIds = primaryNotes.map((n) => n['note_id'] as int).toSet();

    for (final dupId in duplicateIds) {
      final dupRows = await db.rawQuery(DBQueries.getStudentById, [dupId]);
      if (dupRows.isEmpty) continue;

      final dupStats = await _fetchStudentStats(db, dupId);
      final dupStudent = DuplicateStudent.fromMap(
        dupRows.first,
        marksCount: dupStats['marks'] ?? 0,
        attendanceCount: dupStats['attendance'] ?? 0,
        paymentsCount: dupStats['payments'] ?? 0,
        notesDeliveredCount: dupStats['notes'] ?? 0,
      );
      duplicates.add(dupStudent);

      // Check marks
      final dupMarks = await db.query(
        DBQueries.tableMarks,
        columns: ['exam_id'],
        where: 'student_id = ?',
        whereArgs: [dupId],
      );
      for (final m in dupMarks) {
        final examId = m['exam_id'] as int;
        if (primaryExamIds.contains(examId)) {
          marksConflictsResolved++;
        } else {
          marksToTransfer++;
        }
      }

      // Check attendance
      final dupAttendance = await db.query(
        DBQueries.tableAttendance,
        columns: ['lesson_id', 'date'],
        where: 'student_id = ?',
        whereArgs: [dupId],
      );
      for (final a in dupAttendance) {
        final lessonId = a['lesson_id'] as int?;
        final date = a['date'] as String;
        if (lessonId != null && primaryLessons.contains(lessonId)) {
          attendanceConflictsResolved++;
        } else if (lessonId == null && primaryDates.contains(date)) {
          attendanceConflictsResolved++;
        } else {
          attendanceToTransfer++;
        }
      }

      // Payments
      paymentsToTransfer += dupStats['payments'] ?? 0;

      // Notes
      final dupNotes = await db.query(
        DBQueries.tableStudentNotes,
        columns: ['note_id'],
        where: 'student_id = ?',
        whereArgs: [dupId],
      );
      for (final n in dupNotes) {
        final noteId = n['note_id'] as int;
        if (primaryNoteIds.contains(noteId)) {
          notesConflictsResolved++;
        } else {
          notesToTransfer++;
        }
      }

      // Profile backfill check
      if (primaryStudent.phone1.isEmpty && dupStudent.phone1.isNotEmpty) {
        profileFieldsUpdated.add('phone1');
      }
      if (primaryStudent.phone2.isEmpty &&
          (dupStudent.phone2.isNotEmpty ||
              (dupStudent.phone1.isNotEmpty &&
                  dupStudent.phone1 != primaryStudent.phone1))) {
        profileFieldsUpdated.add('phone2');
      }
      if (primaryStudent.address.isEmpty && dupStudent.address.isNotEmpty) {
        profileFieldsUpdated.add('address');
      }
      if (primaryStudent.fatherJob.isEmpty && dupStudent.fatherJob.isNotEmpty) {
        profileFieldsUpdated.add('father_job');
      }
      if (primaryStudent.school.isEmpty && dupStudent.school.isNotEmpty) {
        profileFieldsUpdated.add('school');
      }
      if (primaryStudent.notes.isEmpty && dupStudent.notes.isNotEmpty) {
        profileFieldsUpdated.add('notes');
      }
    }

    return MergeSummary(
      primaryStudent: primaryStudent,
      duplicateStudents: duplicates,
      marksToTransfer: marksToTransfer,
      marksConflictsResolved: marksConflictsResolved,
      attendanceToTransfer: attendanceToTransfer,
      attendanceConflictsResolved: attendanceConflictsResolved,
      paymentsToTransfer: paymentsToTransfer,
      notesToTransfer: notesToTransfer,
      notesConflictsResolved: notesConflictsResolved,
      profileFieldsUpdated: profileFieldsUpdated.toList(),
    );
  }

  /// Merges all specified duplicate student records into the primary student record
  /// within an atomic database transaction.
  Future<void> mergeStudents({
    required int primaryId,
    required List<int> duplicateIds,
  }) async {
    final db = await _databaseService.database;

    await db.transaction((txn) async {
      final primaryRows = await txn.rawQuery(
        'SELECT * FROM ${DBQueries.tableStudents} WHERE id = ?',
        [primaryId],
      );
      if (primaryRows.isEmpty) {
        throw Exception('Primary student with ID $primaryId not found.');
      }
      final Map<String, dynamic> primary =
          Map<String, dynamic>.from(primaryRows.first);

      for (final dupId in duplicateIds) {
        if (dupId == primaryId) continue;

        final dupRows = await txn.rawQuery(
          'SELECT * FROM ${DBQueries.tableStudents} WHERE id = ?',
          [dupId],
        );
        if (dupRows.isEmpty) continue;
        final Map<String, dynamic> dup =
            Map<String, dynamic>.from(dupRows.first);

        // 1. Consolidate Attendance
        final dupAttendance = await txn.query(
          DBQueries.tableAttendance,
          where: 'student_id = ?',
          whereArgs: [dupId],
        );

        for (final att in dupAttendance) {
          final attId = att['id'] as int;
          final lessonId = att['lesson_id'] as int?;
          final date = att['date'] as String;
          final status = att['status'] as String? ?? 'attended';
          final notes = att['notes'] as String? ?? '';

          List<Map<String, dynamic>> primaryMatches;
          if (lessonId != null) {
            primaryMatches = await txn.query(
              DBQueries.tableAttendance,
              where: 'student_id = ? AND lesson_id = ?',
              whereArgs: [primaryId, lessonId],
            );
          } else {
            primaryMatches = await txn.query(
              DBQueries.tableAttendance,
              where: 'student_id = ? AND date = ? AND lesson_id IS NULL',
              whereArgs: [primaryId, date],
            );
          }

          if (primaryMatches.isNotEmpty) {
            final existingAtt = primaryMatches.first;
            final existingAttId = existingAtt['id'] as int;
            final existingStatus = existingAtt['status'] as String? ?? 'absent';
            final existingNotes = existingAtt['notes'] as String? ?? '';

            // Prefer 'attended' over 'absent'
            final shouldPromoteStatus =
                status == 'attended' && existingStatus != 'attended';

            String updatedNotes = existingNotes;
            if (notes.isNotEmpty && !existingNotes.contains(notes)) {
              updatedNotes = existingNotes.isEmpty
                  ? notes
                  : '$existingNotes | $notes';
            }

            if (shouldPromoteStatus || updatedNotes != existingNotes) {
              await txn.update(
                DBQueries.tableAttendance,
                {
                  if (shouldPromoteStatus) 'status': 'attended',
                  'notes': updatedNotes,
                },
                where: 'id = ?',
                whereArgs: [existingAttId],
              );
            }

            // Remove the duplicate attendance row
            await txn.delete(
              DBQueries.tableAttendance,
              where: 'id = ?',
              whereArgs: [attId],
            );
          } else {
            // Reassign to primary
            await txn.update(
              DBQueries.tableAttendance,
              {'student_id': primaryId},
              where: 'id = ?',
              whereArgs: [attId],
            );
          }
        }

        // 2. Consolidate Marks (Handle UNIQUE(exam_id, student_id))
        final dupMarks = await txn.query(
          DBQueries.tableMarks,
          where: 'student_id = ?',
          whereArgs: [dupId],
        );

        for (final m in dupMarks) {
          final markId = m['id'] as int;
          final examId = m['exam_id'] as int;
          final score = (m['score'] as num).toDouble();

          final primaryMarkMatches = await txn.query(
            DBQueries.tableMarks,
            where: 'student_id = ? AND exam_id = ?',
            whereArgs: [primaryId, examId],
          );

          if (primaryMarkMatches.isNotEmpty) {
            final primaryMark = primaryMarkMatches.first;
            final primaryScore = (primaryMark['score'] as num).toDouble();

            // Preserve highest mark
            if (score > primaryScore) {
              await txn.update(
                DBQueries.tableMarks,
                {'score': score},
                where: 'id = ?',
                whereArgs: [primaryMark['id']],
              );
            }
            // Delete duplicate mark record
            await txn.delete(
              DBQueries.tableMarks,
              where: 'id = ?',
              whereArgs: [markId],
            );
          } else {
            // Reassign to primary
            await txn.update(
              DBQueries.tableMarks,
              {'student_id': primaryId},
              where: 'id = ?',
              whereArgs: [markId],
            );
          }
        }

        // 3. Consolidate Payments (Transfer receipts)
        await txn.update(
          DBQueries.tablePayments,
          {'student_id': primaryId},
          where: 'student_id = ?',
          whereArgs: [dupId],
        );

        // 4. Consolidate Student Notes (Handle UNIQUE(student_id, note_id))
        final dupNotes = await txn.query(
          DBQueries.tableStudentNotes,
          where: 'student_id = ?',
          whereArgs: [dupId],
        );

        for (final n in dupNotes) {
          final noteDeliveryId = n['id'] as int;
          final noteId = n['note_id'] as int;

          final primaryNoteMatches = await txn.query(
            DBQueries.tableStudentNotes,
            where: 'student_id = ? AND note_id = ?',
            whereArgs: [primaryId, noteId],
          );

          if (primaryNoteMatches.isNotEmpty) {
            // Already delivered to primary, delete duplicate delivery log
            await txn.delete(
              DBQueries.tableStudentNotes,
              where: 'id = ?',
              whereArgs: [noteDeliveryId],
            );
          } else {
            // Reassign to primary
            await txn.update(
              DBQueries.tableStudentNotes,
              {'student_id': primaryId},
              where: 'id = ?',
              whereArgs: [noteDeliveryId],
            );
          }
        }

        // 5. Backfill Profile Information on Primary
        final pPhone1 = (primary['phone1'] as String?)?.trim() ?? '';
        final pPhone2 = (primary['phone2'] as String?)?.trim() ?? '';
        final dPhone1 = (dup['phone1'] as String?)?.trim() ?? '';
        final dPhone2 = (dup['phone2'] as String?)?.trim() ?? '';

        if (pPhone1.isEmpty && dPhone1.isNotEmpty) {
          primary['phone1'] = dPhone1;
        }
        if (pPhone2.isEmpty) {
          if (dPhone2.isNotEmpty) {
            primary['phone2'] = dPhone2;
          } else if (dPhone1.isNotEmpty && dPhone1 != primary['phone1']) {
            primary['phone2'] = dPhone1;
          }
        }

        if (((primary['address'] as String?)?.trim() ?? '').isEmpty &&
            ((dup['address'] as String?)?.trim() ?? '').isNotEmpty) {
          primary['address'] = dup['address'];
        }
        if (((primary['father_job'] as String?)?.trim() ?? '').isEmpty &&
            ((dup['father_job'] as String?)?.trim() ?? '').isNotEmpty) {
          primary['father_job'] = dup['father_job'];
        }
        if (((primary['school'] as String?)?.trim() ?? '').isEmpty &&
            ((dup['school'] as String?)?.trim() ?? '').isNotEmpty) {
          primary['school'] = dup['school'];
        }
        if (((primary['previous_teacher'] as String?)?.trim() ?? '').isEmpty &&
            ((dup['previous_teacher'] as String?)?.trim() ?? '').isNotEmpty) {
          primary['previous_teacher'] = dup['previous_teacher'];
        }
        if (primary['group_id'] == null && dup['group_id'] != null) {
          primary['group_id'] = dup['group_id'];
        }
        if (((primary['grade'] as String?)?.trim() ?? '').isEmpty &&
            ((dup['grade'] as String?)?.trim() ?? '').isNotEmpty) {
          primary['grade'] = dup['grade'];
        }
        if (((primary['attendance_day'] as String?)?.trim() ?? '').isEmpty &&
            ((dup['attendance_day'] as String?)?.trim() ?? '').isNotEmpty) {
          primary['attendance_day'] = dup['attendance_day'];
        }

        // Merge notes
        final pNotes = (primary['notes'] as String?)?.trim() ?? '';
        final dNotes = (dup['notes'] as String?)?.trim() ?? '';
        final dName = dup['name']?.toString().trim() ?? '';
        final dSerial = dup['serial_number']?.toString().trim() ?? '';

        if (dNotes.isNotEmpty) {
          if (pNotes.isEmpty) {
            primary['notes'] = dNotes;
          } else {
            primary['notes'] =
                '$pNotes\n[Merged from $dName ($dSerial)]: $dNotes';
          }
        }

        // 6. Delete Duplicate Student Record
        await txn.delete(
          DBQueries.tableStudents,
          where: 'id = ?',
          whereArgs: [dupId],
        );
      }

      // Update primary student record in database
      await txn.update(
        DBQueries.tableStudents,
        {
          'phone1': primary['phone1'] ?? '',
          'phone2': primary['phone2'] ?? '',
          'address': primary['address'] ?? '',
          'father_job': primary['father_job'] ?? '',
          'school': primary['school'] ?? '',
          'previous_teacher': primary['previous_teacher'] ?? '',
          'group_id': primary['group_id'],
          'grade': primary['grade'],
          'attendance_day': primary['attendance_day'],
          'notes': primary['notes'] ?? '',
        },
        where: 'id = ?',
        whereArgs: [primaryId],
      );
    });
  }
}
