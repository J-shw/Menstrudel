import 'package:flutter/material.dart';
import 'package:menstrudel/models/birth_control/pills/pill_status_enum.dart';

class PillCircle extends StatelessWidget {
  final int dayNumber;
  final PillVisualStatus status;
  final bool isSelected;

  const PillCircle({
    super.key, 
    required this.dayNumber, 
    required this.status,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final visuals = status.getVisuals(context, dayNumber);
    final Color selectionColor = Theme.of(context).colorScheme.tertiary; 

    BoxDecoration finalDecoration = visuals.decoration;
    
    if (isSelected) {
      finalDecoration = finalDecoration.copyWith(
        border: Border.all(
          color: selectionColor, 
          width: 3,
        )
      );
    }

    return Container(
      decoration: finalDecoration,
      child: Center(child: visuals.child),
    );
  }
}