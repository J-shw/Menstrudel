import 'package:menstrudel/models/period_logs.dart';
import 'package:menstrudel/models/period_prediction_result.dart';

class PeriodPredictor {
  	static const int _defaultCycleLength = 28;

  	static PeriodPredictionResult? estimateNextPeriod(
    	List<PeriodEntry> entries, DateTime now) {
		
		final List<PeriodEntry> sortedEntries = List.from(entries);
		sortedEntries.sort((a, b) => a.date.compareTo(b.date));

		if (sortedEntries.length < 2) {
		if (sortedEntries.isNotEmpty) {
			final lastPeriodDate = sortedEntries.last.date;
			final estimatedDate = lastPeriodDate.add(const Duration(days: _defaultCycleLength));
			final daysUntilDue = estimatedDate.difference(now).inDays; // Calculate days from 'now'
			return PeriodPredictionResult(
				estimatedDate: estimatedDate,
				daysUntilDue: daysUntilDue,
				averageCycleLength: _defaultCycleLength,
			);
		}
		return null;
		}

		List<int> cycleLengths = [];
		
		for (int i = 0; i < sortedEntries.length - 1; i++) {
		int days = sortedEntries[i + 1].date.difference(sortedEntries[i].date).inDays;
		if (days > 0) {
			cycleLengths.add(days);
		}
		}

		if (cycleLengths.isEmpty) {
			final lastPeriodDate = sortedEntries.last.date;
			final estimatedDate = lastPeriodDate.add(const Duration(days: _defaultCycleLength));
			final daysUntilDue = estimatedDate.difference(now).inDays;
			return PeriodPredictionResult(
				estimatedDate: estimatedDate,
				daysUntilDue: daysUntilDue,
				averageCycleLength: _defaultCycleLength,
			);
		}

		int totalCycleDays = cycleLengths.reduce((a, b) => a + b);
		int averageCycleLength = (totalCycleDays / cycleLengths.length).round();
		
		if (averageCycleLength == 0) averageCycleLength = _defaultCycleLength; 

		DateTime lastPeriodDate = sortedEntries.last.date;
		DateTime estimatedDate = lastPeriodDate.add(Duration(days: averageCycleLength));
		int daysUntilDue = estimatedDate.difference(now).inDays;

		return PeriodPredictionResult(
			estimatedDate: estimatedDate,
			daysUntilDue: daysUntilDue,
			averageCycleLength: averageCycleLength,
		);
	}
}