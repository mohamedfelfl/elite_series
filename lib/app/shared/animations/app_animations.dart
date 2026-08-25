import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animation constants and standard duration/curve tokens for the app.
class AppAnimations {
  const AppAnimations._();

  // Standard Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationMedium = Duration(milliseconds: 500);
  static const Duration durationLong = Duration(milliseconds: 700);
  static const Duration durationThemeTransition = Duration(milliseconds: 650);

  // Standard Curves
  static const Curve curveStandard = Curves.easeInOutCubic;
  static const Curve curveEntrance = Curves.easeOutCubic;
  static const Curve curveSpring = Curves.easeOutBack;
  static const Curve curveDecelerate = Curves.decelerate;
  static const Curve curveMaskReveal = Curves.easeInOutCubic;
}

/// Helpful animation extensions for declarative UI effects.
extension AppAnimationExtensions on Widget {
  /// Staggered entrance animation for lists, grids, or cards.
  Widget animateStaggeredEntrance({
    required int index,
    Duration delay = const Duration(milliseconds: 40),
    Duration duration = const Duration(milliseconds: 400),
    double offsetY = 20.0,
  }) {
    final staggerDelay = Duration(milliseconds: (index.clamp(0, 15) * delay.inMilliseconds));
    return animate(delay: staggerDelay)
        .fadeIn(duration: duration, curve: AppAnimations.curveEntrance)
        .slideY(
          begin: offsetY / 100,
          end: 0,
          duration: duration,
          curve: AppAnimations.curveEntrance,
        );
  }

  /// Fade and subtle spring scale entrance.
  Widget animateSpringEntrance({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 450),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: AppAnimations.curveEntrance)
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: AppAnimations.curveSpring,
        );
  }

  /// Smooth pulse shimmer highlight (useful for notifications or featured items).
  Widget animatePulseHighlight() {
    return animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.03, 1.03),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
        );
  }
}
