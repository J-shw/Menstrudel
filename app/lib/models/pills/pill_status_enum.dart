import 'package:flutter/material.dart';

typedef PillVisuals = ({BoxDecoration decoration, Widget child});

enum PillIntakeStatus {
  taken,
  skipped,
  late,
}

enum PillVisualStatus {
  taken,
  skipped,
  late,
  missed,
  today,
  future,
  placebo;

  static PillVisualStatus fromIntakeStatus(PillIntakeStatus intakeStatus) {
    switch (intakeStatus) {
      case PillIntakeStatus.taken:
        return PillVisualStatus.taken;
      case PillIntakeStatus.skipped:
        return PillVisualStatus.skipped;
      case PillIntakeStatus.late:
        return PillVisualStatus.late;
    }
  }
}

extension PillExtension on PillVisualStatus {
  /// Returns the decoration and child widget for each status.
  PillVisuals getVisuals(BuildContext context, int dayNumber) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    switch (this) {
      case PillVisualStatus.today:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor, width: 2)),
          child: Text('$dayNumber', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
        );

      case PillVisualStatus.future:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey.shade50),
          child: Text('$dayNumber', style: TextStyle(color: Colors.blueGrey.shade300)),
        );
      case PillVisualStatus.taken:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.8)),
          child: Icon(Icons.check, color: onPrimaryColor, size: 18),
        );

      case PillVisualStatus.skipped:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
          child: Icon(Icons.skip_next_rounded, color: Colors.grey.shade600, size: 18),
        );

      case PillVisualStatus.late:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber.shade200),
          child: Text('$dayNumber', style: TextStyle(color: Colors.amber.shade800, fontWeight: FontWeight.bold)),
        );

      case PillVisualStatus.missed:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.1), border: Border.all(color: Colors.red.shade200, width: 1.5)),
          child: Text('$dayNumber', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700)),
        );
      
      case PillVisualStatus.placebo:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
          child: Text('$dayNumber', style: TextStyle(color: Colors.grey.shade600)),
        );

    }
  }
}