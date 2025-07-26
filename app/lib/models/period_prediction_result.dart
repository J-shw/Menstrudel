class PeriodPredictionResult {
	final DateTime estimatedDate;
	final int daysUntilDue;
	final int averageCycleLength;

	PeriodPredictionResult({
		required this.estimatedDate,
		required this.daysUntilDue,
		required this.averageCycleLength,
	});

	@override
	String toString() {
		return 'PeriodPredictionResult(estimatedDate: $estimatedDate, daysUntilDue: $daysUntilDue, averageCycleLength: $averageCycleLength)';
	}
}