# PeriodsRepository Test Suite

This document outlines the unit tests for the `PeriodsRepository`, detailing the purpose of each test case. The structure of this document mirrors the `group` structure in the `periods_repository_test.dart` file.

---
## Core Log Operations (CRUD)
These tests verify the most basic behavior of creating, updating, and deleting single logs.

| Test Case Description | Purpose |
|---|---|
| `createPeriodLog should add a log and its corresponding period` | Verifies that creating a single log correctly creates both a `PeriodDay` and a `Period` record. |
| `updating a log flow should not affect period structure` | Ensures that updating non-date information (like flow) doesn't incorrectly trigger a period recalculation. |
| `deleting the only log should remove the period entirely` | Confirms that deleting the last log of a period also deletes the parent `Period` record. |

---
## Period Recalculation Logic
This is the most critical group, testing how periods are automatically created, extended, merged, and split when logs are added, updated, or removed.

| Test Case Description | Purpose |
|---|---|
| `creating consecutive logs should extend the existing period` | Checks that logging on a consecutive day extends the end date of the current period. |
| `creating a log with a gap should result in a new period` | Verifies that logging a day with a gap after an existing period creates a second, new period. |
| `creating a log between two existing periods should merge them` | Tests that adding a "bridge" log between two separate periods merges them into one. |
| `adding a back-dated log should correctly extend an existing period backwards` | Ensures that adding a log *before* a period's start date correctly updates the `startDate`. |
| `updatePeriodLog by changing date should merge separate periods` | Checks that updating a log's date to fill a gap merges two separate periods. |
| `updating a log date to create a gap should split the period` | Verifies that moving a log to create a gap correctly splits one period into multiple new ones. |
| `deleting the first log should shorten the period from the start` | Ensures deleting the first log of a period correctly updates the `startDate` of the period. |
| `deletePeriodLog from middle of a period should split it into two` | Confirms that deleting a log from the middle of a period splits it into two separate periods. |
| `deleting all logs from a period sequentially should correctly remove the period` | Tests that a period is correctly removed after all of its constituent logs are deleted one by one. |

---
## Validation and Error Handling
This group contains all tests that expect an exception to be thrown for invalid operations.

| Test Case Description | Purpose |
|---|---|
| `createPeriodLog should throw DuplicateLogException for existing date` | Confirms that creating a log for a date that already exists throws a `DuplicateLogException`. |
| `createPeriodLog should throw FutureDateException for a future date` | Confirms that creating a log for a future date throws a `FutureDateException`. |
| `updating a log to a date that already exists should throw DuplicateLogException` | Confirms that *updating* a log to a date that already has an entry throws a `DuplicateLogException`. |

---
## Data Integrity and Edge Cases
These tests check specific business rules and tricky date-related scenarios.

| Test Case Description | Purpose |
|---|---|
| `updating a log with its own date should not change the period structure` | Checks for idempotency; ensures a no-op date update doesn't cause unwanted side effects. |
| `readAllPeriods should return periods in descending order of start date` | Enforces the data contract that periods are always returned sorted from newest to oldest. |
| `periods spanning across month boundaries should have correct total days` | Verifies date calculations are correct when a period crosses the end of a month. |
| `period duration should be calculated correctly over a leap year` | Checks that date calculations correctly handle the extra day in a leap year. |

---
## Read and Aggregation Operations
This group tests all methods that retrieve and process data, like reading the last period or getting stats.

| Test Case Description | Purpose |
|---|---|
| `readLastPeriod should return the most recent period` | Verifies the `readLastPeriod` method correctly identifies the newest period from the database. |
| `readLastPeriod should return null if no periods exist` | Ensures the method returns `null` for an empty database instead of crashing. |
| `getMonthlyFlows should return correct flow data for multiple months` | Checks that the monthly flow aggregator correctly groups and sums data across different months. |
| `getMonthlyFlows should return an empty list when there is no data` | Ensures the aggregator returns an empty list for an empty database instead of crashing. |

---
## General State Management
This group is for tests that affect the entire state of the database.

| Test Case Description | Purpose |
|---|---|
| `deleteAllEntries should clear all periods and logs` | Confirms that the method successfully clears all relevant tables in the database, resetting the state. |