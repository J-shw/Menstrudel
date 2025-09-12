import 'package:flutter/material.dart';
import 'dart:math';

class WearProgressCircle extends StatefulWidget {
  final int currentValue;
  final int maxValue;
  final double circleSize;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;
  final Duration animationDuration;

  const WearProgressCircle({
    super.key,
    required this.currentValue,
    required this.maxValue,
    this.circleSize = 150.0,
    this.strokeWidth = 10.0,
    this.progressColor = Colors.red,
    this.trackColor = const Color(0xFF333333),
    this.animationDuration = const Duration(milliseconds: 700),
  });

  @override
  State<WearProgressCircle> createState() => _WearProgressCircleState();
}

class _WearProgressCircleState extends State<WearProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _calculateTargetProgress() {
    if (widget.maxValue <= 0) return 0.0;
    double progress = (widget.maxValue - widget.currentValue) / widget.maxValue;
    return progress.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation =
        Tween<double>(begin: 0.0, end: _calculateTargetProgress()).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant WearProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentValue != oldWidget.currentValue ||
        widget.maxValue != oldWidget.maxValue) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: _calculateTargetProgress(),
      ).animate(_controller);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int displayValue = widget.currentValue.abs();

    return SizedBox(
      width: widget.circleSize,
      height: widget.circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: widget.circleSize,
            height: widget.circleSize,
            child: Transform.rotate(
              angle: -pi / 2,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
                backgroundColor: widget.trackColor,
              ),
            ),
          ),
          Text(
            '$displayValue',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}