enum FlowLevel {  
  light, 
  medium, 
  heavy 
}

class MonthlyFlowData {
  final String monthLabel;
  final List<int> flows;

  MonthlyFlowData({
    required this.monthLabel,
    required this.flows,
  });
}

FlowLevel flowLevelFromInt(int flowInt) {
  switch (flowInt) {
    case 0:
      return FlowLevel.light;
    case 1:
      return FlowLevel.medium;
    case 2:
      return FlowLevel.heavy;
    default:
      return FlowLevel.light;
  }
}