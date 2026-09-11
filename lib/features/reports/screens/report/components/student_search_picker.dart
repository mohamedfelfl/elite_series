import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../students/cubits/student_cubit.dart';
import '../../../../students/screens/student_list/components/student_ui_helper.dart';

/// A lag-free, on-demand searchable student picker for report screens.
///
/// Avoids eagerly loading or rendering the entire student directory.
/// Users search by student name or serial number, displaying at most 8 matches.
class StudentSearchPicker extends StatefulWidget {
  final int? selectedStudentId;
  final ValueChanged<Map<String, dynamic>?> onStudentSelected;

  const StudentSearchPicker({
    super.key,
    required this.selectedStudentId,
    required this.onStudentSelected,
  });

  @override
  State<StudentSearchPicker> createState() => _StudentSearchPickerState();
}

class _StudentSearchPickerState extends State<StudentSearchPicker> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  Map<String, dynamic>? _selectedStudent;

  @override
  void initState() {
    super.initState();
    if (widget.selectedStudentId != null) {
      _loadInitialStudent(widget.selectedStudentId!);
    }
  }

  @override
  void didUpdateWidget(covariant StudentSearchPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedStudentId != oldWidget.selectedStudentId) {
      if (widget.selectedStudentId == null) {
        setState(() {
          _selectedStudent = null;
          _searchResults = [];
          _searchController.clear();
        });
      } else if (_selectedStudent?['id'] != widget.selectedStudentId) {
        _loadInitialStudent(widget.selectedStudentId!);
      }
    }
  }

  Future<void> _loadInitialStudent(int id) async {
    final student = await context.read<StudentCubit>().getStudentById(id);
    if (mounted && student != null) {
      setState(() {
        _selectedStudent = student;
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 250), () async {
      if (!mounted) return;
      setState(() => _isSearching = true);

      final results = await context.read<StudentCubit>().searchStudentsQuick(
            trimmed,
            limit: 8,
          );

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  void _selectStudent(Map<String, dynamic> student) {
    setState(() {
      _selectedStudent = student;
      _searchResults = [];
      _searchController.clear();
    });
    _focusNode.unfocus();
    widget.onStudentSelected(student);
  }

  void _clearSelection() {
    setState(() {
      _selectedStudent = null;
      _searchResults = [];
      _searchController.clear();
    });
    widget.onStudentSelected(null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_selectedStudent != null) {
      return _buildSelectedCard(colorScheme, textTheme);
    }

    return _buildSearchSection(colorScheme, textTheme);
  }

  Widget _buildSelectedCard(ColorScheme colorScheme, TextTheme textTheme) {
    final name = _selectedStudent!['name']?.toString() ?? '';
    final serial = _selectedStudent!['serial_number']?.toString() ?? '';
    final groupName = _selectedStudent!['group_name']?.toString();
    final grade = _selectedStudent!['grade']?.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            child: Text(
              name.isNotEmpty ? StudentUIHelper.getInitials(name) : 'S',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildBadge(
                      icon: Icons.tag,
                      label: LocaleKeys.student_serial.tr(args: [serial]),
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    if (groupName != null && groupName.isNotEmpty)
                      _buildBadge(
                        icon: Icons.groups_outlined,
                        label: groupName,
                        color: colorScheme.secondary,
                        backgroundColor:
                            colorScheme.secondary.withValues(alpha: 0.1),
                      ),
                    if (grade != null && grade.isNotEmpty)
                      _buildBadge(
                        icon: Icons.school_outlined,
                        label: StudentUIHelper.getGradeLabel(grade),
                        color: colorScheme.tertiary,
                        backgroundColor:
                            colorScheme.tertiary.withValues(alpha: 0.1),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _clearSelection,
            icon: const Icon(Icons.swap_horiz_rounded, size: 18),
            label: Text(LocaleKeys.change.tr()),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: LocaleKeys.search_hint.tr(),
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: colorScheme.primary,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
          onChanged: _onSearchChanged,
        ),
        SizedBox(height: 10.h),

        // Result / State container
        if (_searchController.text.trim().isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_search_outlined,
                  size: 26.r,
                  color: colorScheme.primary.withValues(alpha: 0.7),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: Text(
                    LocaleKeys.search_payment_desc.tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        else if (_isSearching)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (_searchResults.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Center(
              child: Text(
                LocaleKeys.no_students_found.tr(),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Container(
            constraints: BoxConstraints(maxHeight: 260.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                itemCount: _searchResults.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 16.w,
                  endIndent: 16.w,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
                itemBuilder: (context, index) {
                  final student = _searchResults[index];
                  final sName = student['name']?.toString() ?? '';
                  final sSerial = student['serial_number']?.toString() ?? '';
                  final sGroup = student['group_name']?.toString();

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: Text(
                        sName.isNotEmpty ? sName[0].toUpperCase() : 'S',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    title: Text(
                      sName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      [
                        LocaleKeys.student_serial.tr(args: [sSerial]),
                        if (sGroup != null && sGroup.isNotEmpty) sGroup,
                      ].join(' • '),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    onTap: () => _selectStudent(student),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
