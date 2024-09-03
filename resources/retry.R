scrape_url = function(url) {
  # Set a user-agent
  user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
  
  attempt = 1
  max_attempts = 3
  
  while(attempt <= max_attempts) {
    tryCatch({
      page = read_html(httr::GET(url, user_agent(user_agent)))
      result = page %>% html_elements(".TeamLinks") %>% html_elements("a") %>% html_attr("href")
      # filter out urls that match pattern
      result = result[grep("/soccer/team/_/id*", result)] %>% unique()
      return(paste(base_url, result, sep = ""))
      
    }, error = function(cond){
      message(cond)
      message(paste("Attempt", attempt, "failed for", url))
      Sys.sleep(runif(1, min = 3, max = 10))  # random delay between 3 to 30 seconds
    })
    attempt = attempt + 1
  }
  
  message(paste("exceeded max_attempts", url))
  return(NULL)
}

lapply(squads$squad_url[9], function(item) {
  page = read_html(item)
  years = page %>% html_elements("#fittPageContainer :nth-child(3) .dropdown__select")
  years[1] %>% html_elements("option") %>% html_attr("value")
}) %>% tibble()


squad_scraper = function(url) {
  # Set a user-agent
  user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
  
  attempt = 1
  max_attempts = 2
  
  while(attempt <= max_attempts) {
    tryCatch({
      message("processing: ", url)
      page = read_html(httr::GET(url, user_agent(user_agent)))
      result = page %>% html_elements("#fittPageContainer :nth-child(3) .dropdown__select")
      result = result[1] %>% html_elements("option") %>% html_attr("value")
      
      return(result)
    }, error = function(cond){
      message(cond)
      message(paste("Attempt", attempt, "failed for", url))
      Sys.sleep(runif(1, min = 3, max = 10))  # random delay between 3 to 30 seconds
    })
    attempt = attempt + 1
  }
  
  message(paste("exceeded max_attempts", url))
  return(NULL)
} 

player_scraper = function(url){
  user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
  
  attempt = 1
  max_attempts = 2
  
  while(attempt <= max_attempts) {
    tryCatch({
      message("processing: ", url)
      page = read_html(httr::GET(url, user_agent(user_agent)))
      result = page %>% html_elements(".Roster__MixedTable") %>% html_table(header = T)
      
      return(result)
    }, error = function(cond){
      message(cond)
      message(paste("Attempt", attempt, "failed for", url))
      Sys.sleep(runif(1, min = 3, max = 10))  # random delay between 3 to 30 seconds
    })
    attempt = attempt + 1
  }
  
  message(paste("exceeded max_attempts", url))
  return(NULL)
}
