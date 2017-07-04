json_file <- "data/lafourchette-corse.json"
#list_json_file <- c("data/lafourchette-corse.json","data/lafourchette-corse.json","data/lafourchette-corse.json")


#for (json_file in list_json_file){
  json_data <- fromJSON(paste(readLines(json_file),collapse=""))
  json_data <- lapply(json_data, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })

  json_data <- data.frame(do.call("rbind",json_data))
  json_data <- data.frame(region=json_data$region,type_activite=json_data$type_activite,sous_type_activite=json_data$sous_type_activite,content=json_data$content)

  
#}

contents <- iconv(as.vector(json_data[which(json_data$region=='corse'&
                                              json_data$type_activite=='offre de services'&
                                              json_data$sous_type_activite=='restauration'),]$content), from='UTF-8', to='ASCII//TRANSLIT')



#Preparing frequency matrix for wordcloud

getTermMatrix <- memoise(function() {
  
  myCorpus = Corpus(VectorSource(contents))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords, c(iconv(stopwords("french"),from="UTF-8", to="ASCII//TRANSLIT"),iconv(stopwords("english"),from="UTF-8", to="ASCII//TRANSLIT"),'tres'))
  
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 3))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)

  })


#terms = getTermMatrix()
#wordcloudshaped <- function(){
  v <- terms
  df <- data.frame(word = names(v),freq = v) 
  mots_a_retenir<-str('')
  head(df,50)$word
  wordcloud2(head(df,50), size = 1, color = "pink" )
  
  
  
#}

head(df,30)

wordcloudshaped()

    
