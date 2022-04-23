last = function(vec, n = 1){
  
  # Get last element of vector or list
  if (class(vec) == 'list' & n != 1) stop('Multiple elements not supported for lists')
  if (class(vec) == 'list') return(vec[[length(vec)]]) else return(vec[(length(vec) - n + 1):length(vec)])  
  
}


chunk = function(vec, chunksize = 50){
  
  split(vec, ceiling(seq_along(vec)/chunksize))
  
}


minus = function(vec){
  
  -vec

} 


na2zero = function(vec){
  
  ifelse(is.na(vec), 0, vec)

}


na2emptystr = function(vec){
  
  ifelse(is.na(vec), '', vec)
  
}


has_all = function(vec, ...){
  
  purrr::map(vec, function(x) all(stringr::str_detect(x, c(...)))) %>% unlist()
  
}


has_any = function(vec, ...){
  
  stringr::str_detect(vec, paste(c(...), collapse = '|'))

}


strip_scandinavian = function(vec){
  
  vec %>% enc2utf8() %>% iconv(from = "UTF-8", to = "ASCII//TRANSLIT")
  
}


strip_copyright_sign = function(vec){
  
  vec %>% stringr::str_replace_all('\\(P\\) |\\(C\\) |\\u00AE |\\u00a9 |\\u2122 |\\u2117 ' , '')
   
}

first_non_na = function(vec){
  
  c(vec, NA) %>% .[!is.na(.)] %>% first()

}
