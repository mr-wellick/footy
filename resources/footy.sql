-- create countries table
create table if not exists countries(
	country_id uuid default gen_random_uuid() primary key,
	country_code varchar(3) unique not null,
	country_name varchar(100) unique not null
);

-- create leagues table
create table if not exists leagues(
	league_id uuid default gen_random_uuid() primary key,
	league_name varchar(100) not null,
    country_id uuid references countries(country_id) not null
);

-- create seasons years
create table if not exists seasons(
	season_id uuid default gen_random_uuid() primary key,
	start_year int not null,
	end_year int check (end_year > start_year) not null
);

-- create players table
create table if not exists players(
	player_id uuid default gen_random_uuid() primary key,
	name varchar(100) not null,
	nationality varchar(50) not null,
	position varchar(5) not null,
	height_cm int not null,
	weight_kg decimal(5, 2) not null
);

-- create teams table
create table if not exists teams(
	team_id uuid default gen_random_uuid() primary key,
	name varchar(100) not null,
    league_id uuid references leagues(league_id) not null
);

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
 	player_id uuid references players(player_id) unique not null,
 	team_id uuid references teams(team_id) not null,
 	season_id uuid references seasons(season_id) not null
);

-- create matches table
create table if not exists matches(
    match_id uuid default gen_random_uuid() primary key,
    match_date timestamptz not null default now(),
    home_score int not null,
    away_score int not null,
    home_team uuid references teams(team_id) not null,
    away_team uuid references teams(team_id) not null,
    league_id uuid references leagues(league_id) not null,
    season_id uuid references seasons(season_id) not null
);

-- create teams_statistics table: (dont have data for this table, will wait on creating)
-- create table if not exists team_statistics()

