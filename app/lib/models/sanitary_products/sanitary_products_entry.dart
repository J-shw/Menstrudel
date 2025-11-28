import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';

class SanitaryProductsEntry {
  int? id;
  final DateTime logTime;
  final DateTime reminderTime;
  final SanitaryProducts type;
  final String? note;

  SanitaryProductsEntry({
    this.id,
    required this.logTime,
    required this.reminderTime,
    required this.type,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logTime': logTime.toIso8601String(),
      'reminderTime': reminderTime.toIso8601String(),
      'type': type.name,
      'note': note,
    };
  }

  SanitaryProductsEntry copyWith({
		int? id,
		DateTime? logTime,
    DateTime? reminderTime,
    SanitaryProducts? type,
    String? note,
	}) {
		return SanitaryProductsEntry(
			id: id ?? this.id,
			logTime: logTime ?? this.logTime,
      reminderTime: reminderTime ?? this.reminderTime,
      type: type ?? this.type,
      note: note ?? this.note,
		);
	}

  static SanitaryProductsEntry fromMap(Map<String, dynamic> map) {
    return SanitaryProductsEntry(
      id: map['id'] as int,
      logTime: DateTime.parse(map['logTime'] as String),
      reminderTime: DateTime.parse(map['reminderTime'] as String),
      type: SanitaryProducts.values.firstWhere((e) => e.name == map['type']),
      note: map['note'],
    );
  }
}