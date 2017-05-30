library(data.table)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(leaflet)
library(lattice)

source("global.R")
source("config.R")

server <- function(input, output,session) {
  
  
#wordcloud
  
  terms = getTermMatrix("Input a faire")
  output$wordcloudshaped <- renderWordcloud2({
    v <- terms
    df <- data.frame(word = names(v),freq = v) 
    wordcloud2(df, size = 1, color = "pink" )
  })
  
 
#radar 
  
  output$radarPlot1 <- renderPlot({
    
    radar_data=as.data.frame(matrix(sample(2:5, 4, replace = TRUE), ncol = 4))
    colnames(radar_data)=c("Offre de services", "Patrimoine naturel", "Patrimoine culturel", "Offre de loisirs")
    radar_data=rbind(rep(5,4),rep(0,4), radar_data)
    
    radarchart(radar_data  , axistype=1 , 
                #custom polygon
                pcol=rgb(0.7,0.5,0.5,0.9) , pfcol=rgb(0.7,0.5,0.5,0.3) , plwd=3 , 
                
                #custom the grid
                cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,6,1), cglwd=0.8,
                
                #custom labels
                vlcex=0.8 
    )
    
  })
  
  output$radarPlot2 <- renderPlot({
    
    radar_data=as.data.frame(matrix(sample(2:5, 4, replace = TRUE), ncol = 4))
    colnames(radar_data)=c("Offre de services", "Patrimoine naturel", "Patrimoine culturel", "Offre de loisirs")
    radar_data=rbind(rep(5,4),rep(0,4), radar_data)
    
    radarchart(radar_data  , axistype=1 , 
               #custom polygon
               pcol=rgb(0.7,0.5,0.5,0.9) , pfcol=rgb(0.7,0.5,0.5,0.3) , plwd=3 , 
               
               #custom the grid
               cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,6,1), cglwd=0.8,
               
               #custom labels
               vlcex=0.8 
    )
    
  })
  
  #logos
  
  output$myImage1 <- renderImage({
    
    filename <- normalizePath(file.path(paste("./images/",input$global_reg1,".png", sep="")))
    list(src = filename)
    
  }, deleteFile = FALSE)
  
  output$myImage2 <- renderImage({
    
    filename <- normalizePath(file.path(paste("./images/",input$global_reg2,".png", sep="")))
    list(src = filename)
    
  }, deleteFile = FALSE)
  
  
  #barcharts
  
  output$barplot_themes <- renderPlotly({
    
    themes <- c('Accueil', 'Accessibilité', 'Cadre', 'Propreté', 'Prix')
    data_french <- c(4.5,4.9,4.3,3.7,4.5)
    data_english <- c(4.7,4.8,4.4,3.5,4.5)
    data_plot <- data.frame(themes, data_french, data_english)
    
    plot_ly(data_plot, x= ~themes, y= ~data_french, type = 'bar', name = 'FR', marker = list(color = "#C2C1C1", width = 0.5)) %>%
      add_trace(y= ~data_english, name = 'ENG', marker = list(color = "#A13E59", width = 0.5)) %>%
      layout(yaxis = list(title = 'Note moyenne', showgrid = TRUE, gridcolor = 'rgb(200,200,200)'), xaxis = list(title = ''), barmode = 'group')
    
  })
  
  
  #lineplot
  
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
  

 #MAP of France  
  
  
  output$map_france <- renderLeaflet({
   leaflet() %>%
      addTiles(
        urlTemplate = "http://{s}.tile.osm.org/{z}/{x}/{y}.png",
        attribution = '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
      ) %>%
      setView(lng = 2.288, lat = 46.127, zoom = 6)
   
 })
  
  
}


 


