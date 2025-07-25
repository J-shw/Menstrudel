import 'package:flutter/material.dart';

class DaysCounterCircle extends StatelessWidget {
  // We make these final because StatelessWidget properties don't change
  final int days;
  final double circleSize;
  final Color borderColor;

  // Constructor to pass in the values
  const DaysCounterCircle({
    super.key,
    required this.days,
    this.circleSize = 200.0,
    this.borderColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 15.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$days',
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
    );
  }
}