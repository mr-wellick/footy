-- 1. https://supabase.com/blog/choosing-a-postgres-primary-key
-- 2. https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-UNIQUE-CONSTRAINTS
-- 3. https://stackoverflow.com/questions/42193716/datatype-for-country-in-mysql
-- 4. https://sql.toad.cz/?keyword=default
-- 5. https://stackoverflow.com/questions/51463706/can-somebody-give-a-practical-example-of-a-many-to-many-relationship
-- 6. Reference OWASP documentation

-- create countries table (seeded)
drop table if exists countries cascade;
create table if not exists countries(
	country_id uuid default gen_random_uuid() primary key,
	country_code varchar(10) unique not null,
	country_name varchar(100) unique not null
);

-- create leagues table (seeded)
drop table if exists leagues cascade;
create table if not exists leagues(
	league_id uuid default gen_random_uuid() primary key,
	league_name varchar(100) not null,
    country_id uuid references countries(country_id) not null
);

-- create seasons years (seeded)
drop table if exists seasons cascade;
create table if not exists seasons(
	season_id uuid default gen_random_uuid() primary key,
	start_year int not null,
	end_year int check (end_year > start_year) not null
);

-- create players table (seeded)
drop table if exists players cascade;
create table if not exists players(
	player_id uuid default gen_random_uuid() primary key,
	name varchar(100) not null,
	position varchar(5) not null,
	height_cm int not null,
	weight_kg decimal(5, 2) not null

    -- drop column and change to foreign key
	nationality varchar(50) not null,
);

-- create teams table
drop table if exists teams cascade;
create table if not exists teams(
	team_id uuid default gen_random_uuid() primary key,
	name varchar(100) not null,
    league_id uuid references leagues(league_id) not null
);

-- create player statistics table
drop table if exists player_statistics cascade;
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
drop table if exists matches cascade;
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

-- updated following constraints after running sql above
alter table countries 
alter column country_name drop not null;

alter table leagues 
add constraint unique_league_name unique(league_name);

alter table leagues
add column division varchar(100) not null;

alter table seasons
add column years_interval varchar(50) not null unique;

-- find the constraint name and drop unique constrain from country_name col
SELECT conname
FROM pg_constraint
WHERE conrelid = 'countries'::regclass
AND contype = 'u';

alter table countries
drop constraint countries_country_name_key;

-- drop nationality column from players and add new foreign key
alter table players
drop column nationality;

alter table players
add column country_id uuid not null references countries(country_id);

-- drop height_cm and re-add col with new data type
alter table players
drop column height_cm;

alter table players
add column height_cm numeric(5,2);

alter table players
drop column weight_kg;

alter table players
add column weight_kg numeric(5,2);

-- create teams_statistics table: (dont have data for this table, will wait on creating)
-- create table if not exists team_statistics()

