class CircleData {
  final int currentValue;
  final int maxValue;

  CircleData({this.currentValue = 0, this.maxValue = 28});

  factory CircleData.fromJson(Map<String, dynamic> json) {
    return CircleData(
      currentValue: json['currentValue'] as int? ?? 0,
      maxValue: json['maxValue'] as int? ?? 28,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentValue': currentValue,
    'maxValue': maxValue,
  };

  @override
  String toString() {
    return 'CircleData(currentValue: $currentValue, maxValue: $maxValue)';
  }
}