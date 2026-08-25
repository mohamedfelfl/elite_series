import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../groups/cubits/group_cubit.dart';
import '../../../cubits/lesson_cubit.dart';
import '../../../models/lesson.dart';

/// Dialog to add a new lesson or edit an existing lesson.
class AddEditLessonDialog extends StatefulWidget {
  final DateTime initialDate;
  final Lesson? lessonToEdit;

  const AddEditLessonDialog({
    super.key,
    required this.initialDate,
    this.lessonToEdit,
  });

  static Future<void> show(
    BuildContext context, {
    required DateTime initialDate,
    Lesson? lessonToEdit,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddEditLessonDialog(
        initialDate: initialDate,
        lessonToEdit: lessonToEdit,
      ),
    );
  }

  @override
  State<AddEditLessonDialog> createState() => _AddEditLessonDialogState();
}

class _AddEditLessonDialogState extends State<AddEditLessonDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  int? _selectedGroupId;
  late DateTime _selectedDate;
  TimeOfDay _selectedStartTime = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay? _selectedEndTime;

  bool get _isEditing => widget.lessonToEdit != null;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    if (_isEditing) {
      final lesson = widget.lessonToEdit!;
      _selectedGroupId = lesson.groupId;
      _titleController.text = lesson.title;
      try {
        _selectedDate = DateTime.parse(lesson.date);
      } catch (_) {}

      try {
        final parts = lesson.startTime.split(':');
        _selectedStartTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } catch (_) {}

      if (lesson.endTime != null && lesson.endTime!.isNotEmpty) {
        try {
          final parts = lesson.endTime!.split(':');
          _selectedEndTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        } catch (_) {}
      }
    }
    context.read<GroupCubit>().loadGroups();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.r24),
      ),
      title: Row(
        children: [
          Icon(
            _isEditing ? Icons.edit_outlined : Icons.add_circle_outline,
            color: colorScheme.primary,
          ),
          SizedBox(width: AppDimens.w10),
          Text(
            _isEditing
                ? LocaleKeys.edit_lesson.tr()
                : LocaleKeys.add_lesson.tr(),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Group Selector
              BlocBuilder<GroupCubit, GroupState>(
                builder: (context, groupState) {
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: LocaleKeys.group.tr(),
                      prefixIcon: const Icon(Icons.group_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r16),
                      ),
                    ),
                    initialValue: _selectedGroupId,
                    items: groupState.groups.map((group) {
                      return DropdownMenuItem<int>(
                        value: group['id'] as int,
                        child: Text(group['name'] as String),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedGroupId = val;
                      });
                    },
                    validator: (val) =>
                        val == null ? LocaleKeys.required_field.tr() : null,
                  );
                },
              ),
              SizedBox(height: AppDimens.h16),

              // Date Picker Field
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.calendar_today_outlined,
                  color: colorScheme.primary,
                ),
                title: Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: textTheme.bodyLarge,
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Text(LocaleKeys.edit.tr()),
                ),
              ),
              const Divider(),

              // Start Time Picker Field
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.access_time_outlined,
                  color: colorScheme.primary,
                ),
                title: Text(
                  '${LocaleKeys.start_time.tr()}: ${_formatTimeOfDay(_selectedStartTime)}',
                  style: textTheme.bodyLarge,
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedStartTime,
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedStartTime = picked;
                      });
                    }
                  },
                  child: Text(LocaleKeys.edit.tr()),
                ),
              ),
              const Divider(),

              // End Time Picker Field (Optional)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.timer_off_outlined,
                  color: colorScheme.primary,
                ),
                title: Text(
                  _selectedEndTime != null
                      ? '${LocaleKeys.end_time.tr()}: ${_formatTimeOfDay(_selectedEndTime!)}'
                      : '${LocaleKeys.end_time.tr()}: -',
                  style: textTheme.bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedEndTime != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            _selectedEndTime = null;
                          });
                        },
                      ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedEndTime ??
                              TimeOfDay(
                                hour: (_selectedStartTime.hour + 2) % 24,
                                minute: _selectedStartTime.minute,
                              ),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedEndTime = picked;
                          });
                        }
                      },
                      child: Text(LocaleKeys.edit.tr()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimens.h8),

              // Title / Topic Field (Optional)
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.lesson_title.tr(),
                  hintText: LocaleKeys.lesson_title_hint.tr(),
                  prefixIcon: const Icon(Icons.title_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.r16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.cancel.tr()),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final startTimeStr = _formatTimeOfDay(_selectedStartTime);
              final endTimeStr = _selectedEndTime != null
                  ? _formatTimeOfDay(_selectedEndTime!)
                  : null;

              if (_isEditing && widget.lessonToEdit!.id != null) {
                context.read<LessonCubit>().updateLesson(
                      lessonId: widget.lessonToEdit!.id!,
                      groupId: _selectedGroupId!,
                      date: _selectedDate,
                      startTime: startTimeStr,
                      endTime: endTimeStr,
                      title: _titleController.text.trim(),
                    );
              } else {
                context.read<LessonCubit>().createAdHocLesson(
                      groupId: _selectedGroupId!,
                      date: _selectedDate,
                      startTime: startTimeStr,
                      endTime: endTimeStr,
                      title: _titleController.text.trim(),
                    );
              }

              Navigator.of(context).pop();
            }
          },
          child: Text(LocaleKeys.save.tr()),
        ),
      ],
    );
  }
}
