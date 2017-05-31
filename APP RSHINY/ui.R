library(data.table)
library(shiny)
library(shinydashboard)
library(plotly)
library(radarchart)

source("global.R")
source("config.R")

header <- dashboardHeader(title = "Baromètre",
                          tags$li(a(href = 'http://www.sia-partners.com/services/data-science',
                                    img(src = 'logo_sia-partners2.png',
                                        title = "Sia Partners", width = '120px', height = '50px'),
                                    style = "padding-top:0px; padding-bottom:0px;"),
                                  class = "dropdown"))

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    
    id="tabs",
    menuItem("Cartographie des régions", tabName = "carte", icon = icon("map-marker")),
    menuItem("Synthèse globale", tabName = "global", icon = icon("dashboard")),
    menuItem("Statistiques détaillées", tabName = "detail", icon = icon("bar-chart")),
    conditionalPanel("input.tabs == 'detail'",
                     selectizeInput("detail_region", 
                                    label = "Région", 
                                    choices = list_regions,
                                    multiple =FALSE,
                                    selected = 'corse'),
                         selectizeInput("axe_analyse", 
                                    label = "Type d'activité", 
                                    choices = list_type_activites,
                                    multiple =FALSE,
                                    selected = 'offre de services')
    ),
    menuItem(""),
    menuItem("Qui sommes-nous ?", tabName = "presentation", icon = icon("diamond")),
    menuItem("Nous contacter", tabName = "contact", icon = icon("envelope"))
    
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  tabItems(
  
    #ONGLET CARTE
    
    tabItem(tabName = "carte",
      leafletOutput("map_france", height = "1000px")
        

    ),
    
    #ONGLET SYNTHESE GLOBALE
    
    tabItem(tabName = "global",
            fluidRow(
              column(
                width = 3 ,img(src = 'auvergne-rhone-alpes.png')
                ),
              column(
                width = 3, box(title = strong("Auvergne-Rhone-Alpes"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial"), br(),
                               em("La region ou ... volcans !"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
              width = 3, img(src = 'bourgogne-franche-comte.png')
              ),
              column(
                width = 3, box(title = strong("Bourgogne-Franche-Comte"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial"), br(),
                               em("La region ou.... fromage !"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE , chartJSRadarOutput("radarPlot1"))
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE , chartJSRadarOutput("radarPlot2"))
              )
            ),
            fluidRow(
              column(
                width = 3 ,img(src = 'bretagne.png')
              ),
              column(
                width = 3, box(title = "Bretagne", 
                               "Note globale : 4.72/5", 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
                width = 3, img(src = 'centre-val-de-loire.png')
              ),
              column(
                width = 3, box(title = "Centre-Val-de-Loire", 
                               "Note globale : 4.56/5", 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              
              fluidRow(
                column(
                  width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot3"))
                ),
                column(
                  width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot4"))
                )
              )
            ),
            
              fluidRow(
                column(
                  width = 3 ,img(src = 'corse.png')
                ),
                column(
                  width = 3, box(title = "Corse", 
                                 "Note globale : 4.72/5", 
                                 header = FALSE, solidHeader = TRUE, width = NULL )
                ),
                column(
                  width = 3, img(src = 'grand-est.png')
                ),
                column(
                  width = 3, box(title = "Grand-Est", 
                                 "Note globale : 4.56/5", 
                                 header = FALSE, solidHeader = TRUE, width = NULL )
                )
              ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot5") )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot6") )
              )
            ),
            
            fluidRow(
              column(
                width = 3 ,img(src = 'hauts-de-france.png')
              ),
              column(
                width = 3, box(title = "Hauts-de-France", 
                               "Note globale : 4.72/5", 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
                width = 3, img(src = 'ile-de-france.png')
              ),
              column(
                width = 3, box(title = "Ile-de-France", 
                               "Note globale : 4.56/5", 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot7") )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot8"))
              )
            ),
            
            fluidRow(
              column(
                width = 3 ,img(src = 'normandie.png')
              ),
              column(
                width = 3, box(title = "Normandie", 
                               "Note globale : 4.72/5", 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
                width = 3, img(src = 'nouvelle-aquitaine.png')
              ),
              column(
                width = 3, box(title = "Nouvelle-Aquitaine", 
                               "Note globale : 4.56/5", 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot9") )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot10"))
              )
            ),
            
            fluidRow(
              column(
                width = 3 ,img(src = 'occitanie.png')
              ),
              column(
                width = 3, box(title = "Occitanie", 
                               "Note globale : 4.72/5",
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
                width = 3, img(src = 'pays-de-la-loire.png')
              ),
              column(
                width = 3, box(title = "Pays de la Loire", 
                               "Note globale : 4.56/5", 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot11") )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot12"))
              )
            ),
            
            fluidRow(
              column(
                width = 3 ,img(src = "provence-alpes-cote-d'azur.png")
              ),
              column(
                width = 3, box(title = "Provence-Alpes-Cote d'Azur", 
                               "Note globale : 4.72/5", 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              
              column(
                width = 6
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot13") )
              ),
              column(
                width = 6)
            )
    
            ),
    
    
    #ONGLET DETAIL
    
    tabItem(tabName = "detail",
            fluidRow(
              column(
                width = 6, infoBox(title = (
                tags$p(style = "font-size: 15px; font-style: bold;", "NOTE GLOBALE")),
                value = (tags$p(style = "font-size: 27px;", "4.56")), 
                icon = icon("star"), fill = FALSE, color = "purple", width = NULL
                )),
              column(
                width = 6,
                box(title = "Notes par thématique", solidHeader=FALSE, status = "primary", width = NULL, plotlyOutput("barplot_themes"))
              )),
            fluidRow(
              column(
                width = 6,box(title = "Evolution de la note", solidHeader=FALSE, status = "primary", width = NULL, plotlyOutput("lineplot_ratings"))
                ),
              column(
              width = 6,box(wordcloud2Output("wordcloudshaped"), width = NULL)
              )
              
            )
            ),
    
    tabItem(tabName = "presentation",
            "Presentation de Sia Partners et des equipes Data Science / Secteur Public"
            
            ),
    
    tabItem(tabName = "contact",
           "Infos contact"
           
           )
    
    
    )
)




ui <- dashboardPage(header,sidebar,body)