library(DBI)
library(RPostgres)
library(ggplot2)
library(tibble)
library(dplyr)
library(rvest)
library(stringr)

readRenviron("~/Repos/footy/.env")

cn = dbConnect(
  RPostgres::Postgres(), 
  dbname = 'footy', 
  host ="localhost",
  port = "5432",
  user = "postgres",
  password = Sys.getenv("DATABASE_PASSWORD")
)

# inspect db tables 
dbListTables(cn)
dbReadTable(cn, 'country_codes') %>% tibble()
dbReadTable(cn, 'leagues') %>% tibble()

# get html page for each url in complete_leagues_df
html_pages = lapply(complete_leagues_df$url, read_html)

# leauge name
league_name = html_page[[1]] %>% html_element('title') %>% html_text() %>% str_replace(' Teams - ESPN', '')

teams = html_page[[1]] %>% 
  html_elements("#fittPageContainer .pl3 :nth-child(1)") %>% 
  html_attr("href") %>% 
  na.omit() %>% 
  matrix(ncol = 3, byrow = T) %>% 
  as_tibble()

colnames(teams) = c("team", "fixtures", "stats")

# extract text
#league_data_urls = html_page[[1]] %>% 
#  html_elements("#fittPageContainer .dropdown__select") %>% 
#  html_elements('option') %>% html_attr('data-url')

# extract team names
teams_names = teams$team %>% strsplit('/') %>% lapply(last) %>% unlist()
team_names_df = tibble(teams_names, league_name)
