import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';

import 'package:menstrudel/widgets/pills/empty_pills_state.dart';
import 'package:menstrudel/widgets/pills/pill_pack_visualiser.dart';
import 'package:menstrudel/widgets/pills/pill_status_card.dart';
import 'package:menstrudel/models/pills/pill_status_enum.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class PillsScreen extends StatefulWidget {
  const PillsScreen({super.key});

  @override
  State<PillsScreen> createState() => _PillsScreenState();
}

class _PillsScreenState extends State<PillsScreen> {
  final pillsRepo = PillsRepository();

  bool _isLoading = true;
  PillRegimen? _activeRegimen;
  List<PillIntake> _intakes = [];
  int _currentPillNumberInCycle = 0;

  @override
  void initState() {
    super.initState();
    _loadPillData();
  }

  Future<void> _loadPillData() async {
    setState(() { _isLoading = true; });
    final regimen = await pillsRepo.readActivePillRegimen();
    if (regimen != null) {
      final intakes = await pillsRepo.readIntakesForRegimen(regimen.id!);
      final cycleDay = DateTime.now().difference(regimen.startDate).inDays;
      final totalCycleLength = regimen.activePills + regimen.placeboPills;
      if (mounted) {
        setState(() {
          _activeRegimen = regimen;
          _intakes = intakes;
          _currentPillNumberInCycle = (cycleDay % totalCycleLength) + 1;
        });
      }
    }
    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _takePill() async {
    if (_activeRegimen == null) return;

    final newIntake = PillIntake(
      regimenId: _activeRegimen!.id!,
      takenAt: DateTime.now(),
      scheduledDate: DateTime.now(),
      status: PillIntakeStatus.taken,
      pillNumberInCycle: _currentPillNumberInCycle,
    );

    await pillsRepo.createPillIntake(newIntake);

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.pillScreen_pillForTodayMarkedAsTaken),
        backgroundColor: Colors.green,
      ),
    );
    
    _loadPillData();
  }

  Future<void> _skipPill() async {
    if (_activeRegimen == null) return;
    final newIntake = PillIntake(
      regimenId: _activeRegimen!.id!,
      takenAt: DateTime.now(),
      scheduledDate: DateTime.now(),
      status: PillIntakeStatus.skipped,
      pillNumberInCycle: _currentPillNumberInCycle,
    );

    await pillsRepo.createPillIntake(newIntake);

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      
      SnackBar(
        content: Text(l10n.pillScreen_pillForTodayMarkedAsSkipped),
        backgroundColor: Colors.green,
      ),
    );
    
    _loadPillData();
  }

  Future<void> _undoTakePill() async {
    if (_activeRegimen == null) return;
    await pillsRepo.undoLastPillIntake(_activeRegimen!.id!);
    _loadPillData();
  }
  
  bool get _isTodayPillTaken {
    return _intakes.any((intake) =>
        intake.pillNumberInCycle == _currentPillNumberInCycle &&
        DateUtils.isSameDay(intake.takenAt, DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return  _buildBody();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_activeRegimen == null) {
      return const EmptyPillsState();
    }
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PillStatusCard(
              currentPillNumberInCycle: _currentPillNumberInCycle,
              totalPills: _activeRegimen!.activePills + _activeRegimen!.placeboPills,
              isTodayPillTaken: _isTodayPillTaken,
              onTakePill: _takePill,
              onSkipPill: _skipPill,
              undoTakePill: _undoTakePill,
            ),
            const SizedBox(height: 24),
            PillPackVisualiser(
              activeRegimen: _activeRegimen!,
              intakes: _intakes,
              currentPillNumberInCycle: _currentPillNumberInCycle,
            ),
          ],
        ),
      ),
    );
  }
}