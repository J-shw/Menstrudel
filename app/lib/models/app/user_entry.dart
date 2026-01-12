import 'package:menstrudel/models/app/user_goal_types_enum.dart';

class UserEntry {
  final int? id;
  final String name;
  final DateTime? birthDate;
  final UserGoalTypes primaryGoal;

  UserEntry({
    this.id,
    required this.name,
    this.birthDate,
    required this.primaryGoal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate?.toIso8601String(),
      'primary_goal': primaryGoal.dbName,
    };
  }

  UserEntry copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    UserGoalTypes? primaryGoal,
  }) {
    return UserEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      primaryGoal: primaryGoal ?? this.primaryGoal,
    );
  }

  factory UserEntry.fromMap(Map<String, dynamic> map) {
    return UserEntry(
      id: map['id'] as int,
      name: map['name'] as String,
      birthDate: map['birth_date'] != null ? DateTime.parse(map['birth_date'] as String): null,
      primaryGoal: UserGoalTypes.fromDbName(map['primary_goal'] as String),
    );
  }
}