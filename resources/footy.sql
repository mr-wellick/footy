-- 1. https://supabase.com/blog/choosing-a-postgres-primary-key
-- 2. https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-UNIQUE-CONSTRAINTS
-- 3. https://stackoverflow.com/questions/42193716/datatype-for-country-in-mysql
-- 4. https://sql.toad.cz/?keyword=default
-- 5. https://stackoverflow.com/questions/51463706/can-somebody-give-a-practical-example-of-a-many-to-many-relationship

-- Note: look at uuid postgres docs

-- create user tables
create table if not exists users (
   /* 
        A primary key constraint indicates that a column, or group of columns, can be used as a unique identifier for rows in the table. 
        This requires that the values be both unique and not null.
   */
   /* 
        Adding a primary key will automatically create a unique B-tree index on the column or group of columns 
        listed in the primary key, and will force the column(s) to be marked NOT NULL. 
   */
    -- Relational database theory dictates that every table must have a primary key. This rule is not enforced by PostgreSQL, but it is usually best to follow it.
	user_id uuid default gen_random_uuid() primary key,
    -- Adding a unique constraint will automatically create a unique B-tree index on the column or group of columns listed in the constraint
	user_email varchar(255) unique not null, -- https://www.postgresql.org/docs/current/citext.html
    user_password varchar(128) not null
    password varchar(128) not null
) 
select * from users;

-- country codes table
create table if not exists country_codes(
	country_code varchar(2) primary key,
	country_name varchar(55)  not null unique
)
select * from country_codes;

-- leagues table
create table if not exists leagues(
	league_id uuid default gen_random_uuid() primary key,
	league_name varchar(55) not null unique,
	country_code varchar(2) references country_codes(country_code)
)
select * from leagues;

-- teams table
create table if not exists teams(
	team_id uuid default gen_random_uuid() primary key,
	league_id uuid references leagues(league_id)
)
select * from teams;

-- matches table
create table if not exists matches(
    match_id uuid primary key default gen_random_uuid(),
    -- read postgres docs to figure which data type to use for time
    match_date timestamp not null,
    home_score int not null,
    away_score int not null,
    home_team uuid references teams(team_id),
    away_team uuid references teams(team_id)
)
select * from matches;