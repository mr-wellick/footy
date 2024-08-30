library(rvest)
library(tibble)
library(dplyr)
library(stringr)
library(tidyr)
library(countrycode)
library(httr)

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
domestic_leagues = all_metadata %>% filter(!is.na(team_id)) %>% filter(nchar(country_code) <= 3)
domestic_leagues$league_name %>% unique()
domestic_leagues$country_code %>% unique() %>% tolower()

####################################################################

# construct url for squad list
squads = sapply(domestic_leagues$team_url, function(item){
  sub("team", "team/squad", item)
}) %>% tibble()
colnames(squads) = "squad_url"

# get years for all squads
squads_for_each_season = lapply(squads$squad_url, function(url) {
  result = squad_scraper(url)
  Sys.sleep(runif(1, min = 3, max = 10))  # Random delay
  return(result)
})



