library(DBI)
library(RPostgres)
library(tibble)
library(dplyr)
library(rvest)
library(stringr)
library(plyr)
library(tidyr)
library(purrr)


# init db
readRenviron("~/Repos/footy/.env")
cn = dbConnect(
  RPostgres::Postgres(), 
  dbname = 'footy', 
  host ="localhost",
  port = "5432",
  user = "postgres",
  password = Sys.getenv("DATABASE_PASSWORD")
)

# inspect db
dbListTables(cn)
dbReadTable(cn, 'country_codes') %>% tibble()
dbReadTable(cn, 'leagues') %>% tibble()

# get all html pages
pages = lapply(complete_leagues_df$url, read_html)

# get all teams
parsePage = function(page, index){
  tibble(
    page %>% html_elements('.h5') %>% html_text(),
    page %>% html_element('title') %>% html_text() %>% str_replace(' Teams - ESPN', ''),
    complete_leagues_df$ur[index]
  )
}


league_dfs = pages %>% lapply(parsePage) %>% ldply(tibble)
colnames(league_dfs) = c("team_name", "league_name")
View(league_dfs)

league_dfs$league_name %>% unique()
complete_leagues_df$url

# try this one
test = imap(pages, function(page, index) {
  new_cols = complete_leagues_df$url[index] %>% strsplit("/") %>% unlist() %>%  tail(n = 1) %>% strsplit('\\.') 
  tibble(
    page %>% html_elements('.h5') %>% html_text(),
    page %>% html_element('title') %>% html_text() %>% str_replace(' Teams - ESPN', ''),
    new_cols
  )
}) %>% ldply(tibble)

test = unnest_wider(test, col = 3, names_sep = 'data')
colnames(test) = c("team_name", "league_name", "country_code", "league_division")

# seed leagues database
dbAppendTable(
  cn, 
  'leagues',
  test %>% select(league_name:league_division) %>% unique()
)
dbReadTable(cn, 'leagues') %>% tibble()


# teams
dbReadTable(cn, 'teams') %>% tibble()
dbGetQuery(cn, 'select * from leagues')

league_ids = lapply(test$league_name, function(col){
  dbGetQuery(cn, str_glue("select league_id from leagues where league_name = '{col}';"))
}) %>% unlist(use.names = F)

test$league_id = league_ids

# seed teams database
dbAppendTable(
  cn, 
  'teams',
  test %>% select(league_id, team_name)
)
dbReadTable(cn, 'teams') %>% tibble()


