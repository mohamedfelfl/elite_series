import 'package:flutter/material.dart';

/// Animated laser sweep beam for QR scanner viewfinder.
class ScannerLaserBeam extends StatefulWidget {
  final double width;
  final double height;
  final Color color;

  const ScannerLaserBeam({
    super.key,
    this.width = 200,
    this.height = 200,
    required this.color,
  });

  @override
  State<ScannerLaserBeam> createState() => _ScannerLaserBeamState();
}

class _ScannerLaserBeamState extends State<ScannerLaserBeam>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final double topOffset = _animation.value * (widget.height - 4);

          return Stack(
            children: [
              Positioned(
                top: topOffset,
                left: 10,
                right: 10,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.8),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
