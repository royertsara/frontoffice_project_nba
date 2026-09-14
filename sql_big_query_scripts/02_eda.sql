-- EDA on teams performance data:

--1) League standings:

select 
  TEAM_NAME,
  W,
  L,
  W_PCT
from `nba_project_dataset.Team_perfromance` 
order by W desc
;


--overall rankings of top 5 winning teams:

select 
  TEAM_NAME,
  W,
  W_PCT,
  NET_RATING_RANK,
  DEF_RATING_RANK,
  OFF_RATING_RANK
from `nba_project_dataset.Team_perfromance`
order by W desc
limit 5;

-- overall ranking of the bottom 5:
select 
  TEAM_NAME,
  W,
  W_PCT,
  NET_RATING_RANK,
  DEF_RATING_RANK,
  OFF_RATING_RANK
from `nba_project_dataset.Team_perfromance`
order by W 
limit 5;


-- overall most of the top 5 teams are among the league top 10 in both off and def , the bottom 5 are among the worst logically

--3) Descriptive stats of league 

--average league stats:
select
  avg(W) as avg_win,
  avg(OFF_RATING) as avg_off_rating,
  avg(DEF_RATING) as avg_def_rating
from `nba_project_dataset.Team_perfromance`;

-- below/above average in offense and defense :

with team_offense as(
  select TEAM_NAME,
    OFF_RATING,
    case when OFF_RATING>(select avg(OFF_RATING) from `nba_project_dataset.Team_perfromance`)
      then 'above average'
      else 'below average'
      end as offense_level
  from `nba_project_dataset.Team_perfromance`
)
select 
  offense_level,
  count(distinct TEAM_NAME) as nb_teams
from team_offense
group by offense_level;