import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class ProfileStep extends StatelessWidget {
  final TextEditingController nameController;
  final DateTime? selectedDate;
  final VoidCallback onDateTap;
  final VoidCallback onDateClear;

  const ProfileStep({
    super.key,
    required this.nameController,
    this.selectedDate,
    required this.onDateTap,
    required this.onDateClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasDate = selectedDate != null;
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingScreen_profileTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 32),
          
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n.onboardingScreen_profileName,
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 24),

          InkWell(
            onTap: onDateTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasDate ? colorScheme.primary : colorScheme.outlineVariant,
                ),
                color: hasDate ? colorScheme.primaryContainer.withValues(alpha: 0.1) : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cake_outlined, 
                    color: hasDate ? colorScheme.primary : colorScheme.onSurfaceVariant
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboardingScreen_profileDate,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          hasDate 
                            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                            : l10n.onboardingScreen_profileDatePlaceholder,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: hasDate ? colorScheme.onSurface : colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasDate)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onDateClear,
                    )
                  else
                    const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}