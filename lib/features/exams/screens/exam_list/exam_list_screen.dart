import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/app_router.gr.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/exam_cubit.dart';

@RoutePage()
class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ExamCubit>().loadInitialData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: context.router.canPop()
          ? AppBar(
              title: Text(
                LocaleKeys.exams.tr(),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: BlocBuilder<ExamCubit, ExamState>(
        builder: (BuildContext context, ExamState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final int totalExams = state.exams.length;

          return RefreshIndicator(
            onRefresh: () => context.read<ExamCubit>().loadExams(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main Purple Banner
                  Container(
                    padding: EdgeInsets.all(28.r),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerHigh
                          : colorScheme.primary,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 24.r,
                            offset: Offset(0, 8.h),
                          ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.exam_banner_title.tr(),
                          style: textTheme.titleMedium?.copyWith(
                            color: isDark
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          LocaleKeys.exam_banner_subtitle.tr(),
                          style: textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? colorScheme.onSurface
                                : colorScheme.onPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: () => context.router.push(ExamFormRoute()),
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: colorScheme.primary,
                          ),
                          label: Text(
                            LocaleKeys.add_exam.tr(),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Mini Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? colorScheme.surfaceContainerLow
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              if (!isDark)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4.h),
                                ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.scheduled_exams.tr(),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '$totalExams',
                                    style: textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.description,
                                color: colorScheme.primary,
                                size: 28.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? colorScheme.surfaceContainerLow
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              if (!isDark)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4.h),
                                ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.average_score.tr(),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${state.averageScore.toStringAsFixed(1)}%',
                                    style: textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.bar_chart,
                                color: colorScheme.error,
                                size: 28.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerLow
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10.r,
                            offset: Offset(0, 4.h),
                          ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.search_hint.tr(),
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorScheme.primary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Scheduled Exams List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.event_note, color: colorScheme.primary),
                          SizedBox(width: 8.w),
                          Text(
                            LocaleKeys.scheduled_exams.tr(),
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            context.router.push(ExamsManagementRoute()),
                        child: Text(LocaleKeys.view_all.tr()),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (state.exams.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.r),
                        child: Text(
                          LocaleKeys.no_exams.tr(),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else
                    ...state.exams
                        .where((e) {
                          final name =
                              e['name']?.toString().toLowerCase() ?? '';
                          final date =
                              e['date']?.toString().toLowerCase() ?? '';
                          return name.contains(_searchQuery) ||
                              date.contains(_searchQuery);
                        })
                        .map((e) {
                          final title = e['name']?.toString() ?? 'Exam';
                          final isMath = title.toLowerCase().contains('math');
                          return Card(
                            margin: EdgeInsets.only(bottom: 12.h),
                            elevation: 0,
                            color: isDark
                                ? colorScheme.surfaceContainerLow
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              side: isDark
                                  ? BorderSide.none
                                  : BorderSide(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                    ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 8.h,
                              ),
                              leading: Container(
                                width: 48.r,
                                height: 48.r,
                                decoration: BoxDecoration(
                                  color: isMath
                                      ? AppColors.examTabActive
                                      : AppColors.examTabInactive,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  isMath ? Icons.functions : Icons.science,
                                  color: isMath
                                      ? AppColors.examTabActiveText
                                      : AppColors.examTabInactiveText,
                                ),
                              ),
                              title: Text(
                                title,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                LocaleKeys.total_mark.tr(
                                  args: [
                                    (e['full_mark'] as num?)?.toStringAsFixed(
                                          0,
                                        ) ??
                                        '0',
                                  ],
                                ),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  e['date']?.toString() ?? '',
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onTap: () => context.router.push(
                                ExamDetailRoute(examId: e['id'] as int),
                              ),
                            ),
                          );
                        }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
