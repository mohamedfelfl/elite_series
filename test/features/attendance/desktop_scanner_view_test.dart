import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/features/attendance/screens/qr_scanner/components/desktop_scanner_view.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    EasyLocalization.logger.enableLevels = [];
  });

  Widget buildTestableWidget(Widget child) {
    return EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: ScreenUtilInit(
        designSize: const Size(1920, 1080),
        builder: (context, _) => MaterialApp(
          home: Scaffold(body: child),
        ),
      ),
    );
  }

  group('DesktopScannerView Autofocus & Rapid Scan Tests', () {
    testWidgets('renders TextField and connects external FocusNode', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      String? scannedSerial;

      await tester.pumpWidget(
        buildTestableWidget(
          DesktopScannerView(
            manualController: controller,
            focusNode: focusNode,
            onScan: (val) => scannedSerial = val,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(TextField), findsOneWidget);

      // Verify tapping the outer container requests focus
      focusNode.unfocus();
      await tester.pump(const Duration(milliseconds: 50));
      expect(focusNode.hasFocus, isFalse);

      await tester.tap(find.byType(DesktopScannerView));
      await tester.pump(const Duration(milliseconds: 50));
      expect(focusNode.hasFocus, isTrue);

      // Type a complete serial into the field
      await tester.enterText(find.byType(TextField), 'EL-01-00003');
      await tester.pump(const Duration(milliseconds: 50));

      // Should have triggered onScan immediately via onChanged without requiring enter
      expect(scannedSerial, equals('EL-01-00003'));
      // Controller should be cleared ready for next scan
      expect(controller.text, isEmpty);

      controller.dispose();
      focusNode.dispose();
    });

    testWidgets('triggers onScan immediately on submitted or complete serial', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      String? scannedSerial;

      await tester.pumpWidget(
        buildTestableWidget(
          DesktopScannerView(
            manualController: controller,
            focusNode: focusNode,
            onScan: (val) => scannedSerial = val,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Test 1: Typing complete standard serial triggers immediately via onChanged
      await tester.enterText(find.byType(TextField), 'EL-02-00045');
      await tester.pump(const Duration(milliseconds: 50));

      expect(scannedSerial, equals('EL-02-00045'));
      expect(controller.text, isEmpty);

      // Test 2: Custom serial submitted with enter key
      await tester.enterText(find.byType(TextField), 'CUSTOM_STUDENT_99');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 50));

      expect(scannedSerial, equals('CUSTOM_STUDENT_99'));
      expect(controller.text, isEmpty);

      controller.dispose();
      focusNode.dispose();
    });

    testWidgets('handles long old card payload pattern instantly', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      String? scannedSerial;

      await tester.pumpWidget(
        buildTestableWidget(
          DesktopScannerView(
            manualController: controller,
            focusNode: focusNode,
            onScan: (val) => scannedSerial = val,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Long old card payload
      await tester.enterText(
        find.byType(TextField),
        'ELITE|stu_bd02c7b92a2b49da8a|EL-01-00003\r\n',
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(scannedSerial, equals('EL-01-00003'));
      expect(controller.text, isEmpty);

      controller.dispose();
      focusNode.dispose();
    });
  });
}
