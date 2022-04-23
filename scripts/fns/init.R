use = function(library, repo = getOption('repos'), suppress = TRUE){
  
  # This function first tries to load a package, and installs it if necessary
  if (suppress){
    if(!is.element(library, .packages(all.available = TRUE))) {suppressMessages(install.packages(library))}
    suppressMessages(library(library,character.only = TRUE))  
  } else {
    if(!is.element(library, .packages(all.available = TRUE))) {install.packages(library)}
    library(library,character.only = TRUE)
  }
  
}


get_src_list = function(path = './scripts/src'){
  
  sort(
    list.files(
      path, 
      pattern = '\\d{2}.*.R', 
      full.names = TRUE
    )
  )
  
}
