enum ContextType {
  logPeriodRequest,
  circleDataUpdate,
  unknown,
}

class AppContext {
  final int timestamp;

  final ContextType type;

  final Map<String, dynamic> data;

  AppContext({
    required this.timestamp,
    required this.type,
    this.data = const {},
  });

  factory AppContext.fromJson(Map<String, dynamic> json) {
    final type = ContextType.values.firstWhere(
      (e) => e.toString() == json['type'],
      orElse: () => ContextType.unknown,
    );

    return AppContext(
      timestamp: json['timestamp'] ?? 0,
      type: type,
      data: Map<String, dynamic>.from(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'type': type.toString(),
      'data': data,
    };
  }
}