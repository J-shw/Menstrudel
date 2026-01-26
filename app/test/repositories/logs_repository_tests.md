# LogsRepository Test Suite

This document outlines the unit tests for the `LogsRepository`, detailing the purpose of each test case.

## Core Log Operations (CRUD)
Verifies the basic ability to write and remove data from the `period_logs` table.

| Test Case Description | Purpose |
|---|---|
| `upsertLog should save a new LogDay` | Verifies that a log entry is correctly written to the database. |
| `upsertLog should update an existing entry` | Ensures that calling upsert on an existing ID updates the symptoms/flow without creating a duplicate. |
| `deleteLog should remove a specific entry` | Confirms that a log is removed from the database by ID. |
| `readAllLogs should return all entries sorted by date` | Ensures the repo returns the full history in a predictable order. |

## Validation and Error Handling
Tests the `LogValidator` logic that prevents data corruption.

| Test Case Description | Purpose |
|---|---|
| `upsertLog should throw DuplicateLogException for existing date` | Prevents two different logs from sharing the same calendar date. |
| `upsertLog should throw FutureDateException for a future date` | Prevents users from logging data for tomorrow or beyond. |
| `updating a log to a conflicting date should throw DuplicateLogException` | Ensures date changes don't collide with existing logs. |

## General State Management
| Test Case Description | Purpose |
|---|---|
| `deleteAllLogs should clear the log table` | Confirms the database can be reset to a clean state. |