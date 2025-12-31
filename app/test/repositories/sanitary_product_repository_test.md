# SanitaryProductRepository Test Suite

This document outlines the unit tests for the `SanitaryProductRepository` and its `Manager`.

## Core Product Operations (CRUD)
Verifies the management of sanitary product usage logs (pads, tampons, cups, etc.).

| Test Case Description | Purpose |
|---|---|
| `logSanitaryProduct should save a new entry` | Verifies a log is inserted into the database. |
| `getActiveEntry should return entry with null removedTime` | Ensures the app can identify a product currently in use. |
| `markEntryAsRemoved should set the removed timestamp` | Validates the transition from an active to an inactive state. |
| `getInactiveLogs should only return removed items` | Confirms the filter for historical/completed usage logs works. |
| `deleteLog should remove a specific entry` | Confirms a record can be permanently deleted. |

## Data Management (Import/Export)
Tests the `Manager` class for data portability and database cleanup.

| Test Case Description | Purpose |
|---|---|
| `importDataFromJson should restore logs and clear table` | Ensures the database is reset and filled correctly during import. |
| `clearAllData should wipe the table` | Confirms the database can be fully reset. |