rm(list=ls()) ## Removendo as variáveis

library(robis)
library(sf)

#Ler shp amazonia azul
s<-read_sf("zee_regioes.shp")

#Subset para N e NE
p<-c("Norte","Nordeste")
p<-subset(s, regiao %in% p)
plot(p)

p_simple<-st_simplify(p,dTolerance=10000)
plot(p_simple)

wkt<-st_as_text(p_simple$geometry)

#download dos dados do OBIS de Mamíferos
data<-occurrence(scientificname = "Mammalia", 
                 geometry = wkt)
