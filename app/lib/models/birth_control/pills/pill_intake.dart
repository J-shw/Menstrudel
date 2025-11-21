import 'package:menstrudel/models/birth_control/pills/pill_status_enum.dart';

class PillIntake {
  final int? id;
  final int regimenId;
  final DateTime takenAt;
  final DateTime scheduledDate;
  final PillIntakeStatus status;
  final int pillNumberInCycle;

  PillIntake({
    this.id,
    required this.regimenId,
    required this.takenAt,
    required this.scheduledDate,
    required this.status,
    required this.pillNumberInCycle,
  });

  PillIntake copyWith({int? id}) {
    return PillIntake(
      id: id ?? this.id,
      regimenId: regimenId,
      takenAt: takenAt,
      scheduledDate: scheduledDate,
      status: status,
      pillNumberInCycle: pillNumberInCycle,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regimen_id': regimenId,
      'taken_at': takenAt.toIso8601String(),
      'scheduled_date': scheduledDate.toIso8601String(),
      'status': status.name,
      'pill_number_in_cycle': pillNumberInCycle,
    };
  }

  factory PillIntake.fromMap(Map<String, dynamic> map) {
    return PillIntake(
      id: map['id'],
      regimenId: map['regimen_id'],
      takenAt: DateTime.parse(map['taken_at']),
      scheduledDate: DateTime.parse(map['scheduled_date']),
      status: PillIntakeStatus.values.byName(map['status']),
      pillNumberInCycle: map['pill_number_in_cycle'],
    );
  }
}