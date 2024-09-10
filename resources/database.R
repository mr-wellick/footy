library(DBI)
library(RPostgres)
library(tibble)
library(dplyr)
library(nanoarrow)
library(purrr)
library(stringr)

readRenviron("~/Repos/footy/.env")

cn = dbConnect(
  RPostgres::Postgres(),
  dbname = "footy_statistics",
  host = "localhost",
  port = "5432",
  user = "postgres",
  password = Sys.getenv("DATABASE_PASSWORD")
)

# inspect db tables
#dbListTables(cn)
#dbReadTable(cn, "countries") %>% tibble()
#
######## seed countries table
#dbAppendTable(
#  cn, 
#  'countries',
#  domestic_leagues %>% select(country_code, country_name) %>% unique()
#)

####### reseed: countries

# create new column for country codes
test_df_fixed$country_code = countrycode(test_df_fixed$nationality, "country.name", "iso3c")

# following country codes did not return a country name when using package countrycode package
test_df_fixed %>% select(nationality, country_code) %>% filter(is.na(country_code)) %>% unique()

country_mapping = tibble(
  country_code = c("GB-ENG", "GB-WLS", "GB-SCT", "GB-NIR", "XKX"),
  nationality = c("England", "Wales", "Scotland", "Northern Ireland", "Kosovo")
)

# all country codes now have a country name
countries = test_df_fixed %>% left_join(country_mapping, by = "nationality")
countries = countries %>% mutate(country_code = coalesce(country_code.x, country_code.y))

countries = countries %>% 
            mutate(country_code = replace_na(country_code, "unkown")) %>% 
            mutate(nationality = ifelse(nationality == "--", "unknown", nationality))

dbReadTable(cn, "countries") %>% tibble()
dbAppendTable(
  cn, 
  'countries',
  countries %>% select(country_code, nationality) %>% unique() %>% rename(country_name = nationality)
)

####### leagues

# But first:
# ESPN data is inconsistent:
#   - We have multiple country codes for a few countries.
#   - For example, Germany has two country codes: GER and DEU.
#
# To fix, we add both values into countries database since the table is small

# SKIP THIS STEP FOR NOW

#missing_countries_in_db = setdiff(
#  domestic_leagues %>% select(country_code, country_name) %>% unique(),
#  dbReadTable(cn, "countries") %>% select(country_code, country_name)
#)
#
#missing_countries_mapping = tibble(
#  country_code = c("ENG", "GER", "NED", "POR", "KSA", "SCO", "GRE", "SUI", "DEN", 
#                   "WAL", "NIR", "CHI", "URU", "PAR", "HON", "CRC", "GUA", "RSA", "ZAM", "ZIM"),
#  country_name = c("England", "Germany", "Netherlands", "Portugal", "Saudi Arabia", 
#                          "Scotland", "Greece", "Switzerland", "Denmark", "Wales", 
#                          "Northern Ireland", "Chile", "Uruguay", "Paraguay", "Honduras", "Costa Rica", 
#                          "Guatemala", "South Africa", "Zambia", "Zimbabwe")
#)
#
#dbAppendTable(
#  cn,
#  "countries",
#  missing_countries_in_db %>% 
#    left_join(missing_countries_mapping, by = "country_code") %>% 
#    rename(country_name = country_name.y) %>% 
#    select(country_code, country_name) %>% 
#    filter(!is.na(country_name))
#)

# seed leagues table

# note: issues with country codes (for example, Germany -> DUE or GER)
dbReadTable(cn, "leagues") %>% tibble()

data_for_leagues_table_in_db = pmap(
  # get unique league names
  domestic_leagues %>% select(league_name, country_code, division) %>% unique(), 
  function(league_name, country_code, division) { 
    temp = dbGetQuery(cn, str_glue("select * from countries where country_code like '%{country_code}%'"))
    tryCatch({
      temp$league_name = league_name
      temp$division = division
      
      return(temp)
    }, error = function(e){
      message("issue with following country_code: ", country_code)
      
      return(data.frame(country_id = NA, country_code, country_name = NA, league_name ,division))
    })
}) %>% bind_rows() %>% tibble()

# the following leagues were not inserted into db
missing_country_name = data_for_leagues_table_in_db %>% filter(is.na(country_name))

# SKIP THIS STEP FOR NOW
#missing_leagues_for_tabl_in_db = pmap(
#  missing_country_name %>% select(league_name, country_code, division), 
#  function(league_name, country_code, division){
#    tryCatch({
#      temp = dbGetQuery(cn, str_glue("select * from countries where country_name ilike '{country_code}%' or country_code ilike '{country_code}%'"))
#      temp$league_name = league_name
#      temp$division = division
#      return(temp)
#    }, error = function(e){
#      message("issue with following country_code: ", country_code)
#      
#      return(data.frame(country_id = NA, country_code, country_name = NA, league_name ,division))
#    })
#  
#}) %>% bind_rows() %>% tibble()


# seed leagues table
dbAppendTable(
  cn,
  "leagues",
  data_for_leagues_table_in_db %>% filter(!is.na(country_name)) %>% select(league_name, country_id, division) 
)

####### seed seasons table

# create cols: start_year and end_year
season_yrs_data_for_table_in_db = test_df_fixed$year_range %>% str_match("(\\d{4})-(\\d{4})")
season_yrs_data_for_table_in_db = tibble(
  years_interval = season_yrs_data_for_table_in_db[,1], 
  start_year = season_yrs_data_for_table_in_db[,2], 
  end_year = season_yrs_data_for_table_in_db[,3]) %>% unique()

dbAppendTable(
  cn, 
  "seasons",
  season_yrs_data_for_table_in_db
)

####### seed players table
dbReadTable(cn, "players")

players_data_for_table_in_db = test_df_fixed %>% 
  select(full_name, nationality, position, height, weight) %>%
  mutate(across(everything(), ~ ifelse(trimws(.) == "", NA, .))) %>% # get rid of spaces or empty string
  mutate(across(everything(), ~ifelse(. %in% c("--"), NA, .))
) %>% tibble()

convert_to_cm = function(height_str) {
  feet = as.numeric(str_extract(height_str, "^[0-9]+"))
  inches = as.numeric(str_extract(height_str, "(?<=') [0-9]+"))
  
  height_cm = (feet * 30.48) + (inches * 2.54)
  return(height_cm)
}

players_data_for_table_in_db = players_data_for_table_in_db %>% 
  mutate(height_cm = sapply(height, convert_to_cm))

convert_to_kg = function(weight_str) {
  weight_lbs = as.numeric(str_remove(weight_str, " lbs"))
  weight_kg = weight_lbs * 0.453592
  return(weight_kg)
}

players_data_for_table_in_db = players_data_for_table_in_db %>% 
  mutate(weight_kg = sapply(weight, convert_to_kg))

players_test = pmap(
  players_data_for_table_in_db[,-c(4,5)] %>%  distinct(full_name, .keep_all = T),
  function(full_name, nationality, position, height_cm, weight_kg){
    tryCatch({
      db_result = dbGetQuery(cn, str_glue("select * from countries where country_name ='{nationality}'"))
      temp = tibble(name = full_name, position, height_cm, weight_kg, country_id = db_result$country_id,)
      return(temp)
    }, error = function(e){
      message("error retrieving nationality for: ", full_name)
    })
    
    return(tibble(name = full_name, position, height_cm, weight_kg, country_id = NULL))
  }
)

players_test = players_test %>% 
  bind_rows() %>% 
  mutate(height_cm = as.numeric(height_cm), weight_kg = as.numeric(weight_kg)) %>% 
  mutate(height_cm = round(height_cm, 2), weight_kg = round(weight_kg, 2))

dbAppendTable(
  cn,
  "players",
  players_test
)
