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

The project is organized to separate raw data, data preparation, analysis, database transformations, and the final dashboard. This makes the workflow easier to understand, reproduce, and maintain, while keeping the different stages of the project clearly separated.


- **README.md** — project overview, business questions, dashboard, key metrics, tools, and limitations.
- **data_inventory.md** — concise inventory of the datasets used in the project: dataset/table names, source, main variables, period, and their role in the analysis. It provides a quick reference for understanding the data without going through the notebooks.
- **requirements.txt** — list of Python libraries required to run the data collection and processing notebooks, allowing the Python environment to be reproduced.
- **data_raw/** — original datasets collected from external sources, kept unchanged.
- **data_cleaned/** — cleaned and analysis-ready datasets used for the database/dashboard.
- **python_notebooks/** — notebooks for data collection, cleaning, transformation, and preparation.
- **sql_bigquery_scripts/** — SQL scripts used to create tables, transformations, metrics, and analytical views in BigQuery.
- **dashboard/** — Power BI dashboard file and any related dashboard assets.