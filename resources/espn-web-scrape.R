library(rvest)
library(tibble)
library(dplyr)
library(stringr)
library(tidyr)
library(countrycode)
library(httr)
library(tidyverse)
library(purrr)
library(vctrs)

# urls
base_url = "https://www.espn.com"
endpoint = "/soccer/teams/_/league/usa.1"
url = base_url + enpoint
html = read_html(url)

# extract all data-url attribute from html option element (this is the enpoint, like above, that we need for each league)
leagues = html %>%
  html_element("#fittPageContainer .dropdown__select") %>%
  html_elements("option") %>% 
  html_attr("data-url")

# construct all enpoints using base url and endpoint
leagues = lapply(leagues, function(item) { 
  paste(base_url, item, sep = "")
  }) %>% unlist()

# extract all value attributes from html option element
league_metadata = html %>%
  html_element("#fittPageContainer .dropdown__select") %>%
  html_elements("option") %>% 
  html_attr("value")

# value attributes from above are in the following format: XXX.XXX.XXX.XXX
# here, we split string at "." and create a new tible piece of the string (4 pieces)
league_metadata = sapply(league_metadata, function(name){ str_split(name, "\\.") }) %>% 
                  tibble() %>% 
                  unnest_wider(1, 'col')

colnames(league_metadata) = c("league", "division", "col_three", "col_four")

# using country code, get country names
country_name = countrycode(league_metadata$league, origin = 'iso3c', "country.name")

# add country name and leagues columns
league_metadata = tibble(
                    leagues, # change col name
                    league_metadata, 
                    country_name
                  )

# only consider obs that have league
league_metadata %>% filter(is.na(col_three) & is.na(col_four), !is.na(country_name))

# split(league_metadata, ceiling(seq(nrow(league_metadata))/30))


####################################################################

# error handling to avoid 503 status code
teams = sapply(league_metadata$leagues, function(url) {
    result = scrape_url(url)
    Sys.sleep(runif(1, min = 3, max = 10))  # Random delay
    return(result)
})

test = lapply(names(teams), function(name){
  tibble(league_url = name, team_url = teams[name])
}) %>% bind_rows()

test = test %>% unnest_longer(2)

division_data = sapply(test$league_url, function(item){ 
    item %>% 
    str_remove("https://www.espn.com/soccer/teams/_/league/") %>%
    str_extract("^[^/]+")
    # %>% str_split("\\.") 
  }) %>% tibble()

all_metadata = tibble(test, division_data)
colnames(all_metadata)[3] = "division"

# add new columns
all_metadata$league_name = all_metadata$league_url %>% str_extract("[^/]+$") %>% str_replace_all("-", " ")
all_metadata$team_id  = all_metadata$team_url %>% str_extract("\\d+")
all_metadata$team_name = all_metadata$team_url %>% str_extract("[^/]+$") %>% str_replace_all("-", " ")
all_metadata$country_code = all_metadata$division %>% str_extract("\\w+")
all_metadata$country_name = countrycode(all_metadata$country_code, origin = 'iso3c', "country.name")

# filter all_metadata
domestic_leagues = all_metadata %>% filter(!is.na(team_id)) %>% filter(nchar(division) <= 5)
domestic_leagues$league_name %>% unique()
domestic_leagues$country_code %>% unique() %>% tolower()

####################################################################

# construct url for squad list
squads = sapply(domestic_leagues$team_url, function(item){
  sub("team", "team/squad", item)
}) %>% tibble()
colnames(squads) = "squad_url"

# get years for all squads
squads_for_each_season = sapply(squads$squad_url %>% unique(), function(url) {
  result = squad_scraper(url)
  Sys.sleep(runif(1, min = 3, max = 10))  # Random delay
  return(result)
})

####################################################################

# get all squads for all available seasons for each team
season_yrs = squads_for_each_season %>% tibble() 
season_yrs$url = names(squads_for_each_season)
colnames(season_yrs) = c("year", "url")

season_yrs = unnest_longer(season_yrs, 1)
season_yrs$full_url = paste(season_yrs$url, season_yrs$year, sep = "/")

####################################################################
players = sapply(season_yrs$full_url, player_scraper)

# drop items in list that are empty
players_filtered = list_drop_empty(players)

# convert all columns to character data type
test_df = map(players_filtered, function(item){ 
  map(item, function(df) { df %>% discard(~all(is.na(.))) %>% mutate(across(everything(), as.character)) })
})

# each list item contains two tibbles. combine both tibbles into one
test_df_fixed = map(test_df, function(tibble_list){ bind_rows(tibble_list) })

# rename columns
col_names = c(
  "name", "position", 
  "age", "height", "weight", 
  "nationality", "appearances", "substitutions", 
  "saves", "goals_against", "assists", 
  "fouls_committed", "fouls_against", "yellow_cards", 
  "red_cards", "goals", 
  "shots", "shots_on_target"
)

test_df_fixed = map(test_df_fixed, function(tibble_list){ 
  colnames(tibble_list) = col_names
  return(tibble_list)
})

# create a single data frame from list
test_df_fixed = map_df(test_df_fixed, data.frame, .id = 'url')

# create new columns
test_df_fixed$number = test_df_fixed$name %>% str_extract("\\d+")
test_df_fixed$full_name = test_df_fixed$name %>% str_extract_all("[A-Za-z]+") %>% map_chr(~str_c(., collapse = " "))

# create more columns
team_info_regex = "https://www\\.espn\\.com/soccer/team/squad/_/id/\\d+/([^/]+)/([0-9]{4})"
team_col = test_df_fixed$url %>% str_match(team_info_regex)

test_df_fixed$team_name = team_col[,2]
test_df_fixed$seasom = team_col[,3] %>% as.numeric()

test_df_fixed = test_df_fixed %>% mutate(year_range = paste(seasom, seasom + 1, sep = "-"))
# create cols: start_year and end_year
#test_df_fixed$year_range %>% str_match("(\\d{4})-(\\d{4})")
