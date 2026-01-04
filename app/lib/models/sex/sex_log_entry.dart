
import 'package:menstrudel/models/sex/sex_participation_type_enum.dart';
import 'package:menstrudel/models/sex/sex_protection_type_enum.dart';
import 'package:menstrudel/models/sex/sex_type_enum.dart';

class SexLogEntry {
  int? id;
  final DateTime date;
  final SexTypes sexType;
  final SexParticipationTypes participationType;
  final SexProtectionTypes protectionType;
  final bool protectionUsed;
  final String? note;

  SexLogEntry({
    this.id,
    required this.date,
    required this.sexType,
    required this.participationType,
    required this.protectionType,
    required this.protectionUsed,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'sexType': sexType.dbName,
      'participationType': participationType.dbName,
      'protectionType': protectionType.dbName,
      'protectionUsed': protectionUsed ? 1 : 0,
      'note': note,
    };
  }

  SexLogEntry copyWith({
		int? id,
		DateTime? date,
    SexTypes? sexType,
    SexParticipationTypes? participationType,
    SexProtectionTypes? protectionType,
    bool? protectionUsed,
    String? note,
	}) {
		return SexLogEntry(
			id: id ?? this.id,
			date: date ?? this.date,
      sexType: sexType ?? this.sexType,
      participationType: participationType ?? this.participationType,
      protectionType: protectionType ?? this.protectionType,
      protectionUsed: protectionUsed ?? this.protectionUsed,
      note: note ?? this.note,
		);
	}

  static SexLogEntry fromMap(Map<String, dynamic> map) {
    return SexLogEntry(
      id: map['id'] as int,
      date: DateTime.parse(map['date'] as String),
      sexType: SexTypes.fromDbName(map['sexType'] as String),
      participationType: SexParticipationTypes.fromDbName(map['participationType'] as String),
      protectionType: SexProtectionTypes.fromDbName(map['protectionType'] as String),
      protectionUsed: (map['protectionUsed'] as int) == 1,
      note: map['note'],
    );
  }
}