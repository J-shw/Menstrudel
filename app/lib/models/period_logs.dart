class PeriodLogEntry {
	int? id;
	DateTime date;
	String? symptom;
	int flow;
	int? periodId;

	PeriodLogEntry({
		this.id,
		required this.date,
		this.symptom,
		required this.flow,
		this.periodId,
	});

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'date': date.toIso8601String(),
			'symptom': symptom,
			'flow': flow,
			'period_id': periodId,
		};
	}

	factory PeriodLogEntry.fromMap(Map<String, dynamic> map) {
		return PeriodLogEntry(
			id: map['id'] as int?,
			date: DateTime.parse(map['date'] as String),
			symptom: map['symptom'] as String?,
			flow: map['flow'] as int,
			periodId: map['period_id'] as int?,
		);
	}

	PeriodLogEntry copyWith({
		int? id,
		DateTime? date,
		String? symptom,
		int? flow,
		int? periodId,
	}) {
		return PeriodLogEntry(
			id: id ?? this.id,
			date: date ?? this.date,
			symptom: symptom ?? this.symptom,
			flow: flow ?? this.flow,
			periodId: periodId ?? this.periodId,
		);
	}
}