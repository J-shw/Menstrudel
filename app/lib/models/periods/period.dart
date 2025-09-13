import 'package:intl/intl.dart';

/// Represents a single, complete period event, defined by a start and end date.
///
/// Each [Period] object can be linked to a list of [PeriodDay] objects
/// that contain day-to-day details.
class Period {
	final int? id;
	final DateTime startDate;
	final DateTime endDate;
	final int totalDays;

  String get monthLabel {
    return DateFormat('MMM').format(startDate);
  }

	Period({
		this.id, 
		required this.startDate, 
		required this.endDate,
		required this.totalDays
	});

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'start_date': startDate.millisecondsSinceEpoch,
			'end_date': endDate.millisecondsSinceEpoch,
			'total_days': totalDays,
		};
	}

	factory Period.fromMap(Map<String, dynamic> map) {
		return Period(
			id: map['id'],
			startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date']),
			endDate: DateTime.fromMillisecondsSinceEpoch(map['end_date']),
			totalDays: map['total_days'],
		);
	}

	Period copyWith({
		int? id,
		DateTime? startDate,
		DateTime? endDate,
		int? totalDays,
	}) {
		return Period(
			id: id ?? this.id,
			startDate: startDate ?? this.startDate,
			endDate: endDate ?? this.endDate,
			totalDays: totalDays ?? this.totalDays,
		);
	}
}