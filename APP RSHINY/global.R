library(tm)
library(wordcloud)
library(memoise)
library(wordcloud2)
library(rjson)

#Loading data for wordcloud

json_file <- "../lafourchette/data/lafourchette-corse.json"
json_data <- fromJSON(paste(readLines(json_file),collapse=""))

json_data <- lapply(json_data, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

comments = data.frame(do.call("rbind",json_data))

contents <- as.vector(comments$content)


#Preparing frequency matrix for wordcloud

getTermMatrix <- memoise(function(book) {
  text <- readLines(sprintf("%s.txt",book), encoding=  "UTF-8")
  
  myCorpus = Corpus(VectorSource(contents))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("french"),"avec", "très","je","a","et","mais","nous", "on", "est", "il", "elle", "dans", "ou", "le", "la", "les", "un", "de"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 2))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})