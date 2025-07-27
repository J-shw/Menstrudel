class MonthlyCycleData {
  final int year;
  final int month;
  final int cycleLength;

  MonthlyCycleData({
    required this.year,
    required this.month,
    required this.cycleLength,
  });

  @override
  String toString() {
    return 'MonthlyCycleData(Year: $year, Month: $month, CycleLength: $cycleLength days)';
  }
}