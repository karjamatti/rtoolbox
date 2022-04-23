add_prefix_to_cols = function(data, prefix, ...){
  
  # Ellipsis allows exclusion of columns
  data %>% dplyr::rename_with(.fn = ~ glue::glue('{prefix}_{.x}'), .cols = -c(...)) 
  
}


col2string = function(tib, column){
  
  tib %>% dplyr::filter(!is.na({{column}})) %>% dplyr::pull({{column}}) %>% unique() %>% sprintf(fmt = "'%s'") %>% toString()
  
}
