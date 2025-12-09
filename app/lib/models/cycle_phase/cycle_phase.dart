import 'package:menstrudel/models/cycle_phase/cycle_phase_enum.dart';

class CyclePhaseResult {
  final CyclePhase phase;
  final int daysInPhase;
  final int daysRemainingInPhase;

  CyclePhaseResult({
    required this.phase,
    required this.daysInPhase,
    required this.daysRemainingInPhase,
  });
}