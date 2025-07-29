class PeriodStats {
  final int averageLength;
  final int? shortestLength;
  final int? longestLength;
  final int numberofPeriods;

  PeriodStats({
    required this.averageLength,
    this.shortestLength,
    this.longestLength,
    required this.numberofPeriods,
  });
}