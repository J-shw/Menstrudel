import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';

class SanitaryProductsEntry {
  int? id;
  final DateTime date;
  final SanitaryProducts type;
  final String? note;

  SanitaryProductsEntry({
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

  SanitaryProductsEntry copyWith({
		int? id,
		DateTime? date,
    SanitaryProducts? type,
    String? note,
	}) {
		return SanitaryProductsEntry(
			id: id ?? this.id,
			date: date ?? this.date,
      type: type ?? this.type,
      note: note ?? this.note,
		);
	}

  static SanitaryProductsEntry fromMap(Map<String, dynamic> map) {
    return SanitaryProductsEntry(
      id: map['id'] as int,
      date: DateTime.parse(map['date'] as String),
      type: SanitaryProducts.values.firstWhere((e) => e.name == map['type']),
      note: map['note'],
    );
  }
}