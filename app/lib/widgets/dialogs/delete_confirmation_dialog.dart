import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String contentText;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.contentText,
    required this.onConfirm,
    this.confirmButtonText = 'Confirm',
    this.isDestructive = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog.adaptive(
      title: Text(title, textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              contentText,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
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
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: isDestructive ? colorScheme.error : null,
                      foregroundColor: isDestructive ? colorScheme.onError : null,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    child: Text(confirmButtonText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}