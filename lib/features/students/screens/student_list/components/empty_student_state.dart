import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:student_management_system/generated/locale_keys.g.dart';

class EmptyStudentState extends StatelessWidget {
  const EmptyStudentState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(LocaleKeys.no_students_found.tr(), style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.adjust_filters_hint.tr(),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
