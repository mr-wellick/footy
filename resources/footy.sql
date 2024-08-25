-- 1. https://supabase.com/blog/choosing-a-postgres-primary-key
-- 2. https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-UNIQUE-CONSTRAINTS
-- 3. https://stackoverflow.com/questions/42193716/datatype-for-country-in-mysql
-- 4. https://sql.toad.cz/?keyword=default
-- 5. https://stackoverflow.com/questions/51463706/can-somebody-give-a-practical-example-of-a-many-to-many-relationship
-- 6. Reference OWASP documentation

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
-- todo: need to run a migration
create table if not exists teams(
	team_id uuid default gen_random_uuid() primary key,
    team_name varchar(55) not null unique,
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

-- TODO
-- players table
-- note, we will be storing player stats for multiple seasons
-- how to query for season 2003-200?
-- can query for a single player stats across x years
-- can query for an entire team's stats for x years
--create table players(
--    player_id int primary key,
--    name text,
--)
--
--create table statistics(
--    stat_id int primary key,
--    player_id references players(player_id),
--    team_id int references teams(team_id),
--    from text,
--    to text,
--    pos text,
--    age int,
--    ht int,
--    wt int,
--    nat text,
--    app int ,
--    sub int,
--    g int,
--    a int,
--    sh int,
--    st int,
--    fc int,
--    fa int,
--    yc int,
--    rc int,
--)

-- favorites table
-- link table aka association table. Example of a User and Favourite sounds like M:M relationship.
--create table if not exists favorites(
--    favorite_id integer primary key,
--    user_id uuid references users(user_id),
--    team_id integer references teams(team_id)
--)


/*
    database migration ran after creating tables above
*/
select * from country_codes;

-- query to list all tables that have a foreign key
SELECT
    conname AS constraint_name,
    conrelid::regclass AS table_name,
    a.attname AS column_name
FROM
    pg_constraint AS c
    JOIN pg_attribute AS a ON a.attnum = ANY(c.conkey) AND a.attrelid = c.conrelid
    JOIN pg_class AS cl ON cl.oid = c.conrelid
WHERE
    c.confrelid = 'country_codes'::regclass
    AND c.confkey @> ARRAY[(SELECT attnum FROM pg_attribute WHERE attrelid = 'country_codes'::regclass AND attname = 'country_code')];

-- steps to update data type on a primary key (which is referenced in other tables: foreign key)

-- 1. drop foreign key constraint

select * from leagues;

-- list all constraints in leagues
SELECT conname
FROM pg_constraint
WHERE conrelid = 'leagues'::regclass;

begin; -- transaction rollback (simulating a Dry Run)
	alter table leagues drop constraint leagues_country_code_fkey;
rollback;

alter table leagues drop constraint leagues_country_code_fkey;

-- 2. drop primary key constraint in country_codes
begin;
	alter table country_codes drop constraint country_codes_pkey;
rollback;

alter table country_codes drop constraint country_codes_pkey;

SELECT conname
FROM pg_constraint
WHERE conrelid = 'country_codes'::regclass;

-- 3. update data type for primary key in country_codes
select * from country_codes;

begin;
	alter table country_codes alter column country_code type varchar(3) using country_code::varchar(3);
rollback;

alter table country_codes alter column country_code type varchar(3) using country_code::varchar(3);

-- 4. Recreate primary key constraint
begin;
	alter table country_codes add constraint country_codes_pkey primary key (country_code);
rollback;

alter table country_codes add constraint country_codes_pkey primary key (country_code);

-- 5. Update the foreign key columns’ data type in the dependent tables
select * from leagues;

begin;
	alter table leagues alter column country_code type varchar(3) using country_code::varchar(3);
rollback;

alter table leagues alter column country_code type varchar(3) using country_code::varchar(3);

-- 6. Recreate the foreign key constraints
SELECT conname
FROM pg_constraint
WHERE conrelid = 'leagues'::regclass;

begin;
	alter table leagues add constraint leagues_country_code_fkey foreign key (country_code) references country_codes(country_code);
rollback;

alter table leagues add constraint leagues_country_code_fkey foreign key (country_code) references country_codes(country_code);

select * from leagues;






