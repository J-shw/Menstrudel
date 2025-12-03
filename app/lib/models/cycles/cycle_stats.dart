class CycleStats {
  final int averageCycleLength;
  final int? shortestCycleLength;
  final int? longestCycleLength;
  final int numberOfCycles;
  final List<int> cycleLengths;

  CycleStats({
    required this.averageCycleLength,
    this.shortestCycleLength,
    this.longestCycleLength,
    required this.numberOfCycles,
    required this.cycleLengths,
  });
}