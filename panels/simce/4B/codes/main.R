
####################################### Setup #####################################################

rm(list = ls())

t0 <- Sys.time() 

library(dplyr) 
library(data.table) 

####################################### Functions #################################################

getDataFromFile <- function(file.name) {
  df <- fread(file.name, encoding = "UTF-8") 
  
  # Fix for column "noaplica" (it is only in the new tables) 
  if (! "noaplica" %in% names(df)) { df$noaplica <- 0 }

  df <- df %>% 
    select(agno, 
           rbd, 
           nalu_lect4b_rbd, 
           nalu_mate4b_rbd,
           prom_lect4b_rbd,
           prom_mate4b_rbd, 
           noaplica) %>% 
    filter(noaplica == 0 | noaplica == "Rbd y curso rinde Simce")
  
  return(df)
}

####################################### Get data ##################################################

file.names <- list.files("data")
file.content <- lapply(file.names, function(x) getDataFromFile(paste0("data/", x)))

####################################### Main task #################################################

df <- rbindlist(file.content) %>% 
  arrange(agno, rbd) 

####################################### Save output ###############################################

fwrite(df, file = paste0("output/", format(Sys.time(), "%Y%m%d"), "_Simce4B.csv"), sep = "|")

print(Sys.time() - t0) 

