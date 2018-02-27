#When the Rockies are winning by 1 run at the start of the 7th win percentage
SELECT COUNT(*)/(SELECT COUNT(*)
	FROM events e
	WHERE ((e.away_team_id = 'COL' AND (e.away_score_ct - e.home_score_ct = 1) AND e.inn_ct = 7
	AND e.leadoff_fl = 'T' AND e.bat_team_id = 'COL') OR (e.home_team_id = 'COL'
	AND ((e.home_score_ct+e.EVENT_RUNS_CT) - e.away_score_ct = 1) AND e.inn_ct = 6 AND e.inn_end_fl = 'T'
	AND e.bat_team_id = 'COL')
	)
)
	FROM events e
	JOIN games g ON g.game_id = e.game_id
	WHERE ((e.away_team_id = 'COL' AND (e.away_score_ct - e.home_score_ct = 1)
	AND e.inn_ct = 7 AND e.leadoff_fl = 'T' AND e.bat_team_id = 'COL'
	AND (g.AWAY_SCORE_CT > g.HOME_SCORE_CT)) OR
	(e.home_team_id = 'COL' AND ((e.home_score_ct + e.EVENT_RUNS_CT) - e.away_score_ct = 1)
	AND e.inn_ct = 6 AND e.inn_end_fl = 'T' AND e.bat_team_id = 'COL'
	AND (g.HOME_SCORE_CT > g.AWAY_SCORE_CT)));
    
#When the Rockies are losing by 1 run at the start of the 7th win percentage
SELECT COUNT(*)/(SELECT COUNT(*)
	FROM events e
	WHERE ((e.away_team_id = 'COL' AND (e.away_score_ct - e.home_score_ct < 0) AND e.inn_ct = 7
	AND e.leadoff_fl = 'T' AND e.bat_team_id = 'COL') OR (e.home_team_id = 'COL'
	AND ((e.home_score_ct+e.EVENT_RUNS_CT) - e.away_score_ct < 0) AND e.inn_ct = 6 AND e.inn_end_fl = 'T'
	AND e.bat_team_id = 'COL')
	)
)
	FROM events e
	JOIN games g ON g.game_id = e.game_id
	WHERE ((e.away_team_id = 'COL' AND (e.away_score_ct - e.home_score_ct < 0)
	AND e.inn_ct = 7 AND e.leadoff_fl = 'T' AND e.bat_team_id = 'COL'
	AND (g.AWAY_SCORE_CT > g.HOME_SCORE_CT)) OR
	(e.home_team_id = 'COL' AND ((e.home_score_ct + e.EVENT_RUNS_CT) - e.away_score_ct < 0)
	AND e.inn_ct = 6 AND e.inn_end_fl = 'T' AND e.bat_team_id = 'COL'
	AND (g.HOME_SCORE_CT > g.AWAY_SCORE_CT)));

#All teams leading after six and won
SELECT COUNT(*)/(SELECT COUNT(*)
	FROM events e
	WHERE ((e.away_score_ct - e.home_score_ct = 1) AND e.inn_ct = 7 AND e.leadoff_fl = 'T') OR ((((e.home_score_ct+e.EVENT_RUNS_CT) - e.away_score_ct = 1) AND e.inn_ct = 6 AND e.inn_end_fl = 'T')
	)
)
	FROM events e
	JOIN games g ON g.game_id = e.game_id
	WHERE (((e.away_score_ct - e.home_score_ct = 1)
	AND e.inn_ct = 7 AND e.leadoff_fl = 'T'
	AND (g.AWAY_SCORE_CT > g.HOME_SCORE_CT)) OR
	(((e.home_score_ct + e.EVENT_RUNS_CT) - e.away_score_ct = 1)
	AND e.inn_ct = 6 AND e.inn_end_fl = 'T'
	AND (g.HOME_SCORE_CT > g.AWAY_SCORE_CT)));
    
#Number of stolen bases Rockies
select count(RUN1_SB_FL = 'T')+count(RUN2_SB_FL = 'T')+count(RUN3_SB_FL = 'T') from events e
where e.BAT_TEAM_ID = 'COL';


