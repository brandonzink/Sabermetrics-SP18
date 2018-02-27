#Compute averages for BA, OBP, SLG, and ISO for the MLB 
drop table if exists mlb_stats;
create table mlb_stats as
	select 
        round((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)),3) as 'BA',
        round(((sum(case when EVENT_CD > 19 then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end))/(sum(case AB_FL when 'T' then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end)+sum(case SF_FL when 'T' then 1 else 0 end))),3) as 'OBP',
        round(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))),3) as 'SLG',
		round(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))),3)-round((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)),3) as 'ISO'
	from events;

#Compute averages for BA, OBP, SLG, and ISO for away teams all stadiums
drop table if exists stadium_stats;
create table stadium_stats as
	select 
		HOME_TEAM_ID as 'Team',
        round((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)),3) as 'BA',
        round(((sum(case when EVENT_CD > 19 then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end))/(sum(case AB_FL when 'T' then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end)+sum(case SF_FL when 'T' then 1 else 0 end))),3) as 'OBP',
        round(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))),3) as 'SLG',
		round(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))),3)-round((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)),3) as 'ISO'
	from events
	where BAT_HOME_ID = 0 and HOME_TEAM_ID != 'HOM'
    group by HOME_TEAM_ID;

#Compute a score (as percent difference, centered at 100) for each stadium
drop table if exists stadium_factors;
create table stadium_factors as
	select
		Team as 'Team',
        round((((BA/0.255)+(OBP/0.320)+(SLG/0.401)+(ISO/0.146))/4)*100,0) as 'Offensive Park Factor',
        round((BA/0.255)*100,0) as 'BA Factor',
        round((OBP/0.320)*100,0) as 'OBP Factor',
        round((SLG/0.401)*100,0) as 'SLG Factor',
        round((ISO/0.146)*100,0) as 'ISO Factor'
	from stadium_stats
    order by (((BA/0.255)+(OBP/0.320)+(SLG/0.401)+(ISO/0.146))/4)*100 DESC;
    
#Congregate all of the home stats for Rockies players adjusting for Park Factor above
drop table if exists COL_home_stats;
create table COL_home_stats as
	select 
		BAT_ID as 'BatterID',
        count(*) as 'Home_AB',
        round(((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end))/1.11),3) as 'Home_Adj_BA',
        round((((sum(case when EVENT_CD > 19 then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end))/(sum(case AB_FL when 'T' then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end)+sum(case SF_FL when 'T' then 1 else 0 end)))/1.07),3) as ' Home_Adj_OBP',
        round((((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end)))/1.12),3) as 'Home_Adj_SLG',
		round((((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))))-(sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)/1.14),3) as 'Home_Adj_ISO'
	from events
	where BAT_TEAM_ID = 'COL' and HOME_TEAM_ID = 'COL' 
    group by BAT_ID;
    
#Congregate all of the away stats for Rockies players
drop table if exists COL_away_stats;
create table COL_away_stats as
	select 
		BAT_ID as 'BatterID',
        count(*) as 'Away_AB',
        round((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)),3) as 'Away_BA',
        round(((sum(case when EVENT_CD > 19 then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end))/(sum(case AB_FL when 'T' then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end)+sum(case SF_FL when 'T' then 1 else 0 end))),3) as 'Away_OBP',
        round(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))),3) as 'Away_SLG',
		round(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))),3)-round((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)),3) as 'Away_ISO'
	from events
	where BAT_TEAM_ID = 'COL' and HOME_TEAM_ID != 'COL' 
    group by BAT_ID;

#Compare the home and away stats
select distinct n.FIRST_NAME_TX as 'First', n.LAST_NAME_TX as 'Last', chs.BatterID, 
	(chs.Home_Adj_BA-cas.Away_BA) as 'BA Diff',
	(chs.Home_Adj_OBP-cas.Away_OBP) as 'OBP Diff',
	(chs.Home_Adj_SLG-cas.Away_SLG) as 'SLG Diff',
	(chs.Home_Adj_ISO-cas.Away_ISO) as 'ISO Diff'
from COL_home_stats as chs
join COL_away_stats cas on chs.BatterID = cas.BatterID
join rosters n on n.PLAYER_ID = chs.BatterID and n.PLAYER_ID = cas.BatterID
where chs.Home_AB > 50 and cas.Away_AB > 50
order by (chs.Home_Adj_BA-cas.Away_BA)+(chs.Home_Adj_OBP-cas.Away_OBP)+(chs.Home_Adj_SLG-cas.Away_SLG)+(chs.Home_Adj_ISO-cas.Away_ISO) DESC;

