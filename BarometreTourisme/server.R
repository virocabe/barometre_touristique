library(data.table)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(leaflet)
library(lattice)
library(radarchart)

source("global.R")


# ############################################################
#                           GRAPHIQUES
# ############################################################


server <- function(input, output,session) {
  
  
#Variables reactives
  
  outVar <- reactive({
    mydata = get(input$type_activite)
  })
  
  observe({
      updateSelectizeInput(session, "sous_type_activite", choices = outVar())
  })
  
  regions <- reactive({
    return(geojson_read("france-geojson-master/regions.geojson", what = "sp", parse = TRUE))
  })
  
  # Filtre des donnees sur periode selectionnee
  
  data_plageEtude = reactive({
    date_debut = input$periode_etude[1]
    date_fin   = input$periode_etude[2]
    data_plageEtude = global_data[(date>=date_debut & date<=date_fin),]
  })
  
  # Filtre des donnees pour fiche identite
  
  data_detail_0 = reactive({
    data_detail_0 = data_plageEtude()[data_plageEtude()$region == input$detail_region,]
  })
  
  data_detail_1 = reactive({
    data_detail_1 = data_detail_0()[data_detail_0()$type_activite == input$type_activite,]
  })
  
  data_detail = reactive({
    data_detail = data_detail_1()[data_detail_1()$sous_type_activite == input$sous_type_activite,]
  })
  
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
  
  calcul_notes<-function(region_choisie){
    data_detail_region = data_plageEtude()[data_plageEtude()$region == region_choisie,]
    note_activite_moy<-rep(0,3)
    for (j in 1:length(list_type_activites)){
      data_detail_activite = data_detail_region[data_detail_region$type_activite == list_type_activites[j],]
      sous_activites <- unique(data_detail_activite$sous_type_activite)
      note_sous_activite <- rep(0,length(sous_activites))
      for (k in 1:length(sous_activites)){
        note_sous_activite[k] <- (sum(data_detail_activite[sous_type_activite==sous_activites[k],]$note)/sum(data_detail_activite[sous_type_activite==sous_activites[k],]$nb_note))
      }
      note_activite_moy[j] <- mean(note_sous_activite)
    }
    return(note_activite_moy)
  }

  fonction_radar<-function(region_choisie){
    radar_data = data.frame("Label" = c("Patrimoine", "Offre de loisirs", "Offre de services"),
                            "Note" = c(calcul_notes(region_choisie)[2], calcul_notes(region_choisie)[3], calcul_notes(region_choisie)[1]))
    chartJSRadar(radar_data, maxScale = 5, showToolTipLabel = TRUE, scaleStepWidth = 1, showLegend = FALSE)
  }

  #radars
  output$radarPlot1 <- renderChartJSRadar({fonction_radar('auvergne-rhone-alpes')})
  output$radarPlot2 <- renderChartJSRadar({fonction_radar('bourgogne-franche-comte')})
  output$radarPlot3 <- renderChartJSRadar({fonction_radar('bretagne')})
  output$radarPlot4 <- renderChartJSRadar({fonction_radar('centre-val-de-loire')})
  output$radarPlot5 <- renderChartJSRadar({fonction_radar('corse')})
  output$radarPlot6 <- renderChartJSRadar({fonction_radar('grand-est')})
  output$radarPlot7 <- renderChartJSRadar({fonction_radar('hauts-de-france')})
  output$radarPlot8 <- renderChartJSRadar({fonction_radar('ile-de-france')})
  output$radarPlot9 <- renderChartJSRadar({fonction_radar('normandie')})
  output$radarPlot10 <- renderChartJSRadar({fonction_radar('nouvelle-aquitaine')})
  output$radarPlot11 <- renderChartJSRadar({fonction_radar('occitanie')})
  output$radarPlot12 <- renderChartJSRadar({fonction_radar('pays-de-la-loire')})
  output$radarPlot13 <- renderChartJSRadar({fonction_radar("provence-alpes-cote-d-azur")})
  
  #-------------------------
  #Notes globales des radars
  output$note1 <- renderText({paste("Note globale : ",round(mean(calcul_notes('auvergne-rhone-alpes')),2),"/5",sep="")})
  output$note2<- renderText({paste("Note globale : ",round(mean(calcul_notes('bourgogne-franche-comte')),2),"/5",sep="")})
  output$note3<- renderText({paste("Note globale : ",round(mean(calcul_notes('bretagne')),2),"/5",sep="")})
  output$note4<- renderText({paste("Note globale : ",round(mean(calcul_notes('centre-val-de-loire')),2),"/5",sep="")})
  output$note5<- renderText({paste("Note globale : ",round(mean(calcul_notes('corse')),2),"/5",sep="")})
  output$note6<- renderText({paste("Note globale : ",round(mean(calcul_notes('grand-est')),2),"/5",sep="")})
  output$note7<- renderText({paste("Note globale : ",round(mean(calcul_notes('hauts-de-france')),2),"/5",sep="")})
  output$note8<- renderText({paste("Note globale : ",round(mean(calcul_notes('ile-de-france')),2),"/5",sep="")})
  output$note9<- renderText({paste("Note globale : ",round(mean(calcul_notes('normandie')),2),"/5",sep="")})
  output$note10<- renderText({paste("Note globale : ",round(mean(calcul_notes('nouvelle-aquitaine')),2),"/5",sep="")})
  output$note11<- renderText({paste("Note globale : ",round(mean(calcul_notes('occitanie')),2),"/5",sep="")})
  output$note12<- renderText({paste("Note globale : ",round(mean(calcul_notes('pays-de-la-loire')),2),"/5",sep="")})
  output$note13<- renderText({paste("Note globale : ",round(mean(calcul_notes("provence-alpes-cote-d-azur")),2),"/5",sep="")})
 #Notes par activite des radars
  output$note1_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('auvergne-rhone-alpes')[1],2),"/5",sep="")})
  output$note1_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('auvergne-rhone-alpes')[2],2),"/5",sep="")})
  output$note1_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('auvergne-rhone-alpes')[3],2),"/5",sep="")})
  output$note2_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('bourgogne-franche-comte')[1],2),"/5",sep="")})
  output$note2_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('bourgogne-franche-comte')[2],2),"/5",sep="")})
  output$note2_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('bourgogne-franche-comte')[3],2),"/5",sep="")})
  output$note3_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('bretagne')[1],2),"/5",sep="")})
  output$note3_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('bretagne')[2],2),"/5",sep="")})
  output$note3_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('bretagne')[3],2),"/5",sep="")})
  output$note4_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('centre-val-de-loire')[1],2),"/5",sep="")})
  output$note4_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('centre-val-de-loire')[2],2),"/5",sep="")})
  output$note4_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('centre-val-de-loire')[3],2),"/5",sep="")})
  output$note5_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('corse')[1],2),"/5",sep="")})
  output$note5_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('corse')[2],2),"/5",sep="")})
  output$note5_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('corse')[3],2),"/5",sep="")})
  output$note6_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('grand-est')[1],2),"/5",sep="")})
  output$note6_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('grand-est')[2],2),"/5",sep="")})
  output$note6_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('grand-est')[3],2),"/5",sep="")})
  output$note7_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('hauts-de-france')[1],2),"/5",sep="")})
  output$note7_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('hauts-de-france')[2],2),"/5",sep="")})
  output$note7_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('hauts-de-france')[3],2),"/5",sep="")})
  output$note8_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('ile-de-france')[1],2),"/5",sep="")})
  output$note8_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('ile-de-france')[2],2),"/5",sep="")})
  output$note8_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('ile-de-france')[3],2),"/5",sep="")})
  output$note9_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('normandie')[1],2),"/5",sep="")})
  output$note9_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('normandie')[2],2),"/5",sep="")})
  output$note9_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('normandie')[3],2),"/5",sep="")})
  output$note10_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('nouvelle-aquitaine')[1],2),"/5",sep="")})
  output$note10_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('nouvelle-aquitaine')[2],2),"/5",sep="")})
  output$note10_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('nouvelle-aquitaine')[3],2),"/5",sep="")})
  output$note11_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('occitanie')[1],2),"/5",sep="")})
  output$note11_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('occitanie')[2],2),"/5",sep="")})
  output$note11_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('occitanie')[3],2),"/5",sep="")})
  output$note12_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes('pays-de-la-loire')[1],2),"/5",sep="")})
  output$note12_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes('pays-de-la-loire')[2],2),"/5",sep="")})
  output$note12_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes('pays-de-la-loire')[3],2),"/5",sep="")})
  output$note13_activite1 <- renderText({paste("Note patrimoine : ",round(calcul_notes("provence-alpes-cote-d-azur")[1],2),"/5",sep="")})
  output$note13_activite2 <- renderText({paste("Note offre de services : ",round(calcul_notes("provence-alpes-cote-d-azur")[2],2),"/5",sep="")})
  output$note13_activite3 <- renderText({paste("Note offre de loisirs : ",round(calcul_notes("provence-alpes-cote-d-azur")[3],2),"/5",sep="")})
  
  
  #-------------------------------------------------------------
  #                         STARS
  #-------------------------------------------------------------
  fonction_stars<-function(note){
    if (note< 0.25){return("stars_0")}
    else if (note< 0.75){return("stars_0_5")}
    else if (note< 1.25){return("stars_1")}
    else if (note< 1.75){return("stars_1_5")}
    else if (note< 2.25){return("stars_2")}
    else if (note< 2.75){return("stars_2_5")}
    else if (note< 3.25){return("stars_3")}
    else if (note< 3.75){return("stars_3_5")}
    else if (note< 4.25){return("stars_4")}
    else if (note< 4.75){return("stars_4_5")}
    else {return("stars_5")}
  }
  
  
  output$star1 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('auvergne-rhone-alpes'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star2 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('bourgogne-franche-comte'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star3 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('bretagne'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star4 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('centre-val-de-loire'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star5 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('corse'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star6 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('grand-est'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star7 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('hauts-de-france'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star8 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('ile-de-france'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star9 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('normandie'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star10 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('nouvelle-aquitaine'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star11 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes('occitanie'))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star12 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes("pays-de-la-loire"))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  output$star13 <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(mean(calcul_notes("provence-alpes-cote-d-azur"))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  
  
  # ------------------------------------------------------------
  #                 Logo region
  # ------------------------------------------------------------
  
  output$myImage <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",input$detail_region,".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  
  # ------------------------------------------------------------
  #                 Barcharts
  # ------------------------------------------------------------
  
  output$histo_themes = renderPlot({
    
    themes <- c('Accueil', 'Accessibilité', 'Cadre', 'Propreté', 'Prix')
    data_french <- c(4.5,4.9,4.3,3.7,4.5)
    data_english <- c(4.7,4.8,4.4,3.5,4.5)
    data_plot <- data.frame(themes, data_french, data_english)
    
    #data_plot <- data_detail(note_cuisine,note_service,note_cadre)
    
    myplot = ggplot(data=data_plot, aes(y=data_french, x=themes)) 
    myplot = myplot + geom_histogram(stat='identity', aes(fill=themes), width=0.4, position="dodge")
    myplot = myplot + labs(title="Note moyenne par thématique en lien avec l'offre") 
    myplot = myplot + scale_fill_manual(values=c("#E99494", "#EE9724", "#665B5B", "#C2C1C1", "#A13E59"))
    myplot = myplot + theme(legend.position="none", axis.title.x=element_blank(), plot.title = element_text(lineheight=.8, face="bold", color="#665B5B", vjust=3, size =18))
    myplot = myplot + labs(y = "Note moyenne")
    myplot = myplot + theme(axis.text=element_text(size = 12), axis.title.y=element_text(vjust=2, size = 14))
    myplot
    
  })
  
  output$histo_themes_restauration_hebergement = renderPlot({
    
    
    if (input$sous_type_activite=='restauration'){
      themes <- c('Cuisine', 'Service', 'Cadre')
    }
    
    else {
      themes <- c('Confort', 'Propreté', 'Qualité-Prix')
    }
      
    nb_comments <- sum(data_detail()[note_cuisine!=0,]$nb_note)
    data_french <- c((sum(data_detail()$note_cuisine)/nb_comments),(sum(data_detail()$note_service)/nb_comments),(sum(data_detail()$note_cadre)/nb_comments))
    data_plot <- data.frame(themes, data_french)
    
    if (input$sous_type_activite=='restauration' || input$sous_type_activite=='hebergement'){
    myplot = ggplot(data=data_plot, aes(y=data_french, x=themes)) 
    myplot = myplot + geom_histogram(stat='identity', aes(fill=themes), width=0.4, position="dodge")
    myplot = myplot + labs(title="Note moyenne par thématique en lien avec l'offre")
    myplot = myplot + scale_fill_manual(values=c("#E99494", "#EE9724", "#A13E59"))
    myplot = myplot + theme(legend.position="none", axis.title.x=element_blank(), plot.title = element_text(lineheight=.8, face="bold", color="#665B5B", vjust=3, size =16))
    myplot = myplot + labs(y = "Note moyenne")
    myplot = myplot + theme(axis.text=element_text(size = 12), axis.title.y=element_text(vjust=2, size = 14))
    myplot
    }
    
  })
  
  

  # ------------------------------------------------------------
  #                 Lineplot et note globale
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
  
 #Evolution temporelle des notes  
  calcul_evolrating_french <- function(){
    dates <- unique(data_plageEtude()$date)
    notes_french <-rep(0,length(dates))
    for (i in 1:length(dates)){
      notes_french[i] <- ((sum(data_detail()[date==dates[i],]$note))/(sum(data_detail()[date==dates[i],]$nb_note)))
    }
    return(notes_french)
  }
  
  output$line_evolrating = renderPlot({
    dates <- unique(data_detail_0()$date)
    data_lineplot <- data.frame(dates,calcul_evolrating_french())
    
    evol_rating = ggplot(data=data_lineplot, aes(x=as.factor(dates), y=calcul_evolrating_french(), colour = "#A13E59"))
    evol_rating = evol_rating + geom_point(size=4) + geom_line(size=2)
    evol_rating = evol_rating + labs(title = 'Evolution de la note globale')
    evol_rating = evol_rating + scale_color_manual(values="#A13E59")
    evol_rating = evol_rating + theme(legend.position="none", axis.title.x=element_blank(), plot.title = element_text(lineheight=.8, face="bold", color="#665B5B", vjust=3, size =18))
    evol_rating = evol_rating + labs(y = "Note globale")
    evol_rating = evol_rating + theme(axis.text=element_text(size = 8), axis.title.y=element_text(vjust=2, size = 14), axis.text.x = element_text(angle = 45, hjust = 1))
    evol_rating
  })
  #note globale moyenne sur date ou moyenne tot ?
  output$note_globale <- renderText({paste("NOTE GLOBALE :",round((sum(data_detail()$note)/sum(data_detail()$nb_note)),2))})
  
  #stars
  output$star_note_globale <- renderImage({
    filename <- normalizePath(file.path(paste("./www/",fonction_stars(((sum(data_detail()$note))/(sum(data_detail()$nb_note)))),".png",sep="")))
    list(src=filename)
  }, deleteFile=FALSE)
  
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
  leaf <- reactive({
    #countours regions
    map_regions<-geojsonio::geojson_read("./france-geojson-master/regions.geojson", what = "sp")
    leaflet(map_regions) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addLegend(title = 'Notes moyennes par régions', colors= NULL, labels= NULL, opacity = 0.9, position = 'topright') %>%
      
    # On se place sur la France
    setView(lng = 5, lat = 41, zoom = 5)
  })
    
  output$map_france <- renderLeaflet({
    map_regions<-geojsonio::geojson_read("./france-geojson-master/regions.geojson", what = "sp")
    #echelle à definir
    bins <- c(4,4.1,4.2,4.25,4.3,4.35,4.4,4.45,4.5,4.6,5)
    notes_carte_region<-c(mean(calcul_notes('ile-de-france')),
                          mean(calcul_notes('centre-val-de-loire')),
                          mean(calcul_notes('bourgogne-franche-comte')),
                          mean(calcul_notes('normandie')),
                          mean(calcul_notes('hauts-de-france')),
                          mean(calcul_notes('grand-est')),
                          mean(calcul_notes('pays-de-la-loire')),
                          mean(calcul_notes('bretagne')),
                          mean(calcul_notes('nouvelle-aquitaine')),
                          0,
                          0,
                          0,
                          0,
                          0,
                          mean(calcul_notes('occitanie')),
                          mean(calcul_notes('auvergne-rhone-alpes')),
                          mean(calcul_notes('provence-alpes-cote-d-azur')),
                          mean(calcul_notes('corse')))
    #notes_carte_region<-c(4,4.5,3.5,2,5,4,3,3.5,4.2,4.5,4.6,3.8,4.5,4.1,4.8,3.5,2.5,2)
    pal <- colorBin("YlGn", domain = map_regions$nom, bins = bins)
    labels <- sprintf(
      "<strong>%s</strong><br/>Note globale : %g",
      map_regions$nom, round(notes_carte_region,2)
    ) %>% lapply(htmltools::HTML)
    
    
    return(leaf() %>% addPolygons(fillColor = ~pal(as.numeric(notes_carte_region)),
                                    weight = 2,
                                    opacity = 1,
                                    color = "white",
                                    dashArray = "3",
                                    fillOpacity = 0.6,
                                    highlight = highlightOptions(
                                      weight = 5,
                                      color = "#666",
                                      dashArray = "",
                                      fillOpacity = 0.7,
                                      bringToFront = TRUE),
                                    label = labels,
                                    labelOptions = labelOptions(
                                      style = list("font-weight" = "normal", padding = "3px 8px"),
                                      textsize = "15px",
                                      direction = "auto")) %>%
             addLegend(pal = pal, 
                       values = ~notes_carte_region, 
                       opacity = 0.7, 
                       title = paste("Notes globales <br/> calculées sur",sum(data_plageEtude()$nb_note),"commentaires<br/> sur la période :",input$periode_etude[1],"à",input$periode_etude[2]),
                       position = "topright")
           )
                                  
  })
  
}


 


