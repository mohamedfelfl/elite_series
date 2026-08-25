import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'circular_reveal_theme_wrapper.dart';

/// Figma-style Animated Day / Night Theme Switch Toggle (inspired by community file 1024004634147979851).
/// Features:
/// - Smooth sliding thumb with spring physics
/// - Day sky gradient with rotating sun rays
/// - Night galaxy gradient with twinkling stars & lunar craters
/// - Seamless integration with CircularRevealThemeWrapper
class AnimatedThemeSwitch extends StatefulWidget {
  final double width;
  final double height;
  final bool isDark;
  final ValueChanged<bool>? onChanged;

  const AnimatedThemeSwitch({
    super.key,
    this.width = 58,
    this.height = 30,
    required this.isDark,
    this.onChanged,
  });

  @override
  State<AnimatedThemeSwitch> createState() => _AnimatedThemeSwitchState();
}

class _AnimatedThemeSwitchState extends State<AnimatedThemeSwitch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: widget.isDark ? 1.0 : 0.0,
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedThemeSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDark != oldWidget.isDark) {
      if (widget.isDark) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details) {
    HapticFeedback.lightImpact();
    
    // Find the center of this widget on the screen for the mask reveal
    final renderBox = context.findRenderObject() as RenderBox?;
    Offset? globalOrigin;
    if (renderBox != null && renderBox.hasSize) {
      final size = renderBox.size;
      globalOrigin = renderBox.localToGlobal(Offset(size.width / 2, size.height / 2));
    }

    if (widget.onChanged != null) {
      widget.onChanged!(!widget.isDark);
    } else {
      ThemeMaskController.toggleTheme(context, globalOrigin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double thumbSize = widget.height - 6;
    final double maxSlide = widget.width - thumbSize - 6;

    return GestureDetector(
      onTapUp: _handleTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final double t = _controller.value;

            // Background gradients
            final dayGradient = const LinearGradient(
              colors: [Color(0xFF38BDF8), Color(0xFF60A5FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            );

            final nightGradient = const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            );

            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                gradient: t > 0.5 ? nightGradient : dayGradient,
                boxShadow: [
                  BoxShadow(
                    color: (t > 0.5 ? const Color(0xFF6366F1) : const Color(0xFF38BDF8))
                        .withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  // Night Stars (fade in during dark mode)
                  if (t > 0.1)
                    Positioned.fill(
                      child: Opacity(
                        opacity: t,
                        child: const _NightStars(),
                      ),
                    ),

                  // Day Clouds (fade out during dark mode)
                  if (t < 0.9)
                    Positioned.fill(
                      child: Opacity(
                        opacity: (1 - t),
                        child: const _DayClouds(),
                      ),
                    ),

                  // Sliding Thumb (Sun / Moon Morph)
                  Positioned(
                    top: 3,
                    left: 3 + (_slideAnimation.value * maxSlide),
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * math.pi,
                      child: Container(
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: t > 0.5
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFFFBBF24),
                          boxShadow: [
                            BoxShadow(
                              color: (t > 0.5
                                      ? Colors.blueGrey
                                      : const Color(0xFFF59E0B))
                                  .withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: t > 0.5
                            ? _buildMoonDetails(thumbSize)
                            : _buildSunDetails(thumbSize),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSunDetails(double size) {
    return Center(
      child: Container(
        width: size * 0.5,
        height: size * 0.5,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF59E0B),
        ),
      ),
    );
  }

  Widget _buildMoonDetails(double size) {
    return Stack(
      children: [
        // Moon crater 1
        Positioned(
          top: size * 0.25,
          left: size * 0.25,
          child: Container(
            width: size * 0.22,
            height: size * 0.22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF94A3B8).withValues(alpha: 0.7),
            ),
          ),
        ),
        // Moon crater 2
        Positioned(
          bottom: size * 0.25,
          right: size * 0.25,
          child: Container(
            width: size * 0.16,
            height: size * 0.16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF94A3B8).withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

/// Day Clouds Decoration
class _DayClouds extends StatelessWidget {
  const _DayClouds();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 2,
          right: 6,
          child: Container(
            width: 14,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 14,
          child: Container(
            width: 10,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }
}

/// Night Stars Decoration
class _NightStars extends StatelessWidget {
  const _NightStars();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 6,
          left: 10,
          child: Container(
            width: 2.5,
            height: 2.5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 7,
          left: 18,
          child: Container(
            width: 3.5,
            height: 3.5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFBAE6FD),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 8,
          child: Container(
            width: 1.8,
            height: 1.8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
