import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/locale_cubit.dart';
import '../../animations/app_animations.dart';

/// Controller for initiating circular mask theme transitions.
class ThemeMaskController {
  static _CircularRevealThemeWrapperState? _state;

  static void _register(_CircularRevealThemeWrapperState state) {
    _state = state;
  }

  static void _unregister(_CircularRevealThemeWrapperState state) {
    if (_state == state) _state = null;
  }

  /// Toggles theme mode with a circular reveal mask expanding from [globalPosition].
  static Future<void> toggleTheme(
    BuildContext context, [
    Offset? globalPosition,
  ]) async {
    final localeCubit = context.read<LocaleCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;

    if (_state != null) {
      await _state!.switchTheme(
        nextMode: nextMode,
        origin: globalPosition,
        onExecute: () => localeCubit.setThemeMode(nextMode),
      );
    } else {
      localeCubit.setThemeMode(nextMode);
    }
  }

  /// Explicitly sets theme mode with circular reveal animation.
  static Future<void> setThemeMode(
    BuildContext context,
    ThemeMode mode, [
    Offset? globalPosition,
  ]) async {
    final localeCubit = context.read<LocaleCubit>();
    if (_state != null) {
      await _state!.switchTheme(
        nextMode: mode,
        origin: globalPosition,
        onExecute: () => localeCubit.setThemeMode(mode),
      );
    } else {
      localeCubit.setThemeMode(mode);
    }
  }
}

/// A wrapper around the app that captures the current screen and creates
/// a circular mask reveal transition when changing themes.
class CircularRevealThemeWrapper extends StatefulWidget {
  final Widget child;

  const CircularRevealThemeWrapper({
    super.key,
    required this.child,
  });

  @override
  State<CircularRevealThemeWrapper> createState() =>
      _CircularRevealThemeWrapperState();
}

class _CircularRevealThemeWrapperState extends State<CircularRevealThemeWrapper>
    with SingleTickerProviderStateMixin {
  final GlobalKey _repaintKey = GlobalKey();
  late final AnimationController _animationController;
  ui.Image? _snapshot;
  Offset _revealCenter = Offset.zero;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    ThemeMaskController._register(this);
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.durationThemeTransition,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isTransitioning = false;
          _snapshot?.dispose();
          _snapshot = null;
        });
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    ThemeMaskController._unregister(this);
    _animationController.dispose();
    _snapshot?.dispose();
    super.dispose();
  }

  Future<void> switchTheme({
    required ThemeMode nextMode,
    required VoidCallback onExecute,
    Offset? origin,
  }) async {
    if (_isTransitioning) {
      onExecute();
      return;
    }

    try {
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null || !boundary.hasSize) {
        onExecute();
        return;
      }

      final image = await boundary.toImage(pixelRatio: 1.0);
      final size = boundary.size;

      setState(() {
        _snapshot?.dispose();
        _snapshot = image;
        _revealCenter = origin ?? Offset(size.width / 2, size.height / 2);
        _isTransitioning = true;
      });

      // Update actual theme in state
      onExecute();

      // Run circular mask reveal
      _animationController.forward(from: 0.0);
    } catch (e) {
      debugPrint('Theme mask capture error: $e');
      onExecute();
      setState(() {
        _isTransitioning = false;
        _snapshot?.dispose();
        _snapshot = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main App Layer wrapped in RepaintBoundary
        RepaintBoundary(
          key: _repaintKey,
          child: widget.child,
        ),

        // Old Snapshot Layer overlaid with inverted circular clip during transition
        if (_isTransitioning && _snapshot != null)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                final double progress = CurvedAnimation(
                  parent: _animationController,
                  curve: AppAnimations.curveMaskReveal,
                ).value;

                final screenSize = MediaQuery.sizeOf(context);
                final double maxRadius = _calculateMaxRadius(
                  screenSize,
                  _revealCenter,
                );
                final double currentRadius = progress * maxRadius;

                return ClipPath(
                  clipper: _InvertedCircleClipper(
                    center: _revealCenter,
                    radius: currentRadius,
                  ),
                  child: RawImage(
                    image: _snapshot,
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  double _calculateMaxRadius(Size size, Offset center) {
    final double dx = math.max(center.dx, size.width - center.dx);
    final double dy = math.max(center.dy, size.height - center.dy);
    return math.sqrt(dx * dx + dy * dy);
  }
}

/// Inverted circle clipper: cuts a circular hole out of the snapshot,
/// revealing the new theme underneath.
class _InvertedCircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  _InvertedCircleClipper({
    required this.center,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    if (radius > 0) {
      final holePath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius));
      return Path.combine(PathOperation.difference, path, holePath);
    }
    return path;
  }

  @override
  bool shouldReclip(covariant _InvertedCircleClipper oldClipper) {
    return oldClipper.radius != radius || oldClipper.center != center;
  }
}
