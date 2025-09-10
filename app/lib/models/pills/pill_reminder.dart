class PillReminder {
  final int? id;
  final int regimenId;
  final String reminderTime;
  final bool isEnabled;

  PillReminder({
    this.id,
    required this.regimenId,
    required this.reminderTime,
    required this.isEnabled,
  });

  PillReminder copyWith({
    int? id,
    int? regimenId,
    String? reminderTime,
    bool? isEnabled,
  }) {
    return PillReminder(
      id: id ?? this.id,
      regimenId: regimenId ?? this.regimenId,
      reminderTime: reminderTime ?? this.reminderTime,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regimen_id': regimenId,
      'reminder_time': reminderTime,
      'is_enabled': isEnabled ? 1 : 0,
    };
  }

  factory PillReminder.fromMap(Map<String, dynamic> map) {
    return PillReminder(
      id: map['id'],
      regimenId: map['regimen_id'],
      reminderTime: map['reminder_time'],
      isEnabled: map['is_enabled'] == 1,
    );
  }
}