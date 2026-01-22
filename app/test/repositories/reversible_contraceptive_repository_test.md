# ReversibleContraceptive Test Suite

This document outlines the unit tests for the `ReversibleContraceptiveRepository` and its `Manager`, detailing the purpose of each test case.

## Core ReversibleContraceptive Operations (CRUD)
Verifies the ability to manage Reversible Contraceptive logs.

| Test Case Description | Purpose |
|---|---|
| `logReversibleContraceptive should save a new entry` | Verifies that a ReversibleContraceptive log is correctly inserted into the database. |
| `getAllLogs should return logs in descending date order` | Ensures logs are retrieved with the most recent entries first. |
| `getLogById should return the correct entry` | Validates that a specific log can be fetched using its unique ID. |
| `updateLog should modify an existing entry` | Ensures that changes to a log (e.g., type or notes) are saved correctly. |
| `deleteLog should remove a specific entry` | Confirms a log is deleted and no longer exists in the database. |

## Data Management (Import/Export)
| Test Case Description | Purpose |
|---|---|
| `importDataFromJson should restore logs correctly` | Ensures JSON data is parsed and inserted after clearing old data. |
| `importDataFromJson should throw FormatException for newer DB versions` | Prevents data corruption from incompatible future database schemas. |
| `clearAllData should empty the table` | Confirms the repository can be completely reset. |