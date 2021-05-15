
####################################### Setup #####################################################

rm(list = ls())

t0 <- Sys.time() 

library(dplyr) 
library(data.table) 

####################################### Functions #################################################

getDataFromFile <- function(file.name) {
  df <- fread(file.name) %>% 
    (function(x) {names(x) <- tolower(names(x)); return(x)}) %>% 
    select(agno, 
           rbd, 
           cod_reg_rbd, 
           cod_com_rbd,
           mrun,
           gen_alu, 
           edad_alu, 
           cod_reg_alu, 
           cod_com_alu, 
           cod_ense, 
           cod_grado, 
           cod_espe, 
           cod_jor)
  
  return(df)
}

####################################### Get data ##################################################

file.names <- list.files("data")
file.content <- lapply(file.names, function(x) getDataFromFile(paste0("data/", x)))

####################################### Main task #################################################

df <- rbindlist(file.content) %>% 
  arrange(agno, rbd, mrun) 

####################################### Save output ###############################################

fwrite(df, file = paste0("output/", format(Sys.time(), "%Y%m%d"), "_Matricula.csv"), sep = "|")

print(Sys.time() - t0) 

