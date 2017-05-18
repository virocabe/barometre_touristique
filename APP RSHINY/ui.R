library(data.table)
library(shiny)
library(shinydashboard)

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
    menuItem("Synthèse comparative", tabName = "global", icon = icon("dashboard")),
    menuItem("Statistiques détaillées", tabName = "detail", icon = icon("bar-chart")),
    conditionalPanel("input.tabs == 'global'",
                     selectizeInput("global_reg1", 
                                    label = "Région 1", 
                                    choices = list_regions,
                                    multiple =FALSE,
                                    selected = 'corse'),
                     selectizeInput("global_reg2", 
                                    label = "Région 2", 
                                    choices = list_regions,
                                    multiple =FALSE,
                                    selected = 'bourgogne-franche-comte')
    ),
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
    
    
    tabItem(tabName = "global",
            fluidRow(
              column(
                width = 6 ,imageOutput("myImage1")
                ),
              column(
              width = 6, imageOutput("myImage2")
              )
            ),
            fluidRow(
              column(
                width = 6, infoBox(title = (
                  tags$p(style = "font-size: 15px; font-style: bold;", "NOTE GLOBALE")),
                  value = (tags$p(style = "font-size: 27px;", "4.61")), width = NULL, fill = FALSE, icon = icon("star"), color = "purple")
              ),
              column(
                width = 6, infoBox(title = (
                  tags$p(style = "font-size: 15px; font-style: bold;", "NOTE GLOBALE")),
                  value = (tags$p(style = "font-size: 27px;", "4.14")), width = NULL, fill = FALSE, icon = icon("star"), color = "purple")
              )
            ),
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, status = "primary", plotOutput("radarPlot1"))
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, status = "primary", plotOutput("radarPlot2"))
              )
            )
            ),
    
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