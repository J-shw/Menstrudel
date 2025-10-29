import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/models/period_logs/pain_level_enum.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/period_logs/symptom_type_enum.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/dialogs/custom_symptom_dialog.dart';

class PeriodDetailsBottomSheet extends StatefulWidget {
  final PeriodDay log;
  final VoidCallback onDelete;
  final void Function(PeriodDay) onSave;

  const PeriodDetailsBottomSheet({super.key, required this.log, required this.onDelete, required this.onSave});

  @override
  State<PeriodDetailsBottomSheet> createState() => _PeriodDetailsBottomSheetState();
}

class _PeriodDetailsBottomSheetState extends State<PeriodDetailsBottomSheet> {
  final SettingsService _settingsService = SettingsService();

  bool _isEditing = false;

  late FlowRate _editedFlow;
  late PainLevel _editedPainLevel;

  final Set<Symptom> _defaultSymptoms = {};
  final Set<Symptom> _selectedSymptoms = {};
  final Set<Symptom> _symptoms = {};

  @override
  void initState() {
    super.initState();
    _loadDefaultSymptoms();
    _resetEditableState();
  }

  void _resetEditableState() {
    _editedFlow = widget.log.flow;
    _editedPainLevel = PainLevel.values[widget.log.painLevel];
    _selectedSymptoms.clear();
    _selectedSymptoms.addAll(widget.log.symptoms ?? {});
  }

  void _loadDefaultSymptoms() async {
    var defaultSymptoms = await _settingsService.getDefaultSymptoms();
    setState(() {
      _defaultSymptoms.addAll(defaultSymptoms);
      _symptoms.addAll(_defaultSymptoms);
      _symptoms.addAll(widget.log.symptoms ?? []);
      _symptoms.add(Symptom.addSymptom());
    });
  }

  void _handleSave() {
    final updatedLog = widget.log.copyWith(flow: _editedFlow, painLevel: _editedPainLevel.intValue, symptoms: _selectedSymptoms.toList());

    widget.onSave(updatedLog);

    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _showNewCustomSymptomDialog() async {
    final (String name, bool isDefault)? result = await showDialog<(String, bool)>(
      context: context,
      builder: (BuildContext context) {
        return const CustomSymptomDialog();
      },
    );

    if (mounted && result != null && _symptoms.any((element) => element.customName == result.$1) == false) {
      var symptom = Symptom.fromDbString(result.$1);

      if (result.$2) {
        _defaultSymptoms.add(symptom);
        await _settingsService.addDefaultSymptom(symptom);
      }

      setState(() {
        _symptoms.remove(Symptom.addSymptom());
        _symptoms.add(symptom);
        _symptoms.add(Symptom.addSymptom());

        _selectedSymptoms.add(symptom);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (_isEditing ? 0.6 : 0.4),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildDragHandle(), const SizedBox(height: 12), _buildHeader(context), const Divider(height: 24), _buildFlowSection(context), const SizedBox(height: 16), _buildPainLevelSection(context), const SizedBox(height: 16), _buildSymptomsSection(context)]),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(DateFormat('EEEE, MMMM d').format(widget.log.date), style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        if (_isEditing)
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _resetEditableState();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.check, color: colorScheme.primary),
                onPressed: _handleSave,
              ),
            ],
          )
        else
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 24, color: colorScheme.error),
                onPressed: () {
                  widget.onDelete();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFlowSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isEditing) {
      final flow = widget.log.flow;

      return Row(
        children: [
          Icon(Icons.opacity, color: colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Text('${l10n.periodDetailsSheet_flow}: ', style: textTheme.bodyLarge),
          Text(flow.getDisplayName(l10n), style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          ...List.generate(4, (index) => Icon(flow != FlowRate.none && index < flow.intValue ? Icons.water_drop : Icons.water_drop_outlined, size: 20, color: colorScheme.primary)),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l10n.periodDetailsSheet_flow}:', style: textTheme.bodyLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: FlowRate.periodFlows.map((flow) {
              return ChoiceChip(
                label: Text(flow.getDisplayName(l10n)),
                selected: _editedFlow == flow,
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _editedFlow = flow;
                    } else {
                      _editedFlow = FlowRate.none;
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    }
  }

  Widget _buildPainLevelSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isEditing) {
      final painLevel = PainLevel.values[widget.log.painLevel];

      return Row(
        children: [
          Icon(painLevel.icon, color: colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Text('${l10n.painLevel_title}: ', style: textTheme.bodyLarge),
          Text(painLevel.getDisplayName(l10n), style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l10n.painLevel_title}: ${_editedPainLevel.getDisplayName(l10n)}', style: textTheme.bodyLarge),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: PainLevel.values.map((painLevel) {
              final bool isSelected = _editedPainLevel == painLevel;

              return IconButton(
                icon: Icon(painLevel.icon),
                iconSize: 36,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                onPressed: () {
                  setState(() {
                    _editedPainLevel = painLevel;
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    }
  }

  Widget _buildSymptomsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final header = Row(
      children: [
        Icon(Icons.bubble_chart_outlined, color: colorScheme.onSurfaceVariant, size: 20),
        const SizedBox(width: 12),
        Text('${l10n.periodDetailsSheet_symptoms}:', style: textTheme.bodyLarge),
      ],
    );

    if (!_isEditing) {
      if (_selectedSymptoms.isEmpty) {
        return const SizedBox.shrink();
      }

      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _selectedSymptoms.map((symptom) {
                    return Chip(label: Text(symptom.getDisplayName(l10n)));
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // --- EDIT MODE ---
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _symptoms.map((symptom) {
                    var isAdd = symptom.type == SymptomType.other;
                    return FilterChip(
                      label: Text(symptom.getDisplayName(l10n)),
                      backgroundColor: isAdd ? colorScheme.onSecondary : null,
                      selected: _selectedSymptoms.contains(symptom),
                      onSelected: (isSelected) {
                        setState(() {
                          if (isAdd) {
                            _showNewCustomSymptomDialog();
                          } else {
                            if (isSelected) {
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
              ),
            ),
          ],
        ),
      );
    }
  }
}
