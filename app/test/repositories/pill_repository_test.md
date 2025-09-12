# PillsRepository Test Suite

This document outlines the unit tests for the `PillsRepository`, detailing the purpose of each test case. The structure of this document mirrors the `group` structure in the `pills_repository_test.dart` file.

---
## Pill Regimen Management
Tests for creating, reading, and deleting the main `PillRegimen` objects, focusing on the core logic of managing active regimens.

| Test Case Description | Purpose |
|---|---|
| `createPillRegimen successfully adds a new regimen` | Verifies that a new regimen can be added to the database and is assigned an ID. |
| `createPillRegimen deactivates the previously active regimen` | Confirms the critical transaction logic that ensures only one regimen can be active at a time. |
| `createPillRegimen works correctly when no other regimens exist` | Checks that creating the very first regimen in an empty database works as expected. |
| `readActivePillRegimen returns the correct active regimen` | Ensures the method correctly finds and returns the single regimen marked as active. |
| `readActivePillRegimen returns null when no regimens are active` | Verifies the method returns `null` when all regimens in the database are inactive. |
| `deletePillRegimen successfully removes a regimen` | Checks that a regimen is properly deleted from the database by its ID. |
| `deletePillRegimen does not throw an error for a non-existent ID` | Confirms the method is safe and does not crash if asked to delete a regimen that isn't in the database. |

---
## Pill Intake Tracking
Tests for creating and reading `PillIntake` records.

| Test Case Description | Purpose |
|---|---|
| `createPillIntake successfully adds a record` | Verifies that a single pill intake can be successfully saved to the database. |
| `readIntakesForRegimen returns only intakes for the specified regimen` | Confirms that the method correctly filters intakes and only returns those belonging to the given regimen ID. |
| `readIntakesForRegimen returns an empty list for a regimen with no intakes` | Ensures the method returns an empty list instead of `null` or an error if no intakes are found for a regimen. |

---
## Pill Reminder (Upsert Logic)
A dedicated group to test the `savePillReminder` method, which handles both creating a reminder for the first time and updating it later.

| Test Case Description | Purpose |
|---|---|
| `savePillReminder creates a new reminder if one does not exist` | Tests the "insert" path of the upsert logic, confirming a reminder is created for a regimen that doesn't have one. |
| `savePillReminder updates an existing reminder for the same regimen` | Tests the "update" path of the upsert logic, confirming an existing reminder is modified instead of a new one being created. |
| `readReminderForRegimen returns null if no reminder exists` | Verifies the method correctly returns `null` when a regimen has no associated reminder. |

---
## Data Integrity and Relationships
Tests that verify the connections between tables remain correct, especially after deletion operations.

| Test Case Description | Purpose |
|---|---|
| `deletePillRegimen does not delete associated intakes` | Confirms the non-cascading delete behavior; child intake records are not removed when the parent regimen is deleted. |
| `deletePillRegimen does not delete the associated reminder` | Confirms the non-cascading delete behavior for reminders, ensuring they are not accidentally deleted. |

---
## Empty State Behavior
A set of sanity checks to ensure methods are safe to call when the database is empty or no data is found for a query.

| Test Case Description | Purpose |
|---|---|
| `readActivePillRegimen returns null when database is empty` | Ensures the method is safe to call on a completely empty database. |
| `readIntakesForRegimen returns an empty list for a non-existent regimen ID` | Verifies that querying for intakes of a regimen that doesn't exist returns an empty list rather than crashing. |