makedir = function(dir){
  
  dir.create(dir)
  warning(glue('Directory {dir} not found, but successfully created.'))
  
}


lazyRDS = function(object_, dir = './data/rds', verbose = FALSE){
  
  if (!dir.exists(dir)) makedir(dir)
  
  object_ = substitute(object_)
  
  if (exists(deparse(object_))){
    
    if (verbose) print(glue('Object {deparse(object_)} already in environment'))
    
  } else {
    
    if (verbose) print(glue('Reading {deparse(object_)}.rds from {dir}'))
    assign(deparse(object_), readRDS(glue('{dir}/{deparse(object_)}.rds')), envir = .GlobalEnv)
    
  }
  
}


updateRDS = function(object_, dir = './data/rds'){
  
  if (!dir.exists(dir)) makedir(dir)
  
  content = object_
  object_ = substitute(object_)
  saveRDS(content, file = glue('{dir}/{deparse(object_)}.rds'))
  
}


readdata = function(x, hdr = TRUE, skips = 0, encoding = 'Latin-1', drop_empty_ = TRUE, fix_names_ = TRUE){
  
  # Wrapper for fread
  out_ = fread(x, sep=',', header = hdr, stringsAsFactors = F, encoding = encoding, skip = skips)
  if (fix_names_) out_ = janitor::clean_names(out_) 
  out_  = tibble(out_)
  if (drop_empty_) out_ = out_ %>% dplyr::select(!matches("v\\d+"))
  return(out_)
  
}


get_latest_filename = function(filename, filedir = './data'){
  
  list.files(path = filedir, pattern = glob2rx(filename), full.names = TRUE) %>% sort() %>% last() 
  
}


get_latest_data = function(filename, filedir = './data', encoding = 'Latin-1', hdr = TRUE, skips = 0, verbose = TRUE, drop_empty = TRUE, fix_names = TRUE){
  
  # Get the latest file matching the regex in specified directory
  filename = get_latest_filename(filename, filedir)
  if (verbose) {cat(crayon::cyan(glue('Latest available data is: {filename}'))); cat('\n')}
  data = filename %>% readdata(hdr = hdr, encoding = encoding, skips = skips, drop_empty_ = drop_empty, fix_names_ = fix_names)
  return(data)
  
}


excel_to_csv = function(directory){
  
  'main_dir' %global% getwd()
  setwd(directory)
  xls = dir(pattern = "xlsx")
  
  if (length(xls) != 0){
    created = mapply(rio::convert, xls, gsub("xlsx", "csv", xls))
    unlink(xls) # delete xlsx files  
  } else warning('No excel files found.') 
  
  setwd(main_dir)
  
}
