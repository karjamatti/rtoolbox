`%notin%` = Negate(`%in%`)

`%global%` = function(var.name, var.value){
  
  assign(deparse(substitute(var.name)), var.value, envir = .GlobalEnv)

}


vsource = function(file, color = crayon::green, time = FALSE){
  
  if (time) tictoc::tic(file)
  
  cat('\n'); cat(color(glue('Sourcing {file}'))); cat('\n')
  source(file)
  
  if (time) tictoc::toc()
  
}


cglue = function(str){
  
  as.character(glue(str))
  
}
