import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycle_phase/cycle_phase.dart';
import 'package:menstrudel/models/cycle_phase/cycle_phase_enum.dart';

/// A utility class for calculating current cycle phase
/// based on user data.
/// This is to be used with natural cycles only. If user is on the pill it should not be used.
class CyclePhasePredictor {
  /// This is a constant value for now.
  /// Tracking Cervical Mucus would help better predict this.
  /// So I will look into adding this in the future.
  static const int _lutealPhaseLength = 14;

  /// Calculates the current cycle phase based on user data.
  ///
  /// This function utilises user's historical averages
  /// for more accurate phase duration calculation.
  /// 
  /// If [averageCycleLength] or [averagePeriodDuration] are null then unkown phase is returned.
  /// 
  /// Returns a [CyclePhaseResult] object
  static CyclePhaseResult getPhaseStatus({
    required DateTime? lastPeriodStartDate,
    required int? averageCycleLength,
    required int? averagePeriodDuration,
    bool isPeriodOngoing = false,
  }) {
    if (lastPeriodStartDate == null) {
      return CyclePhaseResult(
        phase: CyclePhase.unknown,
        daysInPhase: 0,
        daysRemainingInPhase: 0,
      );
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysSinceLastPeriodStart = today.difference(lastPeriodStartDate).inDays + 1;

    if (daysSinceLastPeriodStart <= 0 || averageCycleLength == null || averagePeriodDuration == null) {
      return CyclePhaseResult(
        phase: CyclePhase.unknown,
        daysInPhase: 0,
        daysRemainingInPhase: 0,
      );
    }

    int menstruationEndDay = averagePeriodDuration;
    int cycleLength = averageCycleLength;
     
    final int predictedOvulationDay = cycleLength - _lutealPhaseLength;

    // The fertile window is roughly 6 days.
    // This includes 5 days before ovulation and the day of ovulation itself.
    // https://womenshealth.gov/ovulation-calculator - "There are about 6 days during each menstrual cycle when you can get pregnant."
    // https://www.acog.org/womens-health/experts-and-stories/the-latest/trying-to-get-pregnant-heres-when-to-have-sex - "the window of fertility is much wider than this—about 6 days each cycle."
    final int fertileWindowStart = predictedOvulationDay - 5;
    final int fertileWindowEnd = predictedOvulationDay;

    debugPrint('Days since last period start: $daysSinceLastPeriodStart');
    debugPrint('Average cycle length: $averageCycleLength');
    debugPrint('Average period duration: $averagePeriodDuration');
    debugPrint('Menstruation end day: $menstruationEndDay');
    debugPrint('Cycle length: $cycleLength');
    debugPrint('Fertile window start: $fertileWindowStart');
    debugPrint('Fertile window end: $fertileWindowEnd');


    // - - Determine Current Phase - -

    // Phase 1: Menstruation
    // Runs from Day 1 up to Day (Menstruation End Day)
    // Using period ongoing bool for when users cycle is ongoing outside of average
    if (isPeriodOngoing || (daysSinceLastPeriodStart <= menstruationEndDay)) {
      return CyclePhaseResult(
        phase: CyclePhase.menstruation,
        daysInPhase: daysSinceLastPeriodStart,
        daysRemainingInPhase: isPeriodOngoing && daysSinceLastPeriodStart > menstruationEndDay 
            ? 0
            : menstruationEndDay - daysSinceLastPeriodStart,
      );
    }
    
    // Phase 2: Follicular
    // Runs from Day (Menstruation End Day + 1) up to Day (Fertile Window Start - 1)
    if (daysSinceLastPeriodStart < fertileWindowStart) {
      return CyclePhaseResult(
        phase: CyclePhase.follicular,
        daysInPhase: daysSinceLastPeriodStart - menstruationEndDay,
        daysRemainingInPhase: fertileWindowStart - daysSinceLastPeriodStart,
      );
    }
    
    // Phase 3: Ovulation (Fertile Window)
    if (daysSinceLastPeriodStart >= fertileWindowStart && daysSinceLastPeriodStart <= fertileWindowEnd) {
      return CyclePhaseResult(
        phase: CyclePhase.ovulation,
        daysInPhase: (daysSinceLastPeriodStart - fertileWindowStart) + 1,
        daysRemainingInPhase: fertileWindowEnd - daysSinceLastPeriodStart,
      );
    }

    // Phase 4: Luteal
    // Runs from Day (Fertile Window End + 1) up to Day (Average Cycle Length)
    if (daysSinceLastPeriodStart <= cycleLength) {
      return CyclePhaseResult(
        phase: CyclePhase.luteal,
        daysInPhase: daysSinceLastPeriodStart - fertileWindowEnd,
        daysRemainingInPhase: cycleLength - daysSinceLastPeriodStart,
      );
    }

    // Fallback: Late
    // If the cycle exceeds the expected length (Average Cycle Length), return late.
    return CyclePhaseResult(
      phase: CyclePhase.late, 
      daysInPhase: daysSinceLastPeriodStart - cycleLength,
      daysRemainingInPhase: 0,
    );
  }
}