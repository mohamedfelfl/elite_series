import 'package:flutter/material.dart';

/// A high-performance interactive wrapper that provides tactile micro-interactions:
/// - Smooth scale-down on press (0.97)
/// - Subtle scale-up on hover (1.02)
/// - Spring release animation
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double pressedScale;
  final double hoverScale;
  final Duration duration;
  final Curve curve;
  final BorderRadius? borderRadius;
  final bool enableHover;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedScale = 0.97,
    this.hoverScale = 1.02,
    this.duration = const Duration(milliseconds: 140),
    this.curve = Curves.easeOutCubic,
    this.borderRadius,
    this.enableHover = true,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressedScale,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (widget.onTap == null && widget.onLongPress == null) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = widget.onTap != null || widget.onLongPress != null;

    Widget result = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        double currentScale = _scaleAnimation.value;
        if (widget.enableHover && _isHovered && !_isPressed) {
          currentScale = widget.hoverScale;
        }
        return Transform.scale(
          scale: currentScale,
          child: child,
        );
      },
      child: widget.child,
    );

    if (widget.enableHover && isInteractive) {
      result = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: result,
      );
    }

    if (isInteractive) {
      result = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        behavior: HitTestBehavior.opaque,
        child: result,
      );
    }

    return result;
  }
}
