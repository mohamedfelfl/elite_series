import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../exams/cubits/exam_cubit.dart';
import '../../../exams/models/student_exam_result.dart';

@RoutePage()
class HonoredStudentsScreen extends StatefulWidget {
  const HonoredStudentsScreen({super.key});

  @override
  State<HonoredStudentsScreen> createState() => _HonoredStudentsScreenState();
}

enum FilterType { exam, group }

class _HonoredStudentsScreenState extends State<HonoredStudentsScreen> {
  FilterType _filterType = FilterType.exam;
  int? _selectedExamId;
  int? _selectedGroupId;
  int _limit = 10;
  late ExamCubit _examCubit;

  final List<int> _limitOptions = [3, 5, 10, 20, 50, 100];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _examCubit = context.read<ExamCubit>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_examCubit.state.exams.isEmpty) await _examCubit.loadExams();
      if (_examCubit.state.groups.isEmpty) await _examCubit.loadGroups();
    });
  }

  @override
  void dispose() {
    _examCubit.resetTopStudents();
    super.dispose();
  }

  void _fetchData() {
    _examCubit.getTopStudents(
      examId: _selectedExamId,
      groupId: _selectedGroupId,
      limit: _limit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: context.router.canPop()
          ? AppBar(
              title: Text(
                LocaleKeys.honor_board.tr(),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: BlocBuilder<ExamCubit, ExamState>(
        builder: (context, state) {
          final hasSelection =
              _selectedExamId != null || _selectedGroupId != null;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.r, 24.r, 24.r, 0),
                  child: _buildFilters(context, state, isDark, colorScheme),
                ),
              ),
              if (state.isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (!hasSelection)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _filterType == FilterType.exam
                              ? Icons.quiz
                              : Icons.groups,
                          size: 64.r,
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          _filterType == FilterType.exam
                              ? LocaleKeys.select_exam_hint.tr()
                              : LocaleKeys.select_group_hint.tr(),
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (state.topStudents.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.r),
                      child: Text(
                        LocaleKeys.no_honor_students.tr(),
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                )
              else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.r,
                      vertical: 32.h,
                    ),
                    child: _buildTopThreeVisual(
                      state.topStudents,
                      textTheme,
                      isDark,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.r),
                    child: _buildTable(
                      state.topStudents,
                      textTheme,
                      colorScheme,
                      isDark,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    ExamState state,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16.r,
              offset: Offset(0, 4.h),
            ),
        ],
      ),
      child: Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: SegmentedButton<FilterType>(
                segments: [
                  ButtonSegment(
                    value: FilterType.exam,
                    label: Text(LocaleKeys.exam.tr()),
                    icon: const Icon(Icons.quiz),
                  ),
                  ButtonSegment(
                    value: FilterType.group,
                    label: Text(LocaleKeys.groups.tr()),
                    icon: const Icon(Icons.groups),
                  ),
                ],
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                selected: {_filterType},
                onSelectionChanged: (set) {
                  setState(() {
                    _filterType = set.first;
                    _selectedExamId = null;
                    _selectedGroupId = null;
                  });
                  // No immediate fetch, let user choose from dropdown
                },
              ),
            ),
          ),
          if (_filterType == FilterType.exam)
            _buildDropdown<int?>(
              label: LocaleKeys.select_exam_hint.tr(),
              value: _selectedExamId,
              items: state.exams
                  .map(
                    (e) => DropdownMenuItem(
                      value: e['id'] as int,
                      child: Text(e['name'] as String),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedExamId = v;
                });
                _fetchData();
              },
              icon: Icons.description,
            )
          else
            _buildDropdown<int?>(
              label: LocaleKeys.select_group_hint.tr(),
              value: _selectedGroupId,
              items: state.groups
                  .map(
                    (g) => DropdownMenuItem(
                      value: g['id'] as int,
                      child: Text(g['name'] as String),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedGroupId = v;
                });
                _fetchData();
              },
              icon: Icons.groups,
            ),
          _buildDropdown<int>(
            label: LocaleKeys.top_n.tr(args: ['']), // Or just use a generic 'Top' if preferred
            value: _limit,
            items: _limitOptions
                .map(
                  (n) => DropdownMenuItem(value: n, child: Text(n.toString())),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _limit = v);
                _fetchData();
              }
            },
            icon: Icons.format_list_numbered,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    required IconData icon,
  }) {
    return SizedBox(
      width: 250.w,
      child: DropdownButtonFormField<T>(
        key: ValueKey(value),
        initialValue: value,
        hint: Text(label),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          filled: true,
        ),
        items: items,
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }

  Widget _buildTopThreeVisual(
    List<StudentExamResult> students,
    TextTheme textTheme,
    bool isDark,
  ) {
    if (students.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        // We rearrange them: Silver (2), Gold (1), Bronze (3) for better podium layout
        final double podiumHeight = isMobile ? 160.h : 200.h;
        return SizedBox(
          height: podiumHeight + 180.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (students.length > 1)
                _buildPodiumCard(
                  student: students[1],
                  rank: 2,
                  color: AppColors.rankSilver,
                  height: podiumHeight * 0.75,
                  textTheme: textTheme,
                  isDark: isDark,
                  isMobile: isMobile,
                ),
              SizedBox(width: isMobile ? 8.w : 16.w),
              _buildPodiumCard(
                student: students[0],
                rank: 1,
                color: AppColors.rankGold,
                height: podiumHeight,
                textTheme: textTheme,
                isDark: isDark,
                isMobile: isMobile,
              ),
              if (students.length > 2) ...[
                SizedBox(width: isMobile ? 8.w : 16.w),
                _buildPodiumCard(
                  student: students[2],
                  rank: 3,
                  color: AppColors.rankBronze,
                  height: podiumHeight * 0.6,
                  textTheme: textTheme,
                  isDark: isDark,
                  isMobile: isMobile,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPodiumCard({
    required StudentExamResult student,
    required int rank,
    required Color color,
    required double height,
    required TextTheme textTheme,
    required bool isDark,
    required bool isMobile,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: isMobile ? 22.r : 28.r,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(
              rank == 1 ? Icons.emoji_events : Icons.workspace_premium,
              color: color,
              size: isMobile ? 24.r : 32.r,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            student.studentName,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            '${student.percentage.toStringAsFixed(1)}%',
            style: textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.8),
                  color.withValues(alpha: 0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 12.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 12.h),
            child: Text(
              '#$rank',
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
    List<StudentExamResult> students,
    TextTheme textTheme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16.r,
              offset: Offset(0, 4.h),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                horizontalMargin: 24.w,
                columnSpacing: 24.w,
                headingRowColor: WidgetStatePropertyAll(
                  isDark
                      ? colorScheme.surfaceContainerHigh
                      : colorScheme.surfaceContainerHighest,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      '#',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      LocaleKeys.student.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      LocaleKeys.serial_number.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      LocaleKeys.total_mark.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      LocaleKeys.average_score.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: students.asMap().entries.map((entry) {
                  final index = entry.key;
                  final student = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(
                        Text(
                          student.studentName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DataCell(Text(student.serialNumber)),
                      DataCell(
                        Text(
                          '${student.totalMarks.toStringAsFixed(1)} / ${student.totalFullMarks.toStringAsFixed(0)}',
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '${student.percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
