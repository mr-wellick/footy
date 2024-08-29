library(rvest)
library(tibble)
library(dplyr)
library(stringr)
library(tidyr)
library(countrycode)

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


####################################################################

# retrieve html page for each URL in leagues
teams = sapply(league_metadata$leagues, function(league_url){ read_html(league_url) })


# need to figure out a way to process this 
# in batches to avoid HTTP Status Code 503 (service unavailabe)
sapply(league_metadata$leagues, function(league_url){ league_url })



