import 'package:menstrudel/models/cycle_phase/cycle_phase.dart';

/// A utility class for calculating when each cycle phase is due based on user data.
/// This is to be used with natural cycles only. If user is on the pill it should not be used.
class CyclePhasePredictor {
  /// This is a constant value for now.
  /// Tracking Cervical Mucus would help better predict this.
  /// So I will look into adding this in the future.
  static const int _lutealPhaseLength = 14;

  static PredictedCycle predictCycle({
    required DateTime lastPeriodStartDate,
    required int averageCycleLength,
    required int averagePeriodDuration,
  }) {

    final ovulationDayOffset = averageCycleLength - _lutealPhaseLength;
    final ovulationDay = lastPeriodStartDate.add(Duration(days: ovulationDayOffset - 1));

    final fertileStart = ovulationDay.subtract(const Duration(days: 5));
    
    final lutealStart = ovulationDay.add(const Duration(days: 2));

    return PredictedCycle(
      menstruationStart: lastPeriodStartDate,
      follicularStart: lastPeriodStartDate.add(Duration(days: averagePeriodDuration)),
      fertileWindowStart: fertileStart,
      ovulationDay: ovulationDay,
      lutealStart: lutealStart,
      nextPeriodStart: lastPeriodStartDate.add(Duration(days: averageCycleLength)),
    );
  }
}