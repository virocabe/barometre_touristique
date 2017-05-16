library(data.table)
library(shiny)
library(shinydashboard)
library(ggplot2)

source("global.R")

server <- function(input, output,session) {
  
  terms = getTermMatrix("Corse")
  
  output$wordcloudplot <- renderPlot({
    v <- terms
    wordcloud(names(v), v, scale=c(4,1),
                  min.freq = 5, max.words = 100,
                  colors=brewer.pal(8,"Dark2"))
    
  })
  
  output$wordcloudshaped <- renderWordcloud2({
    v <- terms
    df <- data.frame(word = names(v),freq = v) 
    wordcloud2(df, size = 1)
  })
}