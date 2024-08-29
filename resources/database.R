library(DBI)
library(RPostgres)
library(tibble)
library(dplyr)

readRenviron("~/Repos/footy/.env")

cn = dbConnect(
  RPostgres::Postgres(),
  dbname = "footy",
  host = "localhost",
  port = "5432",
  user = "postgres",
  password = Sys.getenv("DATABASE_PASSWORD")
)

# inspect db tables
dbListTables(cn)
dbReadTable(cn, "country_codes") %>% tibble()