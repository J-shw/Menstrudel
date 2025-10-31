import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class CustomSymptomDialog extends StatefulWidget {
  final bool showTemporarySymptomButton;

  const CustomSymptomDialog({
    super.key,
    this.showTemporarySymptomButton = false,
  });

  @override
  State<CustomSymptomDialog> createState() => _CustomSymptomDialogState();
}

class _CustomSymptomDialogState extends State<CustomSymptomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final periodsRepo = PeriodsRepository();

  bool _isTemporary = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> accept() async {
    var symptom = _nameController.text;
    if (mounted) {
      Navigator.of(context).pop((symptom, _isTemporary));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog.adaptive(
      title: Text(
        l10n.customSymptomDialog_newCustomSymptom,
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
              if (widget.showTemporarySymptomButton == false)
                const SizedBox(height: 16),
              if (widget.showTemporarySymptomButton == false)
                SwitchListTile(
                  subtitle: Text(l10n.customSymptomDialog_makeTemporary),
                  secondary: const Icon(Icons.fact_check),
                  value: _isTemporary,
                  onChanged: (value) => {
                    setState(() {
                      _isTemporary = value;
                    }),
                  },
                ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _nameController,
          builder: (context, value, child1) {
            return ElevatedButton(
              onPressed: value.text.isNotEmpty
                  ? () {
                      accept();
                    }
                  : null,
              child: Text(l10n.confirm),
            );
          },
        ),
      ],
    );
  }
}
