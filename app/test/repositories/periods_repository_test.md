# PeriodsRepository Test Suite

This document outlines the unit tests for the `PeriodsRepository`, detailing the purpose of each test case.

## Period Recalculation Logic
Tests the `recalculateAndAssignPeriods` method, which is the "brain" of the cycle logic.

| Test Case Description | Purpose |
|---|---|
| `consecutive logs should be assigned to the same period` | Verifies that days with no gaps are grouped into one `Period` record. |
| `logs with a 1+ day gap should create separate periods` | Verifies that the grouper correctly identifies the end of one cycle and the start of another. |
| `bridging a gap should merge two periods into one` | Tests that adding a missing day between two cycles results in a single, combined `Period`. |
| `creating a gap in the middle should split one period into two` | Verifies that removing or moving a "middle" log triggers a split of the parent period. |
| `back-dated logs should extend period start date` | Ensures the `startDate` of a period updates if an earlier log is added. |

## Data Integrity and Edge Cases
| Test Case Description | Purpose |
|---|---|
| `readAllPeriods should return periods in descending order` | Enforces newest-to-oldest sorting for the UI. |
| `period duration calculation across month boundaries` | Verifies date arithmetic handles varying month lengths correctly. |
| `leap year handling` | Ensures the Feb 29th transition doesn't break cycle length calculations. |

## Read and Aggregation Operations
Tests how the app retrieves summarised cycle data.

| Test Case Description | Purpose |
|---|---|
| `readLastPeriod should return the newest cycle` | Checks that the prediction logic gets the correct "most recent" data. |
| `readLastPeriod should return null for empty DB` | Ensures null-safety when a new user opens the app. |
| `getMonthlyFlows should aggregate stats correctly` | Verifies the "Insights" data grouping by month/year. |