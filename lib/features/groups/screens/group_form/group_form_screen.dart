import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/time_helper.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/group_cubit.dart';
import 'components/schedule_section.dart';
import 'components/student_linking_section.dart';

@RoutePage()
class GroupFormScreen extends StatefulWidget {
  final int? id;
  const GroupFormScreen({super.key, this.id});

  @override
  State<GroupFormScreen> createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends State<GroupFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedGrade = 'sec_1';
  final List<String> _selectedDays = [];
  final Map<String, TimeOfDay> _dayTimes = {};
  bool _isEditing = false;
  bool _isSubmitting = false;
  final List<int> _selectedStudentIds = [];
  final List<Map<String, dynamic>> _selectedStudentsData = [];

  final List<String> _days = <String>[
    'Saturday', 'Sunday', 'Monday', 'Tuesday',
    'Wednesday', 'Thursday', 'Friday',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _isEditing = true;
      _loadGroup();
      context.read<GroupCubit>().loadGroupStudents(widget.id!);
    } else {
      context.read<GroupCubit>().loadAvailableStudents();
    }
  }

  void _loadGroup() {
    final List<Map<String, dynamic>> groups = context
        .read<GroupCubit>()
        .state
        .groups;
    final Map<String, dynamic>? g = groups
        .where((Map<String, dynamic> g) => g['id'] == widget.id)
        .firstOrNull;
    if (g != null) {
      _nameController.text = g['name']?.toString() ?? '';
      _selectedGrade = g['grade']?.toString();

      final List<dynamic> schedules = g['schedules'] ?? [];
      for (final s in schedules) {
        final day = _normalizeDay(s['day_of_week']?.toString().trim() ?? '');
        final timeStr = s['time']?.toString().trim();
        if (day.isNotEmpty && timeStr != null) {
          if (!_selectedDays.contains(day)) {
            _selectedDays.add(day);
          }
          final time = TimeHelper.parseTime(timeStr);
          if (time != null) {
            _dayTimes[day] = time;
          }
        }
      }
      setState(() {});
      context.read<GroupCubit>().loadAvailableStudents(grade: _selectedGrade);
    }
  }

  String _normalizeDay(String day) {
    if (day.isEmpty) return day;
    switch (day) {
      case 'السبت': return 'Saturday';
      case 'الأحد': case 'الاحد': return 'Sunday';
      case 'الإثنين': case 'الاثنين': return 'Monday';
      case 'الثلاثاء': return 'Tuesday';
      case 'الأربعاء': case 'الاربعاء': return 'Wednesday';
      case 'الخميس': return 'Thursday';
      case 'الجمعة': return 'Friday';
      default: return day;
    }
  }

  Future<void> _pickTime(String day) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dayTimes[day] ?? const TimeOfDay(hour: 14, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _dayTimes[day] = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: context.router.canPop() ? const BackButton() : null,
        title: Text(
          _isEditing ? LocaleKeys.edit_group.tr() : LocaleKeys.add_group.tr(),
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Group Name
                  TextFormField(
                    controller: _nameController,
                    style: textTheme.titleMedium,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.group_name.tr(),
                      prefixIcon: const Icon(Icons.groups),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return LocaleKeys.required_field.tr();
                      }
                      final name = v.trim().toLowerCase();
                      final groups = context.read<GroupCubit>().state.groups;
                      final isDuplicate = groups.any((g) {
                        final gName = (g['name'] as String?)?.trim().toLowerCase();
                        if (gName != name) return false;
                        if (_isEditing && g['id'] == widget.id) return false;
                        return true;
                      });
                      if (isDuplicate) {
                        return LocaleKeys.group_name_exists.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Stage / Grade Dropdown
                  DropdownButtonFormField<String>(
                    key: ValueKey('grade_$_selectedGrade'),
                    initialValue: _selectedGrade,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.grade.tr(),
                      prefixIcon: const Icon(Icons.school),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? LocaleKeys.required_field.tr()
                        : null,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'sec_1',
                        child: Text(LocaleKeys.sec_1.tr()),
                      ),
                      DropdownMenuItem<String>(
                        value: 'sec_2',
                        child: Text(LocaleKeys.sec_2.tr()),
                      ),
                      DropdownMenuItem<String>(
                        value: 'sec_3',
                        child: Text(LocaleKeys.sec_3.tr()),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedGrade = val;
                        // If creating, clean up selected students that don't match the new grade
                        if (!_isEditing && val != null) {
                          _selectedStudentsData.removeWhere((s) => s['grade'] != val);
                          _selectedStudentIds.clear();
                          _selectedStudentIds.addAll(_selectedStudentsData.map((s) => s['id'] as int));
                        }
                      });
                      context.read<GroupCubit>().loadAvailableStudents(grade: val);
                    },
                  ),
                  SizedBox(height: 24.h),

                  ScheduleSection(
                    days: _days,
                    selectedDays: _selectedDays,
                    dayTimes: _dayTimes,
                    onChanged: () => setState(() {}),
                    onPickTime: _pickTime,
                  ),

                  SizedBox(height: 32.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submit,
                      icon: _isSubmitting 
                        ? const SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                          )
                        : Icon(_isEditing ? Icons.save : Icons.add),
                      label: Text(
                        _isEditing
                            ? LocaleKeys.update.tr()
                            : LocaleKeys.create.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Student Linking Section
                  SizedBox(height: 40.h),
                  const Divider(),
                  SizedBox(height: 16.h),
                  StudentLinkingSection(
                    isEditing: _isEditing,
                    groupId: widget.id,
                    selectedGrade: _selectedGrade,
                    selectedStudentIds: _selectedStudentIds,
                    selectedStudentsData: _selectedStudentsData,
                    onChanged: () => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedGrade == null || _selectedGrade!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.please_select_stage_first.tr()),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.select_day.tr()),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final List<Map<String, dynamic>> schedules = _selectedDays.map((day) {
        final time = _dayTimes[day] ?? const TimeOfDay(hour: 14, minute: 0);
        return {'day_of_week': day, 'time': TimeHelper.formatForDb(time)};
      }).toList();

      final Map<String, Object?> data = {
        'name': _nameController.text.trim(),
        'grade': _selectedGrade,
        'schedules': schedules,
        if (!_isEditing) 'studentIds': _selectedStudentIds,
      };

      final GroupCubit cubit = context.read<GroupCubit>();
      if (_isEditing) {
        await cubit.updateGroup(widget.id!, data);
      } else {
        await cubit.createGroup(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.success.tr()),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.router.maybePop();
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = e.toString().contains('group_name_exists')
            ? LocaleKeys.group_name_exists.tr()
            : e.toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
