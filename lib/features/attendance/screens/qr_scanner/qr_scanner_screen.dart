import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/constants/dimens.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../cubits/attendance_cubit.dart';
import '../../cubits/lesson_cubit.dart';
import '../../models/lesson.dart';
import 'components/active_lesson_banner.dart';
import 'components/add_edit_lesson_dialog.dart';
import 'components/desktop_scanner_view.dart';
import 'components/end_lesson_dialog.dart';
import 'components/lesson_conflict_dialog.dart';
import 'components/lessons_tab_view.dart';
import 'components/live_roster_view.dart';
import 'components/mobile_scanner_view.dart';

@RoutePage()
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final _manualController = TextEditingController();
  MobileScannerController? _cameraController;
  late TabController _tabController;
  bool _isDesktop = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
    if (!_isDesktop) {
      _cameraController = MobileScannerController();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LessonCubit>().loadLessonsForDate(DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _manualController.dispose();
    _cameraController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScanReceived(String serial) {
    final activeLesson = context.read<LessonCubit>().state.activeLesson;
    if (activeLesson != null) {
      context.read<LessonCubit>().recordScanInActiveLesson(serial);
    } else {
      context.read<AttendanceCubit>().recordAttendanceBySerial(serial);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 76.h,
        title: SizedBox(
          width: 460.w,
          height: 52.h,
          child: Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(AppDimens.r18),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(AppDimens.r14),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              labelColor: colorScheme.onPrimary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner, size: 20),
                      SizedBox(width: 8.w),
                      Text(LocaleKeys.qr_attendance.tr()),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 20),
                      SizedBox(width: 8.w),
                      Text(LocaleKeys.lessons.tr()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LessonCubit, LessonState>(
            listener: (context, state) {
              if (state.scanSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      LocaleKeys.attendance_recorded_for.tr(
                        args: [state.lastScannedStudent ?? ''],
                      ),
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _manualController.clear();
                context.read<LessonCubit>().resetScanState();
              }
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                    backgroundColor: colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.read<LessonCubit>().resetScanState();
              }
            },
          ),
          BlocListener<AttendanceCubit, AttendanceState>(
            listener: (context, state) {
              if (state.scanSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      LocaleKeys.attendance_recorded_for.tr(
                        args: [state.lastScannedStudent ?? ''],
                      ),
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _manualController.clear();
                context.read<AttendanceCubit>().resetScanState();
              }
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                    backgroundColor: colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.read<AttendanceCubit>().resetScanState();
              }
            },
          ),
        ],
        child: TabBarView(
          controller: _tabController,
          children: [
            // TAB 1: QR SCANNER & LIVE ROSTER ATTENDANCE
            _buildScannerTab(context, colorScheme, textTheme),

            // TAB 2: LESSONS & SCHEDULE MANAGEMENT
            LessonsTabView(
              onSwitchToScanner: () {
                _tabController.animateTo(0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerTab(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return BlocBuilder<LessonCubit, LessonState>(
      builder: (context, lessonState) {
        final activeLesson = lessonState.activeLesson;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Session Status Banner / Alert (ABOVE QR Scanner)
              ActiveLessonBanner(
                activeLesson: activeLesson,
                availableLessons: lessonState.dailyLessons,
                onSelectLesson: (lesson) async {
                  final currentActive = context.read<LessonCubit>().state.activeLesson;
                  if (currentActive != null &&
                      currentActive.id != null &&
                      currentActive.id != lesson.id &&
                      currentActive.status == LessonStatus.inProgress) {
                    final confirmed = await LessonConflictDialog.show(
                      context,
                      currentRunningLesson: currentActive,
                      newLessonToStart: lesson,
                    );
                    if (!confirmed || !context.mounted) return;
                    await context.read<LessonCubit>().endLesson(currentActive.id!);
                  }
                  if (!context.mounted) return;
                  if (lesson.status == LessonStatus.scheduled) {
                    context.read<LessonCubit>().startLesson(lesson);
                  } else {
                    context.read<LessonCubit>().setActiveLesson(lesson);
                  }
                },
                onEndLesson: () {
                  if (activeLesson != null) {
                    EndLessonDialog.show(
                      context,
                      lesson: activeLesson,
                      onConfirmEnd: () {
                        context.read<LessonCubit>().endLesson(
                              activeLesson.id!,
                            );
                      },
                    );
                  }
                },
                onOpenSchedule: () {
                  _tabController.animateTo(1);
                },
                onAddLesson: () {
                  AddEditLessonDialog.show(
                    context,
                    initialDate: DateTime.now(),
                  );
                },
              ),

              SizedBox(height: 18.h),

              // 2. QR Scanner Hardware / Camera View
              if (_isDesktop)
                DesktopScannerView(
                  manualController: _manualController,
                  onScan: _onScanReceived,
                )
              else
                MobileScannerView(
                  cameraController: _cameraController!,
                  manualController: _manualController,
                  onScan: _onScanReceived,
                ),

              // 3. If there is an active lesson, show Live Roster below scanner
              if (activeLesson != null) ...[
                SizedBox(height: 20.h),
                Text(
                  LocaleKeys.lesson_summary.tr(),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                LiveRosterView(
                  attendedStudents: lessonState.attendedRoster,
                  absentStudents: lessonState.absentRoster,
                  onMarkPresent: (studentId) {
                    context.read<LessonCubit>().markStudentPresent(
                          studentId,
                        );
                  },
                  onRemoveAttendance: (attendanceId) {
                    context.read<LessonCubit>().removeAttendanceRecord(
                          attendanceId,
                        );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
