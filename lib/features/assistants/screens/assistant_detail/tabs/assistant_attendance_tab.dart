import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/assistant_attendance_cubit.dart';

class AssistantAttendanceTab extends StatefulWidget {
  final int assistantId;

  const AssistantAttendanceTab({super.key, required this.assistantId});

  @override
  State<AssistantAttendanceTab> createState() => _AssistantAttendanceTabState();
}

class _AssistantAttendanceTabState extends State<AssistantAttendanceTab> {
  @override
  void initState() {
    super.initState();
    context.read<AssistantAttendanceCubit>().loadAttendance(widget.assistantId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssistantAttendanceCubit, AssistantAttendanceState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.assistant_attendance.tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => context
                            .read<AssistantAttendanceCubit>()
                            .recordAttendance(widget.assistantId, 'in'),
                        icon: const Icon(Icons.login),
                        label: Text(LocaleKeys.record_in.tr()),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => context
                            .read<AssistantAttendanceCubit>()
                            .recordAttendance(widget.assistantId, 'out'),
                        icon: const Icon(Icons.logout),
                        label: Text(LocaleKeys.record_out.tr()),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.records.isEmpty
                    ? Center(child: Text(LocaleKeys.no_attendance_records.tr()))
                    : ListView.builder(
                        itemCount: state.records.length,
                        itemBuilder: (context, index) {
                          final record = state.records[index];
                          final isOut = record['type'] == 'out';
                          return Card(
                            margin: EdgeInsets.only(bottom: 8.h),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isOut
                                    ? Colors.orange.withValues(alpha: 0.1)
                                    : Colors.green.withValues(alpha: 0.1),
                                child: Icon(
                                  isOut ? Icons.logout : Icons.login,
                                  color: isOut ? Colors.orange : Colors.green,
                                ),
                              ),
                              title: Text(record['date']),
                              subtitle: Text(
                                isOut
                                    ? LocaleKeys.out_type.tr()
                                    : LocaleKeys.in_type.tr(),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmDelete(record),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.delete.tr()),
        content: Text('Delete this attendance record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AssistantAttendanceCubit>().deleteAttendance(
                record['id'] as int,
                widget.assistantId,
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              LocaleKeys.delete.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }
}
