# instalando o pacote Robis
library(remotes)
remotes::install_github("iobis/robis")
library(robis)

#SF package (spatial data))
library(sf)

#Using the occurrence command from robis------------
data<-occurrence(scientificname = "Caretta caretta", 
                 startdate = '2020-01-01')


#Spatial package for R (SF)-----------------
#Loading study site shapefile
s<-read_sf("input_data/sbs_case_study.shp")
s$area<-st_area(s)
s<-s[1,]
s
plot(s)

#Simplifying geometry
s_simple<-st_simplify(s,dTolerance=5000)
plot(s_simple)

#Filtering OBIS data for shapefile
data<-occurrence( scientificname = "Annelida",
                  geometry=st_as_text(s_simple$geometry))
nrow(data)

#Dinamic Maps
map_leaflet(data, color='black', provider_tiles = "Esri.OceanBasemap",
            popup=function(x){x["scientificName"]})

#Dplyr to filter or mutate DF--------------
library(dplyr)
dataf<- data%>%
  filter(institutionCode=='USP')%>%
  select(date_year,scientificName, family, sst, shoredistance, depth)%>%
  mutate(costeira=shoredistance<19312)%>%
  arrange(date_year)
nrow(dataf)

#GGPLOT------------
#A simple histogram
ggplot(data,aes(x=depth))+geom_histogram()+
  theme_bw()

#Customizing histogram
ggplot(data,aes(x=depth))+geom_histogram(bins=10)+
  theme_bw()+xlab('Profundidade (m)')+ylab('Nº de Ocorrências')

#Exporting data---------
#Shapefile
data_sf<-st_as_sf(data, 
                  coords=c("decimalLongitude","decimalLatitude"),
                  crs=4326)
write_sf(data_sf,dsn = 'output_data/annelida.shp')

#R file
save(data,file='output_data/annelida.Rda')

#Excel
library(writexl)
write_xlsx(data,path = 'output_data/annelida.xlsx')

#CSV
write.csv2(data,file='output_data/annelida.csv')
