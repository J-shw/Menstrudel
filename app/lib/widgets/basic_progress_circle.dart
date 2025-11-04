import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class BasicProgressCircle extends StatefulWidget {
  final int currentValue;
  final int maxValue;
  final double circleSize;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;
  final Duration animationDuration;

  const BasicProgressCircle({
    super.key,
    required this.currentValue,
    required this.maxValue,
    this.circleSize = 200.0,
    this.strokeWidth = 15.0,
    this.progressColor = Colors.red,
    this.trackColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 700),
  });

  @override
  State<BasicProgressCircle> createState() => _BasicProgressCircleState();
}

class _BasicProgressCircleState extends State<BasicProgressCircle>
	with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  double _calculateTargetProgress() {
    return (1.0 - (widget.currentValue / widget.maxValue)).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = Tween<double>(begin: 0.0, end: _calculateTargetProgress()).animate(_controller)
    ..addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant BasicProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentValue != oldWidget.currentValue || widget.maxValue != oldWidget.maxValue) {
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
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: widget.circleSize,
      height: widget.circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: widget.circleSize,
            height: widget.circleSize,
            child: CircularProgressIndicator(
              year2023: false,
              value: _animation.value,
              strokeWidth: widget.strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
              backgroundColor: widget.trackColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.currentValue}',
                style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                ),
              ),
              Text(
                l10n.periodPredictionCircle_days(widget.currentValue),
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}