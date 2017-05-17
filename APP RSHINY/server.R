library(data.table)
library(shiny)
library(shinydashboard)
library(ggplot2)

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
                pcol=rgb(0.5,0.5,0.5,0.9) , pfcol=rgb(0.5,0.5,0.5,0.3) , plwd=3 , 
                
                #custom the grid
                cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,
                
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
               pcol=rgb(0.5,0.5,0.5,0.9) , pfcol=rgb(0.5,0.5,0.5,0.3) , plwd=3 , 
               
               #custom the grid
               cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,
               
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
}