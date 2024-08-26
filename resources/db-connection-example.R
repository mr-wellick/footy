# install.packages("DBI")
# install.packages("RPostgres")

library(DBI)
library(RPostgres)
library(ggplot2)
library(tibble)
library(dplyr)

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

# seed country_codes table
dbAppendTable(
  cn, 
  'country_codes', 
  complete_leagues_df %>% select(country_code, country_name) %>% unique()
)
dbReadTable(cn, 'country_codes') %>% tibble()


