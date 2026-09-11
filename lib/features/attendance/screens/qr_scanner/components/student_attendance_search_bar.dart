import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/shared/animations/app_animations.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/lesson_cubit.dart';

/// Search bar widget for searching any student and marking attendance during an active lesson.
class StudentAttendanceSearchBar extends StatefulWidget {
  final ValueChanged<int> onMarkPresent;
  final FocusNode? focusNode;
  final VoidCallback? onSearchCleared;

  const StudentAttendanceSearchBar({
    super.key,
    required this.onMarkPresent,
    this.focusNode,
    this.onSearchCleared,
  });

  @override
  State<StudentAttendanceSearchBar> createState() =>
      _StudentAttendanceSearchBarState();
}

class _StudentAttendanceSearchBarState
    extends State<StudentAttendanceSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  List<Map<String, dynamic>> _results = [];
  String _currentQuery = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    final clean = query.trim();

    if (clean.isEmpty) {
      setState(() {
        _currentQuery = '';
        _results = [];
        _isLoading = false;
      });
      widget.onSearchCleared?.call();
      return;
    }

    setState(() {
      _currentQuery = clean;
      _isLoading = true;
    });

    _debounce = Timer(const Duration(milliseconds: 250), () async {
      if (!mounted) return;
      final results = await context
          .read<LessonCubit>()
          .searchStudentsForActiveLesson(clean);
      if (!mounted) return;
      setState(() {
        _results = results;
        _isLoading = false;
      });
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {
      _currentQuery = '';
      _results = [];
      _isLoading = false;
    });
    widget.onSearchCleared?.call();
  }

  void _handleMarkStudent(Map<String, dynamic> student) {
    final studentId = student['id'] as int;
    setState(() {
      student['is_attended'] = true;
    });
    widget.onMarkPresent(studentId);
  }

  /// Safe translation helper with bilingual fallbacks in case EasyLocalization
  /// hasn't reloaded newly added keys yet.
  String _safeTr(
    String key, {
    List<String>? args,
    required String fallbackAr,
    required String fallbackEn,
  }) {
    final bool isArabic = context.locale.languageCode == 'ar';
    try {
      final text = args != null ? key.tr(args: args) : key.tr();
      if (text.isEmpty || text == key || text.contains(key)) {
        String res = isArabic ? fallbackAr : fallbackEn;
        if (args != null) {
          for (final arg in args) {
            res = res.replaceFirst('{}', arg);
          }
        }
        return res;
      }
      return text;
    } catch (_) {
      String res = isArabic ? fallbackAr : fallbackEn;
      if (args != null) {
        for (final arg in args) {
          res = res.replaceFirst('{}', arg);
        }
      }
      return res;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final searchHint = _safeTr(
      LocaleKeys.search_student_attendance,
      fallbackAr: 'البحث عن طالب لتسجيل الحضور (بالاسم أو الرقم أو الهاتف)...',
      fallbackEn: 'Search student to mark attendance (by name, serial, or phone)...',
    );

    final clearTooltip = _safeTr(
      LocaleKeys.clear,
      fallbackAr: 'مسح',
      fallbackEn: 'Clear',
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Input Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              focusNode: widget.focusNode,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  fontSize: 12.5,
                ),
                prefixIcon: Icon(
                  Icons.person_search_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: _clearSearch,
                        tooltip: clearTooltip,
                      )
                    : null,
                filled: true,
                isDense: true,
                fillColor: isDark
                    ? colorScheme.surfaceContainerLow
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
              onChanged: _onQueryChanged,
            ),
          ),

          // Search Results Area (Displayed when query is active)
          if (_currentQuery.isNotEmpty) ...[
            const Divider(height: 1),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _safeTr(
                        LocaleKeys.loading,
                        fallbackAr: 'جارٍ التحميل...',
                        fallbackEn: 'Loading...',
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else if (_results.isEmpty)
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 32,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _safeTr(
                        LocaleKeys.no_students_matching_query,
                        fallbackAr: 'لم يتم العثور على طلاب يطابقون البحث',
                        fallbackEn: 'No students found matching your query',
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  itemCount: _results.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                  ),
                  itemBuilder: (context, index) {
                    final student = _results[index];
                    final String name = student['name'] as String? ?? '';
                    final String serial =
                        student['serial_number'] as String? ?? '';
                    final String? groupName =
                        student['group_name'] as String?;
                    final bool isAttended =
                        student['is_attended'] == true;
                    final bool isOwnGroup =
                        student['is_own_group'] == true;
                    final bool isFree =
                        student['student_status']?.toString() == 'free';

                    final String otherGroupText = (groupName != null && groupName.isNotEmpty)
                        ? _safeTr(
                            LocaleKeys.other_group_badge,
                            args: [groupName],
                            fallbackAr: 'مجموعة أخرى: {}',
                            fallbackEn: 'Other Group: {}',
                          )
                        : _safeTr(
                            'other_group',
                            fallbackAr: 'مجموعة أخرى',
                            fallbackEn: 'Other Group',
                          );

                    final String alreadyAttendedText = _safeTr(
                      LocaleKeys.already_attended_badge,
                      fallbackAr: 'تم الحضور',
                      fallbackEn: 'Attended',
                    );

                    final String markPresentText = _safeTr(
                      LocaleKeys.mark_present_action,
                      fallbackAr: 'تسجيل حضور',
                      fallbackEn: 'Mark Present',
                    );

                    final String freeStudentText = _safeTr(
                      LocaleKeys.free_student,
                      fallbackAr: 'طالب معفى',
                      fallbackEn: 'Exempt',
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          // Avatar / Icon
                          CircleAvatar(
                            radius: 17,
                            backgroundColor: isAttended
                                ? Colors.green.withValues(alpha: 0.15)
                                : colorScheme.primaryContainer,
                            child: Icon(
                              isAttended
                                  ? Icons.check_circle_rounded
                                  : Icons.person_rounded,
                              size: 18,
                              color: isAttended
                                  ? Colors.green
                                  : colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Student Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        name,
                                        style: textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isFree) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          freeStudentText,
                                          style: textTheme.labelSmall?.copyWith(
                                            color: Colors.amber[900],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    if (serial.isNotEmpty)
                                      Text(
                                        serial,
                                        style: textTheme.bodySmall?.copyWith(
                                          fontFamily: 'monospace',
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    if (groupName != null &&
                                        groupName.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isOwnGroup
                                              ? colorScheme.primary
                                                  .withValues(alpha: 0.1)
                                              : Colors.orange
                                                  .withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                          border: isOwnGroup
                                              ? null
                                              : Border.all(
                                                  color: Colors.orange
                                                      .withValues(alpha: 0.35),
                                                  width: 0.8,
                                                ),
                                        ),
                                        child: Text(
                                          isOwnGroup
                                              ? groupName
                                              : otherGroupText,
                                          style: textTheme.labelSmall?.copyWith(
                                            color: isOwnGroup
                                                ? colorScheme.primary
                                                : Colors.orange[900],
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Attendance Action / Status
                          if (isAttended)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 15,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    alreadyAttendedText,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: Colors.green[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            FilledButton.tonalIcon(
                              onPressed: () => _handleMarkStudent(student),
                              icon: const Icon(Icons.check_rounded, size: 15),
                              label: Text(
                                markPresentText,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ],
      ),
    ).animateSpringEntrance();
  }
}
