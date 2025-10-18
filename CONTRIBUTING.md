# Contributing

Thank you for considering contributing to Menstrudel!

---

## How Can I Contribute?

### Reporting Bugs

-   Ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/J-shw/Menstrudel/issues).
-   If you're unable to find an open issue, [open a new one](https://github.com/J-shw/Menstrudel/issues/new?template=bug_report.md). Be sure to include a title, a clear description, and as much relevant information as possible.

### Suggesting Enhancements

-   Open a new issue to discuss your idea.
-   Clearly describe the feature and why it would be useful.

### Translations

All app translations are managed through Crowdin. We welcome contributions, whether you're suggesting a new language or improving existing translations!

**[Go to the Menstrudel Crowdin Project](https://crowdin.com/project/menstrudel)**

* **To Add a New Language:** Please request the new language through the Crowdin project.
* **To Add Translations:** Once you join the project, you can contribute by translating any untranslated text for the languages you speak.

You do not need to edit any `.arb` or `.dart` files in this repository. All translation changes will be synced from Crowdin by the maintainers.

For more details please see the [translation docs](docs/translation/README.md)

---

## Branching Model

-   `dev` is the default branch. All new development should be merged here.
-   `main` is considered live, production-ready code.

---

## Pull Request Process

This section applies to code contributions. For translations, please see the Crowdin section above.

1.  Fork the repository and create your branch from `dev`.

2.  **Name your branch correctly.**

    Since this is a monorepo, please include the project scope in the name using the format:
    `<type>/<scope>/<short-description>`

    **`<type>` can be one of the following:**
    * `feature`: For new features.
    * `bugfix`: For fixing a bug.
    * `docs`: For changes to documentation.
    * `chore`: For maintenance tasks (e.g., updating dependencies).
    * `refactor`: For code improvements without changing functionality.
    * `style`: For code formatting changes.
    * `test`: For adding or improving tests.

    **`<scope>` is one of the following:**
    * `app`: The main application.
    * `wear`: The Wear OS application.
    * `web`: The project's website.
    * `repo`: Changes to the repository itself (CI, config, etc.).

    **Examples:**
    * `feature/web/add-contact-form`
    * `bugfix/app/fix-user-login-crash`
    * `docs/wear/update-build-instructions`

3.  Add your changes and commit them with a clear commit message.

4.  Push your branch and open a pull request against the `dev` branch.

5.  Clearly describe the changes in your pull request.