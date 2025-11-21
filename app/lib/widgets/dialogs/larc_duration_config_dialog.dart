import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_types_enum.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/services/settings_service.dart';

class LarcDurationConfigDialog extends StatefulWidget {
  const LarcDurationConfigDialog({
    super.key,
    required this.larcType,
  });

  final LarcTypes larcType;

  @override
  State<LarcDurationConfigDialog> createState() => _LarcDurationConfigDialogState();
}

class _LarcDurationConfigDialogState extends State<LarcDurationConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    final settingsService = context.read<SettingsService>();
    final currentDuration = settingsService.getLarcDurationDays(widget.larcType);
    
    _controller = TextEditingController(text: currentDuration.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _acceptDuration() async {
    final int? newDuration = int.tryParse(_controller.text.trim());

    if (newDuration != null && newDuration > 0 && mounted) {
      Navigator.of(context).pop(newDuration);
    } 
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog.adaptive(
      title: Text(
        '${l10n.settingsScreen_setDuration} (${widget.larcType.getDisplayName(l10n)})',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.error_valueCannotBeNull; 
                  }
                  final int? duration = int.tryParse(value);
                  if (duration == null || duration <= 0) {
                    return l10n.error_valueMustbePositive;
                  }
                  return null;
                },
                autofocus: true,
                maxLength: 5,
                maxLines: 1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l10n.settingsScreen_durationInDays,
                  suffixText: l10n.days,
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, child) {
                        final int? inputDuration = int.tryParse(value.text.trim());
                        final bool isValid = inputDuration != null && inputDuration > 0;
                        
                        return FilledButton(
                          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                          onPressed: isValid 
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    _acceptDuration();
                                  }
                                } 
                              : null,
                          child: Text(l10n.confirm), 
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}