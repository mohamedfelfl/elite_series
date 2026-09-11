import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../app/constants/db_queries.dart';
import '../../../app/services/database_service.dart';

part 'report_cubit.freezed.dart';

enum ReportType {
  student,
  weekly,
  monthly,
  highestMarks,
  collection,
  attendanceDate,
  dailyPayments,
  groupPayments,
  assistant,
  notesDelivery,
  lessonSession,
  absenteeFollowUp,
  groupAttendanceSummary,
}

@freezed
abstract class ReportState with _$ReportState {
  const factory ReportState({
    @Default(false) bool isLoading,
    @Default(false) bool isGenerated,
    pw.Document? pdfDocument,
    String? error,
  }) = _ReportState;
}

class ReportCubit extends Cubit<ReportState> {
  final DatabaseService _databaseService;

  ReportCubit({required DatabaseService databaseService})
      : _databaseService = databaseService,
        super(const ReportState());

  void resetState() {
    emit(const ReportState());
  }

  /// Whether the current active locale is RTL (Arabic).
  bool get _isRtl {
    final sample = LocaleKeys.save.tr();
    return RegExp(r'[\u0600-\u06FF]').hasMatch(sample);
  }

  pw.TextDirection get _textDirection =>
      _isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;

  pw.Alignment get _tableAlignment =>
      _isRtl ? pw.Alignment.centerRight : pw.Alignment.centerLeft;

  /// Optimized page format giving 555pt of printable width on A4 portrait.
  PdfPageFormat get _pageFormat => PdfPageFormat.a4.copyWith(
        marginLeft: 20,
        marginRight: 20,
        marginTop: 24,
        marginBottom: 24,
      );

  Future<pw.Document> _createDocument() async {
    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();
    return pw.Document(
      theme: pw.ThemeData.withFont(base: font, bold: fontBold),
    );
  }

  /// Generate a full report for a single student.
  Future<void> generateStudentReport(int studentId) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;

      final studentRows = await db.rawQuery(
        DBQueries.reportStudentInfo,
        [studentId],
      );

      if (studentRows.isEmpty) {
        emit(ReportState(error: LocaleKeys.student_not_found.tr()));
        return;
      }

      final student = studentRows.first;
      final marks = await db.rawQuery(
        DBQueries.reportStudentMarks,
        [studentId],
      );
      final attendance = await db.rawQuery(
        DBQueries.reportStudentAttendance,
        [studentId],
      );
      final payments = await db.rawQuery(
        DBQueries.reportStudentPayments,
        [studentId],
      );

      final pdf = await _createDocument();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                LocaleKeys.student_report.tr(),
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            _buildStudentInfoSection(student),
            pw.SizedBox(height: 16),
            _buildMarksSection(marks),
            pw.SizedBox(height: 16),
            _buildAttendanceSection(attendance),
            pw.SizedBox(height: 16),
            _buildPaymentSection(
              payments,
              isFree: student['student_status'] == 'free',
            ),
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  /// Generate a report for payments made on a specific day.
  Future<void> generateDailyPaymentReport(DateTime date) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;
      final String dateStr = date.toIso8601String().split('T').first;

      final paymentRows = await db.rawQuery(
        DBQueries.reportDailyPayments,
        ['$dateStr%'],
      );

      final freeStudentsAttended = await db.rawQuery(
        '''
        SELECT DISTINCT s.id as student_id, s.name as student_name, s.serial_number, s.student_status,
               0.0 as paid_amount, 0.0 as total_amount, a.date as paid_date, 0 as month, 0 as year
        FROM attendance a
        JOIN students s ON a.student_id = s.id
        WHERE a.date = ? AND s.student_status = 'free'
        ORDER BY s.name ASC
        ''',
        [dateStr],
      );

      final Set<dynamic> existingStudentIds =
          paymentRows.map((r) => r['student_id']).toSet();

      final List<Map<String, dynamic>> combinedResults = [
        ...paymentRows.map((r) => Map<String, dynamic>.from(r)),
        ...freeStudentsAttended
            .where((r) => !existingStudentIds.contains(r['student_id']))
            .map((r) => Map<String, dynamic>.from(r)),
      ];

      final pdf = await _createDocument();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    LocaleKeys.daily_payments_report_title.tr(),
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(dateStr, style: const pw.TextStyle(fontSize: 14)),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
            if (combinedResults.isEmpty)
              pw.Center(
                child: pw.Text(
                  LocaleKeys.no_payments_today.tr(),
                  style: const pw.TextStyle(fontSize: 16),
                ),
              )
            else ...[
              pw.TableHelper.fromTextArray(
                tableDirection: _textDirection,
                headerDirection: _textDirection,
                headerAlignment: _tableAlignment,
                cellAlignment: _tableAlignment,
                columnWidths: {
                  0: const pw.FixedColumnWidth(60),
                  1: const pw.FlexColumnWidth(3.0),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.8),
                  4: const pw.FlexColumnWidth(1.2),
                },
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                headerPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                headerStyle: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headers: [
                  LocaleKeys.serial_number.tr(),
                  LocaleKeys.student.tr(),
                  LocaleKeys.month_year.tr(),
                  LocaleKeys.paid_amount.tr(),
                  LocaleKeys.time.tr(),
                ],
                data: combinedResults.map((r) {
                  final bool isFree = r['student_status'] == 'free';
                  final String studentName = isFree
                      ? '${r['student_name']} (${LocaleKeys.free_student.tr()})'
                      : r['student_name'].toString();
                  final int month = (r['month'] as num?)?.toInt() ?? 0;
                  final int year = (r['year'] as num?)?.toInt() ?? 0;
                  final String monthYearStr = isFree && month == 0
                      ? '-'
                      : '$month/$year';

                  final String paidAmountStr = isFree
                      ? '${LocaleKeys.free.tr()} (0.00)'
                      : '${LocaleKeys.currency_symbol.tr()} ${(r['paid_amount'] as num).toDouble().toStringAsFixed(2)}';

                  final paidDateStr = r['paid_date']?.toString() ?? '';
                  final String timeStr = paidDateStr.contains('T')
                      ? DateFormat('HH:mm').format(DateTime.parse(paidDateStr))
                      : '-';

                  return [
                    r['serial_number']?.toString() ?? '',
                    studentName,
                    monthYearStr,
                    paidAmountStr,
                    timeStr,
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (combinedResults.any((r) => r['student_status'] == 'free'))
                    pw.Text(
                      '${LocaleKeys.free_students_count.tr()}: ${combinedResults.where((r) => r['student_status'] == 'free').length} (${LocaleKeys.exempt_no_payments.tr()})',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.amber900,
                      ),
                    )
                  else
                    pw.SizedBox(),
                  pw.Row(
                    children: [
                      pw.Text(
                        '${LocaleKeys.total.tr()}: ',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${LocaleKeys.currency_symbol.tr()} ${combinedResults.fold(0.0, (sum, r) => sum + (r['student_status'] == 'free' ? 0.0 : (r['paid_amount'] as num).toDouble())).toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  Future<void> generateHighestMarksReport({
    int? examId,
    List<int>? examIds,
    int? groupId,
    int? limit,
    double? minScore,
    double? maxScore,
    DateTime? fromDate,
    DateTime? toDate,
    bool fullMarkOnly = false,
  }) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;
      final conditions = <String>[];
      final args = <dynamic>[];

      final effectiveExamIds = <int>{
        ?examId,
        ...?examIds,
      }.toList();

      if (effectiveExamIds.isNotEmpty) {
        if (effectiveExamIds.length == 1) {
          conditions.add('m.exam_id = ?');
          args.add(effectiveExamIds.first);
        } else {
          conditions.add(
            'm.exam_id IN (${List.filled(effectiveExamIds.length, '?').join(', ')})',
          );
          args.addAll(effectiveExamIds);
        }
      }
      if (groupId != null) {
        conditions.add('s.group_id = ?');
        args.add(groupId);
      }
      if (fullMarkOnly) {
        conditions.add('m.score >= e.full_mark');
      } else {
        if (minScore != null) {
          conditions.add('m.score >= ?');
          args.add(minScore);
        }
        if (maxScore != null) {
          conditions.add('m.score <= ?');
          args.add(maxScore);
        }
      }
      if (fromDate != null) {
        conditions.add('e.date >= ?');
        args.add(fromDate.toIso8601String().split('T').first);
      }
      if (toDate != null) {
        conditions.add('e.date <= ?');
        args.add(toDate.toIso8601String().split('T').first);
      }

      final whereClause = conditions.isEmpty
          ? ''
          : 'WHERE ${conditions.join(' AND ')}';

      String query = '''
        ${DBQueries.reportHighestMarksBase}
        $whereClause
        ORDER BY (CAST(m.score AS REAL) / e.full_mark) DESC, m.score DESC, s.name ASC
      ''';

      if (!fullMarkOnly && limit != null) {
        query += '\n        LIMIT ?';
        args.add(limit);
      }

      final results = await db.rawQuery(query, args);

      String? examsSubtitle;
      if (effectiveExamIds.isNotEmpty) {
        final examRows = await db.rawQuery(
          'SELECT name FROM exams WHERE id IN (${List.filled(effectiveExamIds.length, '?').join(', ')})',
          effectiveExamIds,
        );
        final names = examRows.map((r) => r['name'].toString()).toList();
        if (names.isNotEmpty) {
          examsSubtitle = '${LocaleKeys.exams.tr()}: ${names.join(' - ')}';
        }
      }

      final pdf = await _createDocument();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                fullMarkOnly
                    ? LocaleKeys.full_mark_students_report_title.tr()
                    : LocaleKeys.highest_marks_report_title.tr(),
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            if (examsSubtitle != null) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                examsSubtitle,
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.blueGrey700,
                ),
              ),
            ],
            pw.SizedBox(height: 12),
            pw.TableHelper.fromTextArray(
              tableDirection: _textDirection,
              headerDirection: _textDirection,
              headerAlignment: _tableAlignment,
              cellAlignment: _tableAlignment,
              columnWidths: {
                0: const pw.FixedColumnWidth(55),
                1: const pw.FlexColumnWidth(3.0),
                2: const pw.FlexColumnWidth(2.0),
                3: const pw.FlexColumnWidth(1.4),
                4: const pw.FlexColumnWidth(1.4),
                5: const pw.FlexColumnWidth(1.2),
              },
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              headerPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              headerStyle: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9.5),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.blueGrey800),
              headers: [
                LocaleKeys.serial_number.tr(),
                LocaleKeys.student.tr(),
                LocaleKeys.exam.tr(),
                LocaleKeys.score.tr(),
                LocaleKeys.full_mark.tr(),
                LocaleKeys.percentage.tr(),
              ],
              data: results.map((r) {
                final score = (r['score'] as num).toDouble();
                final fullMark = (r['full_mark'] as num).toDouble();
                final pct = fullMark > 0
                    ? (score / fullMark * 100).toStringAsFixed(1)
                    : '0';
                return [
                  r['serial_number'].toString(),
                  r['student_name'].toString(),
                  r['exam_name'].toString(),
                  score.toStringAsFixed(1),
                  fullMark.toStringAsFixed(1),
                  '$pct%',
                ];
              }).toList(),
            ),
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  /// Generate a report of student attendance filtered by date range.
  Future<void> generateAttendanceReport({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;
      final conditions = <String>[];
      final args = <dynamic>[];

      if (fromDate != null) {
        conditions.add('a.date >= ?');
        args.add(fromDate.toIso8601String().split('T').first);
      }
      if (toDate != null) {
        conditions.add('a.date <= ?');
        args.add(toDate.toIso8601String().split('T').first);
      }

      final whereClause = conditions.isEmpty
          ? ''
          : 'WHERE ${conditions.join(' AND ')}';

      final results = await db.rawQuery('''
        ${DBQueries.reportAttendanceBase}
        $whereClause
        ORDER BY a.date DESC, s.name ASC
      ''', args);

      final pdf = await _createDocument();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                LocaleKeys.attendance_report_title.tr(),
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            if (fromDate != null || toDate != null)
              pw.Text(
                '${LocaleKeys.period.tr()}: ${fromDate?.toIso8601String().split('T').first ?? LocaleKeys.any.tr()} ${LocaleKeys.to.tr()} ${toDate?.toIso8601String().split('T').first ?? LocaleKeys.any.tr()}',
                style: const pw.TextStyle(fontSize: 13),
              ),
            pw.SizedBox(height: 12),
            if (results.isEmpty)
              pw.Text(LocaleKeys.no_attendance_records_found.tr())
            else
              pw.TableHelper.fromTextArray(
                tableDirection: _textDirection,
                headerDirection: _textDirection,
                headerAlignment: _tableAlignment,
                cellAlignment: _tableAlignment,
                columnWidths: {
                  0: const pw.FixedColumnWidth(65),
                  1: const pw.FixedColumnWidth(55),
                  2: const pw.FlexColumnWidth(3.0),
                  3: const pw.FlexColumnWidth(2.0),
                  4: const pw.FlexColumnWidth(1.5),
                  5: const pw.FlexColumnWidth(2.0),
                },
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                headerPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                headerStyle: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headers: [
                  LocaleKeys.date.tr(),
                  LocaleKeys.serial_number.tr(),
                  LocaleKeys.student.tr(),
                  LocaleKeys.group.tr(),
                  LocaleKeys.status.tr(),
                  LocaleKeys.notes.tr(),
                ],
                data: results.map((r) {
                  final bool isFree = r['student_status'] == 'free';
                  final status = r['status']?.toString() ?? '';
                  final notes = r['notes']?.toString() ?? '';
                  final displayStatus =
                      (status == 'attended' || status == 'otherLesson')
                          ? LocaleKeys.present.tr()
                          : (status == 'missed'
                              ? LocaleKeys.absent.tr()
                              : LocaleKeys.other_lesson.tr());
                  final studentName = isFree
                      ? '${r['student_name']} (${LocaleKeys.free_student.tr()})'
                      : r['student_name'].toString();
                  final displayNotes = isFree
                      ? (notes.isNotEmpty
                          ? '$notes - ${LocaleKeys.exempt_no_payments.tr()}'
                          : LocaleKeys.exempt_no_payments.tr())
                      : notes;
                  return [
                    r['date'].toString(),
                    r['serial_number'].toString(),
                    studentName,
                    r['group_name']?.toString() ?? LocaleKeys.na.tr(),
                    displayStatus,
                    displayNotes,
                  ];
                }).toList(),
              ),
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  pw.Widget _buildStudentInfoSection(Map<String, dynamic> student) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            LocaleKeys.student_info.tr(),
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  '${LocaleKeys.name.tr()}: ${student['name']}',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  '${LocaleKeys.serial_number.tr()}: ${student['serial_number']}',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  '${LocaleKeys.group.tr()}: ${student['group_name'] ?? LocaleKeys.na.tr()}',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  '${LocaleKeys.phone.tr()}: ${student['phone1'] ?? '-'}',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  '${LocaleKeys.student_status.tr()}: ${student['student_status'] == 'free' ? LocaleKeys.exempt_no_payments.tr() : LocaleKeys.normal.tr()}',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: student['student_status'] == 'free'
                        ? pw.FontWeight.bold
                        : pw.FontWeight.normal,
                    color: student['student_status'] == 'free'
                        ? PdfColors.amber900
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMarksSection(List<Map<String, dynamic>> marks) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          LocaleKeys.exam_results.tr(),
          style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        if (marks.isEmpty)
          pw.Text(LocaleKeys.no_exam_records.tr())
        else
          pw.TableHelper.fromTextArray(
            tableDirection: _textDirection,
            headerDirection: _textDirection,
            headerAlignment: _tableAlignment,
            cellAlignment: _tableAlignment,
            columnWidths: {
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(1.2),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(1.2),
              4: const pw.FlexColumnWidth(1.5),
            },
            cellPadding:
                const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            headerPadding:
                const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            headerStyle: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9.5),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.blueGrey800),
            headers: [
              LocaleKeys.exam.tr(),
              LocaleKeys.score.tr(),
              LocaleKeys.full_mark.tr(),
              LocaleKeys.percentage.tr(),
              LocaleKeys.date.tr(),
            ],
            data: marks.map((m) {
              final score = (m['score'] as num).toDouble();
              final fullMark = (m['full_mark'] as num).toDouble();
              final pct = fullMark > 0
                  ? (score / fullMark * 100).toStringAsFixed(1)
                  : '0';
              return [
                m['exam_name'].toString(),
                score.toStringAsFixed(1),
                fullMark.toStringAsFixed(1),
                '$pct%',
                m['date'].toString(),
              ];
            }).toList(),
          ),
      ],
    );
  }

  pw.Widget _buildAttendanceSection(List<Map<String, dynamic>> attendance) {
    final total = attendance.length;
    final attended = attendance.where((a) => a['status'] == 'attended').length;
    final rate = total > 0 ? (attended / total * 100).toStringAsFixed(1) : '0';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          LocaleKeys.attendance.tr(),
          style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          '${LocaleKeys.attendance_rate_label.tr()}: $rate% ($attended/$total)',
          style: const pw.TextStyle(fontSize: 11),
        ),
        pw.SizedBox(height: 6),
        if (attendance.isNotEmpty)
          pw.TableHelper.fromTextArray(
            tableDirection: _textDirection,
            headerDirection: _textDirection,
            headerAlignment: _tableAlignment,
            cellAlignment: _tableAlignment,
            columnWidths: {
              0: const pw.FlexColumnWidth(1.8),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(2.5),
            },
            cellPadding:
                const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            headerPadding:
                const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            headerStyle: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9.5),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.blueGrey800),
            headers: [
              LocaleKeys.date.tr(),
              LocaleKeys.status.tr(),
              LocaleKeys.notes.tr(),
            ],
            data: attendance.take(20).map((a) {
              final status = a['status']?.toString() ?? '';
              final notes = a['notes']?.toString() ?? '';
              final displayStatus =
                  (status == 'attended' || status == 'otherLesson')
                      ? LocaleKeys.present.tr()
                      : (status == 'missed'
                          ? LocaleKeys.absent.tr()
                          : LocaleKeys.other_lesson.tr());
              return [a['date'].toString(), displayStatus, notes];
            }).toList(),
          ),
      ],
    );
  }

  pw.Widget _buildPaymentSection(
    List<Map<String, dynamic>> payments, {
    bool isFree = false,
  }) {
    if (isFree) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            LocaleKeys.payment_history.tr(),
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(
              color: PdfColors.amber50,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Row(
              children: [
                pw.Text(
                  LocaleKeys.exempt_no_payments.tr(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.amber900,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          LocaleKeys.payment_history.tr(),
          style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        if (payments.isEmpty)
          pw.Text(LocaleKeys.no_payment_records.tr())
        else
          pw.TableHelper.fromTextArray(
            tableDirection: _textDirection,
            headerDirection: _textDirection,
            headerAlignment: _tableAlignment,
            cellAlignment: _tableAlignment,
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
            },
            cellPadding:
                const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            headerPadding:
                const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            headerStyle: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9.5),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.blueGrey800),
            headers: [
              LocaleKeys.month_year.tr(),
              LocaleKeys.total.tr(),
              LocaleKeys.paid.tr(),
              LocaleKeys.remaining.tr(),
            ],
            data: payments.map((p) {
              final total = (p['total_amount'] as num).toDouble();
              final paid = (p['paid_amount'] as num).toDouble();
              return [
                '${p['month']}/${p['year']}',
                '${LocaleKeys.currency_symbol.tr()} ${total.toStringAsFixed(2)}',
                '${LocaleKeys.currency_symbol.tr()} ${paid.toStringAsFixed(2)}',
                '${LocaleKeys.currency_symbol.tr()} ${(total - paid).toStringAsFixed(2)}',
              ];
            }).toList(),
          ),
      ],
    );
  }

  /// Generate a report for payments made by students in a specific group within a month range.
  Future<void> generateGroupPaymentsReport({
    required int groupId,
    required String groupName,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;

      final int startVal = fromDate.year * 12 + fromDate.month;
      final int endVal = toDate.year * 12 + toDate.month;
      final minVal = startVal <= endVal ? startVal : endVal;
      final maxVal = startVal > endVal ? startVal : endVal;

      final results = await db.rawQuery(
        DBQueries.reportGroupPayments,
        [groupId, minVal, maxVal],
      );

      final freeStudentsInGroup = await db.rawQuery(
        '''
        SELECT s.id as student_id, s.name as student_name, s.serial_number, s.student_status,
               0.0 as total_amount, 0.0 as paid_amount, 0 as month, 0 as year
        FROM students s
        WHERE s.group_id = ? AND s.student_status = 'free'
        ORDER BY s.name ASC
        ''',
        [groupId],
      );

      final Set<dynamic> existingStudentIds =
          results.map((r) => r['student_id']).toSet();

      final List<Map<String, dynamic>> combinedGroupPayments = [
        ...results.map((r) => Map<String, dynamic>.from(r)),
        ...freeStudentsInGroup
            .where((r) => !existingStudentIds.contains(r['student_id']))
            .map((r) => Map<String, dynamic>.from(r)),
      ];

      final pdf = await _createDocument();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    LocaleKeys.group_payments_report_title.tr(),
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(groupName, style: const pw.TextStyle(fontSize: 14)),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            if (combinedGroupPayments.isEmpty)
              pw.Center(
                child: pw.Text(
                  LocaleKeys.no_payments_period.tr(),
                  style: const pw.TextStyle(fontSize: 16),
                ),
              )
            else ...[
              pw.TableHelper.fromTextArray(
                tableDirection: _textDirection,
                headerDirection: _textDirection,
                headerAlignment: _tableAlignment,
                cellAlignment: _tableAlignment,
                columnWidths: {
                  0: const pw.FixedColumnWidth(55),
                  1: const pw.FlexColumnWidth(3.0),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(1.5),
                  5: const pw.FlexColumnWidth(1.5),
                },
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                headerPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                headerStyle: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headers: [
                  LocaleKeys.serial_number.tr(),
                  LocaleKeys.student.tr(),
                  LocaleKeys.month_year.tr(),
                  LocaleKeys.total.tr(),
                  LocaleKeys.paid.tr(),
                  LocaleKeys.remaining.tr(),
                ],
                data: combinedGroupPayments.map((r) {
                  final bool isFree = r['student_status'] == 'free';
                  final String studentName = isFree
                      ? '${r['student_name']} (${LocaleKeys.free_student.tr()})'
                      : r['student_name'].toString();
                  final int month = (r['month'] as num?)?.toInt() ?? 0;
                  final int year = (r['year'] as num?)?.toInt() ?? 0;
                  final String monthYearStr = isFree && month == 0
                      ? '-'
                      : '$month/$year';

                  final double total =
                      (r['total_amount'] as num?)?.toDouble() ?? 0.0;
                  final double paid =
                      (r['paid_amount'] as num?)?.toDouble() ?? 0.0;

                  final String totalStr = isFree
                      ? '0.00'
                      : '${LocaleKeys.currency_symbol.tr()} ${total.toStringAsFixed(2)}';
                  final String paidStr = isFree
                      ? '${LocaleKeys.free.tr()} (0.00)'
                      : '${LocaleKeys.currency_symbol.tr()} ${paid.toStringAsFixed(2)}';
                  final String remainingStr = isFree
                      ? '0.00 (${LocaleKeys.free.tr()})'
                      : '${LocaleKeys.currency_symbol.tr()} ${(total - paid).toStringAsFixed(2)}';

                  return [
                    r['serial_number']?.toString() ?? '',
                    studentName,
                    monthYearStr,
                    totalStr,
                    paidStr,
                    remainingStr,
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (combinedGroupPayments
                      .any((r) => r['student_status'] == 'free'))
                    pw.Text(
                      '${LocaleKeys.free_students_count.tr()}: ${combinedGroupPayments.where((r) => r['student_status'] == 'free').length} (${LocaleKeys.exempt_no_payments.tr()})',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.amber900,
                      ),
                    )
                  else
                    pw.SizedBox(),
                  pw.Row(
                    children: [
                      pw.Text(
                        '${LocaleKeys.total.tr()}: ',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${LocaleKeys.currency_symbol.tr()} ${combinedGroupPayments.fold(0.0, (sum, r) => sum + (r['student_status'] == 'free' ? 0.0 : (r['paid_amount'] as num).toDouble())).toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  /// Generate an attendance report for assistants.
  Future<void> generateAssistantReport(
    int assistantId, {
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;
      final conditions = <String>['aa.assistant_id = ?'];
      final args = <dynamic>[assistantId];

      if (fromDate != null) {
        conditions.add('aa.date >= ?');
        args.add(fromDate.toIso8601String().split('T').first);
      }
      if (toDate != null) {
        conditions.add('aa.date <= ?');
        args.add(toDate.toIso8601String().split('T').first);
      }

      final whereClause = 'WHERE ${conditions.join(' AND ')}';

      final results = await db.rawQuery('''
        SELECT aa.*, a.name as assistant_name
        FROM assistant_attendance aa
        JOIN assistants a ON aa.assistant_id = a.id
        $whereClause
        ORDER BY aa.date DESC, aa.id DESC
      ''', args);

      final pdf = await _createDocument();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                LocaleKeys.assistant_attendance_report_title.tr(),
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 12),
            if (results.isEmpty)
              pw.Text(LocaleKeys.no_assistant_attendance.tr())
            else
              pw.TableHelper.fromTextArray(
                tableDirection: _textDirection,
                headerDirection: _textDirection,
                headerAlignment: _tableAlignment,
                cellAlignment: _tableAlignment,
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.5),
                  1: const pw.FlexColumnWidth(1.8),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                },
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                headerPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                headerStyle: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headers: [
                  LocaleKeys.name.tr(),
                  LocaleKeys.date.tr(),
                  LocaleKeys.time.tr(),
                  LocaleKeys.type.tr(),
                ],
                data: results.map((r) {
                  final type = r['type']?.toString() ?? '';
                  final displayType = type == 'check_in'
                      ? LocaleKeys.check_in.tr()
                      : (type == 'check_out'
                          ? LocaleKeys.check_out.tr()
                          : type);
                  return [
                    r['assistant_name'].toString(),
                    r['date'].toString(),
                    r['time'].toString(),
                    displayType,
                  ];
                }).toList(),
              ),
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  /// Generate Notes Delivery Matrix Report.
  Future<void> generateNotesDeliveryReport({
    int? noteId,
    int? groupId,
    String? groupName,
    int? studentId,
  }) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;

      final notes = noteId != null
          ? await db.query(DBQueries.tableNotes,
              where: 'id = ?', whereArgs: [noteId], orderBy: 'id ASC')
          : await db.query(DBQueries.tableNotes, orderBy: 'id ASC');

      List<Map<String, Object?>> students;
      if (studentId != null) {
        students = await db.query(
          DBQueries.tableStudents,
          where: 'id = ?',
          whereArgs: [studentId],
        );
      } else if (groupId != null) {
        students = await db.query(
          DBQueries.tableStudents,
          where: 'group_id = ?',
          whereArgs: [groupId],
          orderBy: 'name ASC',
        );
      } else {
        students = await db.query(
          DBQueries.tableStudents,
          orderBy: 'name ASC',
        );
      }

      if (students.isEmpty) {
        emit(ReportState(error: LocaleKeys.no_students_found.tr()));
        return;
      }

      final studentIds = students.map((s) => s['id'] as int).toList();
      final placeholders = List.filled(studentIds.length, '?').join(',');
      final deliveries = await db.rawQuery(
        'SELECT * FROM ${DBQueries.tableStudentNotes} WHERE student_id IN ($placeholders)',
        studentIds,
      );

      final deliverySet = <String>{};
      for (final d in deliveries) {
        deliverySet.add('${d['student_id']}_${d['note_id']}');
      }

      final pdf = await _createDocument();

      String title = LocaleKeys.notes_delivery_report_title.tr();
      if (groupName != null) {
        title += ' - $groupName';
      } else if (studentId != null && students.isNotEmpty) {
        title += ' - ${students.first['name']}';
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 12),
            pw.TableHelper.fromTextArray(
              tableDirection: _textDirection,
              headerDirection: _textDirection,
              headerAlignment: _tableAlignment,
              cellAlignment: _tableAlignment,
              columnWidths: {
                0: const pw.FixedColumnWidth(55),
                1: const pw.FlexColumnWidth(3.0),
                for (int i = 0; i < notes.length; i++)
                  (i + 2): const pw.FlexColumnWidth(1.5),
              },
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              headerPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              headerStyle: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9.5),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.blueGrey800),
              headers: [
                LocaleKeys.serial_number.tr(),
                LocaleKeys.student.tr(),
                ...notes.map((n) => n['name'] as String),
              ],
              data: students.map((s) {
                final sId = s['id'] as int;
                final bool isFree = s['student_status'] == 'free';
                final String studentName = isFree
                    ? '${s['name']} (${LocaleKeys.free_student.tr()})'
                    : s['name'].toString();
                return [
                  s['serial_number'].toString(),
                  studentName,
                  ...notes.map((n) {
                    final nId = n['id'] as int;
                    final key = '${sId}_$nId';
                    return deliverySet.contains(key)
                        ? LocaleKeys.yes.tr()
                        : LocaleKeys.no.tr();
                  }),
                ];
              }).toList(),
            ),
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  /// Generate a unified PDF report for a lesson session combining attendance roster and absentee parent follow-up sheet.
  Future<void> generateLessonSessionReport(int lessonId) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;

      final List<Map<String, Object?>> lessonRows = await db.rawQuery(
        DBQueries.loadLessonById,
        [lessonId],
      );

      if (lessonRows.isEmpty) {
        emit(ReportState(error: LocaleKeys.no_attendance_records.tr()));
        return;
      }

      final lesson = lessonRows.first;
      final int groupId = lesson['group_id'] as int;
      final int enrolled = (lesson['enrolled_count'] as int?) ?? 0;
      final int attended = (lesson['attended_count'] as int?) ?? 0;
      final int otherGroup = (lesson['other_group_count'] as int?) ?? 0;
      final int totalPresent = attended + otherGroup;
      final int absent = (enrolled - attended).clamp(0, 999999);
      final double rate =
          enrolled > 0 ? (attended / enrolled * 100).clamp(0, 100) : 100.0;

      // 1. Attended students in this lesson session
      final List<Map<String, Object?>> attendanceRows = await db.rawQuery(
        DBQueries.loadLessonAttendance,
        [lessonId],
      );

      // 2. Absent students from the enrolled group
      final List<Map<String, Object?>> absentStudents = await db.rawQuery(
        DBQueries.reportAbsentStudentsForLesson,
        [groupId, lessonId],
      );

      final pdf = await _createDocument();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            // Header
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    LocaleKeys.lesson_report.tr(),
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '${lesson['date']} | ${lesson['start_time']}${lesson['end_time'] != null && lesson['end_time'].toString().isNotEmpty && lesson['end_time'].toString() != 'null' ? ' - ${lesson['end_time']}' : ''}',
                    style: const pw.TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            // KPI Summary Card
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildPdfKpi(
                    LocaleKeys.group.tr(),
                    lesson['group_name']?.toString() ?? '',
                  ),
                  _buildPdfKpi(
                    LocaleKeys.enrolled_students.tr(),
                    enrolled.toString(),
                  ),
                  _buildPdfKpi(
                    LocaleKeys.present.tr(),
                    '$totalPresent ($attended + $otherGroup)',
                  ),
                  _buildPdfKpi(
                    LocaleKeys.absent.tr(),
                    absent.toString(),
                  ),
                  _buildPdfKpi(
                    LocaleKeys.attendance_rate_pct.tr(),
                    '${rate.toStringAsFixed(1)}%',
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),

            // SECTION 1: ATTENDED STUDENTS
            pw.Row(
              children: [
                pw.Container(
                  width: 8,
                  height: 8,
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.green700,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.SizedBox(width: 6),
                pw.Text(
                  LocaleKeys.attended_tab
                      .tr(args: [attendanceRows.length.toString()]),
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 6),
            if (attendanceRows.isEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Text(
                  LocaleKeys.no_attendance_records.tr(),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              )
            else
              pw.TableHelper.fromTextArray(
                tableDirection: _textDirection,
                headerDirection: _textDirection,
                headerAlignment: _tableAlignment,
                cellAlignment: _tableAlignment,
                columnWidths: {
                  0: const pw.FixedColumnWidth(24),
                  1: const pw.FixedColumnWidth(55),
                  2: const pw.FlexColumnWidth(3.0),
                  3: const pw.FlexColumnWidth(2.0),
                  4: const pw.FlexColumnWidth(1.8),
                  5: const pw.FlexColumnWidth(2.0),
                },
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                headerPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                headerStyle: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headers: [
                  '#',
                  LocaleKeys.serial_number.tr(),
                  LocaleKeys.student.tr(),
                  LocaleKeys.school_group.tr(),
                  LocaleKeys.status.tr(),
                  LocaleKeys.notes.tr(),
                ],
                data: attendanceRows.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final r = entry.value;
                  final bool isFree = r['student_status'] == 'free';
                  final status = r['status']?.toString() ?? '';
                  final displayStatus = status == 'attended'
                      ? LocaleKeys.present.tr()
                      : (status == 'otherLesson'
                          ? LocaleKeys.other_lesson.tr()
                          : LocaleKeys.absent.tr());
                  final studentName = isFree
                      ? '${r['student_name']} (${LocaleKeys.free_student.tr()})'
                      : (r['student_name']?.toString() ?? '');
                  final displayNotes = isFree
                      ? ((r['notes']?.toString() ?? '').isNotEmpty
                          ? '${r['notes']} - ${LocaleKeys.exempt_no_payments.tr()}'
                          : LocaleKeys.exempt_no_payments.tr())
                      : (r['notes']?.toString() ?? '');
                  return [
                    idx.toString(),
                    r['serial_number']?.toString() ?? '',
                    studentName,
                    r['group_name']?.toString() ?? '',
                    displayStatus,
                    displayNotes,
                  ];
                }).toList(),
              ),

            pw.SizedBox(height: 18),

            // SECTION 2: ABSENT STUDENTS & PARENT FOLLOW-UP SHEET
            pw.Row(
              children: [
                pw.Container(
                  width: 8,
                  height: 8,
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.red700,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.SizedBox(width: 6),
                pw.Text(
                  '${LocaleKeys.absent_tab.tr(args: [absentStudents.length.toString()])} - ${LocaleKeys.absentee_report.tr()}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 6),
            if (absentStudents.isEmpty)
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                alignment: pw.Alignment.center,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green50,
                  borderRadius:
                      pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Text(
                  LocaleKeys.zero_absences_msg.tr(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green900,
                  ),
                ),
              )
            else
              pw.TableHelper.fromTextArray(
                tableDirection: _textDirection,
                headerDirection: _textDirection,
                headerAlignment: _tableAlignment,
                cellAlignment: _tableAlignment,
                columnWidths: {
                  0: const pw.FixedColumnWidth(24),
                  1: const pw.FixedColumnWidth(55),
                  2: const pw.FlexColumnWidth(2.8),
                  3: const pw.FlexColumnWidth(2.1),
                  4: const pw.FlexColumnWidth(2.1),
                  5: const pw.FlexColumnWidth(1.8),
                  6: const pw.FlexColumnWidth(1.8),
                },
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                headerPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                headerStyle: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headers: [
                  '#',
                  LocaleKeys.serial_number.tr(),
                  LocaleKeys.student.tr(),
                  LocaleKeys.parent_phone_1.tr(),
                  LocaleKeys.parent_phone_2.tr(),
                  LocaleKeys.father_job_label.tr(),
                  LocaleKeys.notes.tr(),
                ],
                data: absentStudents.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final s = entry.value;
                  final bool isFree = s['student_status'] == 'free';
                  final studentName = isFree
                      ? '${s['name']} (${LocaleKeys.free_student.tr()})'
                      : (s['name']?.toString() ?? '');
                  final notes =
                      isFree ? LocaleKeys.exempt_no_payments.tr() : '';
                  final p1 = s['phone1']?.toString() ?? '';
                  final p2 = s['phone2']?.toString() ?? '';
                  return [
                    idx.toString(),
                    s['serial_number']?.toString() ?? '',
                    studentName,
                    p1,
                    p2,
                    s['father_job']?.toString() ?? '',
                    notes,
                  ];
                }).toList(),
              ),
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  /// Generate Absentee Follow-Up Sheet with parent contact details.
  Future<void> generateAbsenteeFollowUpReport(int lessonId) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;

      final List<Map<String, Object?>> lessonRows = await db.rawQuery(
        DBQueries.loadLessonById,
        [lessonId],
      );

      if (lessonRows.isEmpty) {
        emit(ReportState(error: LocaleKeys.no_attendance_records.tr()));
        return;
      }

      final lesson = lessonRows.first;
      final int groupId = lesson['group_id'] as int;

      final List<Map<String, Object?>> absentStudents = await db.rawQuery(
        DBQueries.reportAbsentStudentsForLesson,
        [groupId, lessonId],
      );

      final pdf = await _createDocument();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    LocaleKeys.absentee_report.tr(),
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '${lesson['group_name']} | ${lesson['date']}',
                    style: const pw.TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            if (absentStudents.isEmpty)
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  LocaleKeys.zero_absences_msg.tr(),
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green900,
                  ),
                ),
              )
            else
              pw.TableHelper.fromTextArray(
                tableDirection: _textDirection,
                headerDirection: _textDirection,
                headerAlignment: _tableAlignment,
                cellAlignment: _tableAlignment,
                columnWidths: {
                  0: const pw.FixedColumnWidth(24),
                  1: const pw.FixedColumnWidth(55),
                  2: const pw.FlexColumnWidth(2.8),
                  3: const pw.FlexColumnWidth(2.1),
                  4: const pw.FlexColumnWidth(2.1),
                  5: const pw.FlexColumnWidth(1.8),
                  6: const pw.FlexColumnWidth(1.8),
                },
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                headerPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                headerStyle: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headers: [
                  '#',
                  LocaleKeys.serial_number.tr(),
                  LocaleKeys.student.tr(),
                  LocaleKeys.parent_phone_1.tr(),
                  LocaleKeys.parent_phone_2.tr(),
                  LocaleKeys.father_job_label.tr(),
                  LocaleKeys.notes.tr(),
                ],
                data: absentStudents.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final s = entry.value;
                  final bool isFree = s['student_status'] == 'free';
                  final studentName = isFree
                      ? '${s['name']} (${LocaleKeys.free_student.tr()})'
                      : (s['name']?.toString() ?? '');
                  final notes =
                      isFree ? LocaleKeys.exempt_no_payments.tr() : '';
                  final p1 = s['phone1']?.toString() ?? '';
                  final p2 = s['phone2']?.toString() ?? '';
                  return [
                    idx.toString(),
                    s['serial_number']?.toString() ?? '',
                    studentName,
                    p1,
                    p2,
                    s['father_job']?.toString() ?? '',
                    notes,
                  ];
                }).toList(),
              ),
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  /// Generate Multi-Lesson Summary PDF Report for a group.
  Future<void> generateGroupAttendanceSummaryReport(
    int groupId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (state.isLoading) return;
    emit(const ReportState(isLoading: true));
    try {
      final db = await _databaseService.database;

      final List<Map<String, Object?>> groupRows = await db.query(
        DBQueries.tableGroups,
        where: 'id = ?',
        whereArgs: [groupId],
      );

      final String groupName =
          groupRows.isNotEmpty ? (groupRows.first['name'] as String) : '';

      String whereClause = 'l.group_id = ?';
      List<Object?> whereArgs = [groupId];

      if (startDate != null) {
        whereClause += ' AND l.date >= ?';
        whereArgs.add(startDate.toIso8601String().split('T').first);
      }
      if (endDate != null) {
        whereClause += ' AND l.date <= ?';
        whereArgs.add(endDate.toIso8601String().split('T').first);
      }

      final List<Map<String, Object?>> lessons = await db.rawQuery('''
        SELECT l.*, g.name as group_name,
          (SELECT COUNT(*) FROM students s WHERE s.group_id = l.group_id) as enrolled_count,
          (SELECT COUNT(*) FROM attendance a WHERE a.lesson_id = l.id AND a.status = 'attended') as attended_count,
          (SELECT COUNT(*) FROM attendance a WHERE a.lesson_id = l.id AND a.status = 'otherLesson') as other_group_count
        FROM lessons l
        JOIN groups g ON l.group_id = g.id
        WHERE $whereClause
        ORDER BY l.date DESC, l.start_time DESC
      ''', whereArgs);

      final pdf = await _createDocument();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: _pageFormat,
          textDirection: _textDirection,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    LocaleKeys.group_summary_report.tr(),
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(groupName, style: const pw.TextStyle(fontSize: 14)),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            if (lessons.isEmpty)
              pw.Text(LocaleKeys.no_lessons_today.tr())
            else
              pw.TableHelper.fromTextArray(
                tableDirection: _textDirection,
                headerDirection: _textDirection,
                headerAlignment: _tableAlignment,
                cellAlignment: _tableAlignment,
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.6),
                  1: const pw.FlexColumnWidth(1.2),
                  2: const pw.FlexColumnWidth(2.0),
                  3: const pw.FlexColumnWidth(1.2),
                  4: const pw.FlexColumnWidth(1.5),
                  5: const pw.FlexColumnWidth(1.2),
                  6: const pw.FlexColumnWidth(1.4),
                },
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                headerPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                headerStyle: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headers: [
                  LocaleKeys.date.tr(),
                  LocaleKeys.start_time.tr(),
                  LocaleKeys.lesson_title.tr(),
                  LocaleKeys.enrolled_students.tr(),
                  LocaleKeys.present.tr(),
                  LocaleKeys.absent.tr(),
                  LocaleKeys.attendance_rate_pct.tr(),
                ],
                data: lessons.map((l) {
                  final enrolled = (l['enrolled_count'] as int?) ?? 0;
                  final attended = (l['attended_count'] as int?) ?? 0;
                  final other = (l['other_group_count'] as int?) ?? 0;
                  final absent = (enrolled - attended).clamp(0, 999999);
                  final rate = enrolled > 0
                      ? (attended / enrolled * 100).clamp(0, 100)
                      : 100.0;

                  return [
                    l['date'].toString(),
                    l['start_time'].toString(),
                    (l['title']?.toString() ?? '').isEmpty
                        ? '-'
                        : l['title'].toString(),
                    enrolled.toString(),
                    '${attended + other} ($attended)',
                    absent.toString(),
                    '${rate.toStringAsFixed(1)}%',
                  ];
                }).toList(),
              ),
          ],
        ),
      );

      emit(ReportState(isGenerated: true, pdfDocument: pdf));
    } catch (e) {
      emit(ReportState(error: e.toString()));
    }
  }

  pw.Widget _buildPdfKpi(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  void resetReport() {
    emit(const ReportState());
  }
}
