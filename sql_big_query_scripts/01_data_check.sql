-- We start with checking the data were uploaded correctly

-- Nb of rows, missing values and duplicates

-- Team Dim

select 
  count(*) as nb_teams,
  sum(case when TEAM_ID is null then 1 else 0 end ) as missing_team_id
from `nba_project_dataset.Team_dim`;

-- duplicates:
select 
  count(*) as total_rows,
  count(distinct TEAM_ID) as nb_teams
from `nba_project_dataset.Team_dim`;


-- Team performance:
select 
  count (*) as nb_teams,
  countif(TEAM_ID is null) as nmissing_teams,
  count(distinct TEAM_ID) as total_teams
from `nba_project_dataset.Team_perfromance`;

-- Players performance:

select 
  count(*) as nb_players,
  countif(PLAYER_ID is null) as missing_players,
  count(distinct PLAYER_ID) as nb_unique_players
from `nba_project_dataset.Players_performance`;

--Players salaries

select
  count (distinct PLAYER_ID) as nb_players,
  countif(SALARY is null) as missing_salary
from `nba_project_dataset.Players_salaries`


-- In summary we have 30 teams, 582 players with 123 with missing salaries, the data were uploaded succesfully