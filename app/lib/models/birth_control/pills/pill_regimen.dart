class PillRegimen {
  final int? id;
  final String name;
  final int activePills;
  final int placeboPills;
  final DateTime startDate;
  final bool isActive;

  PillRegimen({
    this.id,
    required this.name,
    required this.activePills,
    required this.placeboPills,
    required this.startDate,
    required this.isActive,
  });

  PillRegimen copyWith({
    int? id,
    String? name,
    int? activePills,
    int? placeboPills,
    DateTime? startDate,
    bool? isActive,
  }) {
    return PillRegimen(
      id: id ?? this.id,
      name: name ?? this.name,
      activePills: activePills ?? this.activePills,
      placeboPills: placeboPills ?? this.placeboPills,
      startDate: startDate ?? this.startDate,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'active_pills': activePills,
      'placebo_pills': placeboPills,
      'start_date': startDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory PillRegimen.fromMap(Map<String, dynamic> map) {
    return PillRegimen(
      id: map['id'],
      name: map['name'],
      activePills: map['active_pills'],
      placeboPills: map['placebo_pills'],
      startDate: DateTime.parse(map['start_date']),
      isActive: map['is_active'] == 1,
    );
  }
}