import 'package:menstrudel/models/cycle_phase/cycle_phase_enum.dart';

class PredictedCycle {
  final DateTime menstruationStart;
  final DateTime follicularStart;
  final DateTime fertileWindowStart;
  final DateTime ovulationDay;
  final DateTime lutealStart;
  final DateTime nextPeriodStart;

  PredictedCycle({
    required this.menstruationStart,
    required this.follicularStart,
    required this.fertileWindowStart,
    required this.ovulationDay,
    required this.lutealStart,
    required this.nextPeriodStart,
  });

  CyclePhase getPhaseForDate(DateTime date, bool isPeriodOngoing) {
    // Normalise to midnight to make comparison work regardless of time
    final d = DateTime(date.year, date.month, date.day);

    if (isPeriodOngoing && d.isAfter(menstruationStart.subtract(const Duration(days: 1))) 
        && d.isBefore(fertileWindowStart)) {
      return CyclePhase.menstruation;
    }

    if (d.isBefore(menstruationStart)) return CyclePhase.unknown;
    if (d.isBefore(follicularStart)) return CyclePhase.menstruation;
    if (d.isBefore(fertileWindowStart)) return CyclePhase.follicular;
    if (d.isBefore(ovulationDay)) return CyclePhase.fertileWindow;
    if (d == ovulationDay) return CyclePhase.ovulation;
    if (d.isBefore(lutealStart)) return CyclePhase.fertileWindow;
    if (d.isBefore(nextPeriodStart)) return CyclePhase.luteal;
    
    return CyclePhase.late;
  }

  int getDaysLeft(DateTime date, CyclePhase phase) {
    final d = DateTime(date.year, date.month, date.day);

    switch (phase) {
      case CyclePhase.menstruation: // This is based off average and not the if the user is currently on their period.
        return follicularStart.difference(d).inDays;
      case CyclePhase.follicular:
        return fertileWindowStart.difference(d).inDays;
      case CyclePhase.fertileWindow:
        if (d.isBefore(ovulationDay)) {
          return ovulationDay.difference(d).inDays;
        } else {
          return lutealStart.difference(d).inDays;
        }
      case CyclePhase.ovulation:
        return lutealStart.difference(d).inDays;
      case CyclePhase.luteal:
        return nextPeriodStart.difference(d).inDays;
      default:
        return 0;
    }
  }
}