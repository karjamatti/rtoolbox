source('~/Projects/secrets.R')
use('httr')
use('jsonlite')


get_header_token = function(){
  
  response = POST(
    'https://accounts.spotify.com/api/token',
    accept_json(),
    authenticate(clientID, secret),
    body = list(grant_type = 'client_credentials'),
    encode = 'form',
    verbose()
  )
  
  mytoken = content(response)$access_token
  HeaderValue = paste0('Bearer ', mytoken)
  
  return(HeaderValue)
  
}


print_msg_and_sleep = function(resp){
  
  slp = as.numeric(resp$headers$`retry-after`) + 1
  cat(crayon::blue('Sleeping for {slp} seconds...' %>% glue()))
  Sys.sleep(slp)
  
}

get_response = function(f, ...){
  
  resp = f(...)
  
  if (resp$status_code == 429) {
    
    print_msg_and_sleep(resp)
    resp = f(...)
    
  }  
  
  if (resp$status_code == 504) {
    
    Sys.sleep(2)
    resp = f(...)
    
  }  
  
  while (length(resp$content) == 0) {
    
    Sys.sleep(2)
    resp = f(...)
    
  } 
  
  return(resp)
  
}
