import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';

/// Represents a single day's log within a menstrual cycle.
///
/// This class stores daily observations such as symptoms, flow, and pain level.
/// Each [PeriodDay] object is associated with a parent [Period] via the [periodId].
class PeriodDay {
	int? id;
	DateTime date;
	List<Symptom> symptoms;
	FlowRate flow;
  int? painLevel;
	int? periodId;

	PeriodDay({
		this.id,
		required this.date,
		this.symptoms = const [],
		required this.flow,
    this.painLevel,
		this.periodId,
	});

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'date': date.toIso8601String(),
			'flow': flow.intValue,
      'painLevel': painLevel,
			'period_id': periodId,
		};
	}

	factory PeriodDay.fromMap(
    Map<String, dynamic> map, {
    List<Symptom>? symptoms,
  }) {
		return PeriodDay(
			id: map['id'] as int?,
			date: DateTime.parse(map['date'] as String),
			symptoms: symptoms ?? [],
			flow: FlowRate.values[map['flow'] as int],
      painLevel: map['painLevel'] as int?,
			periodId: map['period_id'] as int?,
		);
	}

	PeriodDay copyWith({
		int? id,
		DateTime? date,
		List<Symptom>? symptoms,
		FlowRate? flow,
    int? painLevel,
		int? periodId,
	}) {
		return PeriodDay(
			id: id ?? this.id,
			date: date ?? this.date,
			symptoms: symptoms ?? this.symptoms,
			flow: flow ?? this.flow,
      painLevel: painLevel ?? this.painLevel,
			periodId: periodId ?? this.periodId,
		);
	}
}