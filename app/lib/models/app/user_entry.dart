import 'package:menstrudel/models/app/user_goal_types_enum.dart';

class UserEntry {
  static const int singletonId = 1; // There can only ever be 1 user

  final int id;
  /// The user's name.
  final String name;
  /// The user's date of birth.
  final DateTime? birthDate;
  /// The user's primary goal for the app.
  final UserGoalTypes primaryGoal;

  UserEntry({
    this.id = singletonId,
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
    String? name,
    DateTime? birthDate,
    UserGoalTypes? primaryGoal,
  }) {
    return UserEntry(
      id: id,
      name: name ?? this.name,
      birthDate: birthDate,
      primaryGoal: primaryGoal ?? this.primaryGoal,
    );
  }

  factory UserEntry.fromMap(Map<String, dynamic> map) {
    return UserEntry(
      id: map['id'] as int,
      name: map['name'] as String,
      birthDate: map['birth_date'] != null 
          ? DateTime.parse(map['birth_date'] as String) 
          : null,
      primaryGoal: UserGoalTypes.fromDbName(map['primary_goal'] as String),
    );
  }
}