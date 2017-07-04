library(tm)
library(memoise)
library(wordcloud2)
library(rjson)
library(geojsonio)
library(data.table)
library(shiny)
library(shinydashboard)


## DONNEES ##

data_booking = fread("data/data_booking.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")
data_lafourchette = fread("data/data_lafourchette.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")
data_tripadvisor_activites_plein_air = fread("data/data_tripadvisor_activites_plein_air.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")
data_tripadvisor_patrimoine_naturel = fread("data/data_tripadvisor_patrimoine_naturel.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")
data_tripadvisor_patrimoine_culturel = fread("data/data_tripadvisor_patrimoine_culturel.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")
data_tripadvisor_patrimoine_culturel = fread("data/data_tripadvisor_patrimoine_culturel.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")
data_tripadvisor_restauration = fread("data/data_tripadvisor_restauration.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")
data_tripadvisor_shopping = fread("data/data_tripadvisor_shopping.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")
data_tripadvisor_vie_nocturne = fread("data/data_tripadvisor_vie_nocturne.csv", sep=";", showProgress=FALSE, encoding = "UTF-8")

global_data = rbind(data_booking, 
                    data_lafourchette, 
                    data_tripadvisor_activites_plein_air, 
                    data_tripadvisor_jeux_divertissement, 
                    data_tripadvisor_patrimoine_culturel,
                    data_tripadvisor_restauration,
                    data_tripadvisor_patrimoine_naturel, 
                    data_tripadvisor_vie_nocturne, 
                    data_tripadvisor_shopping)

global_data = transform(global_data, date = paste(date, "01", sep = "-"))



## PARAMETRES ##


choix_langues = c("fr", "eng", "tous")

list_regions = c("Auvergne-Rhône-Alpes" = "auvergne-rhone-alpes",
                 "Bourgogne-Franche-Comté" = "bourgogne-franche-comte",
                 "Bretagne" = "bretagne",
                 "Centre-Val de Loire" = "centre-val-de-loire",
                 "Corse" = "corse",
                 "Grand est" = "grand-est",
                 "Hauts-de-France" = "hauts-de-france",
                 "Ile-de-France" = "ile-de-france",
                 "Normandie" = "normandie",
                 "Nouvelle-Aquitaine" = "nouvelle-aquitaine",
                 "Occitanie" = "occitanie",
                 "Pays de la Loire" = "pays-de-la-loire",
                 "Provence-Alpes-Côte d'azur" = "provence-alpes-cote-d-azur")

list_type_activites = c("Offre de services" = "offre_de_services" , "Patrimoine" = "patrimoine",  "Offre de loisirs" = "offre_de_loisirs")


offre_de_services = c("Restauration" = "restauration", "Hébergement" = "hebergement")


patrimoine = c("Patrimoine naturel" = "patrimoine naturel", "Patrimoine culturel" = "patrimoine culturel")


offre_de_loisirs = c("Activités plein air" = "activites de plein air", "Jeux et divertissements" = "jeux et divertissements", "Shopping" = "shopping", "Vie nocturne" = "vie nocturne")


choix_periode = c("T1 2013","T2 2013","T3 2013","T1 2014","T2 2014","T3 2014","T1 2015","T2 2015","T3 2015","T1 2016","T2 2016","T3 2016","T1 2017", "T2 2017")

regions <- reactive({
  return(geojson_read("france-geojson-master/regions.geojson", what = "sp", parse = TRUE))
})



## WORDCLOUD ##

#Loading data for wordcloud

json_file <- "data/lafourchette-corse.json"
json_data <- fromJSON(paste(readLines(json_file),collapse=""))

json_data <- lapply(json_data, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

comments = data.frame(do.call("rbind",json_data))

contents <- iconv(as.vector(comments$content), from='UTF-8', to='ASCII//TRANSLIT')

figPath_services = "resto.png"


#Preparing frequency matrix for wordcloud

getTermMatrix <- memoise(function(content) {
  
  myCorpus = Corpus(VectorSource(contents))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords, c(iconv(stopwords("french"),from="UTF-8", to="ASCII//TRANSLIT"),'tres'))
  

  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 3))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})


