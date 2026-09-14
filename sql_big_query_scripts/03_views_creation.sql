-- Exectutive view
create or replace view `nba2025.nba_project_dataset.v_executive_summary` as
select 
  t.TEAM_ID,
  TEAM_NAME,
  W,
  L,
  W_PCT,
  case 
  when W_PCT_RANK <= 6 then 'Elite team'
  when W_PCT_RANK <=13 then 'Good team'
  when W_PCT_RANK <=19 then 'Average team'
  when W_PCT_RANK<=25 then 'Below average team'
  else 'Rebuilding team'
    end as Profile,
  sum(p.SALARY) as Estimated_Payroll
from `nba_project_dataset.Team_perfromance` as t 
  left join `nba_project_dataset.Players_salaries` as p on p.TEAM_ID=t.TEAM_ID

group by all
;

-- Team profile view:
create or replace view `nba2025.nba_project_dataset.v_team_profile` as 
with rank_avg as(select
  *,
  (OFF_RATING_RANK*0.5+TS_PCT_RANK*0.25+FG3_PCT_RANK*0.15+TM_TOV_PCT_RANK*0.10) as avg_rank,
  (DEF_RATING_RANK*0.6+DREB_PCT_RANK*0.4) as avg_def_rank
from `nba_project_dataset.Team_perfromance`)
select 
  TEAM_ID,
  TEAM_NAME,
  OFF_RATING,
  DEF_RATING,
  TS_PCT,
  FG3_PCT,
  TM_TOV_PCT,
  REB_PCT,
  DREB_PCT,
  OREB_PCT,
  PACE,
  round(((30-avg_rank)/29)*100,2) as OFFENSIVE_SCORE,
  round(((30-avg_def_rank)/29)*100,2) as DEFENSIVE_SCORE
from rank_avg
;

--Players performance view:

create or replace view `nba2025.nba_project_dataset.v_player_performance` as
with player_stats as(select
  pp.PLAYER_ID,
  pp.PLAYER_NAME,
  pp.TEAM_ID,
  pp.GP,
  W_PCT,
  `MIN`,
  PTS,
  REB,
  AST,
  TS_PCT,
  ps.SALARY,
  PIE,
  percent_rank() over(order by PIE) as pie_percentile,
  percent_rank() over(order by `MIN`) as min_percentile,
  percent_rank() over(order by OFF_RATING) as off_rating_percentile,
  percent_rank() over(order by DEF_RATING desc) as def_rating_percentile,
  percent_rank() over(order by NET_RATING) as net_rating_percentile,
  percent_rank() over(order by ps.SALARY) as salary_percentile
from `nba_project_dataset.Players_performance` as pp
  inner join `nba_project_dataset.Players_salaries` ps
    on pp.PLAYER_ID=ps.PLAYER_ID
where pp.GP>=20 
    
  ),
feature_player_stats as(select
  *,
  (pie_percentile*0.45+net_rating_percentile*0.45+min_percentile*0.1) as player_contribution_index,
  case 
    when off_rating_percentile>=0.5 and def_rating_percentile>=0.5 then 'Two-way player'
    when off_rating_percentile>=0.5 and def_rating_percentile<0.5 then 'Offensive contributor'
    when off_rating_percentile<0.5 and def_rating_percentile>=0.5 then 'Defensive contributor'
  else 'Limited contributor' 
  end as PLAYER_TYPE
from player_stats
)
select
  PLAYER_ID,
  TEAM_ID,
  PLAYER_NAME,
  GP,
  W_PCT,
  `MIN`,
  PTS,
  REB,
  AST,
  TS_PCT,
  SALARY,
  PIE,
  PLAYER_TYPE,
  round(player_contribution_index*100,2) as CONTRIBUTION_INDEX,
  round(salary_percentile*100,2) as SALARY_PERCENTILE,
  case when SALARY is not null then round((player_contribution_index-salary_percentile)*100) 
    else 0 end as VALUE_GAP,
  case when SALARY is null then 'No matching Salary'
    else 'Available Salary' end as SALARY_INFO
from feature_player_stats
;



