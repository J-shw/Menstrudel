import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

enum CyclePhase {
  /// Menstruation phase (On Period)
  menstruation,
  /// Follicular phase (Pre-Ovulation)
  follicular,
  /// Fertile Window
  fertileWindow,
  /// Ovulation phase (Peak Fertility)
  ovulation,
  /// Luteal phase (Post-Ovulation)
  luteal,
  /// Late phase (After Cycle)
  late,
  /// Unknown phase
  unknown,
}

extension FlowExtension on CyclePhase {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case CyclePhase.menstruation:
        return l10n.cyclePhase_menstruation;
      case CyclePhase.follicular:
        return l10n.cyclePhase_follicular;
      case CyclePhase.fertileWindow:
        return l10n.cyclePhase_fertileWindow;
      case CyclePhase.ovulation:
        return l10n.cyclePhase_ovulation;
      case CyclePhase.luteal:
        return l10n.cyclePhase_luteal;
      case CyclePhase.late:
        return l10n.cyclePhase_late;
      case CyclePhase.unknown:
        return l10n.cyclePhase_unknown;
    }
  }

  String getDescription(AppLocalizations l10n) {
    switch (this) {
      case CyclePhase.menstruation:
        return l10n.cyclePhase_menstruationDescription;
      case CyclePhase.follicular:
        return l10n.cyclePhase_follicularDescription;
      case CyclePhase.fertileWindow:
        return l10n.cyclePhase_fertileWindowDescription;
      case CyclePhase.ovulation:
        return l10n.cyclePhase_ovulationDescription;
      case CyclePhase.luteal:
        return l10n.cyclePhase_lutealDescription;
      case CyclePhase.late:
        return l10n.cyclePhase_lateDescription;
      case CyclePhase.unknown:
        return l10n.cyclePhase_unknownDescription;
    }
  }

  IconData get icon {
    switch (this) {
      case CyclePhase.menstruation:
        return Icons.water_drop;
      case CyclePhase.follicular:
        return Icons.wb_sunny_outlined;
      case CyclePhase.fertileWindow:
        return Icons.favorite;
      case CyclePhase.ovulation:
        return Icons.favorite;
      case CyclePhase.luteal:
        return Icons.cloud_queue;
      case CyclePhase.late:
        return Icons.error_outline;
      case CyclePhase.unknown:
        return Icons.help_outline;
    }
  }

  Color get color {
    switch (this) {
      case CyclePhase.menstruation:
        return Colors.red;
      case CyclePhase.follicular:
        return Colors.blue;
      case CyclePhase.fertileWindow:
        return Colors.teal.shade100;
      case CyclePhase.ovulation:
        return Colors.teal.shade300;
      case CyclePhase.luteal:
        return Colors.purple;
      case CyclePhase.late:
        return Colors.orange;
      case CyclePhase.unknown:
        return Colors.grey;
    }
  }
}