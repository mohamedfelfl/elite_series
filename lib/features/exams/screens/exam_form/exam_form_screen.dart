import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/exam_cubit.dart';

@RoutePage()
class ExamFormScreen extends StatefulWidget {
  final int? examId;
  const ExamFormScreen({super.key, this.examId});

  @override
  State<ExamFormScreen> createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends State<ExamFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fullMarkController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<int> _selectedGroupIds = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    context.read<ExamCubit>().loadGroups();
    if (widget.examId != null) {
      final examState = context.read<ExamCubit>().state;
      final exam = examState.exams.firstWhere(
        (e) => e['id'] == widget.examId,
        orElse: () => <String, dynamic>{},
      );

      if (exam.isNotEmpty) {
        _nameController.text = exam['name']?.toString() ?? '';
        final fullMark = exam['full_mark'];
        _fullMarkController.text = fullMark is num
            ? fullMark.toStringAsFixed(0)
            : fullMark?.toString() ?? '';

        if (exam['date'] != null) {
          _selectedDate =
              DateTime.tryParse(exam['date'].toString()) ?? DateTime.now();
        }
      }
      _loadExamGroups();
    }
  }

  Future<void> _loadExamGroups() async {
    final groups = await context.read<ExamCubit>().getExamGroups(
      widget.examId!,
    );
    if (mounted) {
      setState(() {
        _selectedGroupIds.clear();
        _selectedGroupIds.addAll(groups);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullMarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.examId != null
              ? LocaleKeys.edit_exam.tr()
              : LocaleKeys.add_exam.tr(),
        ),
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.p24,
            vertical: AppDimens.p32,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppDimens.maxFormWidth),
            child: Card(
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.r24),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppDimens.p32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.examId != null
                            ? LocaleKeys.edit_exam.tr()
                            : LocaleKeys.add_exam.tr(),
                        style: textTheme.headlineLarge,
                      ),
                      SizedBox(height: AppDimens.h32),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.exam_name.tr(),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? LocaleKeys.required_field.tr()
                            : null,
                      ),
                      SizedBox(height: AppDimens.h20),
                      TextFormField(
                        controller: _fullMarkController,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.full_mark.tr(),
                          prefixIcon: const Icon(Icons.score),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) => value?.isEmpty ?? true
                            ? LocaleKeys.required_field.tr()
                            : null,
                      ),
                      SizedBox(height: AppDimens.h20),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: LocaleKeys.exam_date.tr(),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(DateFormat.yMMMd().format(_selectedDate)),
                        ),
                      ),
                      SizedBox(height: AppDimens.h32),
                      Text(
                        LocaleKeys.link_to_groups.tr(),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppDimens.h12),
                      BlocBuilder<ExamCubit, ExamState>(
                        builder: (context, state) {
                          if (state.groups.isEmpty) {
                            return Text(LocaleKeys.no_groups_yet.tr());
                          }
                          return Wrap(
                            spacing: AppDimens.w8,
                            runSpacing: AppDimens.h8,
                            children: state.groups.map((group) {
                              final int groupId = group['id'] as int;
                              final bool isSelected = _selectedGroupIds
                                  .contains(groupId);
                              return FilterChip(
                                label: Text(group['name'] as String),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedGroupIds.add(groupId);
                                    } else {
                                      _selectedGroupIds.remove(groupId);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: AppDimens.h48),
                      SizedBox(
                        width: double.infinity,
                        height: AppDimens.buttonHeight,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.r16,
                              ),
                            ),
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  width: AppDimens.iconSize24,
                                  height: AppDimens.iconSize24,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  widget.examId != null
                                      ? LocaleKeys.update.tr()
                                      : LocaleKeys.create_exam.tr(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
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

    setState(() => _isSubmitting = true);

    final examData = {
      'name': _nameController.text.trim(),
      'full_mark': double.parse(_fullMarkController.text),
      'date': _selectedDate.toIso8601String().split('T').first,
    };

    final ExamCubit cubit = context.read<ExamCubit>();
    try {
      if (widget.examId != null) {
        await cubit.updateExam(
          widget.examId!,
          examData,
          groupIds: _selectedGroupIds,
        );
      } else {
        await cubit.createExam(examData, groupIds: _selectedGroupIds);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.success.tr()),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.router.popForced();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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
