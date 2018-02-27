#Brandon Zink

#2 - First, last name, BA for every SS in NL since 2010, ordered BA high to low
select m.nameFirst, m.nameLast, b.yearID, (b.H/b.AB) as BA from master m
left join batting b on b.playerID = m.playerID
left join fielding f on f.playerID = b.playerID and f.yearID = b.yearID and f.teamID = b.teamID
where b.lgID = 'NL' and f.POS = 'SS' and f.yearID > 2009
order by BA DESC;

#3 - Top five universities that MLB players have attended, and the count for each

#Create a temp table containing the schoolID, count for each school...
drop table if exists SchoolCountCalc;
create temporary table SchoolCountCalc as
select schoolID, count(*) as 'Count' from (select distinct playerID, schoolID from collegeplaying) cp
group by cp.schoolID
order by count(*) DESC;

#...then join it with the school name
select s.name_full as 'Name', scc.Count from SchoolCountCalc scc
join schools s on s.schoolID = scc.schoolID
order by scc.Count DESC
limit 0,5;

#4 - All non-pitchers with BA below .200 since 2010
select distinct m.nameFirst, m.nameLast, b.yearID, b.teamID, f.POS, (b.H/b.AB) as BA from batting b
join master m on m.playerID = b.playerID
join fielding f on f.playerID = b.playerID and f.yearID = b.yearID and f.teamID = b.teamID
where (b.H/b.AB) < .200 and b.yearID > 2009 and f.POS != 'P';

#5 - Add % of PA that end in BB, HBP, or sac to question 2
select m.nameFirst, m.nameLast, b.yearID, (b.H/b.AB) as BA, ((b.BB+b.HBP+b.SF+b.SH)/(b.AB+b.BB+b.HBP+b.SH+b.SF)) as 'On base by BB, HBP, or sac' from master m
left join batting b on b.playerID = m.playerID
left join fielding f on f.playerID = b.playerID and f.yearID = b.yearID and f.teamID = b.teamID
where b.lgID = 'NL' and f.POS = 'SS' and f.yearID > 2009
order by BA DESC;

#AAP Queries


#AAP for a team-year combination. Returns one row for every team the player was on in 2016 (from class notes)
SELECT f.playerID, m.nameFirst, m.nameLast, f.yearID, f.teamID, f.POS, f.PO, f.A, f.E, (f.PO+f.A)/(f.PO+f.A+f.E) AS FP, 
	p.W, p.L, p.W/(p.W+p.L) AS WP, b.H, b.AB, (b.H/b.AB) AS BA, 
    (f.PO+f.A)/(f.PO+f.A+f.E)+p.W/(p.W+p.L)+(b.H/b.AB) as AAP
	FROM Fielding f
    LEFT JOIN Pitching p ON p.playerID = f.playerID and p.yearID = f.yearID and p.teamID = f.teamID
    LEFT JOIN Batting b ON b.playerID = f.playerID and b.yearID = f.yearID and b.teamID = f.teamID
    LEFT JOIN Master m ON m.playerID = f.playerID
    WHERE f.POS = 'P' and f.yearID = 2016 and AB > 30
    ORDER BY BA DESC;
    
#Number of PA for pitchers in 1910 versus 2016
select avg((b.AB+b.BB+b.HBP+b.SH+b.SF)) as 'Avg AB' from batting b
join fielding f on b.playerID = f.playerID and b.yearID = f.yearID and b.teamID=f.teamID
where b.yearID = 1910 and f.POS = 'P';

select avg((b.AB+b.BB+b.HBP+b.SH+b.SF)) as 'Avg AB' from batting b
join fielding f on b.playerID = f.playerID and b.yearID = f.yearID and b.teamID=f.teamID
where b.yearID = 2016 and f.POS = 'P';

#% of runs that are earned
select (sum(p.ER)/sum(p.R)) from pitching p
where p.yearID = 1910;

select (sum(p.ER)/sum(p.R)) from pitching p
where p.yearID = 2016;

#average OBP of pitchers in 1910 versus 2016
select avg((b.H+b.BB+b.HBP)/(b.AB+b.BB+b.HBP+b.SF)) as OBP from batting b
join fielding f on b.playerID = f.playerID and b.yearID = f.yearID and b.teamID=f.teamID
where b.yearID = 1910 and f.POS = 'P';

select avg((b.H+b.BB+b.HBP)/(b.AB+b.BB+b.HBP+b.SF)) as OBP from batting b
join fielding f on b.playerID = f.playerID and b.yearID = f.yearID and b.teamID=f.teamID
where b.yearID = 2016 and f.POS = 'P';