
import 'package:menstrudel/models/sex/sex_participation_type_enum.dart';
import 'package:menstrudel/models/sex/sex_protection_type_enum.dart';
import 'package:menstrudel/models/sex/sex_type_enum.dart';

class SexLogEntry {
  int? id;
  final DateTime dateTime;
  final SexTypes? sexType;
  final SexParticipationTypes? participationType;
  final SexProtectionTypes? protectionType;
  final bool? protectionUsed;
  final String? note;

  SexLogEntry({
    this.id,
    required this.dateTime,
    this.sexType,
    this.participationType,
    this.protectionType,
    this.protectionUsed,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time': dateTime.toIso8601String(),
      'sex_type': sexType?.dbName,
      'participation_type': participationType?.dbName,
      'protection_type': protectionType?.dbName,
      'protection_used': protectionUsed == null ? null : (protectionUsed! ? 1 : 0),
      'note': note,
    };
  }

  SexLogEntry copyWith({
		int? id,
		DateTime? dateTime,
    SexTypes? sexType,
    SexParticipationTypes? participationType,
    SexProtectionTypes? protectionType,
    bool? protectionUsed,
    String? note,
	}) {
		return SexLogEntry(
			id: id ?? this.id,
			dateTime: dateTime ?? this.dateTime,
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
      dateTime: DateTime.parse(map['date_time'] as String),
      sexType: map['sex_type'] != null ? SexTypes.fromDbName(map['sex_type']) : null,
      participationType: map['participation_type'] != null ? SexParticipationTypes.fromDbName(map['participation_type'] as String) : null,
      protectionType: map['protection_type'] != null ? SexProtectionTypes.fromDbName(map['protection_type'] as String) : null,
      protectionUsed: map['protection_used'] != null ? (map['protection_used'] as int) == 1 : null,
      note: map['note'],
    );
  }
}