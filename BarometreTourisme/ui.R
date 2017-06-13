library(data.table)
library(shiny)
library(shinydashboard)
library(plotly)
library(radarchart)
library(leaflet)

source("global.R")
source("config.R")

header <- dashboardHeader(title = "Baromètre",
                          tags$li(a(href = 'http://www.sia-partners.com/services/data-science',
                                    img(src = 'logo_sia-partners2.png',
                                        title = "Sia Partners", width = '120px', height = '50px'),
                                    style = "padding-top:0px; padding-bottom:0px;"),
                                  class = "dropdown"))

sidebar <- dashboardSidebar(
  
  sidebarMenu(
    
    id="tabs",
    menuItem("Présentation", tabName = "accueil", icon = icon("home")),
    menuItem("Cartographie des régions", tabName = "carte", icon = icon("map")),
    menuItem("Synthèse globale", tabName = "global", icon = icon("dashboard")),
    
    menuItem("Fiche d'identité région", tabName = "detail", icon = icon("bar-chart")),
    dateRangeInput("periode_etude", 
                   label = "Période d'étude", 
                   start = NULL, end = NULL, 
                   min = NULL, max = NULL, 
                   format = "yyyy-mm", 
                   startview = "year", 
                   weekstart = 0, 
                   language = "fr", 
                   separator = " au ", 
                   width = NULL),
    conditionalPanel("input.tabs == 'global'",
                     selectizeInput("langue", 
                                    label = "Langue", 
                                    choices = choix_langues,
                                    multiple =FALSE,
                                    selected = 'tous')
    ),
    conditionalPanel("input.tabs == 'detail'",
                     selectizeInput("detail_region", 
                                    label = "Région", 
                                    choices = list_regions,
                                    multiple =FALSE,
                                    selected = 'corse'),
                         selectizeInput("axe_analyse", 
                                    label = "Type d'activité", 
                                    choices = list_type_activites,
                                    multiple =FALSE,
                                    selected = 'offre de services')
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
            fluidRow("Presentation")
            
            
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
            fluidRow(
              column(
                width = 3 ,img(src = 'auvergne-rhone-alpes.png')
                ),
              column(
                width = 3, box(title = strong("Auvergne-Rhone-Alpes"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               em("La region ou ... volcans !"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
              width = 3, img(src = 'bourgogne-franche-comte.png')
              ),
              column(
                width = 3, box(title = strong("Bourgogne-Franche-Comte"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"),
                               img(src = 'stars.PNG', style = "margin-left : 0"),
                               em("La region ou.... fromage !"),
                               header = FALSE, solidHeader = TRUE, width = NULL )
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
            fluidRow(
              column(
                width = 3 ,img(src = 'bretagne.png')
              ),
              column(
                width = 3, box(title = strong("Bretagne"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"),  
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
                width = 3, img(src = 'centre-val-de-loire.png')
              ),
              column(
                width = 3, box(title = strong("Centre-Val-de-Loire"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               header = FALSE, solidHeader = TRUE, width = NULL )
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
            
              fluidRow(
                column(
                  width = 3 ,img(src = 'corse.png')
                ),
                column(
                  width = 3, box(title = strong("Corse"), 
                                 p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                                 img(src = 'stars.PNG', style = "margin-left : 0"), 
                                 header = FALSE, solidHeader = TRUE, width = NULL )
                ),
                column(
                  width = 3, img(src = 'grand-est.png')
                ),
                column(
                  width = 3, box(title = strong("Grand-Est"), 
                                 p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                                 img(src = 'stars.PNG', style = "margin-left : 0"), 
                                 header = FALSE, solidHeader = TRUE, width = NULL )
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
            
            fluidRow(
              column(
                width = 3 ,img(src = 'hauts-de-france.png')
              ),
              column(
                width = 3, box(title = strong("Hauts-de-France"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
                width = 3, img(src = 'ile-de-france.png')
              ),
              column(
                width = 3, box(title = strong("Ile-de-France"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               header = FALSE, solidHeader = TRUE, width = NULL )
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
            
            fluidRow(
              column(
                width = 3 ,img(src = 'normandie.png')
              ),
              column(
                width = 3, box(title = strong("Normandie"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
                width = 3, img(src = 'nouvelle-aquitaine.png')
              ),
              column(
                width = 3, box(title = strong("Nouvelle-Aquitaine"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               header = FALSE, solidHeader = TRUE, width = NULL )
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
            
            fluidRow(
              column(
                width = 3 ,img(src = 'occitanie.png')
              ),
              column(
                width = 3, box(title = strong("Occitanie"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               header = FALSE, solidHeader = TRUE, width = NULL )
              ),
              column(
                width = 3, img(src = 'pays-de-la-loire.png')
              ),
              column(
                width = 3, box(title = strong("Pays de la Loire"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               header = FALSE, solidHeader = TRUE, width = NULL )
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
            
            fluidRow(
              column(
                width = 3 ,img(src = "provence-alpes-cote-d'azur.png")
              ),
              column(
                width = 3, box(title = strong("Provence-Alpes-Cote d'Azur"), 
                               p("Note globale : 4.72/5", style = "font-size : 16pt; font-family : Arial; color : #690f3c"), 
                               img(src = 'stars.PNG', style = "margin-left : 0"), 
                               header = FALSE, solidHeader = TRUE, width = NULL )
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
                width = 6, infoBox(title = (
                tags$p(style = "font-size: 15px; font-style: bold;", "NOTE GLOBALE")),
                value = (tags$p(style = "font-size: 27px;", "4.56")), 
                icon = icon("star"), fill = FALSE, color = "purple", width = NULL
                )),
              column(
                width = 6,
                box(
                    header = FALSE, solidHeader = TRUE, width = NULL,
                    plotlyOutput("barplot_themes"))
              )),
            fluidRow(
              column(
                width = 6,box(
                              header = FALSE, solidHeader = TRUE, width = NULL,
                              plotlyOutput("lineplot_ratings"))
                ),
              column(
              width = 6,box(wordcloud2Output("wordcloudshaped"),
                            header = FALSE, solidHeader = TRUE, width = NULL)
              )
              
            )
            ),
    
    # ------------------------------------------------------------
    #                 Onglet methodo
    # ------------------------------------------------------------
    
    tabItem(tabName = "methodo",
            fluidRow("Methodo")
            
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
                         p(strong("Marketing Analytics"), ": 90% des donnees collectees par les entreprises sont des donnees relatives aux clients. L'optimisation des actions marketing souleve 4 questions fondamentales : Qui sont mes clients ?
                            Quels sont leurs comportements et opinions ? Sur quels clients dois-je concentrer mes efforts ? Quelle est leur rentabilite future ?", style = "margin-left : 10px"),
                         p(strong("Etude de perception"), ": L'evaluation de la perception client est une methode d'analyse de la valeur qui permet une meilleure comprehension des relations que vous entretenez avec vos clients.", style = "margin-left : 10px"),
                         p(strong("Detection d'atypisme"), ": avec l'intensification et l'instantaneite des echanges numeriques, la detection de ysfonctionnements et de fraudes est devenue une priorite, notamment pour les organismes publics et financiers.", style = "margin-left : 10px"),
                         p(strong("Prevision"), "En permettant d'ajuster les stocks et l'approvisionnement a l'offre et la demande, les techniques de prevision contribuent a une meilleure maitrise des couts dans les maillons de la chaine de valeur des entreprises.", style = "margin-left : 10px"),
                         p(strong("Pricing"), ": Le developpement du e-commerce et la pression concurrentielle de plus en plus forte dans cetains secteurs, font du pricing et de l'optimisation associee des enjeux cles pour rester competitif.
                            Les techniques de pricing permettent de repondre aux questions : Quels criteres pour fixer le prix? Quel est l'impact du prix?? Quel est le signal prix? Comment optimiser la valeur percue? Quelle strategie tarifaire adopter?", style = "margin-left : 10px"),
                         style = "padding-left : 30px; padding-right : 30px")
                     ),

                     column(
                       width = 5, div(br(),
                          p("Créée en 2011 et dotée d'une quarantaine de consultants, l'équipe a su gagner en quelques années la confiance des acteurs de la sphère publique
                            (Administrations centrales et déconcentrées : Services du Premier Ministre, SGMAP, DINSIC, Ministère de la Justice, Ministère de l'Intérieur, Ministère de la Défense, ...)
                             ; Collectivités territoriales : Région PaCA, Région Pays de la Loire, Département de la Charente, Eurométropole e Strasbourg, Grand Dijon, Métropole de Lyon, ...)
                             ; Opérateurs de l'Etat et établissements publics : ACOSS, Pôle Emploi, CNAF, MUsée du Louvre, Opéra de Paris, CNFPT, etc.)", 
                                    style = "text-align : justify"),
                          p("Notre coeur d'intervention :"),
                          p("Accompagnement des projets de transformation dans toutes leurs composantes (de l'appui stratégique a la conduite opérationnelle du changement)", style = "margin-left : 10px"),
                          p("Accompagner la composante humaine des organisations (GPEC, prévention de l'absentéisme et des risques psycho-sociaux, politique de qualité de vie au travail, ingénierie sociale, etc.)", style = "margin-left : 10px"),
                          p("Améliorer la performance opérationnelle et s'appuyer sur la composante managériale et l'embarquement des agents (projets d'administration / de
                            service, mise en oeuvre de démarches participatives ou de concertation, etc.)", style = "margin-left : 10px"),
                          p("Forts de leurs expériences réussies et de leur approche adaptée aux véritables besoins des acteurs publics, nos consultants proposent des solutions ajustées
                             permettant d'apporter, en tout synergie avec les équipes, des solutions concrètes et cohérentes aux problèmes et contraintes qui pèsent sur les acteurs publics", style = "text-align : justify"),
                          style = "padding-left : 30px; padding-right : 30px")
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
                width = 5, h2("France", style = "margin-top : 0pt")
              ),
              column(
                width = 5, h2("Nous contacter via le site", style = "margin-top: 0pt; text-align:center")
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
                box("- Paris", br(),
                "12 Rue Magellan", br(),
                "75008 Paris", br(),
                "+33 1 42 77 76 17", br(),
                "+33 1 42 77 76 16",
                header = FALSE, solidHeader = TRUE, width = NULL
                )
              ),
              column(
                width = 3,
                box("- Lyon", br(), 
                "3 Rue du Président Carnot", br(),
                "69002 Lyon", br(),
                "+33 1 42 77 76 17", br(),
                "+33 1 42 77 76 16",
                header = FALSE, solidHeader = TRUE, width = NULL
                )
              ),
              
              column(
                width = 4, div(br(),a(href = "http://sia-partners.com/contact", img(src = "sia-home.PNG")))
              ),
              column(
                width = 2
              )
              )
              
    )

    )
)




ui <- dashboardPage(header,sidebar,body)