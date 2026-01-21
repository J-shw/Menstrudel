import 'package:menstrudel/models/birth_control/reversible_contraceptives/reversible_contraceptive_types_enum.dart';

class ReversibleContraceptiveLogEntry {
  int? id;
  final DateTime date;
  final ReversibleContraceptiveTypes type;
  final String? note;

  ReversibleContraceptiveLogEntry({
    this.id,
    required this.date,
    required this.type,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type.name,
      'note': note,
    };
  }

  ReversibleContraceptiveLogEntry copyWith({
		int? id,
		DateTime? date,
    ReversibleContraceptiveTypes? type,
    String? note,
	}) {
		return ReversibleContraceptiveLogEntry(
			id: id ?? this.id,
			date: date ?? this.date,
      type: type ?? this.type,
      note: note ?? this.note,
		);
	}

  static ReversibleContraceptiveLogEntry fromMap(Map<String, dynamic> map) {
    return ReversibleContraceptiveLogEntry(
      id: map['id'] as int,
      date: DateTime.parse(map['date'] as String),
      type: ReversibleContraceptiveTypes.values.firstWhere((e) => e.name == map['type']),
      note: map['note'],
    );
  }
}