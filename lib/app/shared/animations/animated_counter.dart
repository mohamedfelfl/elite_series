import 'package:flutter/material.dart';

/// An animated rolling number counter widget with smooth easing.
class AnimatedCounter extends ImplicitlyAnimatedWidget {
  final num value;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;
  final int fractionDigits;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.prefix,
    this.suffix,
    this.fractionDigits = 0,
    super.duration = const Duration(milliseconds: 900),
    super.curve = Curves.easeOutExpo,
  });

  @override
  AnimatedWidgetBaseState<AnimatedCounter> createState() =>
      _AnimatedCounterState();
}

class _AnimatedCounterState extends AnimatedWidgetBaseState<AnimatedCounter> {
  Tween<double>? _valueTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _valueTween = visitor(
      _valueTween,
      widget.value.toDouble(),
      (dynamic value) => Tween<double>(begin: (value as num).toDouble()),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final double currentValue = _valueTween?.evaluate(animation) ?? widget.value.toDouble();
    
    final String formattedNumber = widget.fractionDigits > 0
        ? currentValue.toStringAsFixed(widget.fractionDigits)
        : currentValue.round().toString();

    final String displayText =
        '${widget.prefix ?? ''}$formattedNumber${widget.suffix ?? ''}';

    return Text(
      displayText,
      style: widget.style,
    );
  }
}
