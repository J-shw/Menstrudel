import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/birth_control/reversible_contraceptives/reversible_contraceptive_types_enum.dart';
import 'package:menstrudel/models/birth_control/pills/pill_regimen.dart';
import 'package:menstrudel/models/birth_control/pills/pill_reminder.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/widgets/dialogs/reversible_contraceptive_duration_config_dialog.dart';
import 'package:menstrudel/widgets/settings/regimen_setup_dialog.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:provider/provider.dart';

class BirthControlSettingsScreen extends StatefulWidget {
  const BirthControlSettingsScreen({super.key});

  @override
  State<BirthControlSettingsScreen> createState() =>
      _BirthControlSettingsScreenState();
}

class _BirthControlSettingsScreenState extends State<BirthControlSettingsScreen> {
  final pillsRepo = PillsRepository();
  bool _isLoading = true;

  List<PillRegimen> _allRegimens = []; 
  PillRegimen? _activeRegimen;
  bool _pillNotificationsEnabled = false;
  TimeOfDay _pillNotificationTime = const TimeOfDay(hour: 21, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final allRegimens = await pillsRepo.readAllPillRegimens();
    final activeRegimen = await pillsRepo.readActivePillRegimen();
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

    if(_pillNotificationsEnabled) {
      await NotificationService.schedulePillReminder(
        reminderTime: _pillNotificationTime,
        isEnabled: _pillNotificationsEnabled,
        title: l10n.notification_pillTitle,
        body: l10n.notification_pillBody,
      );
    }else{
      await NotificationService.cancelPillReminder();
    }
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

  Future<void> _selectReversibleContraceptiveReminderTime() async {
    final settingsService = context.read<SettingsService>();
    final TimeOfDay initialTime = settingsService.reversibleContraceptiveReminderTime; 

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null && pickedTime != initialTime) {
      await settingsService.setReversibleContraceptiveReminderTime(pickedTime); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.watch<SettingsService>();
    final bool pillEnabled = settingsService.isPillNavEnabled;
    final bool reversibleContraceptiveEnabled = settingsService.isReversibleContraceptiveNavEnabled;
    final bool showReminderSettings = _activeRegimen != null && !_isLoading; 
    final ReversibleContraceptiveTypes activeReversibleContraceptiveType = settingsService.reversibleContraceptiveType;

    const Widget shortDivider = Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Divider());

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
                  subtitle: Text(l10n.settingsScreen_pillDescription),
                  value: pillEnabled,
                  onChanged: (bool value) {
                    context.read<SettingsService>().setPillNavEnabled(value);
                  },
                ),
                if (pillEnabled) ...[
                  shortDivider,
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
                  
                  if (showReminderSettings) ...[
                    shortDivider,
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

                const Divider(),
                
                SwitchListTile(
                  title: Text(l10n.settingsScreen_enableReversibleContraceptiveTracking),
                  subtitle: Text(l10n.settingsScreen_reversibleContraceptiveDescription),
                  value: reversibleContraceptiveEnabled,
                  onChanged: (bool value) {
                    context.read<SettingsService>().setReversibleContraceptiveNavEnabled(value);
                  },
                ),
                if (reversibleContraceptiveEnabled) ...[
                  shortDivider,
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: Text(l10n.settingsScreen_reversibleContraceptiveType),
                    trailing: DropdownButton<ReversibleContraceptiveTypes>(
                      value: settingsService.reversibleContraceptiveType,
                      items: ReversibleContraceptiveTypes.values.map((type) {
                        return DropdownMenuItem<ReversibleContraceptiveTypes>(
                          value: type,
                          child: Text(type.getDisplayName(l10n)),
                        );
                      }).toList(),
                      onChanged: (ReversibleContraceptiveTypes? selectedType) {
                        if (selectedType != null) {
                          context.read<SettingsService>().setReversibleContraceptiveType(selectedType);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.date_range_outlined),
                    title: Text(l10n.settingsScreen_reversibleContraceptiveDuration),
                    subtitle: Text('${l10n.settingsScreen_currentDuration}: ${settingsService.getReversibleContraceptiveDurationDays(activeReversibleContraceptiveType)} ${l10n.days}'),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () async {
                      final result = await showDialog<int>(
                        context: context,
                        builder: (ctx) => ReversableContraceptiveDurationConfigDialog(contraceptiveType: activeReversibleContraceptiveType),
                      );

                      if (result != null && context.mounted) {
                        await context.read<SettingsService>().setReversibleContraceptiveDurationForType(activeReversibleContraceptiveType, result);
                      }
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.settingsScreen_enableReversibleContraceptiveReminder),
                    value: settingsService.reversibleContraceptiveNotificationsEnabled,
                    onChanged: (bool value) {
                      context.read<SettingsService>().setReversibleContraceptiveNotificationsEnabled(value);
                    },
                  ),
                  if (settingsService.reversibleContraceptiveNotificationsEnabled) ...[
                    ListTile(
                      title: Text(l10n.settingsScreen_remindMeBefore),
                      trailing: DropdownButton<int>(
                        value: settingsService.reversibleContraceptiveReminderDays,
                        items: [1, 7, 14, 30].map((int days) {
                          return DropdownMenuItem<int>(
                            value: days,
                            child: Text(l10n.dayCount(days)),
                          );
                        }).toList(),
                        onChanged: (int? newDays) {
                          if (newDays != null) {
                            context.read<SettingsService>().setReversibleContraceptiveReminderDays(newDays);
                          }
                        },
                      ),
                    ),
                    
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(l10n.settingsScreen_reminderTime),
                      trailing: Text(
                        settingsService.reversibleContraceptiveReminderTime.format(context),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onTap: _selectReversibleContraceptiveReminderTime,
                    ),
                  ],
                ]
              ],
            ),
    );
  }
}
