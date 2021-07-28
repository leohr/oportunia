
####################################### Setup #####################################################

rm(list = ls())

library(dplyr) 
library(data.table) 

####################################### Functions #################################################

getDataFromFile <- function(file.name) {
  df <- fread(file.name) %>% 
    (function(x) {names(x) <- tolower(names(x)); return(x)}) %>% 
    select(agno, 
           rbd, 
           nom_rbd, 
           cod_reg_rbd,
           cod_pro_rbd, 
           cod_com_rbd,
           nom_com_rbd,
           cod_depe, 
           rural_rbd,
           mrun, 
           doc_genero, 
           doc_fec_nac, 
           horas_contrato,
           ano_servicio_sistema, 
           tit_id_1, 
           tip_tit_id_1, 
           esp_id_1,
           nivel1, 
           nivel2) %>% 
    merge(y = df.tit, by.x = "tit_id_1", by.y = "tit_id", all.x = TRUE) %>% 
    merge(y = df.tip_tit, by.x = "tip_tit_id_1", by.y = "tip_tit_id", all.x = TRUE)
  
  return(df)
}

####################################### Get data ##################################################

# Catalogs 
df.tit <- data.table::fread("catalogs/tit_id.csv")
df.tip_tit <- data.table::fread("catalogs/tip_tit_id.csv")

# Main data frames 
df2003 <- getDataFromFile("data/Docentes 2003_PUBLICA.csv")
df2004 <- getDataFromFile("data/Docentes 2004_PUBLICA.csv")
df2005 <- getDataFromFile("data/Docentes 2005_PUBLICA.csv")
df2006 <- getDataFromFile("data/Docentes 2006_PUBLICA.csv")
df2007 <- getDataFromFile("data/Docentes 2007_PUBLICA.csv")
df2008 <- getDataFromFile("data/Docentes 2008_PUBLICA.csv")
df2009 <- getDataFromFile("data/Docentes 2009_PUBLICA.csv")
df2010 <- getDataFromFile("data/Docentes 2010_PUBLICA.csv")
df2011 <- getDataFromFile("data/Docentes 2011_PUBLICA.csv")
df2012 <- getDataFromFile("data/Docentes 2012_PUBLICA.csv")
df2013 <- getDataFromFile("data/20130904_Docentes_2013_20130709_PUBL.csv")
df2014 <- getDataFromFile("data/20140819_Docentes_2014_20140704_PUBL.csv")
df2015 <- getDataFromFile("data/20160727_Docentes_2015_20150707_PUBL.csv")
df2016 <- getDataFromFile("data/20160809_Docentes_2016_20160630_PUBL.csv")
df2017 <- getDataFromFile("data/20170720_Docentes_2017_20170630_PUBL.csv")
df2018 <- getDataFromFile("data/20180807_Docentes_2018_20180630_WEB.csv")
df2019 <- getDataFromFile("data/20191009_Docentes_2019_20190630_PUBL.csv")
df2020 <- getDataFromFile("data/20200727_Docentes_2020_20200630_PUBL.csv")

####################################### Main task #################################################

df <- rbindlist(lapply(paste0("df", 2003:2020), get)) 

####################################### Save output ###############################################

fwrite(df, file = paste0("output/", format(Sys.time(), "%Y%m%d"), "_Docentes.csv"), sep = "|")

