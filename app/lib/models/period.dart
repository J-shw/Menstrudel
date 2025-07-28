class PeriodEntry {
	final int? id;
	final DateTime startDate;
	final DateTime endDate;

	PeriodEntry({
		this.id, 
		required this.startDate, 
		required this.endDate
	});

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'start_date': startDate.millisecondsSinceEpoch,
			'end_date': endDate.millisecondsSinceEpoch,
		};
	}

	factory PeriodEntry.fromMap(Map<String, dynamic> map) {
		return PeriodEntry(
			id: map['id'],
			startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date']),
			endDate: DateTime.fromMillisecondsSinceEpoch(map['end_date']),
		);
	}

	PeriodEntry copyWith({
		int? id,
		DateTime? startDate,
		DateTime? endDate,
	}) {
		return PeriodEntry(
			id: id ?? this.id,
			startDate: startDate ?? this.startDate,
			endDate: endDate ?? this.endDate,
		);
	}
}