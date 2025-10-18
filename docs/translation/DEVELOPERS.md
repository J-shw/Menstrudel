
## Guide for Developers 🧑‍💻

If your feature or bugfix introduces new user-visible text, you **must** follow these rules.

### Your Only Task: Edit `app_en.arb`

The English file, `lib/l10n/app_en.arb`, is the **source of truth** for all text in the app.

* **DO:** Add your new text keys and their descriptions *only* to `app_en.arb`.
* **DO NOT:** Add your keys to any other `app_xx.arb` file. Translators will handle this via Crowdin.

### Key Naming Standards

All new keys must follow these rules.

**1. Use Prefixes for Grouping**
Group keys by their screen or feature.
* **GOOD:** `settingsScreen_appearance`, `navBar_logs`
* **BAD:** `appearance`, `logs`

**2. Add a Description for EVERY Key**
This is the most important rule. Translators need context to do their job correctly. Add a `@keyName` entry immediately after your key.
```json
    "settingsScreen_pack": "Pack",
    "@settingsScreen_pack": {
        "description": "A label for a pill pack. Example: 'Pack 1 of 3'."
    },
```

**3. Don't Repeat Yourself (DRY)**
Before adding a new key, check if one already exists

* **GOOD:** Reusing the existing dayCount key for a new feature.
* **BAD:** Adding newUserScreen_dayCounter when dayCount already exists.

**4. Keep the File Sorted Alphabetically**
After adding your new keys (and their descriptions), please sort the entire file alphabetically by the key name. This prevents merge conflicts.