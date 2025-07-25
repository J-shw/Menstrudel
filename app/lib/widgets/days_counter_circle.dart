import 'package:flutter/material.dart';

// You'll likely want to put this in your components folder, e.g.,
// lib/components/basic_progress_circle.dart
class BasicProgressCircle extends StatelessWidget {
  final int currentValue;
  final int maxValue;
  final double circleSize;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;

  const BasicProgressCircle({
    super.key,
    required this.currentValue,
    required this.maxValue,
    this.circleSize = 200.0,
    this.strokeWidth = 15.0,
    this.progressColor = Colors.red,
    this.trackColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    double progressValue = (1.0 - (currentValue / maxValue)).clamp(0.0, 1.0);

    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: circleSize,
            height: circleSize,
            child: CircularProgressIndicator(
              year2023: false,
              value: progressValue,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: trackColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$currentValue',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Days',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}