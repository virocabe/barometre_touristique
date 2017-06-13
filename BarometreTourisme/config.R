library(data.table)
library(shiny)
library(shinydashboard)

## PARAMETRES ##
choix_langues = c("fr", "eng", "tous")
list_regions = c("auvergne-rhone-alpes","bourgogne-franche-comte","bretagne","centre-val-de-loire",
              "corse","grand-est","hauts-de-france","ile-de-france","normandie","nouvelle-aquitaine","occitanie","pays-de-la-loire","provence-alpes-cote-d'azur")
list_type_activites = c("offre de services", "patrimoine naturel", "patrimoine culturel", "offre de loisirs")

choix_periode = c("T1 2013","T2 2013","T3 2013","T1 2014","T2 2014","T3 2014","T1 2015","T2 2015","T3 2015","T1 2016","T2 2016","T3 2016","T1 2017", "T2 2017")