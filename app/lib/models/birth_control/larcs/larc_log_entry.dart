import 'package:menstrudel/models/birth_control/larcs/larc_types_enum.dart';

class LarcLogEntry {
  int? id;
  final DateTime date;
  final LarcTypes type;
  final String? note;

  LarcLogEntry({
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

  static LarcLogEntry fromMap(Map<String, dynamic> map) {
    return LarcLogEntry(
      id: map['id'] as int,
      date: DateTime.parse(map['date'] as String),
      type: LarcTypes.values.firstWhere((e) => e.name == map['type']),
      note: map['note'],
    );
  }
}