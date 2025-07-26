class PeriodEntry {
	int? id;
	DateTime date;
	String? symptom;
	String flow;

	PeriodEntry({
		this.id,
		required this.date,
		this.symptom,
		required this.flow,
	});

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'date': date.toIso8601String(),
			'symptom': symptom,
			'flow': flow,
		};
	}

	factory PeriodEntry.fromMap(Map<String, dynamic> map) {
		return PeriodEntry(
			id: map['id'] as int?,
			date: DateTime.parse(map['date'] as String),
			symptom: map['symptom'] as String?,
			flow: map['flow'] as String,
		);
	}

	PeriodEntry copyWith({
		int? id,
		DateTime? date,
		String? symptom,
		String? flow,
	}) {
		return PeriodEntry(
		id: id ?? this.id,
		date: date ?? this.date,
		symptom: symptom ?? this.symptom,
		flow: flow ?? this.flow,
		);
	}

	@override
	String toString() {
		return 'PeriodEntry(id: $id, date: $date, symptom: $symptom, flow: $flow)';
	}
}