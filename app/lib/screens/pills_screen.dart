import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';
import 'package:menstrudel/services/notification_service.dart';

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
  int _selectedPillNumber = 0;

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

      final now = DateTime.now();
      final totalCycleLength = regimen.activePills + regimen.placeboPills;

      int currentPillNumber;
      if (regimen.startDate.isAfter(now)) {
        currentPillNumber = 0; 
      } else {
        final cycleDayIndex = now.difference(regimen.startDate).inDays; 
        currentPillNumber = (cycleDayIndex % totalCycleLength) + 1;
      }
      if (mounted) {
        setState(() {
          _activeRegimen = regimen;
          _intakes = intakes;
          _currentPillNumberInCycle = currentPillNumber;
          _selectedPillNumber = currentPillNumber;
        });
      }
    }
    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  void _selectPillNumber(int dayNumber) {
    setState(() {
      _selectedPillNumber = dayNumber;
    });
  }

  Future<void> _takePill() async {
    if (_activeRegimen == null) return;

    final pillNumberToLog = _selectedPillNumber; 

    final cycleDayOffset = (pillNumberToLog - 1);
    final scheduledDate = _activeRegimen!.startDate.add(Duration(days: cycleDayOffset));

    final newIntake = PillIntake(
      regimenId: _activeRegimen!.id!,
      takenAt: DateTime.now(),
      scheduledDate: scheduledDate,
      status: PillIntakeStatus.taken,
      pillNumberInCycle: pillNumberToLog,
    );

    await pillsRepo.createOrUpdatePillIntake(newIntake);

    if (pillNumberToLog == _currentPillNumberInCycle) {
      await NotificationService.cancelPillReminder();
    }

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

    final pillNumberToLog = _selectedPillNumber;

    final cycleDayOffset = (pillNumberToLog - 1);
    final scheduledDate = _activeRegimen!.startDate.add(Duration(days: cycleDayOffset));


    final newIntake = PillIntake(
      regimenId: _activeRegimen!.id!,
      takenAt: DateTime.now(),
      scheduledDate: scheduledDate,
      status: PillIntakeStatus.skipped,
      pillNumberInCycle: pillNumberToLog,
    );

    await pillsRepo.createOrUpdatePillIntake(newIntake);

    if (pillNumberToLog == _currentPillNumberInCycle) {
      await NotificationService.cancelPillReminder();
    }

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      
      SnackBar(
        content: Text(l10n.pillScreen_pillForTodayMarkedAsSkipped),
      ),
    );
    
    _loadPillData();
  }

  Future<void> _undoPillIntake(int selectedPillNumber) async {
    if (_activeRegimen == null) return;

    final activeRegimenId = _activeRegimen!.id!;

    await pillsRepo.deletePillIntakeByDay(activeRegimenId, selectedPillNumber);

    final pillReminder = await pillsRepo.readReminderForRegimen(_activeRegimen!.id!);
    bool pillNotificationsEnabled = false;
    TimeOfDay pillNotificationTime = const TimeOfDay(hour: 9, minute: 0);
    
    if (pillReminder != null) {
      pillNotificationsEnabled = pillReminder.isEnabled;
      final timeParts = pillReminder.reminderTime.split(':');
      pillNotificationTime = TimeOfDay(
        hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]))
      ;
    }
    if(mounted){
      final l10n = AppLocalizations.of(context)!;
      await NotificationService.schedulePillReminder(
        reminderTime: pillNotificationTime,
        isEnabled: pillNotificationsEnabled,
        title: l10n.notification_pillTitle,
        body: l10n.notification_pillBody,
      );
    }
    _loadPillData();
  }
  
  bool get _isSelectedPillTaken {
    if (_selectedPillNumber == 0) return false;
    return _intakes.any((intake) =>
        intake.pillNumberInCycle == _selectedPillNumber);
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
              currentPillNumberInCycle: _selectedPillNumber,
              totalPills: _activeRegimen!.activePills + _activeRegimen!.placeboPills,
              isSelectedPillTaken: _isSelectedPillTaken,
              packStartDate: _activeRegimen!.startDate,
              onTakePill: _takePill,
              onSkipPill: _skipPill,
              undoTakePill: () => _undoPillIntake(_selectedPillNumber),
            ),
            const SizedBox(height: 24),
            PillPackVisualiser(
              activeRegimen: _activeRegimen!,
              intakes: _intakes,
              currentPillNumberInCycle: _currentPillNumberInCycle,
              selectedPillNumber: _selectedPillNumber,
              onPillTapped: _selectPillNumber,
            ),
          ],
        ),
      ),
    );
  }
}