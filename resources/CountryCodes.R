library("rvest")
library("stringr")
library("tidyr")
library("dplyr")
library("plyr")
library("countrycode")

# web-scrape country codes
url = "https://www.espn.com/soccer/competitions"
html = read_html(url)

# extract urls
leagues = html %>% 
    html_elements(".nowrap:nth-child(2) .AnchorLink") %>% 
    html_attr('href')

# create data frame
league_df = leagues %>% unique() %>% tibble()
colnames(league_df) = c("url")
View(league_df)

# check urls that don't have this path in url: soccer/teams/_/league
league_df %>% filter(!str_detect(url, "(soccer/teams/_/league)"))

league_df = league_df %>% filter(str_detect(url, "(soccer/teams/_/league)"))
View(league_df)

# create new columns: region, division
# note: need to categorize 
league_names_from_url = sapply(
                          league_df$url, 
                          function(item){ str_split(item, "/") %>% tail(2)}
                       ) %>% 
                      lapply(
                        function(item) { tail(item, 1) }
                      ) %>% 
                      unlist(use.names = F)

# add league column
league_df$league = league_names_from_url
View(league_df)

# gather league information into a list
league_metadata_df = lapply(league_df$league, function(item) {
  item %>% str_split("\\.")
}) %>% ldply(tibble)
league_metadata_df = bind_cols(league_df, league_metadata_df)
View(league_metadata_df)

# unesting list a creating a new dataframe
league_metadata_df = league_metadata_df %>% unnest_wider(col = 3, names_sep = "league")
league_metadata_df

# show all regions/leagues
league_metadata_df$`<list>league1` %>% unique()

# only look at cols 1,2
filter(
  league_metadata_df, 
  is.na(league_metadata_df$`<list>league3`) & is.na(league_metadata_df$`<list>league4`) 
)

## Will exclude these entries

# only look at cols: 1,2,3
filter(
  league_metadata_df, 
  !is.na(league_metadata_df$`<list>league3`) & is.na(league_metadata_df$`<list>league4`) 
) 

# only look at cols: 1,2,3,4
filter(
  league_metadata_df, 
  !is.na(league_metadata_df$`<list>league3`) & !is.na(league_metadata_df$`<list>league4`) 
)

# included leagues
included_leagues_df = filter(
  league_metadata_df, 
  is.na(league_metadata_df$`<list>league3`) & is.na(league_metadata_df$`<list>league4`) 
)
colnames(included_leagues_df) = c("url", "full_league_name", "league", 'division')

# drop cols with NA
included_leagues_df = included_leagues_df %>% select(where(~!all(is.na(.))))
View(included_leagues_df)

# look at country codes only
filtered_leagues_df = filter(included_leagues_df, nchar(league) <= 3 & nchar(division) == 1)

filtered_leagues_df$country_name = filtered_leagues_df$league %>% 
                                  countrycode::countrycode(origin = 'iso3c', "country.name")

# obs with NA
incomplete_leagues_df = filtered_leagues_df[!complete.cases(filtered_leagues_df), ]

# obs with NA
complete_leagues_df = filtered_leagues_df %>% na.omit()
colnames(complete_leagues_df)[3] = "country_code"












