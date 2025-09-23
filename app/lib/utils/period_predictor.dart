import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/models/cycles/cycle_stats.dart';
import 'package:menstrudel/models/periods/period_stats.dart';
import 'package:menstrudel/models/cycles/monthly_cycle_data.dart';
import 'package:menstrudel/utils/constants.dart';
import 'dart:math';


class PeriodPredictor {
  	static const int _defaultCycleLength = 28;

	static List<int> _getValidCycleLengths(List<Period> periods) {
    if (periods.length < 2) {
      return [];
    }

    final List<Period> sortedPeriods = List.from(periods);
    sortedPeriods.sort((a, b) => a.startDate.compareTo(b.startDate));

    List<int> cycleLengths = [];
    for (int i = 0; i < sortedPeriods.length - 1; i++) {
      int days = sortedPeriods[i + 1].startDate.difference(sortedPeriods[i].startDate).inDays;
      
      if (days >= minValidCycleLength && days <= maxValidCycleLength) {
        cycleLengths.add(days);
      }
    }
    return cycleLengths;
  }

  static List<int> _getValidPeriodDurations(List<Period> entries) {
    final List<int> durations = [];
    for (final entry in entries) {
      final duration = entry.endDate.difference(entry.startDate).inDays + 1;
      if (duration > 0) {
        durations.add(duration);
      }
      
    }
    return durations;
  }

  static PeriodPredictionResult? estimateNextPeriod(List<Period> entries, DateTime now) {
    if (entries.length < 2) {
      return null;
    }

    final sortedEntries = List<Period>.from(entries)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final List<int> cycleLengths = _getValidCycleLengths(sortedEntries);
    if (cycleLengths.isEmpty) {
      return null;
    }
    final int totalCycleDays = cycleLengths.reduce((a, b) => a + b);
    final int averageCycleLength = (totalCycleDays / cycleLengths.length).round();

    final List<int> periodDurations = _getValidPeriodDurations(sortedEntries);
    if (periodDurations.isEmpty) {
      return null;
    }
    final int totalDurationDays = periodDurations.reduce((a, b) => a + b);
    final int averagePeriodDuration = (totalDurationDays / periodDurations.length).round();

    if (averageCycleLength <= 0 || averagePeriodDuration <= 0) {
      return null;
    }

    DateTime lastPeriodStartDate = sortedEntries.last.startDate;

    DateTime estimatedStartDate = lastPeriodStartDate.add(Duration(days: averageCycleLength));

    DateTime estimatedEndDate = estimatedStartDate.add(Duration(days: averagePeriodDuration - 1));

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startOfEstimatedDate = DateTime(estimatedStartDate.year, estimatedStartDate.month, estimatedStartDate.day);

    int daysUntilDue = startOfEstimatedDate.difference(today).inDays;


    return PeriodPredictionResult(
      estimatedStartDate: estimatedStartDate,
      estimatedEndDate: estimatedEndDate,
      daysUntilDue: daysUntilDue,
      averageCycleLength: averageCycleLength,
      averagePeriodDuration: averagePeriodDuration,
    );
  }

	static CycleStats? getCycleStats(List<Period> periods) {
    if (periods.length < 2) {
      return null;
    }

    List<int> validCycleLengths = _getValidCycleLengths(periods);

    if (validCycleLengths.isEmpty) {
      return null;
    }

    int totalCycleDays = validCycleLengths.reduce((a, b) => a + b);
    int averageCycleLength = (totalCycleDays / validCycleLengths.length).round();
    
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
    );
  }

	static List<MonthlyCycleData> getMonthlyCycleData(List<Period> periods) {
    if (periods.length < 2) {
      return [];
    }

    final sortedPeriods = List<Period>.from(periods)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final List<MonthlyCycleData> monthlyData = [];
    for (int i = 0; i < sortedPeriods.length - 1; i++) {
      int days = sortedPeriods[i + 1].startDate.difference(sortedPeriods[i].startDate).inDays;

      if (days >= minValidCycleLength && days <= maxValidCycleLength) {
        final DateTime cycleEndDate = sortedPeriods[i + 1].startDate;
        monthlyData.add(MonthlyCycleData(
          year: cycleEndDate.year,
          month: cycleEndDate.month,
          cycleLength: days,
        ));
      }
    }
    return monthlyData;
  }

  static PeriodStats? getPeriodData(List<Period> entries) {
    if (entries.length < 2) {
			return null;
		}

		final List<Period> sortedEntries = List.from(entries);
		sortedEntries.sort((a, b) => a.startDate.compareTo(b.startDate));

		int totalCycleDays = sortedEntries.fold(0, (sum, entry) => sum + entry.totalDays);
		int averageLength = (totalCycleDays / sortedEntries.length).round();

		int shortestLength = sortedEntries.reduce((a, b) => a.totalDays < b.totalDays ? a : b).totalDays;
		int longestLength = sortedEntries.reduce((a, b) => a.totalDays > b.totalDays ? a : b).totalDays;

		return PeriodStats(
      averageLength: averageLength,
      shortestLength: shortestLength,
      longestLength: longestLength,
      numberofPeriods: sortedEntries.length,
		);
  }
}