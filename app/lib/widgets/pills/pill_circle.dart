import 'package:flutter/material.dart';
import 'pill_pack_visualiser.dart';

class PillCircle extends StatelessWidget {
  final int dayNumber;
  final PillStatus status;

  const PillCircle({super.key, required this.dayNumber, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    BoxDecoration decoration;
    Widget child;

    switch (status) {
      case PillStatus.taken:
        decoration = BoxDecoration(shape: BoxShape.circle, color: primaryColor.withValues(alpha: 0.8));
        child = Icon(Icons.check, color: onPrimaryColor, size: 18);
        break;
      case PillStatus.today:
        decoration = BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: primaryColor, width: 2),
        );
        child = Text('$dayNumber', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor));
        break;
      case PillStatus.missed:
        decoration = BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.withValues(alpha: 0.1),
          border: Border.all(color: Colors.red.shade200, width: 1.5),
        );
        child = Text('$dayNumber', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700));
        break;
      case PillStatus.placebo:
         decoration = BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300);
        child = Text('$dayNumber', style: TextStyle(color: Colors.grey.shade600));
        break;
      case PillStatus.future:
        decoration = BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey.shade50);
        child = Text('$dayNumber', style: TextStyle(color: Colors.blueGrey.shade300));
        break;
    }

    return Container(
      decoration: decoration,
      child: Center(child: child),
    );
  }
}