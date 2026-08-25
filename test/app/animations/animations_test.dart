import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_management_system/app/shared/animations/animated_counter.dart';
import 'package:student_management_system/app/shared/animations/app_animations.dart';
import 'package:student_management_system/app/shared/animations/pressable_scale.dart';
import 'package:student_management_system/app/shared/widgets/theme_mask/animated_theme_switch.dart';
import 'package:student_management_system/app/shared/widgets/theme_mask/circular_reveal_theme_wrapper.dart';
import 'package:student_management_system/features/attendance/screens/qr_scanner/components/scanner_laser_beam.dart';

void main() {
  group('App Animations & Components Tests', () {
    testWidgets('PressableScale renders child and handles taps', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PressableScale(
              onTap: () => tapped = true,
              child: const Text('Click Me'),
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);

      await tester.tap(find.text('Click Me'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('AnimatedCounter displays formatted number', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCounter(
              value: 150,
              prefix: r'$',
              suffix: ' EGP',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text(r'$150 EGP'), findsOneWidget);
    });

    testWidgets('AnimatedCounter animates decimals cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCounter(
              value: 99.50,
              fractionDigits: 2,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('99.50'), findsOneWidget);
    });

    testWidgets('AnimatedThemeSwitch toggles between day and night mode',
        (tester) async {
      bool currentDark = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AnimatedThemeSwitch(
                  isDark: currentDark,
                  onChanged: (val) {
                    setState(() => currentDark = val);
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedThemeSwitch), findsOneWidget);

      // Tap to switch to dark
      await tester.tap(find.byType(AnimatedThemeSwitch));
      await tester.pumpAndSettle();
      expect(currentDark, isTrue);

      // Tap to switch back to light
      await tester.tap(find.byType(AnimatedThemeSwitch));
      await tester.pumpAndSettle();
      expect(currentDark, isFalse);
    });

    testWidgets('CircularRevealThemeWrapper renders child widget',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CircularRevealThemeWrapper(
            child: Scaffold(
              body: Text('Protected Content'),
            ),
          ),
        ),
      );

      expect(find.text('Protected Content'), findsOneWidget);
    });

    testWidgets('ScannerLaserBeam renders without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScannerLaserBeam(
              width: 100,
              height: 100,
              color: Colors.cyan,
            ),
          ),
        ),
      );

      expect(find.byType(ScannerLaserBeam), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(ScannerLaserBeam), findsOneWidget);
    });

    testWidgets('AppAnimationExtensions apply entrance animations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Staggered')
                .animateStaggeredEntrance(index: 0),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Staggered'), findsOneWidget);
    });
  });
}
