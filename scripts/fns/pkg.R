# REQUIRED PACKAGES ---------------------------------------------------------------
options(dplyr.summarise.inform = FALSE) # Suppress summarise inf

# file importing 
use('bit64') # Ensuring special characters are imported appropriately
use('data.table') # fread. fwrite, data.tables or rolling joins
use('readr') # Reading SQL-files
use('rio') # Convert xls to csv

# data wrangling and stuff
use('dplyr') # Wrangling functions
use('magrittr') # the compound assignment (%<>%) and other special pipes
use('tidyr') # pivoting, nesting, etc.
use('tibble') # modern data frames
use('janitor') # clean names in data frames
use('lubridate') # date manipulation
use('imputeTS') # Impute missing values

# Hashing
use('digest')

# Scraping
use('rvest')
use('knitr')
use('xml2')
use('httr')
use('RSelenium')

# Automated emails
use('RDCOMClient')

# statistical
use('forecast') # Modeling, forecasting, decomposing

# plotting
use('ggplot2') # Plotting
use('gridExtra') # Arranging plots
use('ggdark') # Dark theme for plots
use('plotly') # Interactive plots
use('ggrepel') # Callout labels
theme_set(dark_theme_bw())
theme_update(plot.title = element_text(hjust = 0.5))
title.size = 15

# console printing
use('glue') # Using variables in strings
use('crayon') # Colored console output
use('tictoc') # Running time

# Sound notifications
use('beepr')

# Robustness and debugging
use('assertthat')
