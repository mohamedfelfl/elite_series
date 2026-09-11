import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/utils/arabic_name_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../groups/cubits/group_cubit.dart';
import '../../cubits/student_cubit.dart';
import 'components/student_academic_section.dart';
import 'components/student_form_header.dart';
import 'components/student_info_section.dart';

@RoutePage()
class StudentFormScreen extends StatefulWidget {
  final int? id;
  const StudentFormScreen({super.key, this.id});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phone1Controller = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();
  final TextEditingController _fatherJobController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _previousTeacherController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  int? _selectedGroupId;
  String _selectedGrade = 'prep_1';
  String _selectedStatus = 'normal';
  String? _selectedAttendanceDay;
  bool _isEditing = false;
  bool _isSubmitting = false;

  List<Map<String, dynamic>> _allStudents = [];
  List<NameDuplicateMatch> _duplicateMatches = [];

  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().loadGroups();
    _loadAllStudents();
    _nameController.addListener(_onNameChanged);
    if (widget.id != null) {
      _isEditing = true;
      _loadStudent();
    } else {
      _selectedGrade = 'prep_1';
      _updateNextSerial('prep_1');
    }
  }

  Future<void> _loadAllStudents() async {
    final students =
        await context.read<StudentCubit>().getAllStudentsWithGroups();
    if (mounted) {
      setState(() {
        _allStudents = students;
        _checkDuplicates();
      });
    }
  }

  void _onNameChanged() {
    _checkDuplicates();
    setState(() {});
  }

  void _checkDuplicates() {
    final input = _nameController.text;
    _duplicateMatches = ArabicNameHelper.checkDuplicates(
      input,
      _allStudents,
      excludeId: widget.id,
    );
  }

  Future<void> _updateNextSerial(String grade) async {
    if (_isEditing) return;
    final String nextSerial =
        await context.read<StudentCubit>().getNextSerialNumber(grade);
    if (mounted) {
      setState(() {
        _serialController.text = nextSerial;
      });
    }
  }

  Future<void> _loadStudent() async {
    final Map<String, Object?>? student =
        await context.read<StudentCubit>().getStudentById(widget.id!);
    if (student != null) {
      _serialController.text = student['serial_number']?.toString() ?? '';
      _nameController.text = student['name']?.toString() ?? '';
      _addressController.text = student['address']?.toString() ?? '';
      _phone1Controller.text = student['phone1']?.toString() ?? '';
      _phone2Controller.text = student['phone2']?.toString() ?? '';
      _fatherJobController.text = student['father_job']?.toString() ?? '';
      _schoolController.text = student['school']?.toString() ?? '';
      _previousTeacherController.text =
          student['previous_teacher']?.toString() ?? '';
      _notesController.text = student['notes']?.toString() ?? '';
      _selectedGroupId = student['group_id'] as int?;

      final String? gradeValue = student['grade']?.toString();
      const List<String> validGrades = [
        'prep_1',
        'prep_2',
        'prep_3',
        'sec_1',
        'sec_2',
        'sec_3',
      ];
      _selectedGrade = validGrades.contains(gradeValue) ? gradeValue! : 'prep_1';

      _selectedStatus = student['student_status']?.toString() ?? 'normal';

      final String? dayValue = student['attendance_day']?.toString();
      const List<String> validDays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      _selectedAttendanceDay = validDays.contains(dayValue) ? dayValue : null;

      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _serialController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _fatherJobController.dispose();
    _schoolController.dispose();
    _previousTeacherController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ─── Header & Profile Identity Hero ───
                          StudentFormHeader(
                            isEditing: _isEditing,
                            studentName: _nameController.text,
                            selectedGrade: _selectedGrade,
                            selectedStatus: _selectedStatus,
                            serialNumber: _serialController.text,
                            onBack: () => Navigator.of(context).maybePop(),
                          ),

                          const SizedBox(height: 24),

                          // ─── Responsive Form Cards (2-Column Grid on Desktop) ───
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth >= 850;

                              final academicCard = StudentAcademicSection(
                                selectedGrade: _selectedGrade,
                                selectedStatus: _selectedStatus,
                                selectedGroupId: _selectedGroupId,
                                selectedAttendanceDay: _selectedAttendanceDay,
                                serialController: _serialController,
                                isEditing: _isEditing,
                                onGradeChanged: (v) {
                                  if (v != null) {
                                    setState(() => _selectedGrade = v);
                                    if (!_isEditing) {
                                      _updateNextSerial(v);
                                    }
                                  }
                                },
                                onStatusChanged: (v) =>
                                    setState(() => _selectedStatus = v),
                                onGroupChanged: (v) =>
                                    setState(() => _selectedGroupId = v),
                                onAttendanceDayChanged: (v) =>
                                    setState(() => _selectedAttendanceDay = v),
                              );

                              final infoCard = StudentInfoSection(
                                nameController: _nameController,
                                addressController: _addressController,
                                phone1Controller: _phone1Controller,
                                phone2Controller: _phone2Controller,
                                fatherJobController: _fatherJobController,
                                schoolController: _schoolController,
                                previousTeacherController:
                                    _previousTeacherController,
                                notesController: _notesController,
                                duplicateMatches: _duplicateMatches,
                                nameValidator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return LocaleKeys.required_field.tr();
                                  }
                                  return null;
                                },
                              );

                              if (!isWide) {
                                return Column(
                                  children: [
                                    academicCard,
                                    const SizedBox(height: 24),
                                    infoCard,
                                  ],
                                );
                              }

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: academicCard,
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 6,
                                    child: infoCard,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ─── Sticky Bottom Action Bar ───
            _buildBottomActionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text(LocaleKeys.cancel.tr()),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_rounded, size: 20),
                label: Text(
                  _isEditing
                      ? LocaleKeys.save_changes.tr()
                      : LocaleKeys.create.tr(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    NameDuplicateMatch? exactOrNormalizedMatch;
    for (final m in _duplicateMatches) {
      if (m.matchLevel == NameMatchLevel.exact ||
          m.matchLevel == NameMatchLevel.normalizedExact) {
        exactOrNormalizedMatch = m;
        break;
      }
    }

    bool allowDuplicateName = false;

    if (exactOrNormalizedMatch != null) {
      final matchStudent = exactOrNormalizedMatch.student;
      final matchName = matchStudent['name']?.toString() ?? '';
      final matchSerial = matchStudent['serial_number']?.toString() ?? '';
      final matchGroup = matchStudent['group_name']?.toString() ?? '';

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(dialogCtx).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  LocaleKeys.duplicate_name_warning_title.tr(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.duplicate_name_warning_confirm.tr()),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(dialogCtx)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(dialogCtx).colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      matchName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${LocaleKeys.serial_number.tr()}: $matchSerial${matchGroup.isNotEmpty ? " • $matchGroup" : ""}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(dialogCtx).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogCtx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogCtx).colorScheme.error,
              ),
              child: Text(LocaleKeys.proceed_anyway.tr()),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
      if (!mounted) return;
      allowDuplicateName = true;
    }

    setState(() => _isSubmitting = true);

    try {
      final studentCubit = context.read<StudentCubit>();
      final Map<String, dynamic> data = <String, dynamic>{
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone1': _phone1Controller.text.trim(),
        'phone2': _phone2Controller.text.trim(),
        'father_job': _fatherJobController.text.trim(),
        'school': _schoolController.text.trim(),
        'previous_teacher': _previousTeacherController.text.trim(),
        'notes': _notesController.text.trim(),
        'group_id': _selectedGroupId,
        'grade': _selectedGrade,
        'student_status': _selectedStatus,
        'attendance_day': _selectedAttendanceDay,
      };

      if (_isEditing) {
        await studentCubit.updateStudent(
              widget.id!,
              data,
              allowDuplicateName: allowDuplicateName,
            );
      } else {
        await studentCubit.createStudent(
              data,
              allowDuplicateName: allowDuplicateName,
            );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
