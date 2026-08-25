import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/dimens.dart';
import '../../../../../app/shared/animations/app_animations.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/attendance_cubit.dart';

/// Desktop scanner view with manual serial number entry field.
class DesktopScannerView extends StatelessWidget {
  final TextEditingController manualController;
  final ValueChanged<String>? onScan;

  const DesktopScannerView({
    super.key,
    required this.manualController,
    this.onScan,
  });

  void _handleScan(BuildContext context, String rawValue) {
    final serial = rawValue.trim();
    if (serial.isEmpty) return;

    if (onScan != null) {
      onScan!(serial);
    } else {
      context.read<AttendanceCubit>().recordAttendanceBySerial(serial);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimens.r24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: 48.r,
            color: colorScheme.primary,
          ).animatePulseHighlight(),
          SizedBox(height: 10.h),
          Text(
            LocaleKeys.connect_scanner.tr(),
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            LocaleKeys.scanner_hint.tr(),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: manualController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.student_serial_number.tr(),
                    prefixIcon: const Icon(Icons.qr_code, size: 20),
                    filled: true,
                    isDense: true,
                    fillColor: isDark
                        ? colorScheme.surfaceContainerLow
                        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.r14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                  onSubmitted: (value) => _handleScan(context, value),
                ),
              ),
              SizedBox(width: 12.w),
              FilledButton(
                onPressed: () => _handleScan(context, manualController.text),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.r14),
                  ),
                ),
                child: const Icon(Icons.send, size: 20),
              ),
            ],
          ),
        ],
      ),
    ).animateSpringEntrance();
  }
}
