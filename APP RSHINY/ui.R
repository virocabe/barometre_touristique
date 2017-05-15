library(data.table)
library(shiny)
library(shinydashboard)

source("global.R")

header <- dashboardHeader(title = "Baromètre",
                          tags$li(a(href = 'http://www.sia-partners.com/services/data-science',
                                    img(src = 'logo_sia-partners2.png',
                                        title = "Sia Partners", width = '120px', height = '50px'),
                                    style = "padding-top:0px; padding-bottom:0px;"),
                                  class = "dropdown"))

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    
    id="tabs",
    menuItem("Synthèse comparative", tabName = "test"),
    menuItem("Offre de services", tabName = "test"),
    menuItem("Offre de loisirs", tabName = "test"),
    menuItem("Patrimoine naturel", tabName = "test"),
    menuItem("Patrimoine culturel", tabName = "test"),
    menuItem("Exemple wordcloud", tabName = "wordcloud")
    
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  tabItems(
    
    
    tabItem(tabName = "test"),
    

    
    
    tabItem(tabName = "wordcloud",
            fluidRow(
              column(
                12, box(plotOutput("wordcloudplot"), width = "100%")
                )
            ),
            fluidRow(
              column(
                12, box(wordcloud2Output("wordcloudshaped", width = "100%"))
              )
            )
            )
    
    
    )
)




ui <- dashboardPage(header,sidebar,body)