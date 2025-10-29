import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/widgets/settings/regimen_setup_dialog.dart';
import 'package:menstrudel/services/settings_service.dart';

class BirthControlSettingsScreen extends StatefulWidget {
  const BirthControlSettingsScreen({super.key});

  @override
  State<BirthControlSettingsScreen> createState() =>
      _BirthControlSettingsScreenState();
}

class _BirthControlSettingsScreenState extends State<BirthControlSettingsScreen> {
  final pillsRepo = PillsRepository();
  final SettingsService _settingsService = SettingsService();
  bool _isLoading = true;

  List<PillRegimen> _allRegimens = []; 
  PillRegimen? _activeRegimen;
  bool _pillNotificationsEnabled = false;
  bool _pillNavEnabled = false;
  TimeOfDay _pillNotificationTime = const TimeOfDay(hour: 21, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final allRegimens = await pillsRepo.readAllPillRegimens();
    final activeRegimen = await pillsRepo.readActivePillRegimen();
    bool pillNavEnabled = await _settingsService.isPillNavEnabled();
    PillReminder? pillReminder;
    bool pillNotificationsEnabled = false;
    TimeOfDay pillNotificationTime = const TimeOfDay(hour: 21, minute: 0);

    if (activeRegimen != null) {
      pillReminder = await pillsRepo.readReminderForRegimen(activeRegimen.id!);
      if (pillReminder != null) {
        pillNotificationsEnabled = pillReminder.isEnabled;
        final timeParts = pillReminder.reminderTime.split(':');
        pillNotificationTime = TimeOfDay(
            hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      }
    }

    if (mounted) {
      setState(() {
        _allRegimens = allRegimens;
        _activeRegimen = activeRegimen;
        _pillNotificationsEnabled = pillNotificationsEnabled;
        _pillNavEnabled = pillNavEnabled;
        _pillNotificationTime = pillNotificationTime;
        _isLoading = false;
      });
    }
  }

  Future<void> savePillReminderSettings() async {
    if (_activeRegimen == null) return;

    final reminder = PillReminder(
      regimenId: _activeRegimen!.id!,
      reminderTime:
          '${_pillNotificationTime.hour}:${_pillNotificationTime.minute}',
      isEnabled: _pillNotificationsEnabled,
    );
    final l10n = AppLocalizations.of(context)!;

    await pillsRepo.savePillReminder(reminder);

    await NotificationService.schedulePillReminder(
      reminderTime: _pillNotificationTime,
      isEnabled: _pillNotificationsEnabled,
      title: l10n.notification_pillTitle,
      body: l10n.notification_pillBody,
    );

    _loadSettings();
  }

  Future<void> selectPillReminderTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _pillNotificationTime,
    );

    if (pickedTime != null && pickedTime != _pillNotificationTime) {
      setState(() {
        _pillNotificationTime = pickedTime;
      });
      await savePillReminderSettings();
    }
  }

  Future<void> showRegimenSetupDialog() async {
    final result = await showDialog<PillRegimen>(
      context: context,
      builder: (BuildContext context) {
        return const RegimenSetupDialog();
      },
    );

    if (result != null && mounted) {
      await pillsRepo.createPillRegimen(result);
      await NotificationService.cancelPillReminder();
      _loadSettings();
    }
  }

  Future<void> showDeleteRegimenDialog(PillRegimen regimenToDelete) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_deleteRegimen_question,
          contentText: l10n.settingsScreen_deleteRegimenDescription,
          confirmButtonText: l10n.delete,
          onConfirm: () async {
            await pillsRepo.deletePillRegimen(regimenToDelete.id!);
            
            if (regimenToDelete.id == _activeRegimen?.id) {
              await NotificationService.cancelPillReminder();
            }
            _loadSettings();
          },
        );
      },
    );
  }

  Future<void> _setActiveRegimen(PillRegimen regimen) async {
    await pillsRepo.setActiveRegimen(regimen.id!);
    await NotificationService.cancelPillReminder();
    await _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool showReminderSettings = _activeRegimen != null && !_isLoading; 

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_birthControl),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  title: Text(l10n.settingsScreen_enablePillTracking),
                  value: _pillNavEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _pillNavEnabled = value;
                    });
                    _settingsService.setPillNavEnabled(value);
                  },
                ),
                const Divider(),
                if (_pillNavEnabled) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      l10n.settingsScreen_pillRegimens,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  ..._allRegimens.map((regimen) {
                    final bool isActive = regimen.id == _activeRegimen?.id;
                    final l10n = AppLocalizations.of(context)!;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            
                            leading: Icon(
                              isActive ? Icons.check_circle : Icons.circle_outlined,
                              color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
                              size: 28,
                            ),
                            title: Text(
                              regimen.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                                '${regimen.activePills}/${regimen.placeboPills} ${l10n.settingsScreen_pack} | ${regimen.startDate.day}/${regimen.startDate.month}/${regimen.startDate.year}'),
                            
                            trailing: isActive 
                                ? null
                                : Row(
                                    mainAxisSize: MainAxisSize.min, 
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                                        ),
                                        onPressed: () => _setActiveRegimen(regimen),
                                        child: Text(l10n.settingsScreen_makeActive),
                                      ),
                                      
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                                        onPressed: () => showDeleteRegimenDialog(regimen),
                                        tooltip: l10n.delete,
                                      ),
                                    ],
                                  )
                          ),
                        ],
                      ),
                    );
                  }),

                  ListTile(
                    title: Text(l10n.settingsScreen_setUpPillRegimen),
                    trailing: const Icon(Icons.add_circle, size: 30),
                    onTap: showRegimenSetupDialog,
                  ),

                  const Divider(),
                  
                  if (showReminderSettings) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        l10n.settingsScreen_activeRegimenReminder,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SwitchListTile(
                      title: Text(l10n.settingsScreen_dailyPillReminder),
                      value: _pillNotificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _pillNotificationsEnabled = value;
                        });
                        savePillReminderSettings();
                      },
                    ),
                    if (_pillNotificationsEnabled)
                      ListTile(
                        title: Text(l10n.settingsScreen_reminderTime),
                        trailing: Text(
                          _pillNotificationTime.format(context),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onTap: selectPillReminderTime,
                      ),
                  ],
                ],
              ],
            ),
    );
  }
}
