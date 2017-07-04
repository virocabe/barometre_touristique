library(data.table)
library(shiny)
library(shinydashboard)
library(plotly)
library(radarchart)
library(leaflet)

source("global.R")


header <- dashboardHeader(title = "Baromètre",
                          tags$li(a(href = 'http://www.sia-partners.com/services/data-science',
                                    img(src = 'logo_sia-partners2.png',
                                        title = "Sia Partners", width = '120px', height = '50px'),
                                    style = "padding-top:0px; padding-bottom:0px;"),
                                  class = "dropdown"))

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    
    id="tabs",
    menuItem("Accueil", tabName = "accueil", icon = icon("home")),
    menuItem("Vue carte", tabName = "carte", icon = icon("map")),
    menuItem("Analyse comparative des régions", tabName = "global", icon = icon("dashboard")),
    
    menuItem("Fiche d'identité région", tabName = "detail", icon = icon("bar-chart")),
    dateRangeInput("periode_etude", 
                   label = "Choix de la période d'analyse", 
                   start = "2013-01-01", end = "2017-06-01", 
                   min = "2013-01-01", max = "2017-06-01", 
                   format = "yyyy-mm-dd", 
                   startview = "year", 
                   weekstart = 0, 
                   language = "fr", 
                   separator = " au ", 
                   width = NULL),
    
    conditionalPanel("input.tabs == 'detail'",
                     selectizeInput("detail_region", 
                                    label = "Focus sur la région", 
                                    choices = list_regions,
                                    multiple =FALSE,
                                    selected = 'corse')
    ),
    menuItem(""),
    menuItem("Méthodologie", tabName = "methodo", icon = icon("flask")),
    menuItem("Qui sommes-nous ?", tabName = "presentation", icon = icon("diamond")),
    menuItem("Nous contacter", tabName = "contact", icon = icon("envelope"))
    
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  tabItems(
    
    # ------------------------------------------------------------
    #                 Onglet Accueil
    # ------------------------------------------------------------
    
    tabItem(tabName = "accueil",
            fluidRow(
              
              column(
                width = 12,
                h1("Tourisme - Baromètre de la e-réputation des régions", style = "color : #690f3c; text-align:center"), br())
            ),
            fluidRow(
              column(
                width =2
              ),
              column(
                width = 8,
                box(p("Ce baromètre a pour objectif d'offrir une analyse comparative des régions dans le domaine touristique, selon 3 axes principaux déterminés par Sia Partners :", 
                      style = "font-size : 12pt; text-align : justify")
                    , header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 2
              )
            ),
            fluidRow(
              column(
                width =2
              ),
              column(
                width = 8,
                box(p(strong("L'offre de services"), 
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    img(src = "offre-services.PNG"),
                    p(strong("L'offre de loisirs"), 
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    img(src = "offre-loisirs.PNG"),
                    p(strong("Le patrimoine (naturel et culturel)"), 
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    img(src = "patrimoine.PNG"),
                    header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 2
              )
            ),
            fluidRow(
              column(
                width =1
              ),
              column(
                width = 10,
                box(br(),
                    p(icon(name = "bullseye"),"Un focus plus détaillé par région (Carte d'identité) est proposé afin de permettre aux professionnels du tourisme et acteurs impliqués dans les politiques en la matière, aux habitants et aux curieux
                      d'en savoir plus sur les atouts et la perception du territoire par les touristes.", 
                      style = "font-size : 12pt; text-align : justify"),
                    p(icon(name = "info-circle"),"Ce baromètre n'a pas vocation a être exhaustif : des analyses plus approfondies peuvent être conduites sur demande. A titre illustratif,
                      Sia Partners a accompagné le Comité Régional de Tourisme d'Ile de France pour la réalisation d'un diagnostic du potentiel touristique francilien en 2016.", 
                      style = "font-size : 12pt; text-align : justify"),
                    header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 1
              )
            ),
            fluidRow(
              column(
                width =1
              ),
              column(
                width = 10,
                box(br(),
                    p(strong("Sources")),
                    p("En termes méthodologique, la e-réputation des régions dans le domaine touristique résulte de l'analyse des notes et commentaires/avis publiés sur 3 principaux review-sites sur le Web sélectionnés
                      par Sia Partners en raison de leur notoriété et de leur fréquentation :", 
                      style = "font-size : 12pt; text-align : justify"),
                    p("- TripAdvisor", 
                      style = "font-size : 12pt; text-align : justify"),
                    p("- Booking", 
                      style = "font-size : 12pt; text-align : justify"),
                    p("- Lafourchette", 
                      style = "font-size : 12pt; text-align : justify"),
                    br(),
                    p(strong("Modalités de restitution")),
                    p("Par défaut, la période d'analyse porte sur les notes, avis et commentaires publiés depuis le 1er janvier 2013 par l'ensemble des touristes quelque soit leur pays d'origine.", 
                      style = "font-size : 12pt; text-align : justify"),
                    p("Les notes moyennes obtenues sur un même critère ont été rapportées sur une même échelle et pondérées en fonction du nombre de commentaires de chaque source pour calculer la note globale.",
                      style = "font-size : 12pt; text-align : justify"),
                    p("Il est possible de paramétrer l'affichage des indicateurs, afin de sélectionner une période d'analyse plus restreinte dans le temps.",
                      style = "font-size : 12pt; text-align : justify"),
                    header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 1
              )
            ),
            fluidRow(
              column(
                width =1
              ),
              column(
                width = 10,
                box(br(),
                    p(icon(name = "arrow-right"),"Pour en savoir plus, vous pouvez consulter la page Méthodologie ou nous contacter directement.", 
                      style = "font-size : 12pt; text-align : justify"),
                    header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 1
              )
            )
            
            
    ),
  
    # ------------------------------------------------------------
    #                 Onglet Carte
    # ------------------------------------------------------------
    
    tabItem(tabName = "carte",
      leafletOutput("map_france", height = "1000px")
        

    ),
    
    # ------------------------------------------------------------
    #                 Onglet Synthese Globale
    # ------------------------------------------------------------
    
    tabItem(tabName = "global",
            fluidRow(box(header = FALSE, solidHeader = TRUE,
              column(
                width = 6 ,img(src = 'auvergne-rhone-alpes.png')
                ),
              column(
                width = 6, box(title = strong("Auvergne-Rhone-Alpes"), 
                               span(textOutput("note1"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),  
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star1"), style = "margin-left : 0"),HTML("</div>"),
                               em("La region ou ... volcans !"),
                               header = FALSE, solidHeader = TRUE, width = NULL)
              )
              ),
              
              box(header = FALSE, solidHeader = TRUE,
              column(
              width = 6, img(src = 'bourgogne-franche-comte.png')
              ),

              column(
                width = 6, box(title = strong("Bourgogne-Franche-Comte"), 
                               span(textOutput("note2"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star2"), style = "margin-left : 0"),HTML("</div>"),
                               em("La region ou.... fromage !"),
                               header = FALSE, solidHeader = TRUE, width = NULL)
              )
              )
            ),
            fluidRow(
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE , 
                span(textOutput("note1_activite1"), style = "font-size : 10pt; font-family : Arial; color : #690f3c"),
                span(textOutput("note1_activite2"), style = "font-size : 10pt; font-family : Arial; color : #690f3c"),
                span(textOutput("note1_activite3"), style = "font-size : 10pt; font-family : Arial; color : #690f3c")
                )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE , 
                span(textOutput("note2_activite1"), style = "font-size : 10pt; font-family : Arial; color : #690f3c"),
                span(textOutput("note2_activite2"), style = "font-size : 10pt; font-family : Arial; color : #690f3c"),
                span(textOutput("note2_activite3"), style = "font-size : 10pt; font-family : Arial; color : #690f3c")
                )
              )
            ),
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE , chartJSRadarOutput("radarPlot1"))
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE , chartJSRadarOutput("radarPlot2"))
              )
            ),
            
            fluidRow(box(
              column(
                width = 6 ,img(src = 'bretagne.png')
              ),
              column(
                width = 6, box(title = strong("Bretagne"), 
                               span(textOutput("note3"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star3"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
              
                )
              ),
              box(
              column(
                width = 6, img(src = 'centre-val-de-loire.png')
              ),
              column(
                width = 6, box(title = strong("Centre-Val-de-Loire"), 
                               span(textOutput("note4"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                               
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star4"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
              
                )
              ),

              fluidRow(
                column(
                  width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot3"))
                ),
                column(
                  width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot4"))
                )
              )
            ),
            
              fluidRow(box(
                column(
                  width = 6 ,img(src = 'corse.png')
                ),
                column(
                  width = 6, box(title = strong("Corse"), 
                                 span(textOutput("note5"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                                 
                                 HTML("<div style='height: 35px;'>"),img(imageOutput("star5"), style = "margin-left : 0"),HTML("</div>"),
                                 header = FALSE, solidHeader = TRUE, width = NULL )
                  )
                ),
                box(
                column(
                  width = 6, img(src = 'grand-est.png')
                ),
                column(
                  width = 6, box(title = strong("Grand-Est"), 
                                 span(textOutput("note6"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                                 
                                 HTML("<div style='height: 35px;'>"),img(imageOutput("star6"), style = "margin-left : 0"),HTML("</div>"),
                                 header = FALSE, solidHeader = TRUE, width = NULL )
                  )
                )
              ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot5") )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot6") )
              )
            ),
            
            fluidRow(box(
              column(
                width = 6 ,img(src = 'hauts-de-france.png')
              ),
              column(
                width = 6, box(title = strong("Hauts-de-France"), 
                               span(textOutput("note7"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                               
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star7"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
              
                )
              ),
              box(
              column(
                width = 6, img(src = 'ile-de-france.png')
              ),
              column(
                width = 6, box(title = strong("Ile-de-France"), 
                               span(textOutput("note8"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                               
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star8"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
              )
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot7") )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot8"))
              )
            ),
            
            fluidRow(box(
              column(
                width = 6 ,img(src = 'normandie.png')
              ),
              column(
                width = 6, box(title = strong("Normandie"), 
                               span(textOutput("note9"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                               
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star9"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
                )
              ),
              box(
              column(
                width = 6, img(src = 'nouvelle-aquitaine.png')
              ),
              column(
                width = 6, box(title = strong("Nouvelle-Aquitaine"), 
                               span(textOutput("note10"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                               
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star10"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
                )
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot9") )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot10"))
              )
            ),
            
            fluidRow(box(
              column(
                width = 6 ,img(src = 'occitanie.png')
              ),
              column(
                width = 6, box(title = strong("Occitanie"), 
                               span(textOutput("note11"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                               
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star11"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
                )
              ),
              box(
              column(
                width = 6, img(src = 'pays-de-la-loire.png')
              ),
              column(
                width = 6, box(title = strong("Pays de la Loire"), 
                               span(textOutput("note12"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                               
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star12"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
                )
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot11") )
              ),
              column(
                width = 6, box(width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot12"))
              )
            ),
            
            fluidRow(box(
              column(
                width = 6 ,img(src = "provence-alpes-cote-d'azur.png")
              ),
              column(
                width = 6, box(title = strong("Provence-Alpes-Cote d'Azur"), 
                               span(textOutput("note13"), style = "font-size : 15pt; font-family : Arial; color : #690f3c"),                               
                               HTML("<div style='height: 35px;'>"),img(imageOutput("star13"), style = "margin-left : 0"),HTML("</div>"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
                )
              ),
              
              column(
                width = 6
              )
            ),
            
            fluidRow(
              column(
                width = 6, box( width = NULL, header = FALSE, solidHeader = TRUE, chartJSRadarOutput("radarPlot13") )
              ),
              column(
                width = 6)
            )
    
            ),
    
    
    # ------------------------------------------------------------
    #                 Onglet fiche d'identite detaillee
    # ------------------------------------------------------------
    
    tabItem(tabName = "detail",
            fluidRow(
              column(
                width = 6, 
                box(div(p("Affiner la restitution", style = "font-size: 15pt; text-align:center"), selectizeInput("type_activite", "Type d'activité", list_type_activites, selected = "offre de services", multiple = FALSE, width = NULL),
                    selectizeInput("sous_type_activite", "Catégorie", choices = NULL, multiple = FALSE, width = NULL), style = "background:#f5f5f5; padding : 5pt;  padding-top : 2pt;border-radius : 3pt"),
                    header = FALSE, solidHeader = TRUE, width = NULL),
                div(
                  imageOutput("myImage"),
                  h3(textOutput("note_globale"), style = "text-align:center"),
                  HTML("<div style='height: 35px;'>"),img(imageOutput("star_note_globale")),HTML("</div>"),
                  br()
                )),
              column(
                width = 6, 
                box(
                    header = FALSE, solidHeader = TRUE, width = NULL,
                    plotOutput("histo_themes_restauration_hebergement"))
              )),
            fluidRow(
              column(
                width = 6,box(
                              header = FALSE, solidHeader = TRUE, width = NULL,
                              plotOutput("line_evolrating"))
                ),
              column(
              width = 6,p(strong("Ce qu'ils disent de l'offre"), style ="font-size:16pt"),
              box(wordcloud2Output("wordcloudshaped"),
              header = FALSE, solidHeader = TRUE, width = NULL)
              )
              
            )
            ),
    
    # ------------------------------------------------------------
    #                 Onglet methodo
    # ------------------------------------------------------------
    
    tabItem(tabName = "methodo",
            fluidRow(
              column(
                width =1
              ),
              column(
                width = 11,
                h1("Méthodologie", style = "color : #690f3c"), br())
              
            ),
            
            fluidRow(
              column(
                width =1
              ),
              column(
                width = 10,
                box(h3("Axes d'analyses"), br(),
                    p(strong("L'offre de services : "), "Cet axe couvre les établissements proposant une offre d'hébergement ou de restauration." ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    img(src = "offre-services.PNG"), 
                    p(strong("L'offre de loisirs : "), "Cet axe comprend les sites et activités de type activités en plein air, jeux et divertissements, vie nocturne, shopping, etc.",
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    img(src = "offre-loisirs.PNG"),
                    p(strong("Le patrimoine : "), "Cet axe englobe a la fois ce qui relève du patrimoine culturel (musées, sites et monuments) et du patrimoine naturel (plages, sites d'exception, parcs naturels, forêts, grottes, etc.", 
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    img(src = "patrimoine.PNG"),
                    header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 1
              )
            ),
            
            fluidRow(
              column(
                width =1
              ),
              column(
                width = 10,
                box(h3("Onglet : Analyse comparative des régions"), br(),
                    p(strong("Note globale : "), style = "font-size : 12pt;margin-left : 10px"),
                    p("Il s'agit de la note moyenne sur 5 obtenue par la région pour les 3 axes (Offre de services, Offre culturelle, Patrimoine)." ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    p("Cette note est également déclinée pour chaque axe (visualisable sur le radar et dans la page Carte d'identité des régions)." ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 1
              )
            ),
            
            fluidRow(
              column(
                width =1
              ),
              column(
                width = 10,
                box(h3("Onglet : Fiche identité région"), br(),
                    p(strong("Note globale de satisfaction 'Restauration' : "), style = "font-size : 12pt;margin-left : 10px"),
                    p("Notes obtenues sur les différentes sources rapportées sur une même échelle (sur 5) et pondérées en fonction du nombre de commentaires de chaque source (commentaires postérieurs au 01/01/2013)" ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    p("Sources : TripAdvisor, Lafourchette" ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    br(),
                    p(strong("Sous-critères"),
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    tags$ul(
                      tags$li("Cadre : source Lafourchette", style = "margin-left : 10px"),
                      tags$li("Cuisine : source Lafourchette", style = "margin-left : 10px"),
                      tags$li("Service : source Lafourchette", style = "margin-left : 10px")
                    ),
                    br(),
                    p(strong("Nuage de mots 'Ce qu'ils disent de l'offre restauration'"), style = "font-size : 12pt;margin-left : 10px"),
                    p("Analyse sémantique des commentaires rédigés sur des restaurants du territoire régional, avec mise en exergue des principaux termes qui ressortent (présents dans au moins 10% des contenus textes)" ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    p("Sources : TripAdvisor, Lafourchette" ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    br(),
                    br(),
                    p(strong("Note globale de satisfaction 'Hébergement' : "), style = "font-size : 12pt;margin-left : 10px"),
                    p("Notes obtenues sur les différentes sources rapportées sur une même échelle (sur 5) et pondérées en fonction du nombre de commentaires de chaque source (commentaires postérieurs au 01/01/2013)" ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    p("Sources : TripAdvisor, Booking" ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    br(),
                    p(strong("Sous-critères"),
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    tags$ul(
                      tags$li("Chambres : source Booking", style = "margin-left : 10px"),
                      tags$li("Service : source Booking", style = "margin-left : 10px"),
                      tags$li("Prix : source Booking", style = "margin-left : 10px")
                    ),
                    br(),
                    p(strong("Nuage de mots 'Ce qu'ils disent de l'offre hébergement'"), style = "font-size : 12pt;margin-left : 10px"),
                    p("Analyse sémantique des commentaires rédigés sur des hôtels / chambres d'hôtes / complexes hôteliers du territoire régional, avec mise en exergue des principaux termes qui ressortent (présents dans au moins 10% des contenus textes)" ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    p("Sources : TripAdvisor, Booking" ,
                      style = "font-size : 12pt; text-align : justify;margin-left : 10px"),
                    header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 1
              )
            )
            
            ),
    
    
    # ------------------------------------------------------------
    #                 Onglet qui-sommes nous
    # ------------------------------------------------------------
     
    tabItem(tabName = "presentation",
            fluidRow(
              column(
                width =1
              ),
              column(
                width = 11,
                h1("Sia Partners en quelques mots", style = "color : #690f3c"), br())
              
            ),
            
            fluidRow(
              column(
                width =2
              ),
              column(
                width = 8,
                box(p(strong("Sia Partners est le leader français indépendant des cabinets de conseil en management."),"Fort d'une équipe de consultants de haut niveau,
                     nous accompagnons nos clients dans la conduite de leurs projets de transformation. Avec un portefeuille d'expertises de premier plan, 
                    nous apportons un regard innovant et des résultats concrets. Sia Partners est une partnership mondiale détenue a 100% par ses dirigeants.", 
                      style = "font-size : 12pt; text-align : justify")
                    , header = FALSE, solidHeader = TRUE, width = NULL)),
              column(
                width = 2
              )              
              
            ),
            
            fluidRow(
              column(
                width = 11,
                h1("En quelques chiffres", style = "text-align : right; color : #690f3c"), br()),
              column(
                width =1
              )
            ),
            
            fluidRow(
              column(
                width = 1
                ),
              
              column(
                width = 2,
                img(src = "sia-chiffres.PNG", style = "margin-right : 0pt")
              ),
              
              column(
                width = 3, 
                box(div(h2("Chiffres Clés", style = "margin-top : 0pt"), 
                        hr(style = "margin-top : 0pt; margin-bottom : 1pt; border-color : #690f3c"),
                    "140 M€ de Chiffre d'Affaires", br(),
                    "Créé en 1999", br(),
                    "20 bureaux", br(),
                    "45 Partners"),
                    header = FALSE, solidHeader = TRUE, width = NULL)
              ),
              
              column(
                width = 2,
                img(src= "sia-equipe.PNG", style = "margin-right : 0pt")
              ),
              
              column(
                width = 3,
                box(div(h2("Notre équipe", style = "margin-top : 0pt"), 
                        hr(style = "margin-top : 0pt; margin-bottom : 1pt; border-color : #690f3c"),
                        "Plus de 850 consultants", br(),
                        "Présent dans 15 pays", br(),
                        "Couvre 21 secteurs et services"),
                    header = FALSE, solidHeader = TRUE, width = NULL)
              ),
              
              column(
                width = 1
              )
            ),
            
            fluidRow(
              column(
                width = 1
              ),
              
              column(
                width = 2,
                img(src= "sia-clients.PNG", style = "margin-right : 0pt")
              ),
              
              column(
                width = 3,
                box(div(h2("Nos clients", style = "margin-top : 0pt"), 
                        hr(style = "margin-top : 0pt; margin-bottom : 1pt; border-color : #690f3c"),
                        "Plus de 230 clients", br(),
                        "Plus de 7000 missions depuis sa création", br(),
                        "20% des clients clefs faisant partie des 500 compagnies classées par le magazine Fortune"),
                    header = FALSE, solidHeader = TRUE, width = NULL)
              ),
              
              column(
                width = 2,
                img(src= "sia-services.PNG", style = "margin-right : 0pt")
              ),
              
              column(
                width = 3,
                box(div(h2("Nos services", style = "margin-top : 0pt"), 
                        hr(style = "margin-top : 0pt; margin-bottom : 1pt; border-color : #690f3c"),
                        "15% Stratégie", br(),
                        "70% Projets de transformation", br(),
                        "15% Stratégie IT et digitale"),
                    header = FALSE, solidHeader = TRUE, width = NULL)
              ),
              
              column(
                width = 1
              )   
            ),
            fluidRow(style = "background-color : #f5f5f5",
              column(
                width = 1
              ),
              column(
                width = 5, div(br(),
                              img(src = "data-science.PNG"),
                               h3("UC Data Science", style = "text-align:center"),br()
                               )
              ),
              column(
                width = 5, div(br(),img(src = "secteur-public.PNG"),
                               h3("UC Secteur Public", style = "text-align:center"),br())
              ),
              column(
                width = 1
              )
            ),
            
            fluidRow(
                     column(
                       width = 1
                     ),
                     column(
                       width = 5, div(br(),
                         p("L'unité de Compétences Data Science, développée il y a presque 2 ans chez Sia Partners sur un mode start-up, regroupe des consultants disposant de compétences en matière de modélisation statistique et machine learning.", 
                           style = "text-align : justify"),
                         p("Convaincus qu'un projet de data science repose sur des itérations entre les expertises statistiques et métiers, l'équipe compte aujourd'hui 20 consultants alliant la connaissance des secteurs (énergie, transport, secteur public, banque/assurance, etc..) aux compétences techniques et business.", style ="text-align : justify"),
                         p("Une expertise au service de l'ensemble des secteurs :"),
                         p(strong("Marketing Analytics"), ": 90% des données collectées par les entreprises sont des données relatives aux clients. L'optimisation des actions marketing soulève 4 questions fondamentales : Qui sont mes clients ?
                            Quels sont leurs comportements et opinions ? Sur quels clients dois-je concentrer mes efforts ? Quelle est leur rentabilité future ?", style = "margin-left : 10px"),
                         p(strong("Etude de perception"), ": L'évaluation de la perception client est une méthode d'analyse de la valeur qui permet une meilleure compréhension des relations que vous entretenez avec vos clients.", style = "margin-left : 10px"),
                         p(strong("Detection d'atypisme"), ": avec l'intensification et l'instantanéité des échanges numériques, la détection de dysfonctionnements et de fraudes est devenue une priorité, notamment pour les organismes publics et financiers.", style = "margin-left : 10px"),
                         p(strong("Prevision"), "En permettant d'ajuster les stocks et l'approvisionnement a l'offre et la demande, les techniques de prévision contribuent a une meilleure maitrise des couts dans les maillons de la chaine de valeur des entreprises.", style = "margin-left : 10px"),
                         p(strong("Pricing"), ": Le développement du e-commerce et la pression concurrentielle de plus en plus forte dans certains secteurs, font du pricing et de l'optimisation associée des enjeux clés pour rester compétitif.
                            Les techniques de pricing permettent de répondre aux questions : Quels critères pour fixer le prix? Quel est l'impact du prix?? Quel est le signal prix? Comment optimiser la valeur percue? Quelle stratégie tarifaire adopter?", style = "margin-left : 10px"),
                         style = "padding-left : 30px; padding-right : 30px")
                     ),

                     column(
                       width = 5, div(br(),
                          p("Créée en 2011 et dotée d'une quarantaine de consultants, l'équipe a su gagner en quelques années la confiance des acteurs de la sphère publique
                            (Administrations centrales et déconcentrées : Services du Premier Ministre, SGMAP, DINSIC, Ministère de la Justice, Ministère de l'Intérieur, Ministère de la Défense, ...)
                             ; Collectivités territoriales : Région PACA, Région Pays de la Loire, Département de la Charente, Eurométropole de Strasbourg, Grand Dijon, Métropole de Lyon, ...)
                             ; Opérateurs de l'Etat et établissements publics : ACOSS, Pôle Emploi, CNAF, Musée du Louvre, Opéra de Paris, CNFPT, etc.)", 
                                    style = "text-align : justify"),
                          
                          p("Notre coeur d'intervention :"),
                          tags$ul(
                          tags$li("Accompagnement des projets de transformation dans toutes leurs composantes (de l'appui stratégique a la conduite opérationnelle du changement)", style = "margin-left : 10px"),
                          tags$li("Accompagner la composante humaine des organisations (GPEC, prévention de l'absentéisme et des risques psycho-sociaux, politique de qualité de vie au travail, ingénierie sociale, etc.)", style = "margin-left : 10px"),
                          tags$li("Améliorer la performance opérationnelle et s'appuyer sur la composante managériale et l'embarquement des agents (projets d'administration / de
                            service, mise en oeuvre de démarches participatives ou de concertation, etc.)", style = "margin-left : 10px")
                          ),
                          p("Forts de leurs expériences réussies et de leur approche adaptée aux véritables besoins des acteurs publics, nos consultants proposent des solutions ajustées
                             permettant d'apporter, en tout synergie avec les équipes, des solutions concrètes et cohérentes aux problèmes et contraintes qui pèsent sur les acteurs publics", style = "text-align : justify"),
                          style = "padding-left : 30px; padding-right : 30px"), br(),
                          a(img(src="picto-secteur-public.PNG"), href = "http://secteur-public.sia-partners.com")
                          
                     ),
                     column(
                       width = 1
                     )
            )
            ),
    
    # ------------------------------------------------------------
    #                 Onglet contact
    # ------------------------------------------------------------
    
    tabItem(tabName = "contact",
            fluidRow(
              img(src = "sia-world.PNG")
            ),
            
            fluidRow(
              column(
                width = 1
              ),
              column(
                width = 11, 
                h1("Contact", style = "text-align : left; color : #690f3c"), br()
              )
            ),
            
            fluidRow(
              column(
                width = 1
              ),
              column(
                width = 5, h2("France", style = "margin-top : 0pt; text-align: left")
              ),
              column(
                width = 5, h2("Nous contacter directement", style = "margin-top: 0pt; text-align:left")
              ),
              column(
                width = 1
              )
            ),
            
            fluidRow(
              column(
                width = 1
              ),
              column(
                width = 2,
                box(p("- Paris", br(),
                "12 Rue Magellan", br(),
                "75008 Paris", br(),
                "+33 1 42 77 76 17", br(),
                "+33 1 42 77 76 16"),
                header = FALSE, solidHeader = TRUE, width = NULL
                )
              ),
              column(
                width = 3,
                box(p("- Lyon", br(), 
                "3 Rue du Président Carnot", br(),
                "69002 Lyon", br(),
                "+33 1 42 77 76 17", br(),
                "+33 1 42 77 76 16"),
                header = FALSE, solidHeader = TRUE, width = NULL
                )
              ),
              
              column(
                width = 3,
                box(p(strong("Olivier DUPONT"), br(), 
                    "Associate Partner - Secteur Public France", br(),
                    "olivier.dupont@sia-partners.com"),
                    
                    header = FALSE, solidHeader = TRUE, width = NULL
                )
              ),
              column(
                width = 3,
                box(p(strong("Romain LAURANS"), br(), 
                    "Responsable Data Science", br(),
                    "romain.laurans@sia-partners.com"),
                  
                    header = FALSE, solidHeader = TRUE, width = NULL
                )
              )
              ),
            fluidRow(
              column(
                width=9
              ),
              
              column(
                width=3,
                column(
                  width= 3, 
                  a(img(src="picto-web.png"), href = "http://www.sia-partners.com/")
                ),
                column(
                  width = 3,
                  a(img(src="picto-twitter.png"), href = "https://twitter.com/siapartners")  
                ),
                column(
                  width = 3,
                  a(img(src = "picto-linkedin.png"), href = "https://www.linkedin.com/company-beta/22581/")
                ),
                column(
                  width = 3,
                  a(img(src="picto-youtube.png"), href="https://www.youtube.com/user/SiaConseil/featured")  
                )
                
              )
            )
              
    )

    )
)




ui <- dashboardPage(header,sidebar,body,
                    uiOutput('type_activite'))