import 'dart:convert';

class PeriodLogEntry {
	int? id;
	DateTime date;
	List<String>? symptoms;
	int flow;
  int painLevel;
	int? periodId;

	PeriodLogEntry({
		this.id,
		required this.date,
		this.symptoms,
		required this.flow,
    required this.painLevel,
		this.periodId,
	});

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'date': date.toIso8601String(),
			'symptoms': symptoms != null ? jsonEncode(symptoms) : null,
			'flow': flow,
      'painLevel': painLevel,
			'period_id': periodId,
		};
	}

	factory PeriodLogEntry.fromMap(Map<String, dynamic> map) {
    List<String>? symptomsFromMap;
    if (map['symptoms'] != null) {
      final decoded = jsonDecode(map['symptoms'] as String);
      symptomsFromMap = List<String>.from(decoded);
    }

		return PeriodLogEntry(
			id: map['id'] as int?,
			date: DateTime.parse(map['date'] as String),
			symptoms: symptomsFromMap,
			flow: map['flow'] as int,
      painLevel: map['painLevel'] as int,
			periodId: map['period_id'] as int?,
		);
	}

	PeriodLogEntry copyWith({
		int? id,
		DateTime? date,
		List<String>? symptoms,
		int? flow,
    int? painLevel,
		int? periodId,
	}) {
		return PeriodLogEntry(
			id: id ?? this.id,
			date: date ?? this.date,
			symptoms: symptoms ?? this.symptoms,
			flow: flow ?? this.flow,
      painLevel: painLevel ?? this.painLevel,
			periodId: periodId ?? this.periodId,
		);
	}
}