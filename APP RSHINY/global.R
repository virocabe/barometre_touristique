library(tm)
library(wordcloud)
library(memoise)
library(wordcloud2)
library(rjson)
library(fmsb)

source("config.R")

## WORDCLOUD ##

#Loading data for wordcloud

json_file <- "../lafourchette/data/lafourchette-corse.json"
json_data <- fromJSON(paste(readLines(json_file),collapse=""))

json_data <- lapply(json_data, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

comments = data.frame(do.call("rbind",json_data))

contents <- iconv(as.vector(comments$content), from='UTF-8', to='ASCII//TRANSLIT')

figPath_services = "resto.png"


#Preparing frequency matrix for wordcloud

getTermMatrix <- memoise(function(content) {
  
  myCorpus = Corpus(VectorSource(contents))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords, iconv(stopwords("french"),from="UTF-8", to="ASCII//TRANSLIT"))
  

  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 3))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})



