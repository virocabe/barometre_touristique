library(data.table)
library(shiny)
library(shinydashboard)

## PARAMETRES ##
choix_langues = c("FR", "ENG", "ALL")
list_regions = c("auvergne-rhone-alpes","bourgogne-franche-comte","bretagne","centre-val-de-loire",
              "corse","grand-est","hauts-de-france","ile-de-france","normandie","nouvelle-aquitaine","occitanie","pays-de-la-loire","provence-alpes-cote-d'azur")
list_type_activites = c("offre de services", "patrimoine naturel", "patrimoine culturel", "offre de loisirs")