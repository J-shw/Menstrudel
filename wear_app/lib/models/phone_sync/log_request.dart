class LogRequest {
  final int timestamp;

  LogRequest({required this.timestamp});

  factory LogRequest.fromJson(Map<String, dynamic> json) {
    return LogRequest(timestamp: json['timestamp'] as int? ?? 0);
  }

  Map<String, dynamic> toJson() => {'timestamp': timestamp};

  @override
  String toString() {
    return 'LogRequest(timestamp: $timestamp)';
  }
}