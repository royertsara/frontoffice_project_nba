# Data Inventory — BigQuery Views

This document describes the three BigQuery views that power the Power BI dashboard. Each view is built on top of the cleaned `Team_dim`, `Team_performance`, `Players_performance`, and `Players_salaries` tables (see `data_dictionary.md` for source table definitions).

## Overview

| View | Grain | Dashboard Page | Business Question |
|---|---|---|---|
| `v_executive_summary` | 1 row per team | Executive Overview | How did the team perform overall this season? |
| `v_team_profile` | 1 row per team | Team Performance | What aspects of the game — offense, defense, style — drove that performance? |
| `v_player_performance` | 1 row per player (GP ≥ 20) | Player Performance | Which players contributed most to team success, relative to their contracts? |

All three views join back to `Team_dim` on `TEAM_ID`, which serves as the model's dimension table.

---

## `v_executive_summary`

High-level team snapshot: record, a performance tier, and estimated payroll.

| Column | Type | Description |
|---|---|---|
| `TEAM_ID` | integer | Team identifier. |
| `TEAM_NAME` | text | Full team name. |
| `W` / `L` | integer | Wins / Losses. |
| `W_PCT` | float | Win percentage. |
| `Profile` | text | Performance tier derived from league-wide win-rate rank: Elite (rank 1–6), Good (7–13), Average (14–19), Below Average (20–25), Rebuilding (26–30). |
| `Estimated_Payroll` | float | Sum of player salaries for the team. Labeled "estimated" because ~21% of players league-wide have no recorded salary and are excluded from this sum. |

---

## `v_team_profile`

Team-level offensive and defensive quality, reduced to two composite 0–100 scores alongside the underlying raw stats.

| Column | Type | Description |
|---|---|---|
| `TEAM_ID`, `TEAM_NAME` | — | Team identifiers. |
| `OFF_RATING`, `DEF_RATING`, `TS_PCT`, `FG3_PCT`, `TM_TOV_PCT`, `REB_PCT`, `DREB_PCT`, `OREB_PCT`, `PACE` | float | Raw team stats, unmodified from source. |
| `OFFENSIVE_SCORE` | float (0–100) | Composite score from league ranks: `OFF_RATING` (50%), `TS_PCT` (25%), `FG3_PCT` (15%), `TM_TOV_PCT` (10%), rescaled so rank 1 → 100. |
| `DEFENSIVE_SCORE` | float (0–100) | Composite score from league ranks: `DEF_RATING` (60%), `DREB_PCT` (40%), rescaled so rank 1 → 100. |

Composite score weights reflect analytical judgment (offensive rating and defensive rating weighted highest as the most direct efficiency measures), not an official NBA formula.

---

## `v_player_performance`

Player-level contribution scoring combined with salary standing to estimate contract value.

| Column | Type | Description |
|---|---|---|
| `PLAYER_ID`, `TEAM_ID`, `PLAYER_NAME` | — | Player identifiers. |
| `GP`, `W_PCT`, `MIN`, `PTS`, `REB`, `AST`, `TS_PCT`, `PIE` | float | Raw player stats, unmodified from source. |
| `SALARY` | float | Player salary; `NULL` where unavailable. |
| `PLAYER_TYPE` | text | Style label from offensive/defensive percentile standing: Two-way player, Offensive contributor, Defensive contributor, or Limited contributor. |
| `CONTRIBUTION_INDEX` | float (0–100) | Composite on-court contribution score: PIE percentile (45%) + Net Rating percentile (45%) + Minutes percentile (10%). |
| `SALARY_PERCENTILE` | float (0–100) | Player's salary rank league-wide. |
| `VALUE_GAP` | float | `CONTRIBUTION_INDEX − SALARY_PERCENTILE`. Positive = outperforming contract; negative = overperforming pay relative to production. `0` where salary is unavailable. |
| `SALARY_INFO` | text | `'Available Salary'` or `'No matching Salary'` — flags whether the value-gap calculation is based on real salary data. |

**Filter applied:** only players with `GP >= 20` are included, to exclude small-sample noise from limited playing time.

---

## Notes

Composite scores (`OFFENSIVE_SCORE`, `DEFENSIVE_SCORE`, `CONTRIBUTION_INDEX`) are rank-based, meaning they express a team's or player's standing *relative to the rest of the league* rather than an absolute value.
