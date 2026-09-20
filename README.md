# Nba Front Office dashboard (2025-26 Season)

## Project overview
This project develops an NBA front-office analytics dashboard designed to support decision-making during the offseason. The objective is to combine on-court team and player performance with salary information from the 2025-26 season to create a tool that supports offseason decisions regarding players contracts.

## Buisness Questions:
The main questions driving this project are as follows:
- How did the team perform this season?
- What is the current Team Profile (Offense/Defense/Both) ?
- How did the players contribute to the team's success and deliver value relative to their contracts? 

## Dashboard
## Key Metrics
With all the data available, it is easy to fall into the trap of treating every stat as relevant — which is not the case. For that reason, we made the deliberate decision to include only the data that helps answer our core questions. To complement the raw NBA stats, we also constructed several composite metrics to help evaluate teams and players:

**Offensive Score**
League-relative 0–100 index based on Offensive Rating, TS%, 3P%, and turnover rate.

**Defensive Score**
League-relative 0–100 index based on Defensive Rating and Defensive Rebound%.

**Contribution Index**
Composite indicator combining selected player performance metrics.

**Value Gap**
Contribution Percentile − Salary Percentile
*Used to identify potential value opportunities and inefficient contracts.*

Details about the data used can be found in the data inventory file.

## Data tools
|Tool|Purpose|
| --- | --- |
|Python (pandas, nba_api)|Data collection & cleaning|
|SQL (BigQuery)|Data transformation & analytical views|
|Power BI |Dashboard and Data visualisation|

## Limitations
Data covers the 2025–26 regular season. Salary information was collected separately (on ESPN.com) and may be incomplete for certain players/contracts, so payroll figures are treated as estimates. Custom performance and value metrics are analytical indicators developed for this project and should not be interpreted as official NBA measures.

## Project structure

