## Guide for Maintainers ⚙️

This guide is for repository maintainers on what to do when **new** languages are added.

### Syncing New Languages

After translators have completed a new language on Crowdin, a PR will automatically be made with the new file. Merge this into the `dev` branch.

After the new file is added, you must manually update the in-app language dropdown to make the new language visible to users.

#### Steps:

* Run `flutter gen-l10n` to update the Localization delegates.

* Open `lib/l10n/l10n.dart`.

* Add the new language code and its native name (e.g., 'Español', 'Deutsch') to the `nativeLanguageNames` map.

```dart
static final Map<String, String> nativeLanguageNames = {
  'en': 'English',
  'fr': 'Français',
  'de': 'Deutsch',
  'it': 'Italiano',
  'es': 'Español', // <-- ADD THE NEW LANGUAGE HERE
};
```