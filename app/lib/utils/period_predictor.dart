import 'package:menstrudel/models/period_logs.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/models/cycle_stats.dart';
import 'package:menstrudel/models/monthly_cycle_data.dart';
import 'dart:math';


class PeriodPredictor {
  	static const int _defaultCycleLength = 28;
	 
  	static const int _maxValidCycleLength = 45;
  	static const int _minValidCycleLength = 20;

	static List<int> _getValidCycleLengths(List<PeriodEntry> entries) {
		if (entries.length < 2) {
			return [];
		}

		final List<PeriodEntry> sortedEntries = List.from(entries);
		sortedEntries.sort((a, b) => a.date.compareTo(b.date));

		List<int> cycleLengths = [];
		for (int i = 0; i < sortedEntries.length - 1; i++) {
			int days = sortedEntries[i + 1].date.difference(sortedEntries[i].date).inDays;
			
			if (days >= _minValidCycleLength && days <= _maxValidCycleLength) {
				cycleLengths.add(days);
			}
		}
		return cycleLengths;
	}

  	static PeriodPredictionResult? estimateNextPeriod(List<PeriodEntry> entries, DateTime now) {
		
		final List<PeriodEntry> sortedEntries = List.from(entries);
		sortedEntries.sort((a, b) => a.date.compareTo(b.date));

		if (sortedEntries.length < 2) {
			if (sortedEntries.isNotEmpty) {
				final lastPeriodDate = sortedEntries.last.date;
				final estimatedDate = lastPeriodDate.add(const Duration(days: _defaultCycleLength));
				final daysUntilDue = estimatedDate.difference(now).inDays;
				return PeriodPredictionResult(
					estimatedDate: estimatedDate,
					daysUntilDue: daysUntilDue,
					averageCycleLength: _defaultCycleLength,
				);
			}
			return null;
		}

		List<int> validCycleLengths = _getValidCycleLengths(entries);

		int averageCycleLength;
		if (validCycleLengths.isNotEmpty) {
			int totalCycleDays = validCycleLengths.reduce((a, b) => a + b);
			averageCycleLength = (totalCycleDays / validCycleLengths.length).round();
			if (averageCycleLength == 0){
				averageCycleLength = _defaultCycleLength; 
			} else {
				averageCycleLength = _defaultCycleLength;
			}

			DateTime lastPeriodDate = sortedEntries.last.date;

			DateTime estimatedDate = lastPeriodDate.add(Duration(days: averageCycleLength));

			int daysUntilDue = estimatedDate.difference(now).inDays;

			return PeriodPredictionResult(
				estimatedDate: estimatedDate,
				daysUntilDue: daysUntilDue,
				averageCycleLength: averageCycleLength,
			);
		}else{
			return null;
		}
	}

	static CycleStats? getCycleStats(List<PeriodEntry> entries) {
		if (entries.length < 2) {
			return null;
		}

		final List<PeriodEntry> sortedEntries = List.from(entries);
		sortedEntries.sort((a, b) => a.date.compareTo(b.date));

		List<int> validCycleLengths = _getValidCycleLengths(entries);

		if (validCycleLengths.isEmpty) {
			return null;
		}

		int totalCycleDays = validCycleLengths.reduce((a, b) => a + b);
		int averageCycleLength = (totalCycleDays / validCycleLengths.length).round();
		
		if (averageCycleLength == 0) averageCycleLength = _defaultCycleLength; 

		int shortestCycle = validCycleLengths.reduce(min);
		int longestCycle = validCycleLengths.reduce(max);

		return CycleStats(
		averageCycleLength: averageCycleLength,
		shortestCycleLength: shortestCycle,
		longestCycleLength: longestCycle,
		numberOfCycles: validCycleLengths.length,
		);
	}
	static List<MonthlyCycleData> getMonthlyCycleData(List<PeriodEntry> entries) {
		List<MonthlyCycleData> monthlyData = [];

		if (entries.length < 2) {
			return monthlyData; 
		}

		final List<PeriodEntry> sortedEntries = List.from(entries);
		sortedEntries.sort((a, b) => a.date.compareTo(b.date));

		for (int i = 0; i < sortedEntries.length - 1; i++) {
		int days = sortedEntries[i + 1].date.difference(sortedEntries[i].date).inDays;

		if (days >= _minValidCycleLength && days <= _maxValidCycleLength) {
			final DateTime cycleEndDate = sortedEntries[i + 1].date;
			monthlyData.add(MonthlyCycleData(
				year: cycleEndDate.year,
				month: cycleEndDate.month,
				cycleLength: days,
			));
		}
		}
		return monthlyData;
  	}
}