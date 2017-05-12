library(data.table)
library(shiny)
library(shinydashboard)

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
    menuItem("Synthèse comparative"),
    menuItem("Offre de services"),
    menuItem("Offre de loisirs"),
    menuItem("Patrimoine naturel"),
    menuItem("Patrimoine culturel")
    
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  )
)




ui <- dashboardPage(header,sidebar,body)