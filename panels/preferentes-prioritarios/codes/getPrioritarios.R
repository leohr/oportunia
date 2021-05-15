
####################################### Setup #####################################################

rm(list = ls())

library(dplyr) 
library(data.table) 

####################################### Functions #################################################

getDataFromFile <- function(file.name) {
  df <- fread(file.name)  %>% 
    (function(x) {names(x) <- tolower(names(x)); return(x)}) 
  
  if (length(unique(df$agno)) > 1) {
    stop("There is more than one year in the data frame!")
  }
  
  if (unique(df$agno) > 2015) {
    df <- df %>% 
      filter(prioritario_alu == 1) 
  }
  
  df <- df %>% 
    select(agno, mrun)
  
  return(df)
}

####################################### Get data ##################################################

file.names <- list.files("data")
file.content <- lapply(file.names, function(x) getDataFromFile(paste0("data/", x)))

####################################### Main task #################################################

df <- rbindlist(file.content) %>% 
  arrange(agno, mrun) 

####################################### Save output ###############################################

fwrite(df, file = paste0("output/", format(Sys.time(), "%Y%m%d"), "_Prioritarios.csv"), sep = "|")


