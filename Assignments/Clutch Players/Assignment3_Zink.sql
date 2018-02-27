#Average runs per 9 for each home team (stadium) in order by highest scored
select HOME_TEAM_ID as 'Home Stadium', (avg((AWAY_SCORE_CT + HOME_SCORE_CT)*(9/INN_CT))) as 'R/9' from games
group by HOME_TEAM_ID
order by (avg((AWAY_SCORE_CT + HOME_SCORE_CT)*(9/INN_CT))) DESC;

#Expected runs for bases loaded 1 out
select avg(EVENT_RUNS_CT) from events
where HOME_TEAM_ID = 'SDN' AND START_BASES_CD = 7 AND OUTS_CT = 1;

##################
#Calculating a 'Clutch Value' for all players meeting PA requirements
##################

#BA, OBP, SLG for all players over all PA
drop table if exists batting_stats;
create table batting_stats as
	select 
		BAT_ID, 
        round((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)),3) as 'BA',
        round(((sum(case when EVENT_CD > 19 then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end))/(sum(case AB_FL when 'T' then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end)+sum(case SF_FL when 'T' then 1 else 0 end))),3) as 'OBP',
        round(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))),3) as 'SLG',
		sum(case when EVENT_CD > 19 then 1 else 0 end) as H, 
		sum(case EVENT_CD when 20 then 1 else 0 end) as '1B',
		sum(case EVENT_CD when 21 then 1 else 0 end) as '2B',
		sum(case EVENT_CD when 22 then 1 else 0 end) as '3B',
		sum(case EVENT_CD when 23 then 1 else 0 end) as 'HR',
		sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end) as 'BB',
		sum(case EVENT_CD when 16 then 1 else 0 end) as 'HBP',
		sum(case SF_FL when 'T' then 1 else 0 end) as 'SF',
		sum(case AB_FL when 'T' then 1 else 0 end) as 'AB'
		from events
	group by BAT_ID;

#BA, OBP, SLG for clutch appearances in the 7th inning
drop table if exists clutch_batting_stats7;
create table clutch_batting_stats7 as
	select 
		BAT_ID, 
        ((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end))*0.8) as 'C_BA7',
        (((sum(case when EVENT_CD > 19 then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end))/(sum(case AB_FL when 'T' then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end)+sum(case SF_FL when 'T' then 1 else 0 end)))*0.8) as 'C_OBP7',
		(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end)))*0.8) as 'C_SLG7',
        sum(case AB_FL when 'T' then 1 else 0 end) as 'C_AB7'
		from events
	where INN_CT = 7 and 
    (BASE2_RUN_ID <> '' or BASE3_RUN_ID <> '') and
    AWAY_SCORE_CT - HOME_SCORE_CT < 3 and AWAY_SCORE_CT - HOME_SCORE_CT > -3
	group by BAT_ID;

#BA, OBP, SLG for clutch appearances in the 8th inning
drop table if exists clutch_batting_stats8;
create table clutch_batting_stats8 as
	select 
		BAT_ID, 
        (sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end)) as 'C_BA8',
        ((sum(case when EVENT_CD > 19 then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end))/(sum(case AB_FL when 'T' then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end)+sum(case SF_FL when 'T' then 1 else 0 end)))*0.8 as 'C_OBP8',
		((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end))) as 'C_SLG8',
        sum(case AB_FL when 'T' then 1 else 0 end) as 'C_AB8'
		from events
	where INN_CT = 8 and 
    (BASE2_RUN_ID <> '' or BASE3_RUN_ID <> '') and
    AWAY_SCORE_CT - HOME_SCORE_CT < 3 and AWAY_SCORE_CT - HOME_SCORE_CT > -3
	group by BAT_ID;

#BA, OBP, SLG for clutch appearances in innings after the 8th
drop table if exists clutch_batting_stats9;
create table clutch_batting_stats9 as
	select 
		BAT_ID, 
        ((sum(case when EVENT_CD > 19 then 1 else 0 end)/sum(case AB_FL when 'T' then 1 else 0 end))*1.2) as 'C_BA9',
        (((sum(case when EVENT_CD > 19 then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end))/(sum(case AB_FL when 'T' then 1 else 0 end)+sum(case EVENT_CD when 14 then 1 else 0 end)+sum(case EVENT_CD when 15 then 1 else 0 end)+sum(case EVENT_CD when 16 then 1 else 0 end)+sum(case SF_FL when 'T' then 1 else 0 end)))*1.2) as 'C_OBP9',
		(((sum(H_CD)/sum(case AB_FL when 'T' then 1 else 0 end)))*1.2) as 'C_SLG9',
        sum(case AB_FL when 'T' then 1 else 0 end) as 'C_AB9'
		from events
	where INN_CT > 8 and 
    (BASE2_RUN_ID <> '' or BASE3_RUN_ID <> '') and
    AWAY_SCORE_CT - HOME_SCORE_CT < 3 and AWAY_SCORE_CT - HOME_SCORE_CT > -3
	group by BAT_ID;

#Compiling the clutch stats with their appropriate weights
drop table if exists clutch_batting_stats;
create table clutch_batting_stats as
	select distinct
		cbs7.BAT_ID, 
        round((cbs7.C_BA7 + cbs8.C_BA8 + cbs9.C_BA9)/3,3) as 'C_BA',
        round((cbs7.C_OBP7 + cbs8.C_OBP8 + cbs9.C_OBP9)/3,3) as 'C_OBP',
        round((cbs7.C_SLG7 + cbs8.C_SLG8 + cbs9.C_SLG9)/3,3) as 'C_SLG',
        cbs7.C_AB7 + cbs8.C_AB8 + cbs9.C_AB9 as 'C_AB'
        from clutch_batting_stats7 as cbs7
	join clutch_batting_stats8 cbs8 on cbs8.BAT_ID = cbs7.BAT_ID
    join clutch_batting_stats9 cbs9 on cbs9.BAT_ID = cbs7.BAT_ID;
        

#Calculating the Clutch Value and Normalized Clutch Value for all players with 250 normal PA and 50 'Clutch' PAs
select distinct r.FIRST_NAME_TX as 'First Name', r.LAST_NAME_TX as 'Last Name', bs.BA, cbs.C_BA as 'Clutch BA', bs.OBP, cbs.C_OBP as 'Clutch OBP', bs.SLG, cbs.C_SLG as 'Clutch SLG', 
round(((cbs.C_BA-bs.BA)+(cbs.C_OBP-bs.OBP)+(cbs.C_SLG-bs.SLG)),3) as 'Clutch Value',
round(((((cbs.C_BA-bs.BA)+(cbs.C_OBP-bs.OBP)+(cbs.C_SLG-bs.SLG))-(-0.015420001))/(0.419383332+0.015420001)),3) as 'Normalized Clutch Value'
from batting_stats bs
join clutch_batting_stats cbs on cbs.BAT_ID = bs.BAT_ID
join rosters r on r.PLAYER_ID = bs.BAT_ID and r.PLAYER_ID = cbs.BAT_ID
where bs.AB > 250 and cbs.C_AB > 50
order by ((cbs.C_BA-bs.BA)+(cbs.C_OBP-bs.OBP)+(cbs.C_SLG-bs.SLG)) DESC;
    

    




