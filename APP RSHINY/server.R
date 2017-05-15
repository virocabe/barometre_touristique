library(data.table)
library(shiny)
library(shinydashboard)
library(ggplot2)

source("global.R")

server <- function(input, output,session) {
  
  terms = getTermMatrix("loremipsum")
  
  output$wordcloudplot <- renderPlot({
    v <- terms
    wordcloud(names(v), v, scale=c(2,0.5),
                  min.freq = 2, max.words = 50,
                  colors=brewer.pal(8,"Dark2"))
    
  })
  
  output$wordcloudshaped <- renderWordcloud2({
    v <- terms
    df <- data.frame(word = names(v),freq = v) 
    wordcloud2(df, size = 0.2, shape = "star")
  })
}