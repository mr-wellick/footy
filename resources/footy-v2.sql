-- create countries table
create table if not exists countries(
	country_id uuid default gen_random_uuid() primary key,
	country_code varchar(3) unique not null,
	country_name varchar(100) unique not null
)

-- create leagues table
create table if not exists leagues(
	league_id uuid default gen_random_uuid() primary key,
	league_name varchar(100) not null,
-- 	add relations after creating tables
-- 	country_id uuid references countries(country_id) not null,
	country_id uuid not null
)

-- create seasons years
create table if not exists seasons(
	season_id uuid default gen_random_uuid() primary key,
	start_year int not null,
	end_year int check (end_year > start_year) not null
)

-- create players table
create table if not exists players(
	player_id uuid default gen_random_uuid() primary key,
	player_name varchar(100) not null,
	player_nationality varchar(50) not null,
	player_position varchar(5) not null,
	player_height_cm int not null,
	player_weight_kg decimal(5, 2) not null
);

-- create teams table
create table if not exists teams(
	team_id uuid default gen_random_uuid() primary key,
	team_name varchar(100) not null,
-- 	add relations later
-- 	team_league_id uuid references leagues(league_id) not null,
	team_league_id uuid not null
)
select * from teams;

-- create player statistics table
create table if not exists player_statistics(
	player_statistic_id uuid default gen_random_uuid() primary key,
	
	-- 	performance related statistics
    saves int,
    goals_against int,
    goals int,
    assists int,
    shots int,
    shots_on_target int,
	
	-- disciplice related statistics
	fouls_committed int,
    fouls_against int,
    yellow_cards int,
    red_cards int,
	
	-- participation related statistics
	substitutions int,
    appearances int,
	
	-- foreign keys
	-- 	add relations after creating tables
-- 	player_id uuid references players(player_id) unique not null,
-- 	team_id uuid references teams(team_id) not null,
-- 	season_id uuid references seasons(season_id) not null
	player uuid not null,
	team_id uuid not null,
	season_id uuid not null
)

-- create matches table
-- create teams_statistics table

/*

	- finished creating tables
	- simplify names
	- review relations before creating them
*/






