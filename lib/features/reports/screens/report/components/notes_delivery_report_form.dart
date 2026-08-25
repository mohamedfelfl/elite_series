import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../groups/cubits/group_cubit.dart';
import '../../../../notes/cubits/notes_cubit.dart';
import '../../../../notes/cubits/notes_state.dart';
import '../../../../students/cubits/student_cubit.dart';
import '../../../cubits/report_cubit.dart';

enum NotesReportMode { all, student, group }

/// Notes delivery report form.
class NotesDeliveryReportForm extends StatefulWidget {
  const NotesDeliveryReportForm({super.key});

  @override
  State<NotesDeliveryReportForm> createState() =>
      _NotesDeliveryReportFormState();
}

class _NotesDeliveryReportFormState extends State<NotesDeliveryReportForm> {
  NotesReportMode _notesReportMode = NotesReportMode.all;
  int? _selectedNoteStudentId;
  int? _selectedNoteGroupId;
  int? _selectedNoteId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.report_notes_delivery.tr(),
          style: textTheme.titleMedium,
        ),
        SizedBox(height: 12.h),

        // Mode selector
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<NotesReportMode>(
              segments: [
                ButtonSegment(
                  value: NotesReportMode.all,
                  label: Text(LocaleKeys.all_students.tr()),
                  icon: const Icon(Icons.people),
                ),
                ButtonSegment(
                  value: NotesReportMode.student,
                  label: Text(LocaleKeys.student.tr()),
                  icon: const Icon(Icons.person),
                ),
                ButtonSegment(
                  value: NotesReportMode.group,
                  label: Text(LocaleKeys.select_group.tr()),
                  icon: const Icon(Icons.groups),
                ),
              ],
              selected: {_notesReportMode},
              onSelectionChanged: (value) {
                setState(() {
                  _notesReportMode = value.first;
                  _selectedNoteStudentId = null;
                  _selectedNoteGroupId = null;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 24.h),

        if (_notesReportMode == NotesReportMode.student) ...[
          BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return DropdownMenu<int?>(
                    width: constraints.maxWidth,
                    initialSelection: _selectedNoteStudentId,
                    label: Text(LocaleKeys.student.tr()),
                    leadingIcon: const Icon(Icons.person),
                    enableSearch: true,
                    enableFilter: true,
                    dropdownMenuEntries: [
                      ...state.students.map(
                        (s) => DropdownMenuEntry<int?>(
                          value: s['id'] as int,
                          label: '${s['name']} (${s['serial_number']})',
                        ),
                      ),
                    ],
                    onSelected: (v) {
                      setState(() {
                        _selectedNoteStudentId = v;
                      });
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height: 16.h),
        ],

        if (_notesReportMode == NotesReportMode.group) ...[
          BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return DropdownMenu<int?>(
                    width: constraints.maxWidth,
                    initialSelection: _selectedNoteGroupId,
                    label: Text(LocaleKeys.select_group.tr()),
                    leadingIcon: const Icon(Icons.groups),
                    enableSearch: true,
                    enableFilter: true,
                    dropdownMenuEntries: [
                      ...state.groups.map(
                        (g) => DropdownMenuEntry<int?>(
                          value: g['id'] as int,
                          label: g['name'] as String,
                        ),
                      ),
                    ],
                    onSelected: (v) {
                      setState(() {
                        _selectedNoteGroupId = v;
                      });
                    },
                  );
                },
              );
            },
          ),
          SizedBox(height: 16.h),
        ],

        // Note Unit selector
        BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<int?>(
                  width: constraints.maxWidth,
                  initialSelection: _selectedNoteId,
                  label: Text(LocaleKeys.select_note.tr()),
                  leadingIcon: const Icon(Icons.book),
                  enableSearch: true,
                  enableFilter: true,
                  dropdownMenuEntries: [
                    ...state.notes.map(
                      (n) => DropdownMenuEntry<int?>(
                        value: n.id,
                        label: n.name,
                      ),
                    ),
                  ],
                  onSelected: (v) {
                    setState(() {
                      _selectedNoteId = v;
                    });
                  },
                );
              },
            );
          },
        ),
        SizedBox(height: 16.h),

        BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: state.isLoading || _selectedNoteId == null
                    ? null
                    : () {
                        String? groupName;
                        if (_selectedNoteGroupId != null) {
                          final groupState = context.read<GroupCubit>().state;
                          groupName =
                              groupState.groups.firstWhere(
                                    (g) => g['id'] == _selectedNoteGroupId,
                                  )['name']
                                  as String;
                        }
                        context.read<ReportCubit>().generateNotesDeliveryReport(
                          studentId: _selectedNoteStudentId,
                          groupId: _selectedNoteGroupId,
                          groupName: groupName,
                          noteId: _selectedNoteId,
                        );
                      },
                icon: state.isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(LocaleKeys.generate_report.tr()),
              ),
            );
          },
        ),
      ],
    );
  }
}
