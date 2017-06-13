library(data.table)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(leaflet)
library(lattice)
library(radarchart)

source("global.R")
source("config.R")

# ############################################################
#                           GRAPHIQUES
# ############################################################


server <- function(input, output,session) {
  
  # ------------------------------------------------------------
  #                 Wordcloud
  # ------------------------------------------------------------
  
  terms = getTermMatrix("Input a faire")
  output$wordcloudshaped <- renderWordcloud2({
    v <- terms
    df <- data.frame(word = names(v),freq = v) 
    wordcloud2(df, size = 1, color = "pink" )
  })
  
 
  # ------------------------------------------------------------
  #                 Radar
  # ------------------------------------------------------------
  
  output$radarPlot1 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(4.56, 2.78, 4.13))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot2 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot3 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot4 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot5 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot6 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot7 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot8 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot9 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot10 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot11 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot12 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  output$radarPlot13 <- renderChartJSRadar({
    
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(3.56, 4.78, 4.43))
    
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
    
  })
  
  # ------------------------------------------------------------
  #                 Barcharts
  # ------------------------------------------------------------
  
  output$barplot_themes <- renderPlotly({
    
    themes <- c('Accueil', 'Accessibilité', 'Cadre', 'Propreté', 'Prix')
    data_french <- c(4.5,4.9,4.3,3.7,4.5)
    data_english <- c(4.7,4.8,4.4,3.5,4.5)
    data_plot <- data.frame(themes, data_french, data_english)
    
    plot_ly(data_plot, x= ~themes, y= ~data_french, type = 'bar', name = 'FR', marker = list(color = "#C2C1C1", width = 0.5)) %>%
      add_trace(y= ~data_english, name = 'ENG', marker = list(color = "#A13E59", width = 0.5)) %>%
      layout(yaxis = list(title = 'Note moyenne', showgrid = TRUE, gridcolor = 'rgb(200,200,200)'), xaxis = list(title = ''), barmode = 'group')
    
  })
  
  
  # ------------------------------------------------------------
  #                 Lineplot
  # ------------------------------------------------------------
  
  output$lineplot_ratings <- renderPlotly({
    
    dates <- c("T1 2016", "T2 2016", "T3 2016", "T1 2017", "T2 2017")
    notes_french <- c(4.76,  4.42, 4.63, 4.82, 4.53)
    notes_english <- c(4.65,  4.39, 4.47, 4.53, 4.33)
    
    data_lineplot <- data.frame(dates, notes_french, notes_english)
    
    data_lineplot$dates <- factor(data_lineplot$dates, levels = data_lineplot[["dates"]])
    
    p <- plot_ly(data_lineplot, x = ~dates, y = ~notes_french, name = 'FR', type = 'scatter', mode = 'lines',
                 line = list(color = "#C2C1C1", width = 4)) %>%
      add_trace(y = ~notes_english, name = 'ENG', type = 'scatter', mode = 'lines',
                line = list(color = "#A13E59", width = 4)) %>%
      layout(yaxis = list(title = 'Note moyenne', showgrid = TRUE, gridcolor = 'rgb(200,200,200)'), xaxis = list(title = '', showgrid = TRUE))
    
  })
  
  # ------------------------------------------------------------
  #                 TextOutput - Titre region
  # ------------------------------------------------------------
  
  output$resultat <- renderText({
    paste(input$detail_region)
  })
  

  # ------------------------------------------------------------
  #                 Cartographie
  # ------------------------------------------------------------
  
  
  #Generation de la carte
  
  output$map_france <- renderLeaflet({
    return(leaf())
 })
  
  leaf <- reactive({
      # Carte de base
      leaflet() %>%
        addProviderTiles("CartoDB.Positron") %>%
        addLegend(title = 'Note moyenne', colors = c('pink','#791b53'),labels = c('ACP','Colis contestés'), opacity = 0.9, position = 'bottomleft') %>%
        # On se place sur la France
        setView(lng = 0.0000000, lat = 47.0833300, zoom = 6)
  })
    
  
  
}


 


