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
    final colorScheme = theme.colorScheme;
    
    final primaryColor = colorScheme.primary;
    final onPrimaryColor = colorScheme.onPrimary;
    final errorContainerColor = colorScheme.errorContainer;
    final onErrorContainerColor = colorScheme.onErrorContainer;
    final secondaryContainerColor = colorScheme.secondaryContainer;
    final onSecondaryContainerColor = colorScheme.onSecondaryContainer;
    final tertiaryContainerColor = colorScheme.tertiaryContainer;
    final onTertiaryContainerColor = colorScheme.onTertiaryContainer;
    final surfaceVariantColor = colorScheme.surfaceContainerHighest;
    final onSurfaceVariantColor = colorScheme.onSurfaceVariant;

    switch (this) {
      case PillVisualStatus.taken:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.9)),
          child: Icon(Icons.check, color: onPrimaryColor, size: 18),
        );

      case PillVisualStatus.today:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor, width: 2.5)),
          child: Text('$dayNumber', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
        );

      case PillVisualStatus.missed:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: errorContainerColor),
          child: Text('$dayNumber', style: TextStyle(fontWeight: FontWeight.bold, color: onErrorContainerColor)),
        );

      case PillVisualStatus.late:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: tertiaryContainerColor),
          child: Text('$dayNumber', style: TextStyle(fontWeight: FontWeight.bold, color: onTertiaryContainerColor)),
        );

      case PillVisualStatus.skipped:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: secondaryContainerColor),
          child: Icon(Icons.skip_next_rounded, color: onSecondaryContainerColor, size: 18),
        );
      case PillVisualStatus.placebo:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: secondaryContainerColor),
          child: Text('$dayNumber', style: TextStyle(color: onSecondaryContainerColor)),
        );

      case PillVisualStatus.future:
        return (
          decoration: BoxDecoration(shape: BoxShape.circle, color: surfaceVariantColor),
          child: Text('$dayNumber', style: TextStyle(color: onSurfaceVariantColor)),
        );
    }
  }
}