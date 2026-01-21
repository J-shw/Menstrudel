
import 'package:flutter/material.dart';
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
    required DateTime? lastPeriodStartDate,
    required int? averageCycleLength,
    required int? averagePeriodDuration
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

    if (daysSinceLastPeriodStart <= 0) {
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
    if (daysSinceLastPeriodStart <= menstruationEndDay) {
      return CyclePhaseResult(
        phase: CyclePhase.menstruation,
        daysInPhase: daysSinceLastPeriodStart,
        daysRemainingInPhase: menstruationEndDay - daysSinceLastPeriodStart,
      );
    }
    
    // Phase 2: Follicular
    // Runs from Day (Menstruation End Day + 1) up to Day (Ovulation Start Day - 1)
    if (daysSinceLastPeriodStart < ovulationStartDay) {
      return CyclePhaseResult(
        phase: CyclePhase.follicular,
        daysInPhase: daysSinceLastPeriodStart - menstruationEndDay,
        daysRemainingInPhase: ovulationStartDay - daysSinceLastPeriodStart,
      );
    }
    
    // Phase 3: Ovulation
    if (daysSinceLastPeriodStart >= ovulationStartDay && daysSinceLastPeriodStart <= ovulationEndDay) {
      return CyclePhaseResult(
        phase: CyclePhase.ovulation,
        daysInPhase: daysSinceLastPeriodStart - ovulationStartDay + 1,
        daysRemainingInPhase: ovulationEndDay - daysSinceLastPeriodStart,
      );
    }

    // Phase 4: Luteal
    // Runs from Day (Ovulation End Day + 1) up to Day (Average Cycle Length)
    if (daysSinceLastPeriodStart <= cycleLength) {
      return CyclePhaseResult(
        phase: CyclePhase.luteal,
        daysInPhase: daysSinceLastPeriodStart - ovulationEndDay,
        daysRemainingInPhase: cycleLength - daysSinceLastPeriodStart,
      );
    }

    // Fallback
    return CyclePhaseResult(
      phase: CyclePhase.unknown,
      daysInPhase: daysSinceLastPeriodStart - cycleLength,
      daysRemainingInPhase: 0,
    );
  }
}