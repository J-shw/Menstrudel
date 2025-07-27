class CycleStats {
  final int averageCycleLength;
  final int? shortestCycleLength;
  final int? longestCycleLength;
  final int numberOfCycles;

  CycleStats({
    required this.averageCycleLength,
    this.shortestCycleLength,
    this.longestCycleLength,
    required this.numberOfCycles,
  });

  @override
  String toString() {
    return 'CycleStats(Avg: $averageCycleLength, Shortest: $shortestCycleLength, Longest: $longestCycleLength, Cycles: $numberOfCycles)';
  }
}