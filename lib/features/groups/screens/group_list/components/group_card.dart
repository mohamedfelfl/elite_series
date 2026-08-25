import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/router/app_router.gr.dart';
import '../../../../../app/utils/time_helper.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/group_cubit.dart';

/// A card widget for displaying a single group with schedule and student count.
class GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: () {
          context.router.push(GroupFormRoute(id: group['id'] as int));
        },
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.groups, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _cleanGroupName(group['name']?.toString() ?? ''),
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    itemBuilder: (BuildContext _) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(LocaleKeys.edit.tr()),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(LocaleKeys.delete.tr()),
                      ),
                    ],
                    onSelected: (String v) {
                      if (v == 'edit') {
                        context.router.push(
                          GroupFormRoute(id: group['id'] as int),
                        );
                      } else {
                        context.read<GroupCubit>().deleteGroup(
                          group['id'] as int,
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (group['schedules'] != null &&
                  (group['schedules'] as List).isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...(group['schedules'] as List).map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 10,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_localizeDay(s['day_of_week']?.toString() ?? '')} ${_localizeTime(s['time']?.toString() ?? '')}',
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (group['grade'] != null && (group['grade'] as String).isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school, size: 14, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            _localizeGrade(group['grade'].toString()),
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      LocaleKeys.students_count.tr(
                        args: [
                          (group['student_count'] ?? 0).toString(),
                        ],
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _localizeGrade(String grade) {
    switch (grade) {
      case 'sec_1': return LocaleKeys.sec_1.tr();
      case 'sec_2': return LocaleKeys.sec_2.tr();
      case 'sec_3': return LocaleKeys.sec_3.tr();
      default: return grade;
    }
  }

  String _localizeDay(String day) {
    switch (day.toLowerCase()) {
      case 'monday': return LocaleKeys.monday.tr();
      case 'tuesday': return LocaleKeys.tuesday.tr();
      case 'wednesday': return LocaleKeys.wednesday.tr();
      case 'thursday': return LocaleKeys.thursday.tr();
      case 'friday': return LocaleKeys.friday.tr();
      case 'saturday': return LocaleKeys.saturday.tr();
      case 'sunday': return LocaleKeys.sunday.tr();
      default: return day;
    }
  }

  String _cleanGroupName(String name) {
    String n = name.trim();
    n = n.replaceAll('الثللاثاء', 'الثلاثاء');
    n = n.replaceAll(RegExp(r'\s*[123]\s*ث\s*'), ' ');
    n = n.replaceAll(RegExp(r'\s+'), ' ').trim();
    return n;
  }

  String _localizeTime(String time) {
    return TimeHelper.localizeTimeString(time);
  }
}
