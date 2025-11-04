import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class CustomSymptomDialog extends StatefulWidget {
  final bool hideTemporarySwitch;

  const CustomSymptomDialog({
    super.key,
    this.hideTemporarySwitch = false,
  });

  @override
  State<CustomSymptomDialog> createState() => _CustomSymptomDialogState();
}

class _CustomSymptomDialogState extends State<CustomSymptomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isTemporary = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> accept() async {
    var symptom = _nameController.text.trim().toLowerCase();
    if (mounted) {
      Navigator.of(context).pop((symptom, _isTemporary));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog.adaptive(
      title: Text(
        l10n.customSymptomDialog_newSymptom,
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
                controller: _nameController,
                validator: (value) => value!.isEmpty
                    ? l10n.customSymptomDialog_enterCustomSymptom
                    : null,
                autofocus: true,
                maxLength: 60,
                maxLines: 1,
              ),
              if (!widget.hideTemporarySwitch)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SwitchListTile(
                    title: Text(l10n.customSymptomDialog_temporarySymptom), 
                    secondary: const Icon(Icons.event_note),
                    value: _isTemporary,
                    onChanged: (value) {
                      setState(() {
                        _isTemporary = value;
                      });
                    },
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
                      valueListenable: _nameController,
                      builder: (context, value, child1) {
                        final bool isTextEmpty = value.text.trim().isEmpty;
                        return FilledButton(
                          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                          onPressed: !isTextEmpty ? () => accept() : null,
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
