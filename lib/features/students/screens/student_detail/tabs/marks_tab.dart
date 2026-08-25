import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/router/app_router.gr.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../exams/cubits/exam_cubit.dart';

class MarksTab extends StatelessWidget {
  final int studentId;
  final VoidCallback? onRefresh;
  const MarksTab({super.key, required this.studentId, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.studentMarks.isEmpty) {
          return Center(child: Text(LocaleKeys.no_exam_records.tr()));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.studentMarks.length,
          itemBuilder: (context, i) {
            final m = state.studentMarks[i];
            final score = (m['score'] as num).toDouble();
            final full = (m['exam_full_mark'] as num?)?.toDouble() ?? 0;
            final pct = full > 0 ? (score / full * 100) : 0;

            final isDark =
                Theme.of(context).brightness == Brightness.dark;

            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () async {
                  final examId = m['exam_id'] as int?;
                  if (examId != null) {
                    await context.router.push(
                      MarkEntryRoute(id: examId, studentId: studentId),
                    );
                    if (context.mounted) {
                      // Reload student marks
                      await context.read<ExamCubit>().loadStudentMarks(
                        studentId,
                      );
                      // Reload general student profile data (average score, etc.)
                      onRefresh?.call();
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['exam_name']?.toString() ?? '',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: isDark ? Colors.white : null,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '${score.toStringAsFixed(1)} / ${full.toStringAsFixed(1)}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: isDark ? Colors.white70 : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      CircularProgressIndicator(
                        value: pct / 100,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        color: pct >= 50 ? Colors.green : Colors.red,
                        strokeWidth: 6,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${pct.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isDark ? Colors.white : null,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
