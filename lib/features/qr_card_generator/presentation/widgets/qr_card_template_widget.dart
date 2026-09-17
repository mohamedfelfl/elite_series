import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/constants/dimens.dart';
import '../../../../app/theme/app_typography.dart';
import '../../data/models/student_card_data.dart';

/// Pixel-perfect PVC ID Card template widget that renders the exact Elite Series template design
/// with dynamic student information positioned on the left half of the card to completely avoid the QR area.
class QrCardTemplateWidget extends StatelessWidget {
  final StudentCardData student;
  final double? width;
  final double? height;

  const QrCardTemplateWidget({
    super.key,
    required this.student,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double cardW = width ?? AppDimens.cardDefaultWidth;
    // CR80 Standard Aspect Ratio (1024 x 647)
    final double cardH = height ?? (cardW / (1024.0 / 647.0));
    final double scale = cardW / AppDimens.cardDefaultWidth;

    return Container(
      width: cardW,
      height: cardH,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x26000000),
            blurRadius: 16.0 * scale,
            offset: Offset(0, 6.0 * scale),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0 * scale),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Exact Template Background Image ──
            Image.asset(
              'assets/images/pvc_card_template.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),

            // ── Dynamic Overlaid Data (Confined to Left Side of Card) ──

            // 1. Student Name (Under اسم الطالب, right-aligned, extending left)
            Positioned(
              left: cardW * 0.05,
              top: cardH * 0.325,
              width: cardW * 0.52,
              height: cardH * 0.085,
              child: Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      student.fullName,
                      textAlign: TextAlign.right,
                      style: AppTypography.cairo(
                        fontSize: 17.0 * scale,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Stage Name (Under المرحلة)
            Positioned(
              left: cardW * 0.05,
              top: cardH * 0.485,
              width: cardW * 0.52,
              height: cardH * 0.075,
              child: Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      StudentCardData.formatStageArabic(student.stageName),
                      textAlign: TextAlign.right,
                      style: AppTypography.cairo(
                        fontSize: 13.0 * scale,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Group Name (Under المجموعة)
            Positioned(
              left: cardW * 0.05,
              top: cardH * 0.615,
              width: cardW * 0.52,
              height: cardH * 0.075,
              child: Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      student.groupName.isNotEmpty
                          ? student.groupName
                          : _formatScheduleArabic(student.groupSchedule),
                      textAlign: TextAlign.right,
                      style: AppTypography.cairo(
                        fontSize: 12.0 * scale,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 4. Time / Schedule (Under الوقت)
            Positioned(
              left: cardW * 0.05,
              top: cardH * 0.745,
              width: cardW * 0.52,
              height: cardH * 0.075,
              child: Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: student.groupSchedule.isNotEmpty
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      student.groupSchedule.isNotEmpty
                          ? _formatScheduleArabic(student.groupSchedule)
                          : '\u2066${student.studentCode}\u2069',
                      textAlign: TextAlign.right,
                      style: AppTypography.cairo(
                        fontSize: 12.0 * scale,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 5. QR Code inside the rounded white box container on the right
            Positioned(
              left: cardW * 0.655,
              top: cardH * 0.38,
              width: cardW * 0.23,
              height: cardH * 0.37,
              child: Center(
                child: QrImageView(
                  data: student.qrPayload,
                  version: QrVersions.auto,
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.all(4.0 * scale),
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF0F172A),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatScheduleArabic(String schedule) {
    switch (schedule.trim().toLowerCase()) {
      case AppConstants.daySaturday:
        return 'مجموعة السبت';
      case AppConstants.daySunday:
        return 'مجموعة الأحد';
      case AppConstants.dayMonday:
        return 'مجموعة الاثنين';
      case AppConstants.dayTuesday:
        return 'مجموعة الثلاثاء';
      case AppConstants.dayWednesday:
        return 'مجموعة الأربعاء';
      case AppConstants.dayThursday:
        return 'مجموعة الخميس';
      case AppConstants.dayFriday:
        return 'مجموعة الجمعة';
      default:
        return schedule.isNotEmpty ? schedule : 'مجموعة عامة';
    }
  }
}
