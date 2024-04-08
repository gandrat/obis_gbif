rm(list=ls()) ## Removendo as variáveis

library(robis)

library(sf)

library(spocc)

#Ler shp amazonia azul
s<-read_sf("zee_regioes.shp")


#Subset para N e NE
p<-c("Norte","Nordeste")
p<-subset(s, regiao %in% p)
plot(p)

#Simplificar polígono
p_simple<-st_simplify(p,dTolerance=10000)
plot(p_simple)

#Obter coordenadas
bbox<-st_bbox(p_simple)
wkt<-st_as_text(p_simple$geometry)


#download dos dados do OBIS de Mamíferos usando ROBIS
#data<-occurrence(scientificname = "Odontoceti",
                 #geometry =st_as_text(p_simple$geometry) )

#Download dos dados usando SPOCC
mammals<-occ(query = 'Mammalia', 
             from = c('obis','gbif'), 
             limit= 10000, 
             geometry = bbox)

out_mammals<-occ2df(mammals)

point_mamm<-st_as_sf(out_mammals,
                     coords = c("longitude","latitude"),
                     crs=4326)


point_mamm<-st_intersection(point_mamm,p)
plot(point_mamm)

write_sf(point_mamm,'Data/mammals.shp')



