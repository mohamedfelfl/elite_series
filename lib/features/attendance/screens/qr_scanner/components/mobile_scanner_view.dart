import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../cubits/attendance_cubit.dart';
import 'scanner_laser_beam.dart';

/// Mobile scanner view with camera, controls, and manual entry fallback.
class MobileScannerView extends StatelessWidget {
  final MobileScannerController cameraController;
  final TextEditingController manualController;
  final ValueChanged<String>? onScan;

  const MobileScannerView({
    super.key,
    required this.cameraController,
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

    return Column(
      children: [
        // Camera Viewfinder Box
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.1),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              MobileScanner(
                controller: cameraController,
                onDetect: (BarcodeCapture capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final Barcode barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      _handleScan(context, barcode.rawValue!);
                      break;
                    }
                  }
                },
              ),
              // Camera Overlay Design
              Center(
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: ScannerOverlayPainter(color: colorScheme.primary),
                ),
              ),
              // Animated Laser Beam
              Center(
                child: ScannerLaserBeam(
                  width: 200,
                  height: 200,
                  color: colorScheme.primary,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        LocaleKeys.active_now.tr(),
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls bar: Torch & Switch Camera
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: () => cameraController.toggleTorch(),
              icon: const Icon(Icons.flash_on),
            ),
            const SizedBox(width: 16),
            IconButton.filledTonal(
              onPressed: () => cameraController.switchCamera(),
              icon: const Icon(Icons.cameraswitch),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Manual Entry Fallback Field
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.student_serial_number.tr(),
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: manualController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.scan_hint.tr(),
                        prefixIcon: const Icon(Icons.dialpad),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (val) => _handleScan(context, val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () => _handleScan(context, manualController.text),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    child: Text(LocaleKeys.save.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color color;

  ScannerOverlayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const length = 30.0;

    // Top Left
    canvas.drawLine(const Offset(0, 0), const Offset(length, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, length), paint);

    // Top Right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - length, 0),
      paint,
    );
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), paint);

    // Bottom Left
    canvas.drawLine(Offset(0, size.height), Offset(length, size.height), paint);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - length),
      paint,
    );

    // Bottom Right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - length, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
