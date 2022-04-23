# DB connections
use('RPostgreSQL') # Redshift Connection
use('RPostgres') # Redshift Connection
use('timeseriesdb')

source('~/Projects/secrets.R')

create_connection = function(drv, ...){
  
  dbConnect(
    drv, 
    host = db_host, 
    port = db_port,
    dbname = db_name, 
    user = db_user, 
    password = db_password,
    ...
  )
  
}


connect_to_redshift = function(driver = 'PostgreSQL'){
  
  if (driver == 'PostgreSQL') conn = create_connection(drv = dbDriver("PostgreSQL"))
  if (driver == 'RPostgres') conn = create_connection(drv = RPostgres::Postgres(), bigint = 'integer')
  return(conn)
  
}


SQLget = function(SQLscript, msg = glue('Executing {SQLscript}'), color = crayon::yellow, verbose = FALSE){
  
  # Ready query from specified path
  query = glue(readr::read_file(SQLscript))
  
  if (verbose){
    print(glue('Querying:'))
    print(query)
  } 
  
  # If connection on active in global environment, create temporary connection locally within function scope
  local_conn = FALSE # Initialize local connection as false
  if (!exists('conn', where = .GlobalEnv) || !dbIsValid(conn) ){
    local_conn = TRUE
    conn = connect_to_redshift(driver = 'RPostgres')
    print(glue('Opened local connection'))
  }
  
  cat(color(msg)); cat('\n')
  out_ = dbGetQuery(conn, query) %>% tibble()
  
  # If connection is local, disconnect
  if (local_conn){
    dbDisconnect(conn)
    print(glue('Closed local connection'))
  } 
  
  return(out_)
}


# WRITING
use('reticulate')


start_python = function(){
  
  use_condaenv( "r-reticulate")
  # py_install(c('pandas', 'sqlalchemy', 'psycopg2'))
  import('psycopg2')
  pd %global% import('pandas')
  sa %global% import('sqlalchemy')
  
}


write_to_redshift = function(df, tablename, schemaname, if_exists = 'append'){
  
  pd_df = r_to_py(df)
  eng = sa$create_engine(glue('postgres://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'))
  conn_py = eng$connect()
  write_result = pd_df$to_sql(name = tablename, 
                              con = conn_py, 
                              index = FALSE, 
                              if_exists = if_exists, 
                              schema = schemaname, 
                              chunksize = 1000L, 
                              method = 'multi')
  
  conn_py$close()
  
  return(write_result)
  
}
