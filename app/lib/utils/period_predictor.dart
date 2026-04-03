import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/models/cycles/cycle_stats.dart';
import 'package:menstrudel/models/periods/period_stats.dart';
import 'package:menstrudel/models/cycles/monthly_cycle_data.dart';
import 'package:menstrudel/utils/constants.dart';
import 'dart:math';

/// A utility class for calculating cycle statistics and predicting the next period
/// based on a list of recorded [Period] entries.
class PeriodPredictor {
  /// The default cycle length (in days) used if calculation fails.
  static const int _defaultCycleLength = 28;

  /// The minimum number of periods logged needed to calculate a prediction.
  static const int _minPeriodsLogged = 2;

  /// Calculates a list of valid cycle lengths (in days) from the start date of
  /// one period to the start date of the next.
  ///
  /// A cycle length is only considered valid if it falls within the range
  /// [minValidCycleLength] and [maxValidCycleLength] (defined in `constants.dart`).
  ///
  /// Returns an empty list if there are fewer than `_minPeriodsLogged` or no valid cycles.
  static List<int> _getValidCycleLengths(List<Period> periods) {
    if (periods.length < _minPeriodsLogged) {
      return [];
    }

    final List<Period> sortedPeriods = List.from(periods);
    sortedPeriods.sort((a, b) => a.startDate.compareTo(b.startDate));

    List<int> cycleLengths = [];
    for (int i = 0; i < sortedPeriods.length - 1; i++) {
      int days = sortedPeriods[i + 1].startDate
          .difference(sortedPeriods[i].startDate)
          .inDays;

      if (days >= minValidCycleLength && days <= maxValidCycleLength) {
        cycleLengths.add(days);
      }
    }
    return cycleLengths;
  }

  /// Calculates a list of valid period durations (in days) from a list of period entries.
  ///
  /// Duration is calculated as the difference between end date and start date, plus one day.
  /// Only durations greater than 0 are included.
  static List<int> _getValidPeriodDurations(List<Period> periods) {
    final List<int> durations = [];
    for (final period in periods) {
      if (period.totalDays > 0) {
        durations.add(period.totalDays);
      }
    }
    return durations;
  }

  /// Estimates the start and end dates of the next period.
  ///
  /// The prediction is based on the average cycle length and average period duration
  /// calculated from the historical period entries.
  ///
  /// Returns a [PeriodPredictionResult] object, or `null` if there are not enough
  /// entries or if statistics cannot be calculated.
  static PeriodPredictionResult? estimateNextPeriod(
    List<Period> periods,
    DateTime now,
  ) {
    if (periods.length < _minPeriodsLogged) {
      return null;
    }

    final sortedPeriods = List<Period>.from(periods)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final List<int> validCycleLengths = _getValidCycleLengths(sortedPeriods);
    if (validCycleLengths.isEmpty) {
      return null;
    }
    final int totalCycleDays = validCycleLengths.reduce((a, b) => a + b);
    final int averageCycleLength = (totalCycleDays / validCycleLengths.length)
        .round();

    final List<int> periodDurations = _getValidPeriodDurations(sortedPeriods);
    if (periodDurations.isEmpty) {
      return null;
    }
    final int totalDurationDays = periodDurations.reduce((a, b) => a + b);
    final int averagePeriodDuration =
        (totalDurationDays / periodDurations.length).round();

    if (averageCycleLength <= 0 || averagePeriodDuration <= 0) {
      return null;
    }

    DateTime lastPeriodStartDate = sortedPeriods.last.startDate;

    DateTime estimatedStartDate = lastPeriodStartDate.add(
      Duration(days: averageCycleLength),
    );

    DateTime estimatedEndDate = estimatedStartDate.add(
      Duration(days: averagePeriodDuration - 1),
    );

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startOfEstimatedDate = DateTime(
      estimatedStartDate.year,
      estimatedStartDate.month,
      estimatedStartDate.day,
    );

    int daysUntilDue = startOfEstimatedDate.difference(today).inDays;

    return PeriodPredictionResult(
      estimatedStartDate: estimatedStartDate,
      estimatedEndDate: estimatedEndDate,
      daysUntilDue: daysUntilDue,
      averageCycleLength: averageCycleLength,
      averagePeriodDuration: averagePeriodDuration,
    );
  }

  /// Generates a list of monthly cycle data containing the cycle length for each
  /// recorded cycle end month.
  ///
  /// Returns an empty list if there are fewer than `_minPeriodsLogged` or no valid cycle data.
  static List<MonthlyCycleData> getMonthlyCycleData(List<Period> periods) {
    if (periods.length < _minPeriodsLogged) {
      return [];
    }

    final sortedPeriods = List<Period>.from(periods)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final List<MonthlyCycleData> monthlyData = [];
    for (int i = 0; i < sortedPeriods.length - 1; i++) {
      int days = sortedPeriods[i + 1].startDate
          .difference(sortedPeriods[i].startDate)
          .inDays;

      if (days >= minValidCycleLength && days <= maxValidCycleLength) {
        final DateTime cycleEndDate = sortedPeriods[i + 1].startDate;
        monthlyData.add(
          MonthlyCycleData(
            year: cycleEndDate.year,
            month: cycleEndDate.month,
            cycleLength: days,
          ),
        );
      }
    }
    return monthlyData;
  }

  /// Calculates and returns statistics about the user's menstrual cycles.
  ///
  /// Statistics include average, shortest, and longest cycle lengths, and the total
  /// number of valid cycles recorded.
  ///
  /// Returns a [CycleStats] object, or `null` if there are not enough periods
  /// or no valid cycle data.
  static CycleStats? getCycleStats(List<Period> periods) {
    if (periods.length < _minPeriodsLogged) {
      return null;
    }

    List<int> validCycleLengths = _getValidCycleLengths(periods);

    if (validCycleLengths.isEmpty) {
      return null;
    }

    int totalCycleDays = validCycleLengths.reduce((a, b) => a + b);
    int averageCycleLength = (totalCycleDays / validCycleLengths.length)
        .round();

    if (averageCycleLength == 0) {
      averageCycleLength = _defaultCycleLength;
    }

    int shortestCycle = validCycleLengths.reduce(min);
    int longestCycle = validCycleLengths.reduce(max);

    return CycleStats(
      averageCycleLength: averageCycleLength,
      shortestCycleLength: shortestCycle,
      longestCycleLength: longestCycle,
      numberOfCycles: validCycleLengths.length,
      cycleLengths: validCycleLengths,
    );
  }

  /// Calculates and returns statistics about the duration of the user's periods.
  ///
  /// Statistics include average, shortest, and longest period durations, and the total
  /// number of periods recorded.
  ///
  /// Returns a [PeriodStats] object, or `null` if there are fewer than `_minPeriodsLogged` periods.
  static PeriodStats? getPeriodStats(List<Period> entries) {
    if (entries.length < _minPeriodsLogged) {
      return null;
    }

    final List<Period> sortedEntries = List.from(entries);
    sortedEntries.sort((a, b) => a.startDate.compareTo(b.startDate));
    int totalCycleDays = sortedEntries.fold(
      0,
      (sum, entry) => sum + entry.totalDays,
    );
    int averageLength = (totalCycleDays / sortedEntries.length).round();

    int shortestLength = sortedEntries
        .reduce((a, b) => a.totalDays < b.totalDays ? a : b)
        .totalDays;
    int longestLength = sortedEntries
        .reduce((a, b) => a.totalDays > b.totalDays ? a : b)
        .totalDays;

    return PeriodStats(
      averageLength: averageLength,
      shortestLength: shortestLength,
      longestLength: longestLength,
      numberofPeriods: sortedEntries.length,
    );
  }
}
