import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/models/period_logs/symptom_enum.dart';
import 'package:menstrudel/models/period_logs/pain_level_enum.dart';
import 'package:menstrudel/widgets/dialogs/custom_symptom_dialog.dart';

class SymptomEntrySheet extends StatefulWidget {
  const SymptomEntrySheet({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  State<SymptomEntrySheet> createState() => _SymptomEntrySheetState();
}

class _SymptomEntrySheetState extends State<SymptomEntrySheet> {
  late DateTime _selectedDate;

  final Set<String> _defaultSymptoms = {};
  final Set<String> _selectedSymptoms = {};
  final Set<String> _symptoms = {};

  FlowRate _flowSelection = FlowRate.none;
  PainLevel _painLevel = PainLevel.none;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;

    _defaultSymptoms.addAll(defaultSymptoms());
    _symptoms.addAll(_defaultSymptoms);
    _symptoms.add("+");
  }

  Set<String> defaultSymptoms() {
    return {
      "Headache",
      "Fatigue",
      "Cramps",
      "Nausea",
      "Mood Swings",
      "Bloating",
      "Acne",
      "Back pain",
    };
  }

  Future<void> showAdditionalSymptomDialog() async {
    final (String name, bool isDefault)? result =
        await showDialog<(String, bool)>(
          context: context,
          builder: (BuildContext context) {
            return const CustomSymptomDialog();
          },
        );

    if (result != null && mounted) {
      setState(() {
        var customSymptomName = result.$1;

        if (_symptoms.contains(customSymptomName)) {
          return;
        }

        _symptoms.remove("+");
        _symptoms.add(customSymptomName);
        _symptoms.add("+");

        _selectedSymptoms.add(customSymptomName);

        if (result.$2) {
          _defaultSymptoms.add(customSymptomName);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Drag Handle ---
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // --- Title ---
            Center(
              child: Text(
                l10n.symptomEntrySheet_logYourDay,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // --- Date Picker ---
            const SizedBox(height: 24),
            Text(l10n.date, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(
                DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                alignment: Alignment.centerLeft,
              ),
              onPressed: _pickDate,
            ),
            const SizedBox(height: 8),
            // --- Flow Selection ---
            Text(l10n.flow, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: FlowRate.periodFlows.map((flow) {
                return ChoiceChip(
                  label: Text(flow.getDisplayName(l10n)),
                  selected: _flowSelection == flow,
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        _flowSelection = flow;
                      } else {
                        _flowSelection = FlowRate.none;
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // --- Pain Level ---
            Text(
              '${l10n.painLevel_title}: ${_painLevel.getDisplayName(l10n)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: PainLevel.values.map((painLevel) {
                    final bool isSelected = _painLevel == painLevel;

                    return IconButton(
                      icon: Icon(painLevel.icon),
                      iconSize: 36,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      onPressed: () {
                        setState(() {
                          _painLevel = painLevel;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // --- Symptoms ---
            Text(
              l10n.symptomEntrySheet_symptomsOptional,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _symptoms.map((symptom) {
                var isAdd = symptom == "+";
                return FilterChip(
                  label: Text(symptom),
                  selected: _selectedSymptoms.contains(symptom),
                  onSelected: (bool selected) {
                    setState(() {
                      if (isAdd) {
                        showAdditionalSymptomDialog();
                      } else {
                        if (selected) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                          if (_defaultSymptoms.contains(symptom) == false) {
                            _symptoms.remove(symptom);
                          }
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // --- Action Buttons ---
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop({
                        'date': _selectedDate,
                        'flow': _flowSelection,
                        'symptoms': _selectedSymptoms,
                        'painLevel': _painLevel.intValue,
                      });
                    },
                    child: Text(l10n.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
