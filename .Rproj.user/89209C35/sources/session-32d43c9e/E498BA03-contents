source(file = "librarys.R",encoding = "UTF-8",local = F)
source(file = "funcoes.R",encoding = "UTF-8",local = F)

espaco_html <<- function(n=6){
  
  
  return(HTML( rep("<br>",n)))
  
  
}
blu    <- 'rgb(100, 140, 240)'
dblu   <- 'rgb(0, 0, 102)'
red    <- 'rgb(200, 30, 30)'
dred   <- 'rgb(100, 30, 30)'
f1     <- list(family = "Arial", size = 10, color = "rgb(30, 30, 30)")
size_card = c(8,4)


sobre3 <- dropdown(

  fluidRow(column(width=12)),
  fluidRow(column(width = 12,

                    fluidRow(HTML('<i class="fa fa-info-circle"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                                     <b style = "padding-left:0px;color:#000000;font-size:30px;">
                                                     Coeficiente de Incidência </b>')),

                    withMathJax(),
                    "A incidência acumulada no Estado - período de 27 de julho de 2019 a 11 de julho de 2020 é de 1.803,44 casos por
100.000 hab. (204.785/11.348.937 hab.). Considera-se situação de Epidemia quando o espaço geográfico atinge
a incidência acumulada maior de 299,99 casos/100.000 hab, em um determinado período.",withMathJax(),
                    "$$ \\frac{ \\text{Número de casos confirmados}} { \\text{População Total residente}} \\times 100.000 $$"

                  )),




  style = "jelly", icon = icon("question"),
  status = "primary", width = "auto",
  tooltip =  tooltipOptions(title = "Veja mais sobre este gráfico!",placement = "right"),
  animate = animateOptions(
    enter = animations$fading_entrances$fadeInLeftBig,duration = 0.25,
    exit = animations$fading_exits$fadeOutLeftBig
  )
)



ui <- bs4DashPage(
  #### Cabeçalho da página -----------              
  header = bs4DashNavbar(
    tags$style(".main-header {max-height: 145px}"),
    tags$style(".main-header .logo {height: 145px;}"),
    tags$style(".sidebar-toggle {height: 145px; padding-top: 1px !important;}"),
    tags$style(".navbar {min-height:145px !important}"),
    tags$img(class="logo",
             src = "header_informe_dateless.png", title = "DASHBOARD DENGUE ",
             height="100",width="1360", 
             style = "margin-top: 0px; margin-left: 0px")
    ),
  
  ### Sidebar Menu lateral da página | Esta disposto todas as abas para navegação --------------
  sidebar = bs4DashSidebar(disable = F,
                           inputId = "main_sidebar",
                           title = strong("DASHBOARD",style = "color:#000000;font-size:22px"),
                           src = "https://raw.githubusercontent.com/mleal93/projeto_dengue_git/master/www/dash_logo.png",
                           src = "favicon.ico",
                           expand_on_hover = T,
                           elevation = 5,
                           skin = "light",
                           
                           bs4SidebarMenu(id = "main_sidebar_menu",
                                          flat = T,
                                          compact = T,
                                          childIndent  = F,
                                          
                                          bs4SidebarMenuItem(
                                            text = "Panorama",
                                            icon = icon(name = "home"),
                                            startExpanded = F,
                                            tabName = "tab1"),
                                          
                                          bs4SidebarMenuItem(
                                            text = "Descritivo",
                                            icon = icon("map-marked-alt"),
                                            startExpanded = F,
                                            tabName = "tab2"),
                                          
                                          bs4SidebarMenuItem(
                                            text = "Diagrama Controle",
                                            icon = icon("chart-line"),
                                            startExpanded = F,
                                            tabName = "tab3"
                                            ), 
                                          
                                          bs4SidebarMenuItem(
                                            text = "Sobre",
                                            icon = icon("info"),
                                            startExpanded = F,
                                            tabName = "tab4")
                                          )
                           ),
  ### Rodape da pagina ---------------                         
   footer = bs4DashFooter(
     HTML(
   '<div class="footer">
  <div style="width: 100%;">
    <center>
       <div style="display:inline-flex">
        <a href="http://www.saude.pr.gov.br/">
        <img src="http://www.saude.pr.gov.br/sites/default/arquivos_restritos/files/imagem/2020-02/LogoSaude2019_Horizontal.png" style="height:80px">
      </a>
      <a href="http://www.uem.br/">
        <img src="https://s3-sa-east-1.amazonaws.com/casadenoticias/article_shots/images/27939/header/uem-modelo-01.png?1580416312" style="width:168px;padding-left:15px;">
      </a>

      </div>
    </center>
  </div>
</div>'
   )
   ),
  
  ### Titulo do pagina --------------------
  title = "Dashboard Arboviroses",
  
  controlbar = dashboardControlbar(
    skin = "light",
    
    inputId = "control.bar",
    
    actionBttn(inputId = "open.modal",
               label = "Relatório",
               icon = icon(name = "file-pdf"),
               block = T,
               style = "material-flat")
    ),
  
  body = bs4DashBody(
    tabItems(
      tabItem(tabName = "tab1",
              fluidRow(
                column(
                  width=12,
                  HTML('<i class="fa fa-home"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                       <b style = "padding-left:15px;color:#000000;font-size:30px;">PANORAMA GERAL - DASHBOARD ARBOVIROSES </b>')
                  )
                ),
              
                  bs4Card(
                    title = fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                                     tags$b(c("PRINCIPAIS INDICADORES"),style="padding-left:10px;"),style="font-size:24px"),
                    width = 12,
                    solidHeader = F,
                    headerBorder = F,
                    maximizable = F,
                    collapsible = F,
                    closable = F,
                    
                      fluidRow(column(width = 4,
                                      div(
                                        style = 'text-align:center',
                                      radioGroupButtons(
                                        inputId = "select.indicadores",
                                        label = "Escolha:",
                                        choiceNames = c("Epidemia",
                                                        "Alerta",
                                                        "Baixo",
                                                        "Sem Casos",
                                                        "Outros"),
                                        
                                        choiceValues  = c("epidemia","alerta","baixo","na","oindicadores")
                                      ))),
                               column(width = 6,
                                      div(
                                        style = 'text-align:center',
                                      tags$head(
                                        tags$style(HTML("
                      .selectize-input {
                      height: 20px;
                      width: 200px;
                      font-size: 16pt;
                      padding-left: 20px;
                      }
                                      "))),
                                      # selectizeGroupUI(
                                      #   id = "ftable1",inline = F,
                                      #   params = list(
                                      #     macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                                      #     regional = list(inputId = "regional", title = "Regional:"),
                                      #     nome = list(inputId = "nome", title = "Cidade:")
                                      #   ))
                                      ))),espaco_html(2),
                    withSpinner(uiOutput("indicadores"))
                    ),
                       bs4Card(
                         title = fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                                          tags$b(c("INCIDÊNCIAS"),style="padding-left:10px;"),style="font-size:24px",
                                          div(sobre3,style="padding-left:175px;")
                                          ),
                         
                         width = 12,
                         closable = FALSE,
                         maximizable = TRUE,
                         collapsible = TRUE,
                         collapsed = FALSE,
                         labelText = icon("question"),
                         labelTooltip = HTML("Classificação dos municípios segundo incidência de dengue por 100.000
                                                  habitantes – Paraná – Semana Epidemiológica. Fonte: Coordenadoria de Vigilância Ambiental /SESA"),
                         radioGroupButtons(
                           inputId = "select.mapinc",
                           label = "Escolha:",
                           choiceNames = c("Incidências",
                                           "Incidências 4 Últ. Semanas",
                                           "Óbitos",
                                           "LIA"),

                           choiceValues  = c("inc","inc4","obitos","lia"),
                           status = "primary"
                         ),
                         withSpinner(leafletOutput("map.descritive3",height = 680))
                       
                
              ),
              

             #  bs4Sortable(
             #    width = 4,
             #
             # ),
             #  bs4Sortable(
             #    width = 4,
             #  ,
             #  bs4Sortable(
             #    width = 4,
             #  ,
             #  bs4Sortable(
             #    width = 4,
             #    bs4Card(
             #      title = NULL,
             #      width = 12,solidHeader = F,headerBorder = F,maximizable = T,collapsible = F,closable = F,
             #
             #
             #
             #
             #
             #    )),
             bs4Card(
                              title = fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                                               tags$b(c("CASOS DENGUE, D.S.A E D.G"),style="padding-left:10px;"),style="font-size:24px"),
                              width = 12,solidHeader = F,headerBorder = F,maximizable = T,collapsible = F,closable = F,
                              tags$style(type = "text/css", "#plot.serie.dengue {height: calc(100vh - 80px) !important;}"),
                              withSpinner( plotlyOutput(outputId = "plot.serie.dengue",height = 600))
                            

                            ),
             
                         bs4Card(
                           title = fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                                            tags$b(c("PROPORÇÃO DE CASOS DENGUE, D.S.A E D.G"),style="padding-left:10px;"),style="font-size:24px"),
                           width = 12,solidHeader = F,headerBorder = F,maximizable = T,collapsible = F,closable = F,

                           withSpinner( plotlyOutput(outputId = "plot.pie.dengues",height = 600))
                         

             ),

                            bs4Card(
                              title = fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                                               tags$b(c("RANK CIDADES"),style="padding-left:10px;"),style="font-size:24px"),
                              width = 12,solidHeader = F,headerBorder = F,maximizable = T,collapsible = F,closable = F,
                              withSpinner( plotlyOutput(outputId = "plot.bar.rank10city",height = 600))

                            

             )



            




            ),

    
### Pagina 2 - Descritiva
    tabItem(tabName = "tab2",
            fluidRow(column(width=12,
                            HTML('<i class="fa fa-map-marked-alt"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                  <b style = "padding-left:15px;color:#000000;font-size:30px;">DESCRITIVO </b>'))),
            espaco_html(2),

            fluidRow(
              column(width = 8,
                            bs4Card(
                              title = fluidRow(HTML('<i class="fa fa-map-marked-alt" style = "color:#0072B2;font-size:25px"></i>'),
                                               tags$b(c("MAPA POR MACRORREGIÃO"),style="padding-left:10px;"),style="font-size:24px"),
                              #status = "transparent",
                              width = 12,
                              closable = FALSE,
                              maximizable = TRUE,
                              collapsible = TRUE,
                              collapsed = FALSE,
                              labelText = icon("question"),
                              labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia. Após realizar algum filtro, as cidades que não possuirem casos confirmados, permanecerão ocultas."),
                              withSpinner(leafletOutput("map.descritive",height = 600))
                            )
            ),
            column(width = 4,
                   bs4Card(
                     title = fluidRow(HTML('<i class="fa fa-map-marked-alt" style = "color:#0072B2;font-size:25px"></i>'),
                                      tags$b(c("FILTRO"),style="padding-left:10px;"),style="font-size:24px"),
                     #status = "transparent", 
                     width = 12,
                     closable = FALSE,
                     maximizable = TRUE,
                     collapsible = TRUE,
                     collapsed = FALSE,
                     labelText = icon("question"),
                     labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
                     fluidRow(

                       #maps.cities2
                           selectizeGroupUI(
                             id = "myfilters",inline = F,
                             params = list(
                               macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                               regional = list(inputId = "regional", title = "Regional:",width=12),
                               nome.x = list(inputId = "nome", title = "Cidade:")
                             )
                           )
                           # DT::dataTableOutput(outputId = "table"),
                           # style='overflow-y: scroll;height:760px;font-size:16px;text-align:justify'
                     )
                     )
                   )
            ),
            
            espaco_html(2),
            
            
            useShinyjs(),
            # extendShinyjs(text = jscode),
            # extendShinyjs(text = jscode1),
            #uiOutput("paineis.descritive"),
            bs4Card(
              title = fluidRow(HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
                               tags$b(c("PAINEL")),style="font-size:24px"),
              width = 12,
              closable = FALSE,
              maximizable = TRUE,
              collapsible = TRUE,
              collapsed = FALSE,
              labelText = icon("question"),
              labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
              
              withSpinner(plotlyOutput(outputId = "descritive.sexo",height=550)),
                          withSpinner( plotlyOutput("descritive.idade",height=550)),
                                       withSpinner(plotlyOutput("descritive.escolaridade",height=550)),
                                                   
                                                   bs4Card(
                                                     title = fluidRow(HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
                                                                      tags$b(c("CASOS NÃO GESTANTES")),style="font-size:24px"),
                                                     #status = "transparent",
                                                     width = 12,
                                                     closable = FALSE,
                                                     maximizable = TRUE,
                                                     collapsible = TRUE,
                                                     collapsed = FALSE,
                                                     labelText = icon("question"),
                                                     labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
                                                     espaco_html(4),
                                                     withSpinner(plotlyOutput("descritive.gestante",height=700))
                                                     
                                                   ),
                                                   
                                                   bs4Card(
                                                     title = fluidRow(HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
                                                                      tags$b(c("CASOS GESTANTES")),style="font-size:24px"),
                                                     #status = "transparent",
                                                     width = 12,
                                                     closable = FALSE,
                                                     maximizable = TRUE,
                                                     collapsible = TRUE,
                                                     collapsed = FALSE,
                                                     labelText = icon("question"),
                                                     labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
                                                     espaco_html(4),
                                                     withSpinner( plotlyOutput("descritive.gestante2",height=600))
                                                     
                                                   ), 
                                                   fluidRow(bs_embed_tooltip(prettySwitch(
                                                     inputId = "switch.serie",
                                                     label = strong(textOutput("Habilitar Série com Barras")),width = 30,
                                                     fill = TRUE, status = "primary"
                                                   ),placement = "left",
                                                   title = "Habilitar Barchart"),style="padding-left:50px;paddint-top:10px;"),
                                                   withSpinner( plotlyOutput("plot.serie",height = 550)
             
              ))
              
              
              


),

### Pagina 6 - Diagrama Controle
tabItem(tabName = "tab3",
        fluidRow(column(width=12,
                        HTML('<i class="fa fa-chart-line"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                  <b style = "padding-left:15px;color:#000000;font-size:30px;">DIAGRAMA CONTROLE </b>'))),
        
        
        fluidRow(column(width = 12,
                        bs4Card(
                          title = fluidRow(HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
                                           tags$b(c("COMPARAÇÃO DAs SÉRIES TEMPORAIS DOS CASOS DE DENGUE - 2007 a 2020")),style="font-size:24px"),
                          #status = "transparent",
                          width = 12,
                          closable = FALSE,
                          maximizable = TRUE,
                          collapsible = TRUE,
                          collapsed = FALSE,
                          labelText = icon("question"),
                          labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
                          
                          withSpinner(plotlyOutput("analise_serie"))
                          
                          
                        ),espaco_html(4),
                        
                        bs4Card(
                          title = fluidRow(HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
                                           tags$b(c("DIAGRAMA CONTROLE")),style="font-size:24px"),
                          #status = "transparent",
                          width = 12,
                          closable = FALSE,
                          maximizable = TRUE,
                          collapsible = TRUE,
                          collapsed = FALSE,
                          labelText = icon("question"),
                          labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
                          
                          withSpinner(plotlyOutput("plot_diagrama_controle"))
                          
                          
                        )
        ),
        column(width = 4
               # bs4Card(
               #   title = fluidRow(HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
               #                    tags$b(c("LISTA")),style="font-size:24px"),
               #   status = "transparent", width = 12,
               #   closable = FALSE,
               #   maximizable = TRUE,
               #   collapsible = TRUE,
               #   collapsed = FALSE,
               #   labelText = icon("question"),
               #   labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
               #   fluidRow(
               #
               #     #maps.cities2
               #
               #     # selectizeGroupUI(
               #     #   id = "myfilters3",inline = F,
               #     #   params = list(
               #     #     MACRO = list(inputId = "MACRO", title = "Macroregional:"),
               #     #     RS = list(inputId = "RS", title = "Regional:",width=12)
               #     #
               #     #   )
               #     # ),
               #     #DT::dataTableOutput(outputId = "table3"),
               #     style='overflow-y: scroll;height:760px;font-size:16px;text-align:justify'
               #   )
               #
               # )
        )
        )
),


### Pagina 5 - Sobre
tabItem(tabName = "tab4",
        fluidRow(column(width=6,
                        fluidRow(column(width=12,
                                        HTML('<i class="fa fa-info"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                  <b style = "padding-left:15px;color:#000000;font-size:30px;">SOBRE </b>'))),
                        
                        p("Arboviroses são as doenças causadas pelos chamados arbovírus, que incluem o vírus da dengue, Zika vírus, febre chikungunya e febre amarela.
                            A classificação \"arbovírus\" engloba todos aqueles transmitidos por artrópodes, ou seja, insetos e aracnídeos (como aranhas e carrapatos)."),
                        
                        p("Existem 545 espécies de arbovírus, sendo que 150 delas causam doenças em seres humanos. Apesar de a classificação arbovirose ser utilizada
                            para classificar diversos tipos de vírus, como o mayaro, meningite e as encefalites virais, hoje a expressão tem sido mais usada para designar
                            as doenças transmitidas pelo Aedes aegypti, como o Zika vírus, febre chikungunya, dengue e febre amarela.")
        ),
        column(width=6,
               fluidRow(column(width=12,
                               HTML('<i class="fa fa-info"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                  <b style = "padding-left:15px;color:#000000;font-size:30px;">COLABORADORES </b>'))),
               HTML('<div class="footer">
  <div style="width: 100%;">
    <left>
       <div style="display:inline-flex">
        <a href="http://www.saude.pr.gov.br/">
        <img src="http://www.saude.pr.gov.br/sites/default/arquivos_restritos/files/imagem/2020-02/LogoSaude2019_Horizontal.png" style="height:80px">
      </a>
      <a href="http://www.uem.br/">
        <img src="https://s3-sa-east-1.amazonaws.com/casadenoticias/article_shots/images/27939/header/uem-modelo-01.png?1580416312" style="width:168px;padding-left:15px;">
      </a>

      </div>
    </left>
  </div>
</div>')
               
        ),
        style="text-align:justify;"
        )
        
)








)

)
)

           
             
            



     









    
    
    


