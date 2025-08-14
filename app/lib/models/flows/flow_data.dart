enum FlowLevel {  
  light, 
  medium, 
  heavy 
}

class DailyFlowData {
  final int day;
  final FlowLevel flow;

  DailyFlowData({
    required this.day,
    required this.flow,
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