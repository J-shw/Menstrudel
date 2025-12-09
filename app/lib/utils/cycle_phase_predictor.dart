
import 'package:menstrudel/models/cycle_phase/cycle_phase.dart';
import 'package:menstrudel/models/cycle_phase/cycle_phase_enum.dart';

class CyclePhasePredictor {
  static const int _lutealPhaseLength = 14;
  static const int _defaultCycleLength = 28;
  static const int _defaultPeriodDuration = 5;

  /// Calculates the current cycle phase based on user data.
  ///
  /// This function utilises user's historical averages
  /// for accurate phase duration calculation.
  /// 
  /// If [averageCycleLength] or [averagePeriodDuration] are null then defaults are used.
  /// 
  /// Returns a [CyclePhaseResult] object
  static CyclePhaseResult getPhaseStatus({
    required DateTime lastPeriodStartDate,
    required int? averageCycleLength,
    required int? averagePeriodDuration,
    required DateTime now,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final daysSinceLpStart = today.difference(lastPeriodStartDate).inDays + 1;

    // 
    if (daysSinceLpStart <= 0) {
      return CyclePhaseResult(
        phase: CyclePhase.unknown,
        daysInPhase: 0,
        daysRemainingInPhase: 0,
      );
    }

    // Ok so we can estimate the dates using the default values set in this class. Not sure if this should be kept or not.
    // Maybe it can be [CyclePhase.unknown] if either value is null?
    int menstruationEndDay = averagePeriodDuration ?? _defaultPeriodDuration;
    int cycleLength = averageCycleLength ?? _defaultCycleLength;
     

    final int predictedOvulationDay = cycleLength - _lutealPhaseLength;

    // Assuming the fertile window (Ovulation phase) lasts 3 days for simplicity.
    // This is Day (predictedOvulationDay - 1), Day (predictedOvulationDay), Day (predictedOvulationDay + 1)
    final int ovulationStartDay = predictedOvulationDay - 1;
    final int ovulationEndDay = predictedOvulationDay + 1;

    // - - Determine Current Phase - -

    // Phase 1: Menstruation
    if (daysSinceLpStart <= menstruationEndDay) {
      return CyclePhaseResult(
        phase: CyclePhase.menstruation,
        daysInPhase: daysSinceLpStart,
        daysRemainingInPhase: menstruationEndDay - daysSinceLpStart,
      );
    }
    
    // Phase 2: Follicular
    // Runs from Day (Menstruation End Day + 1) up to Day (Ovulation Start Day - 1)
    if (daysSinceLpStart < ovulationStartDay) {
      return CyclePhaseResult(
        phase: CyclePhase.follicular,
        daysInPhase: daysSinceLpStart - menstruationEndDay,
        daysRemainingInPhase: ovulationStartDay - daysSinceLpStart,
      );
    }
    
    // Phase 3: Ovulation
    if (daysSinceLpStart >= ovulationStartDay && daysSinceLpStart <= ovulationEndDay) {
      return CyclePhaseResult(
        phase: CyclePhase.ovulation,
        daysInPhase: daysSinceLpStart - ovulationStartDay + 1,
        daysRemainingInPhase: ovulationEndDay - daysSinceLpStart,
      );
    }

    // Phase 4: Luteal
    // Runs from Day (Ovulation End Day + 1) up to Day (Average Cycle Length)
    if (daysSinceLpStart <= cycleLength) {
      return CyclePhaseResult(
        phase: CyclePhase.luteal,
        daysInPhase: daysSinceLpStart - ovulationEndDay,
        daysRemainingInPhase: cycleLength - daysSinceLpStart,
      );
    }

    // Fallback: If today is past the predicted cycle length, the next period is late.
    return CyclePhaseResult(
      phase: CyclePhase.unknown,
      daysInPhase: daysSinceLpStart - cycleLength,
      daysRemainingInPhase: 0,
    );
  }
}