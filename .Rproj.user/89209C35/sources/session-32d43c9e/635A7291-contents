source(file = "librarys.R",encoding = "UTF-8",local = F)
source(file = "panel.R",encoding = "UTF-8",local = F)
#source(file = "source.sql.R",encoding = "UTF-8",local = F)

source(file = "funcoes.R",encoding = "UTF-8",local = F)
df1 <<- read.table(file = "dbase_reduzido.csv",header = T,sep = ",")

 # df.notificados <-  df1 %>% filter(SG_UF == 41) %>% group_by(ID_MN_RESI) %>% summarise(Freq=n() )
 # 
 # df.notificados.serie  <- df1 %>% filter(SG_UF == 41) %>%
 #    mutate(date = format(as.Date(DT_NOTIFIC),format="%Y-%U",digits = 1),
 #           date2 = cut.Date(as.Date(DT_NOTIFIC), breaks = "1 week", labels = FALSE)) %>%
 #    group_by(date2) %>%
 #    summarise(frequencia = n())
 # 
 # 
 # df.notificados.serie <-data.frame(labels=df.notificados.serie$date2,
 #                                   values.not=df.notificados.serie$frequencia,
 #                                   row.names = df.notificados.serie$date2)


df.notificados <-  df1 %>% filter(SG_UF == 41) %>% group_by(ID_MN_RESI) %>% summarise(Freq=n() )

# df.notificados.serie  <- df1 %>% filter(SG_UF == 41) %>%
#    mutate(date = format(as.Date(DT_NOTIFIC),format="%Y-%U",digits = 1),
#           date2 = cut.Date(as.Date(DT_NOTIFIC), breaks = "1 week", labels = FALSE)) %>%
#    group_by(date2) %>%
#    summarise(frequencia = n())

df.notificados.serie2  <- df1 %>% filter(SG_UF == 41) %>%
   group_by(SEM_NOT) %>%
   summarise(frequencia = n())
write.csv(x = df.notificados.serie2,file = "dadosdengue.csv",row.names = F)


df.notificados.serie <-data.frame(labels=df.notificados.serie2$SEM_NOT,
                                  values=df.notificados.serie2$frequencia,
                                  row.names = df.notificados.serie2$SEM_NOT)

 
 df.autoctone <-  df1 %>% filter(TPAUTOCTO == 1 & SG_UF == 41) %>% group_by(ID_MN_RESI) %>% summarise(Freq=n() )
 
 # df.autoctone.serie <- df1 %>% filter(TPAUTOCTO == 1 & SG_UF == 41) %>%
 #    mutate(date = format(as.Date(DT_NOTIFIC),format="%Y-%U",digits = 1),
 #           date2 = cut.Date(as.Date(DT_NOTIFIC), breaks = "1 week", labels = FALSE)) %>%
 #    group_by(date2) %>%
 #    summarise(frequencia = n())
 # 
 # df.autoctone.serie <-data.frame(labels=df.autoctone.serie$date2,
 #                                   values.not=df.autoctone.serie$frequencia,
 #                                   row.names = df.autoctone.serie$date2)




df1 <<- df1[df1$CLASSI_FIN==10|df1$CLASSI_FIN==11|df1$CLASSI_FIN==12,]

df02 <- df1 %>%
   mutate(date = format(as.Date(DT_NOTIFIC),format="%Y-%U",digits = 1),
          date2 = cut.Date(as.Date(DT_NOTIFIC), breaks = "1 week", labels = FALSE)) %>%
   group_by(SEM_NOT) %>%
   summarise(frequencia = n())

df02 <-data.frame(label=df02$SEM_NOT,values=df02$frequencia)
pos1 <-which(is.na(df02[,1]))
df02 <- df02[-pos1,]


don2 <<- data.frame(labels = df02$label,values=df02$values,row.names = df02$label )

# # 
# # df.label <- ymd(as.Date(df02$label))
# # df02$label <- df.label

# # don$labels <- as.Date(don$labels)
# # don2$labels <<- as.Date(don2$labels)



data.range <- range(as.Date(df1$DT_NOTIFIC),na.rm = T)
data.range <- format(data.range,format="%d/%m/%Y")


# df.label <- ymd(as.Date(df.investigacao.serie$label))
# df.investigacao.serie$label <- df.label
# 
# don.serie.inv <- data.frame(values.inv=df.investigacao.serie$values,labels = df.investigacao.serie$label,row.names = df.investigacao.serie$label )
# 
# don.serie.inv$labels <- as.Date(don.serie.inv$labels)
source(file = "source.descritivo2.R",encoding = "UTF-8",local = F)


#source(file = "aba_map_server.R",encoding = "UTF-8",local = F)
#source(file = "source.maps.density.R",encoding = "UTF-8",local = F)

lia                 <- readxl::read_xls(path = "www/Planilha IIP.xls",sheet = "Plan1") 
lia                 <- lia %>% filter(!is.na(`Código IBGE`)) %>% select(`Código IBGE`,Condição,Método) %>% rename(Codigo=`Código IBGE`)
lia$Codigo          <- as.numeric(lia$Codigo )


 #test<-lia %>% group_by(Codigo) %>% summarise(freq=n())



regionais                 <- readxl::read_xlsx(path = "www/regionais.xlsx",sheet = "Planilha1")
coordenadas.municipios    <- readxl::read_xls(path = "www/Coordenadas_Municipios.xls",sheet = "Cidades")  %>% rename(Codigo=GEOCODIGO_MUNICIPIO)
regionais$nome            <- tolower(rm_accent(as.character(regionais$nome)))

maps.cities2               <- get_brmap(geo = "City", geo.filter = list(State=41),class="sf") %>% select(nome,City) %>% rename(Codigo = City)
maps.cities2$nome          <- tolower(rm_accent(as.character(maps.cities2$nome)))

maps.cities2                      <- left_join(x = regionais,y = maps.cities2,"nome") 


   
setview <- data.frame(lng= -51.6391,lat = -24.5401)
blu <- 'rgb(100, 140, 240)'
dblu <- 'rgb(0, 0, 102)'
red <- 'rgb(200, 30, 30)'
dred <- 'rgb(100, 30, 30)'
f1 <- list(family = "Arial", size = 10, color = "rgb(30, 30, 30)")
size_card = c(8,4)







 server <- function(input, output) {

    
    dados.maps.pr                       <- readxl::read_xlsx(path = "www/dados.pr.xlsx",sheet = "Worksheet") %>% select(`Município [-]`,`Código [-]`,`População estimada - pessoas [2019]`,`Área Territorial - km² [2019]`) %>% rename(Codigo=`Código [-]`)
    dados.maps.pr$`Município [-]`            <- tolower(rm_accent(as.character(dados.maps.pr$`Município [-]`)))
    
    dados.maps.pr                       <- left_join(dados.maps.pr,maps.cities2,"Codigo")
    dados.maps.pr[which(is.na(dados.maps.pr$macroregional)),"macroregional"]  <- "Leste"
    dados.maps.pr                       <- st_as_sf(x = dados.maps.pr)
    colnames(coordenadas.municipios)[1] <- "Codigo"
    coordenadas.municipios$Codigo       <- as.numeric(coordenadas.municipios$Codigo)
    dados.maps.pr                       <- left_join(dados.maps.pr,coordenadas.municipios,"Codigo") %>% select(-NOME_MUNICIPIO)
    
    dados.maps.pr$Codigo                 <- as.numeric(gsub('.{1}$', '', dados.maps.pr$Codigo))
    casos                                <- df1 %>% group_by(ID_MN_RESI) %>% summarise(Casos=n())  %>% rename(Codigo=ID_MN_RESI)
    obitos                               <- df1 %>% filter(EVOLUCAO == 2) %>% group_by(ID_MN_RESI) %>% summarise(Obitos = n()) %>% rename(Codigo=ID_MN_RESI)
    
    dados.maps.pr                        <- left_join(dados.maps.pr,casos,"Codigo")
    dados.maps.pr                        <- left_join(dados.maps.pr,obitos,"Codigo")
    dados.maps.pr                        <- dados.maps.pr %>% mutate(incidencia=(as.numeric(Casos)/as.numeric(`População estimada - pessoas [2019]`))*100000)
    casos_auto                           <- df1 %>% filter(TPAUTOCTO == 1 & SG_UF == 41) %>% group_by(ID_MN_RESI) %>% summarise(`Casos Autóctones`=n()) %>% mutate(Codigo=ID_MN_RESI)
    dados.maps.pr                        <- left_join(dados.maps.pr,casos_auto,"Codigo")
    dados.maps.pr                        <- dados.maps.pr %>% mutate(incidencia_auto=(as.numeric(`Casos Autóctones`)/as.numeric(`População estimada - pessoas [2019]`))*100000)
    w <- as.Date(today()) - weeks(4)
    casos_auto_4semanas                  <- df1 %>% filter(TPAUTOCTO == 1 & SG_UF == 41 & as.Date(DT_NOTIFIC) > w) %>% group_by(ID_MN_RESI) %>% summarise(`Casos Autóctones 4 Útimas Semanas`=n()) %>% mutate(Codigo=ID_MN_RESI) %>% select(-ID_MN_RESI)
    dados.maps.pr                        <- left_join(dados.maps.pr,casos_auto_4semanas,"Codigo")
    dados.maps.pr                        <- dados.maps.pr %>% mutate(incidencia_auto_4semanas=(as.numeric(`Casos Autóctones 4 Útimas Semanas`)/as.numeric(`População estimada - pessoas [2019]`))*100000)
    
    dengue_dsa                           <- df1 %>% filter(CLASSI_FIN == 11) %>% group_by(ID_MN_RESI) %>% summarise(DSA=n())  %>% rename(Codigo=ID_MN_RESI)
    dengue_dg                            <- df1 %>% filter(CLASSI_FIN == 12) %>% group_by(ID_MN_RESI) %>% summarise(DG=n())  %>% rename(Codigo=ID_MN_RESI)
    dados.maps.pr                        <- left_join(dados.maps.pr,dengue_dsa,"Codigo")
    dados.maps.pr                        <- left_join(dados.maps.pr,dengue_dg,"Codigo")
    
    dados.lia                        <- left_join(dados.maps.pr,lia,"Codigo")
    #dados.lia                        <- dados.lia %>% filter(!is.na(macroregional))
    dados.lia                        <-distinct(dados.lia,"Codigo",.keep_all = TRUE)
    
    # library(arcgisbinding)
    # arc.check_product()
    # arc.write(path = "dados/info",data = dados.maps.pr)
    dados_descritive <- dados.maps.pr %>% filter(!is.na(Casos))
    qtd_regionais <- unique(dados_descritive$regional)
    qtd_regionais <- length(qtd_regionais[!is.na(qtd_regionais)])
    res_mod <<- callModule(
       module = selectizeGroupServer,
       id = "myfilters",
       data = dados_descritive,
       vars = c("macroregional", "regional", "nome")
    )
    output$table <- DT::renderDataTable(res_mod(),
                                        options = list(
                                           pageLength = 5,
                                           scrollX=TRUE,
                                           searching = FALSE,
                                           autoWidth = FALSE
                                        ))

   # observeEvent(list(input$toTop6), {
   #                  # input$toTop2,input$toTop3,input$toTop4,input$toTop5,input$toTop6), {
   #   shinyjs::runjs("window.scrollTo(0, 0)")
   # })


    opac                                <- reactiveValues(values = rep(1,length(maps.cities2$nome)))
   #opac2 <- reactiveValues(values = rep(1,length(maps.cities2$nome.x)))

    
    # dados.maps.pr                        <- readxl::read_xlsx(path = "www/dados.pr.xlsx",sheet = "Worksheet") %>% select(`Município [-]`,`Código [-]`,`População estimada - pessoas [2019]`,`Área Territorial - km² [2019]`) %>% rename(Codigo=`Código [-]`)
    # dados.maps.pr$`Município [-]`        <- tolower(rm_accent(as.character(dados.maps.pr$`Município [-]`)))
    # 
    # dados.maps.pr                        <- left_join(dados.maps.pr,maps.cities2,"Codigo")
    # dados.maps.pr[which(is.na(dados.maps.pr$macroregional)),"macroregional"]  <- "Leste"
    # dados.maps.pr                        <- st_as_sf(x = dados.maps.pr)
    # colnames(coordenadas.municipios)[1]  <- "Codigo"
    # coordenadas.municipios$Codigo        <- as.numeric(coordenadas.municipios$Codigo)
    # dados.maps.pr                        <- left_join(dados.maps.pr,coordenadas.municipios,"Codigo") %>% select(-NOME_MUNICIPIO)
    # 
    # dados.maps.pr$Codigo                 <- as.numeric(gsub('.{1}$', '', dados.maps.pr$Codigo))
    # 
    # casos                                <- df1 %>% group_by(ID_MN_RESI) %>% summarise(Casos=n())  %>% rename(Codigo=ID_MN_RESI)
    # obitos                               <- df1 %>% filter(EVOLUCAO == 2) %>% group_by(ID_MN_RESI) %>% summarise(Obitos = n()) %>% rename(Codigo=ID_MN_RESI)
    # dados.maps.pr                        <- left_join(dados.maps.pr,casos,"Codigo")
    # dados.maps.pr                        <- left_join(dados.maps.pr,obitos,"Codigo")
    # dados.maps.pr                        <<- dados.maps.pr %>% mutate(incidencia=(as.numeric(Casos)/as.numeric(`População estimada - pessoas [2019]`))*100000)
    # 
    # dengue_dsa                           <- df1 %>% filter(CLASSI_FIN == 11) %>% group_by(ID_MN_RESI) %>% summarise(DSA=n())  %>% rename(Codigo=ID_MN_RESI)
    # dengue_dg                            <- df1 %>% filter(CLASSI_FIN == 12) %>% group_by(ID_MN_RESI) %>% summarise(DG=n())  %>% rename(Codigo=ID_MN_RESI)
    # dados.maps.pr                        <<- left_join(dados.maps.pr,dengue_dsa,"Codigo")
    # dados.maps.pr                        <<- left_join(dados.maps.pr,dengue_dg,"Codigo")
    
    
    #dados.maps.pr[which(is.na(dados.maps.pr$macroregional)),] 
    
    #####

    
    output$indicadores <- renderUI({ 
      
      if(input$select.indicadores == "epidemia"){
        
        epi.city      <- dados.maps.pr %>% filter(incidencia > 300) %>% select(c(nome,Codigo,`População estimada - pessoas [2019]`,
                                                                                 regional,macroregional,Casos,DSA,DG,Obitos,incidencia))
        epi.city$geometry <- NULL
        
        res_mod_epi <<- callModule(
          module = selectizeGroupServer,
          id = "ftable1",
          data = epi.city,
          vars = c("macroregional", "regional", "nome"))
        
        fluidRow(fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                          tags$b(paste0("Municípios em Epidemia - ",table_resumo$Epidemia),style="padding-left:10px;"),style="font-size:24px"),
                 fluidRow(
                   selectizeGroupUI(
                     id = "ftable1",inline = F,
                     params = list(
                       macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                       regional = list(inputId = "regional", title = "Regional:"),
                       nome = list(inputId = "nome", title = "Cidade:")
                     )
                   ),
                   withSpinner(DT::dataTableOutput(outputId = "table_epi"))
                 ))
        
        
        
        
        
        
      }else if(input$select.indicadores == "alerta"){
        
        
        epi.city      <- dados.maps.pr %>% filter(incidencia >= 100 & incidencia <= 300) %>% select(c(nome,Codigo,`População estimada - pessoas [2019]`,
                                                                                                      regional,macroregional,Casos,DSA,DG,Obitos,incidencia))
        epi.city$geometry <- NULL
        
        
        res_mod_alerta <<- callModule(
          module = selectizeGroupServer,
          id = "ftable2",
          data = epi.city,
          vars = c("macroregional", "regional", "nome"))
        
        fluidRow(fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                          tags$b(paste0("Municípios em Alerta - ",table_resumo$Alerta),style="padding-left:10px;"),style="font-size:24px"),
                 fluidRow(
                   selectizeGroupUI(
                     id = "ftable2",inline = F,
                     params = list(
                       macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                       regional = list(inputId = "regional", title = "Regional:",width=12),
                       nome = list(inputId = "nome", title = "Cidade:")
                     )
                   ),
                   withSpinner(DT::dataTableOutput(outputId = "table_alerta"))
                 ))
        
        
      }else if(input$select.indicadores == "baixo"){
        
        epi.city      <- dados.maps.pr %>% filter( incidencia < 100) %>% select(c(nome,Codigo,`População estimada - pessoas [2019]`,
                                                                                  regional,macroregional,Casos,DSA,DG,Obitos,incidencia))
        epi.city$geometry <- NULL
        
        res_mod_baixo <<- callModule(
          module = selectizeGroupServer,
          id = "ftable3",
          data = epi.city,
          vars = c("macroregional", "regional", "nome"))
        
        fluidRow(fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                          tags$b(paste0("Municípios com Baixo Indice - ",table_resumo$Baixo),style="padding-left:10px;"),style="font-size:24px"),
                 fluidRow(
                   selectizeGroupUI(
                     id = "ftable3",inline = F,
                     params = list(
                       macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                       regional = list(inputId = "regional", title = "Regional:",width=12),
                       nome = list(inputId = "nome", title = "Cidade:")
                     )
                   ),
                   withSpinner(DT::dataTableOutput(outputId = "table_baixo"))
                 ))
        
        
      }else if(input$select.indicadores == "na"){
        
        
        epi.city      <- dados.maps.pr %>% filter( is.na(incidencia)) %>% select(c(nome,Codigo,`População estimada - pessoas [2019]`,regional,macroregional,Casos,Obitos,incidencia))
        epi.city$geometry <- NULL
        
        res_mod_scasos <<- callModule(
          module = selectizeGroupServer,
          id = "ftable4",
          data = epi.city,
          vars = c("macroregional", "regional", "nome"))
        
        
        
        fluidRow(fluidRow(HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
                          tags$b(paste0("Municípios sem Casos - ",399-(table_resumo$Baixo+table_resumo$Alerta+table_resumo$Epidemia)),style="padding-left:10px;"),style="font-size:24px"),
                 fluidRow(
                   selectizeGroupUI(
                     id = "ftable4",inline = F,
                     params = list(
                       macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                       regional = list(inputId = "regional", title = "Regional:",width=12),
                       nome = list(inputId = "nome", title = "Cidade:")
                     )
                   ),
                   withSpinner(DT::dataTableOutput(outputId = "table_scasos"))
                 ))
        
        
      }else{
        
        
        
        fluidRow(
          fluidRow(
            # withSpinner(uiOutput("ibox.7")),  
            # withSpinner(uiOutput("ibox.8")),  
            # withSpinner(uiOutput("ibox.9")),  
            # withSpinner(uiOutput("ibox.10")),
            withSpinner(bs4InfoBoxOutput("ibox.1",width = 12)),
            withSpinner(bs4InfoBoxOutput("ibox.2",width = 12)),
            withSpinner(bs4InfoBoxOutput("ibox.3",width = 12)),
            withSpinner( bs4InfoBoxOutput("ibox.4",width = 12)),
            withSpinner( bs4InfoBoxOutput("ibox.5",width = 12)),
            withSpinner(bs4InfoBoxOutput("ibox.6",width = 12))
            #style='overflow-y: scroll;height:780px;font-size:16px;text-align:justify'
          )
          
          
          
        )
        
        
        
      }
    })
 
    
  
   output$map.descritive <- renderLeaflet({
      
      
     
      cores               <- c()
      col.brew            <- brewer.pal(n = 6, name = "Set1")
      colors              <- col.brew
      cores               <- sapply(1:length(dados.maps.pr$macroregional),FUN = function(i) getColor(as.character(dados.maps.pr$macroregional[i])))
      dados.maps.pr$cores <- cores
      
      
      maps.label.pr <- sprintf(
         "<strong>%s</strong><br/>
  <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>",
         
         paste0("<b><h1>",dados.maps.pr$`Município [-]`,"</h1></b>"),
         paste0("<b>Macroregião :</b>",dados.maps.pr$macroregional),
         paste0("<b>Regional de Saúde :</b>",dados.maps.pr$regional,"ª"),
         paste0("<b>Longitude :</b>",dados.maps.pr$LONGITUDE),
         paste0("<b>Latitude :</b>",dados.maps.pr$LATITUDE),
         paste0("<b>Área Territorial :</b>",dados.maps.pr$`Área Territorial - km² [2019]`,"Km²"),
         paste0("<b>População Estimada 2019 :</b>",dados.maps.pr$`População estimada - pessoas [2019]`), 
         paste0("<b>Casos :</b>",dados.maps.pr$Casos),
         paste0("<b>Incidência :</b>",dados.maps.pr$incidencia),
         paste0("<b>Óbitos :</b>",dados.maps.pr$Obitos)
         
      ) %>% lapply(htmltools::HTML)
      
      maps.cities2                       <- st_as_sf(x = maps.cities2)
     leaflet(dados.maps.pr,
                 options = list(zoomControl = F)
         ) %>% addTiles() %>%
           setView(lng = setview$lng, lat = setview$lat, zoom=7) %>%
           addPolygons(
             fillColor = cores,layerId = dados.maps.pr$macroid,
             weight = 2,
             opacity = opac$values,label = maps.label.pr,
             color = cores,fill = "black",stroke = T,
             dashArray = "3",
             fillOpacity = opac$values,
             highlight = highlightOptions(
               weight = 5,
               color = "#666",
               dashArray = "",
               fillOpacity = 0.5,
               bringToFront = TRUE),
             labelOptions = labelOptions(
               style = list("font-weight" = "normal", padding = "3px 8px"),
               textsize = "15px",
               direction = "auto"))  %>%
           addLegend(colors  = unique(cores),labels = unique(maps.cities2$macroregional), opacity = 1, title = "Macroregião",
                     position = "topleft")


   })
   
   # observeEvent(list(input$map.descritive_shape_click),{
   # 
   #    event          <- input$map.descritive_shape_click
   #    message        <- event$id
   #    cat("Event",message)
   # 
   #    #if((!isTRUE(message %in% unique(maps.cities2$macroid)))  | !res_mod()$macroid == 1){return()}
   #    #if(isTRUE(message %in% unique(rm_accent(data_pacientes$OBS)))){
   #    #print(message)
   #    if (!is.null(message)){
   #       pos       <- which( maps.cities2$macroid %in% message )
   #       qtd       <- sum( rm_accent(maps.cities2$macroid) %in% message )
   #       reps      <- rep(1.0,qtd)
   #       opac$values[pos] <- reps
   # 
   # 
   #    }
   # 
   # 
   # 
   # 
   # 
   # 
   # })
   # 
   
   
   observeEvent(list(res_mod()),ignoreInit = T,{

     # event          <- input$map.descritive_shape_click
     # message        <- event$id
      #cat("Event",message)

      #if((!isTRUE(message %in% unique(maps.cities2$macroid)))  | !res_mod()$macroid == 1){return()}
      #if(isTRUE(message %in% unique(rm_accent(data_pacientes$OBS)))){
      #print(message)

         posna <- which(is.na(dados.maps.pr$Casos))
         repsna <- rep(1,length(posna))
         pos       <- which(dados.maps.pr$Codigo %in% res_mod()$Codigo)
         qtd       <- sum( dados.maps.pr$Codigo %in% res_mod()$Codigo )
         opac$values      <- rep(0.1,length(dados.maps.pr$macroid))
         opac$valuesvalues[posna]      <- repsna
         reps      <- rep(1.0,qtd)
         opac$values[pos] <- reps


   })
   
   
  
      
   


   # observe({
   # 
   #   output$paineis.descritive <- renderUI({
   #     if(is.null(input$map.descritive_shape_click)){return()}
   # 
   #     fluidRow(column(width = 8,
   #                     bs4Card(
   #                       title = fluidRow(HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
   #                                        tags$b(c("MAPA POR REGIONAL")),style="font-size:24px"),
   #                       status = "transparent", width = 12,
   #                       closable = FALSE,
   #                       maximizable = TRUE,
   #                       collapsible = TRUE,
   #                       collapsed = FALSE,
   #                       labelText = icon("question"),
   #                       labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
   #                       leafletOutput("map.descritive2")
   #                     )
   #                     ),
   #              column(width = 4,
   #                     bs4Card(
   #                       title = fluidRow(HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
   #                                        tags$b(c("LISTA")),style="font-size:24px"),
   #                       status = "transparent", width = 12,
   #                       closable = FALSE,
   #                       maximizable = TRUE,
   #                       collapsible = TRUE,
   #                       collapsed = FALSE,
   #                       labelText = icon("question"),
   #                       labelTooltip = HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia.")
   #                       
   #                     )
   #                     ),
   #       
   #           
   #       
   #         )
   #      
   #     
   #   })
   #   # observeEvent(input$map.descritive_shape_click, {
   #   #   # input$toTop2,input$toTop3,input$toTop4,input$toTop5,input$toTop6), {
   #   #   shinyjs::runjs("window.scrollTo(0, 700)")
   #   # })
   #   
   # })
   
   observeEvent(list(res_mod()),{

      #unique(gsub('.{1}$', '', 

     pos <- which(df1$ID_MN_RESI %in%  res_mod()$Codigo)
     df <- df1[c(as.numeric(pos)),]




        output$descritive.sexo          <- renderPlotly({plot.sexo(df) })
        output$descritive.idade         <- renderPlotly({plot.idade(df) })
        output$descritive.escolaridade  <- renderPlotly({plot.escolaridade(df) })
         # gest <- plot.gestantes(df)
         
         output$descritive.gestante      <- renderPlotly({
            
            tab.gestante <- df %>% filter(SG_UF == 41) %>% group_by(CS_GESTANT) %>% summarise(Freq=n()) %>% filter(!is.na(CS_GESTANT))
            
            Gestante<- ifelse(tab.gestante$CS_GESTANT==1,"1º Trimeste",
                              ifelse(tab.gestante$CS_GESTANT==2,"2º Trimeste",
                                     ifelse(tab.gestante$CS_GESTANT==3,"3º Trimeste",
                                            ifelse(tab.gestante$CS_GESTANT==4,"Idade Gestacional Ignorada",
                                                   ifelse(tab.gestante$CS_GESTANT==5,"Não",
                                                          ifelse(tab.gestante$CS_GESTANT==6,"NSA",
                                                                 ifelse(tab.gestante$CS_GESTANT==9,"Ignorado","")))))))
            
            tab.gestante$CS_GESTANT <- Gestante
            
            tab.gestante <- tab.gestante %>% rename(n.Freq=Freq,categorie=CS_GESTANT)

          
            
           
            plotly.pie(data = tab.gestante,title = "Proporção de Gestantes e Não Gestantes",h=600)
            
          
            
            
            
            
         })
         
         output$descritive.gestante2     <- renderPlotly({
            
            tab.gestante <- df %>% filter(SG_UF == 41) %>% group_by(CS_GESTANT) %>% filter(CS_GESTANT == 1 |CS_GESTANT == 2 |CS_GESTANT == 3 |CS_GESTANT == 4)%>% summarise(Freq=n()) %>% filter(!is.na(CS_GESTANT))
            
            Gestante<- ifelse(tab.gestante$CS_GESTANT==1,"1º Trimeste",
                              ifelse(tab.gestante$CS_GESTANT==2,"2º Trimeste",
                                     ifelse(tab.gestante$CS_GESTANT==3,"3º Trimeste",
                                            ifelse(tab.gestante$CS_GESTANT==4,"IGI",""))))
            
            tab.gestante$CS_GESTANT <- Gestante
            
            tab.gestante <- tab.gestante %>% rename(n.Freq=Freq,categorie=CS_GESTANT)
            
            
            
            fig<-plot_ly(y = ~ tab.gestante$n.Freq, x = ~ tab.gestante$categorie, type="bar",orientation = 'v', 
                         text = "", marker=list(color = c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2")), size=10, opacity=1), 
                         name = 'Cidades')
            
            fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,margin = c(0,0,0,10),
                                  xaxis = list(title = "<b>NÚMERO DE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                               spikemode  = 'across', #toaxis, across, marker
                                               spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                               showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                               
                                               
                                               
                                               
                                               showgrid=TRUE), 
                                  yaxis = list (title = "<b>CIDADES</b>",
                                                spikemode  = 'across', #toaxis, across, marker
                                                spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
                                                showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                                showgrid=TRUE),
                                  autosize = T,height= 600) %>% config(displayModeBar = FALSE)
            
            
            fig  
            
            
            
            
            
            
         })

      cat(input$myfilters)
     output$plot.serie <- renderPlotly({



        df01 <- df %>%
           mutate(date = format(as.Date(DT_NOTIFIC),format="%Y-%U",digits = 1),
                  date2 = cut.Date(as.Date(DT_NOTIFIC), breaks = "1 week", labels = FALSE)) %>%
           group_by(SEM_NOT) %>%
           summarise(frequencia = n())

        df01 <-data.frame(label=df01$SEM_NOT,values=df01$frequencia)
          # pos1 <-which(is.na(df01[,1]))
          # df01 <- df01[-pos1,]
         # df01 <- df01[100:250,]

        blu <- 'rgb(100, 140, 240)'
        dblu <- 'rgb(0, 0, 102)'
        red <- 'rgb(200, 30, 30)'
        dred <- 'rgb(100, 30, 30)'
        # df.label <- ymd(as.Date(df01$label))
        # df01$label <- df.label

        #str(df01)  labels = df02$label,values=df02$values,row.names = df02$label
        
        
        don <- data.frame(labels = df01$label, values=df01$values,row.names = df01$label )
        don$variable <- "Casos Parciais"
        # data <- left_join(don2,don,"labels")
        # data <- as.data.frame(x = data,row.names = as.character(data$labels))
        # data <- na.locf(data)
        #data$bar <- data$values.estate*(2/3)
        #don3 <- list(values=don2,values2=don )
        # if(length(unique(res_mod()$regional)) < qtd_regionais){
        #    pos.macro <- which(df1$ID_MN_RESI %in%  res_mod()$Codigo)
        #    df_macro <- df1[c(as.numeric(pos.macro)),]
        #    
        #    df_macro <- df_macro %>%
        #       mutate(date = format(as.Date(DT_NOTIFIC),format="%Y-%U",digits = 1),
        #              date2 = cut.Date(as.Date(DT_NOTIFIC), breaks = "1 week", labels = FALSE)) %>%
        #       group_by(date2) %>%
        #       summarise(frequencia = n())
        #    
        # }else{
        #    
        #  
        #    
        # }
        # 
        

       






       if(!isTRUE(input$switch.serie)){
          don2$variable <- "Casos Confirmados"
          data <- as.data.frame(rbind(don,don2))
          data$labels <- as.character(data$labels)
          pos.ticks <- seq(2,length(df.notificados.serie2$SEM_NOT),2)
          ticks.labels <- unique(df.notificados.serie2$SEM_NOT)[pos.ticks]
          
          fig <<- data %>%
             ggplot(aes(x = labels, y = values,group=variable)) + 
             geom_line(aes(color=variable),size=1.1) +
             scale_color_manual(values = c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2"))) +
             ggtitle(label = "Casos notificados, cofirmados e Investigados") +
             axis.theme(x.angle = 45,vjust = 0.5,hjust = 0.5) + 
             xlab(label = "Semanas Epidemiologicas")+
             ylab(label = "Número de Casos") + scale_x_discrete(breaks = ticks.labels)
          
          
          
          plot.serie.d <-  ggplotly(p = fig) %>%
             layout(hovermode = TRUE, spikedistance =  -1,legend = list(orientation = "h", x = 0, y =1.2),
                    xaxis = list(title = "<b>SEMANAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                 spikemode  = 'across',
                                 spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                 showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                 showgrid=TRUE), 
                    yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                  spikemode  = 'across', #toaxis, across, marker
                                  spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                  showline=TRUE,tickfont = list(size = 24),
                                  showgrid=TRUE),
                    height= 600 )%>% config(displayModeBar = T)
          
        # plot.serie_dygraph <- dygraph(data,main = paste0("SÉRIE TEMPORAL PARA OS CASOS DE DENGUE ENTRE ",data.range[1]," À ",data.range[2]),height = 550) %>%
        # 
        #    dySeries("values.estate", label = "Casos Estado",color = "blue",fillGraph = T,drawPoints = T,pointSize = 4,strokeBorderWidth = 2,strokeBorderColor = "blue") %>%
        #    dySeries("values", label = "Casos Parcial",color = "red",fillGraph = T,drawPoints = T,pointSize = 4,strokeBorderWidth = 2,strokeBorderColor = "red") %>%
        #    #dyBarSeries('bar') %>%
        #    dyOptions(stackedGraph = TRUE) %>%
        # 
        #    dyOptions(labelsUTC = TRUE, fillGraph=TRUE, fillAlpha=1, drawGrid = T,drawGapEdgePoints = T,
        #              axisLineColor = "black",axisLineWidth = 3,axisLabelFontSize = 12,titleHeight = 32) %>%
        #    dyRangeSelector() %>%
        #    dyCrosshair(direction = "vertical") %>%
        #    dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE)

       }else{

          # plot.serie_dygraph <- dygraph(data,main = paste0("SÉRIE TEMPORAL PARA OS CASOS DE DENGUE ENTRE ",data.range[1]," À ",data.range[2]),height = 550) %>%
          # 
          #    
          #    dyBarSeries('values.estate',label = "Casos Notificados",color="blue") %>%
          #    dyBarSeries('values',label = "Casos Confirmados ",color="darkgrey") %>%
          #    dyOptions(stackedGraph = TRUE) %>%
          #    dyOptions( fillGraph=FALSE, fillAlpha=1, drawGrid = T,
          #               drawGapEdgePoints = T,axisLineColor = "black",axisLineWidth = 3,
          #               axisLabelFontSize = 12,titleHeight = 32) %>%
          #    dyRangeSelector() %>%
          #    dyCrosshair(direction = "vertical") %>%
          #    dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE)
          #    
          # 
          #    # dyBarSeries('values.estate', label = "Casos Estado",color = "blue") %>%
          #    # dyBarSeries('values', label = "Casos Parcial",color = "red") %>%
          #    # dyOptions(stackedGraph = TRUE) %>%
          #    # dyOptions(labelsUTC = TRUE, fillGraph=TRUE, fillAlpha=0.35, drawGrid = T,drawGapEdgePoints = T,axisLineColor = "black",axisLineWidth = 3,axisLabelFontSize = 12,titleHeight = 32) %>%
          #    # dyRangeSelector() %>%
          #    # dyCrosshair(direction = "vertical") %>%
          #    # dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE)
          # 
          # 
          # 
          # 
          # 
          # 
          # plot.serie.not
          # 
          # 



       }


        plot.serie.d


     })
   })

   
   table_resumo <- as.data.frame(dados.maps.pr) %>% select(-geometry) %>%  filter(!is.na(Casos)) %>% summarise(Municipios=length(unique(Codigo)),
                                                                                                        Regional=length(unique(regional)),
                                                                                                        Casos = sum(Casos,na.rm = T),
                                                                                                        Epidemia=sum(incidencia>300),
                                                                                                        Alerta=sum(incidencia>=100&incidencia<=300),
                                                                                                        Baixo=sum(incidencia<100),
                                                                                                        DSA=sum(DSA,na.rm = T),
                                                                                                        DG=sum(DG,na.rm = T)
   )
   
   
   table_resumo$Regional <- qtd_regionais
   table_resumo <- table_resumo %>% mutate(Mun.Not = nrow(df.notificados),
                             Total.Not=sum(df.notificados$Freq),
                             Mun.Auto=nrow(df.autoctone),
                             Total.Auto=sum(df.autoctone$Freq))
   
   output$ibox.1 <- renderbs4InfoBox({
      bs4InfoBox(
         title = "Munícipios com notificação",
         width = 12,
         status = "primary", value = table_resumo$Mun.Not,
         icon = "tachometer-alt"
      )
   })
   #fluidRow(actionBttn(inputId = "open.modal",label = "Relatório",icon =icon(name = "file-pdf"),block = T,style = "material-flat"))
   output$ibox.2 <- renderbs4InfoBox({
      bs4InfoBox(
         title = HTML("Munícipios com casos confirmados <br> (Dengue, D.S.A, D.G)"),
         width = 12,
         status = "info", value = table_resumo$Municipios,
         icon = "tachometer-alt"
      )
   })

   output$ibox.3 <- renderbs4InfoBox({
      bs4InfoBox(
         title = "Regionais com casos confirmados",
         width = 12,
         status = "primary", value = table_resumo$Regional,
         icon = "tachometer-alt"
      )
   })

   output$ibox.4 <- renderbs4InfoBox({
      bs4InfoBox(
         title = "Total de casos notificados",
         width = 12,
         status = "info", value = table_resumo$Total.Not,
         icon = "tachometer-alt"
      )
   })

   output$ibox.5 <- renderbs4InfoBox({
      bs4InfoBox(
         title = HTML("Total de casos Confirmados <br> (Dengue, D.S.A, D.G)"),
         width = 12,
         status = "primary", value = table_resumo$Casos,
         icon = "tachometer-alt"
      )
   })

   output$ibox.6 <- renderbs4InfoBox({
      bs4InfoBox(
         title = "Número de Óbitos",
         width = 12,
         status = "info", value =  sum(dados.maps.pr$Obitos,na.rm = T),
         icon ="tachometer-alt"
      )


   })
   
  
   
   
   
   output$table_epi <- DT::renderDataTable(res_mod_epi(),
                                           options = list(
                                              pageLength = 10,
                                              scrollX=TRUE,
                                              searching = FALSE,
                                              autoWidth = FALSE
                                           ))
   
   output$table_alerta <- DT::renderDataTable(res_mod_alerta(),
                                              options = list(
                                                 pageLength = 10,
                                                 scrollX=TRUE,
                                                 searching = FALSE,
                                                 autoWidth = FALSE
                                              ))
   
   output$table_baixo <- DT::renderDataTable(res_mod_alerta(),
                                              options = list( pageLength = 10,
                                                              scrollX=TRUE,
                                                              searching = FALSE,
                                                              autoWidth = FALSE
                                                                                            ))
   
   output$table_scasos <- DT::renderDataTable(res_mod_scasos(),
                                              options = list(
                                                 pageLength = 10,
                                                 scrollX=TRUE,
                                                 searching = FALSE,
                                                 autoWidth = FALSE
                                              ))

   
   
# output$ibox.7 <- renderUI({
#    
#                             fluidRow(column(width=12,align="center",
#                                             
#                                             actionBttn(inputId = "open.table.epidemia",label = "Cidades em Epidemia",
#                                                        icon =icon(name = "radiation"),block = F,size = "md",color = "danger",style = "float")
#                                             ),
#                                      column(width=12,
#                                             shinydashboard::valueBox(value = table_resumo$Epidemia,
#                                                                      subtitle = "Municípios em Epidemia",color = "red",width = 12,
#                                                                      icon = icon("radiation")
#                                                                      ),
#                                      )                         
# 
#    )
# })




  
   
  


# observeEvent(input$open.table.epidemia,{
#    
#    restoreInput(id = "ftable1",default = NULL)
#    
#    epi.city      <- dados.maps.pr %>% filter(incidencia > 300) %>% select(c(`Município [-]`,nome,Codigo,`População estimada - pessoas [2019]`,`Área Territorial - km² [2019]`,
#                                                                             regional,macroregional,Casos,DSA,DG,Obitos,incidencia))
#    epi.city$geometry <- NULL
#    
#    res_mod_epi <<- callModule(
#       module = selectizeGroupServer,
#       id = "ftable1",
#       data = epi.city,
#       vars = c("macroregional", "regional", "nome"))
#    
#    show_alert(
# 
#       title = NULL,
#       btn_labels = NA,
#       showCloseButton = TRUE,
#       text =    fluidRow(column(width=8,
#                                 withSpinner(DT::dataTableOutput(outputId = "table_epi"))),
#                          column(width = 4,
#                                 selectizeGroupUI(
#                                    id = "ftable1",inline = F,
#                                    params = list(
#                                       macroregional = list(inputId = "macroregional", title = "Macroregional:"),
#                                       regional = list(inputId = "regional", title = "Regional:",width=12),
#                                       nome = list(inputId = "nome", title = "Cidade:")
#                                    )
#                                 ))),
#       html = TRUE,
#       width = "100%")
#    
#   
#    
#   
# })


# output$ibox.8 <- renderbs4ValueBox({
#    bs4ValueBox(
#       subtitle = "Municípios em Alerta",
#       width = 6,
#       status = "warning", value = table$Alerta,
#       icon = "tachometer-alt",
#       footer = fluidRow(style="padding-left:50px;",actionBttn(inputId = "open.table.alerta",label = "Cidades em Alerta",icon =icon(name = "file-pdf"),block = F,color = "danger",style = "stretch"))
#       
#    )
# })

# output$ibox.8 <- renderUI({
#    
#    fluidRow(column(width=12,align="center",
#                    
#                    actionBttn(inputId = "open.table.alerta",label = "Cidades em Alerta",
#                               icon =icon(name = "exclamation-triangle"),block = F,size = "md",color = "warning",style = "float")
#    ),
#    column(width=12,
#           shinydashboard::valueBox(value = table_resumo$Alerta,
#                                    subtitle = "Municípios em Alerta",color = "orange",width = 12,
#                                    icon = icon("exclamation-triangle")
#           ),
#    )                         
#    
#    )
# })
# 
# 
# 
# 
# observeEvent(input$open.table.alerta,{
#    
#    epi.city      <- dados.maps.pr %>% filter(incidencia >= 100 & incidencia <= 300) %>% select(c(`Município [-]`,nome,Codigo,`População estimada - pessoas [2019]`,
#                                                                                                  `Área Territorial - km² [2019]`,regional,macroregional,Casos,DSA,DG,Obitos,incidencia))
#    epi.city$geometry <- NULL
#    
#    res_mod_alerta <<- callModule(
#       module = selectizeGroupServer,
#       id = "ftable2",
#       data = epi.city,
#       vars = c("macroregional", "regional", "nome"))
#    
#    output$table_alerta <- DT::renderDataTable(res_mod_alerta(),
#                                               options = list(
#                                                  pageLength = 10,
#                                                  scrollX=TRUE,
#                                                  searching = FALSE,
#                                                  autoWidth = FALSE
#                                               ))
#    
#    
#    show_alert(
#       
#       title = NULL,
#       btn_labels = NA,
#       showCloseButton = TRUE,
#       text =    fluidRow(column(width=8,
#                                 withSpinner(DT::dataTableOutput(outputId = "table_alerta"))),
#                          column(width = 4,
#                                 selectizeGroupUI(
#                                    id = "ftable2",inline = F,
#                                    params = list(
#                                       macroregional = list(inputId = "macroregional", title = "Macroregional:"),
#                                       regional = list(inputId = "regional", title = "Regional:",width=12),
#                                       nome = list(inputId = "nome", title = "Cidade:")
#                                    )
#                                 ))),
#       html = TRUE,
#       width = "100%")
#    
#    
#    
#    
# })
# 



# output$ibox.9 <- renderbs4ValueBox({
#    bs4ValueBox(
#       subtitle = "Municípios com Índice Baixo",
#       width = 6,
#       status = "success", value = table$Baixo,
#       icon = "tachometer-alt",
#       footer = fluidRow(style="padding-left:50px;",actionBttn(inputId = "open.table.baixo",label = "Cidades com Indíce Baixo",icon =icon(name = "file-pdf"),block = F,color = "danger",style = "stretch"))
#       
#    )
# })


# output$ibox.9 <- renderUI({
#    
#    fluidRow(column(width=12,align="center",
#                    
#                    actionBttn(inputId = "open.table.baixo",label = "Cidades com Índice Baixo",
#                               icon =icon(name = "exclamation-triangle"),block = F,size = "md",color = "success",style = "float")
#    ),
#    column(width=12,
#           shinydashboard::valueBox(value = table_resumo$Baixo,
#                                    subtitle = "Municípios com Índice Baixo",color = "green",width = 12,
#                                    icon = icon("exclamation-triangle")
#           ),
#    )                         
#    
#    )
# })



# observe({
#    epi.city      <- dados.maps.pr %>% filter( incidencia < 100) %>% select(c(`Município [-]`,nome,Codigo,`População estimada - pessoas [2019]`,
#                                                                              `Área Territorial - km² [2019]`,regional,macroregional,Casos,DSA,DG,Obitos,incidencia))
#    epi.city$geometry <- NULL
#    
#    res_mod_baixo <<- callModule(
#       module = selectizeGroupServer,
#       id = "ftable3",
#       data = epi.city,
#       vars = c("macroregional", "regional", "nome"))
#    
#    output$table_baixo <- DT::renderDataTable(res_mod_baixo(),
#                                               options = list(
#                                                  pageLength = 10,
#                                                  scrollX=TRUE,
#                                                  searching = FALSE,
#                                                  autoWidth = FALSE
#                                               ))
#    
# })
# 
# observeEvent(input$open.table.baixo,{
#    
#    
#    
#    show_alert(
#       
#       title = NULL,
#       btn_labels = NA,
#       showCloseButton = TRUE,
#       text =    fluidRow(column(width=8,
#                                 withSpinner(DT::dataTableOutput(outputId = "table_baixo"))),
#                          column(width = 4,
#                                 selectizeGroupUI(
#                                    id = "ftable3",inline = F,
#                                    params = list(
#                                       macroregional = list(inputId = "macroregional", title = "Macroregional:"),
#                                       regional = list(inputId = "regional", title = "Regional:",width=12),
#                                       nome = list(inputId = "nome", title = "Cidade:")
#                                    )
#                                 ))),
#       html = TRUE,
#       width = "100%")
#    
#    
#    
#    
# })



# output$ibox.10 <- renderbs4InfoBox({
#    bs4InfoBox(
#       title = "Municípios sem Casos Confirmados",
#       width = 12,
#       value = 399-(table$Baixo+table$Alerta+table$Epidemia),
#       icon = "tachometer-alt"
#    )
# })

# output$ibox.10 <- renderUI({
#    
#    fluidRow(column(width=12,align="center",
#                    
#                    actionBttn(inputId = "open.table.scasos",label = "Cidades sem Casos Confirmados",
#                               icon =icon(name = "thumbs-up"),block = F,size = "md",color = "primary",style = "float")
#    ),
#    column(width=12,
#           shinydashboard::valueBox(value = 399-(table_resumo$Baixo+table_resumo$Alerta+table_resumo$Epidemia),
#                                    subtitle = "Municípios com Índice Baixo",color = "light-blue",width = 12,
#                                    icon = icon("thumbs-up")
#           ),
#    )                         
#    
#    )
# })
# 
# 
# 
# observe({
#    epi.city      <- dados.maps.pr %>% filter( is.na(incidencia)) %>% select(c(`Município [-]`,nome,Codigo,`População estimada - pessoas [2019]`,`Área Territorial - km² [2019]`,regional,macroregional,Casos,Obitos,incidencia))
#    epi.city$geometry <- NULL
#    
#    res_mod_scasos <<- callModule(
#       module = selectizeGroupServer,
#       id = "ftable4",
#       data = epi.city,
#       vars = c("macroregional", "regional", "nome"))
#    
#    output$table_scasos <- DT::renderDataTable(res_mod_scasos(),
#                                              options = list(
#                                                 pageLength = 10,
#                                                 scrollX=TRUE,
#                                                 searching = FALSE,
#                                                 autoWidth = FALSE
#                                              ))
#    
# })
# 
# observeEvent(input$open.table.scasos,{
#    
#    
#    
#    show_alert(
#       
#       title = NULL,
#       btn_labels = NA,
#       showCloseButton = TRUE,
#       text =    fluidRow(column(width=8,
#                                 withSpinner(DT::dataTableOutput(outputId = "table_scasos"))),
#                          column(width = 4,
#                                 selectizeGroupUI(
#                                    id = "ftable4",inline = F,
#                                    params = list(
#                                       macroregional = list(inputId = "macroregional", title = "Macroregional:"),
#                                       regional = list(inputId = "regional", title = "Regional:",width=12),
#                                       nome = list(inputId = "nome", title = "Cidade:")
#                                    )
#                                 ))),
#       html = TRUE,
#       width = "100%")
#    
#    
#    
#    
# })





   output$plot.serie.dengue <- renderPlotly({
      
      df.notificados.serie$variable <- "Casos Notificados"
      don2$variable <- "Casos Confirmados"
      data <- as.data.frame(rbind(df.notificados.serie,don2))
      data$labels <- as.character(data$labels)
      pos.ticks <- seq(2,length(df.notificados.serie2$SEM_NOT),2)
      ticks.labels <- unique(df.notificados.serie2$SEM_NOT)[pos.ticks]
      # 
      # data <- left_join(df.notificados.serie,don2,"labels")
      # data1 <- data.frame()
      #    stack(data,-c('labels'))
      #data <- na.locf(data)
      #data <- as.data.frame(x = data,row.names = as.character(data$labels))



      # plot.serie.not <<- dygraph(data,height = 550) %>%
      #    dySeries("values.not", label = "Casos Notificados",color = "blue",fillGraph = F,drawPoints = T,pointSize = 4,strokeBorderWidth = 2,strokeBorderColor = "blue") %>%
      #    dySeries("values.estate", label = "Casos Confirmados",color = "red",fillGraph = F,drawPoints = T,pointSize = 4,strokeBorderWidth = 2,strokeBorderColor = "red") %>%
      #    # dyBarSeries('values.not',label = "Casos Notificados",color="blue") %>%
      #    # dyBarSeries('values.estate',label = "Casos Confirmados ",color="red") %>%
      #    dyOptions(stackedGraph = TRUE) %>%
      #    dyOptions( fillGraph=TRUE, fillAlpha=1, drawGrid = T,
      #              drawGapEdgePoints = T,axisLineColor = "black",axisLineWidth = 3,
      #              axisLabelFontSize = 12,titleHeight = 32) %>%
      #    dyRangeSelector() %>%
      #    dyCrosshair(direction = "vertical") %>%
      #    dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE)
      fig <<- data %>%
      ggplot(aes(x = labels, y = values,group=variable)) + 
         geom_line(aes(color=variable),size=1.1) +
         scale_color_manual(values = c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2"))) +
         ggtitle(label = "Casos notificados, cofirmados e Investigados") +
         axis.theme(x.angle = 45,vjust = 0.5,hjust = 0.5) + 
         xlab(label = "Semanas Epidemiologicas")+
         ylab(label = "Número de Casos") + scale_x_discrete(breaks = ticks.labels)
      
   
     
      plot.serie.not <<-  ggplotly(p = fig) %>%
        layout(hovermode = TRUE, spikedistance =  -1,legend = list(orientation = "h", x = 0, y =1.2),
                           xaxis = list(title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                        spikemode  = 'across',
                                        spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                        showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                        showgrid=TRUE), 
                           yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                         spikemode  = 'across', #toaxis, across, marker
                                         spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                         showline=TRUE,tickfont = list(size = 24),
                                         showgrid=TRUE),
                           height= 600 )%>% config(displayModeBar = T)
                
         
         
      plot.serie.not
   })
   
   # output$map.descritive2 <- renderLeaflet({
   #    #if(list(input$map.descritive_shape_click,res_mod())){return()}
   #    leaflet(dados.maps.pr,elementId = "map2",
   #            options = list(zoomControl = F)
   #    ) %>% addTiles() %>%
   #       setView(lng = setview$lng, lat = setview$lat, zoom=7) %>%
   #       addPolygons(
   #          fillColor = cores2,
   #          weight = 2,
   #          opacity = 1,label = maps.label.pr,
   #          color = cores2,fill = "black",stroke = T,
   #          dashArray = "3",
   #          fillOpacity = .95,
   #          highlight = highlightOptions(
   #             weight = 5,
   #             color = "#666",
   #             dashArray = "",
   #             fillOpacity = 0.5,
   #             bringToFront = TRUE),
   #          labelOptions = labelOptions(
   #             style = list("font-weight" = "normal", padding = "3px 8px"),
   #             textsize = "15px",
   #             direction = "auto"))  %>%
   #       addLegend(colors  = unique(cores2),labels = paste0(unique(maps.cities2$regional),"ª Regional"), opacity = 1, title = "Regionais de Saúde",
   #                 position = "topleft")
   # })
   
   output$map.descritive3 <- renderLeaflet({
     
      # regionais                          <- readxl::read_xlsx(path = "www/regionais.xlsx",sheet = "Planilha1")
      # coordenadas.municipios             <- readxl::read_xls(path = "www/Coordenadas_Municipios.xls",sheet = "Cidades")  %>% rename(Codigo=GEOCODIGO_MUNICIPIO)
      # regionais$nome                     <- tolower(rm_accent(as.character(regionais$nome)))
      # 
      # maps.cities2                       <- get_brmap(geo = "City", geo.filter = list(State=41),class="sf") %>% select(nome,City) %>% rename(Codigo = City)
      # maps.cities2$nome                  <- tolower(rm_accent(as.character(maps.cities2$nome)))
      # 
      # maps.cities2                       <- left_join(x = regionais,y = maps.cities2,"nome") 
      
      opac                               <- reactiveValues(values = rep(1,length(maps.cities2$nome)))
      
      # dados.maps.pr                       <- readxl::read_xlsx(path = "www/dados.pr.xlsx",sheet = "Worksheet") %>% select(`Município [-]`,`Código [-]`,`População estimada - pessoas [2019]`,`Área Territorial - km² [2019]`) %>% rename(Codigo=`Código [-]`)
      # dados.maps.pr$`Município [-]`            <- tolower(rm_accent(as.character(dados.maps.pr$`Município [-]`)))
      # 
      # dados.maps.pr                       <- left_join(dados.maps.pr,maps.cities2,"Codigo")
      # 
      # dados.maps.pr                       <- st_as_sf(x = dados.maps.pr)
      # colnames(coordenadas.municipios)[1] <- "Codigo"
      # coordenadas.municipios$Codigo       <- as.numeric(coordenadas.municipios$Codigo)
      # dados.maps.pr                       <- left_join(dados.maps.pr,coordenadas.municipios,"Codigo") %>% select(-NOME_MUNICIPIO)
      # 
      # dados.maps.pr$Codigo                 <- as.numeric(gsub('.{1}$', '', dados.maps.pr$Codigo))
      # casos                                <- df1 %>% group_by(ID_MN_RESI) %>% summarise(Casos=n())  %>% rename(Codigo=ID_MN_RESI)
      # obitos                               <- df1 %>% filter(EVOLUCAO == 2) %>% group_by(ID_MN_RESI) %>% summarise(Obitos = n()) %>% rename(Codigo=ID_MN_RESI)
      # 
      # dados.maps.pr                        <- left_join(dados.maps.pr,casos,"Codigo")
      # dados.maps.pr                        <- left_join(dados.maps.pr,obitos,"Codigo")
      # dados.maps.pr                        <- dados.maps.pr %>% mutate(incidencia=(as.numeric(Casos)/as.numeric(`População estimada - pessoas [2019]`))*100000)
      # casos_auto                           <- df1 %>% filter(TPAUTOCTO == 1 & SG_UF == 41) %>% group_by(ID_MN_RESI) %>% summarise(`Casos Autóctones`=n()) %>% mutate(Codigo=ID_MN_RESI)
      # dados.maps.pr                        <- left_join(dados.maps.pr,casos_auto,"Codigo")
      # dados.maps.pr                        <- dados.maps.pr %>% mutate(incidencia_auto=(as.numeric(`Casos Autóctones`)/as.numeric(`População estimada - pessoas [2019]`))*100000)
      #  w <- as.Date(today()) - weeks(4)
      #  casos_auto_4semanas                  <- df1 %>% filter(TPAUTOCTO == 1 & SG_UF == 41 & as.Date(DT_NOTIFIC) > w) %>% group_by(ID_MN_RESI) %>% summarise(`Casos Autóctones 4 Útimas Semanas`=n()) %>% mutate(Codigo=ID_MN_RESI) %>% select(-ID_MN_RESI)
      #  dados.maps.pr                        <- left_join(dados.maps.pr,casos_auto_4semanas,"Codigo")
      #  dados.maps.pr                        <- dados.maps.pr %>% mutate(incidencia_auto_4semanas=(as.numeric(`Casos Autóctones 4 Útimas Semanas`)/as.numeric(`População estimada - pessoas [2019]`))*100000)
      #  
      #  dengue_dsa                           <- df1 %>% filter(CLASSI_FIN == 11) %>% group_by(ID_MN_RESI) %>% summarise(DSA=n())  %>% rename(Codigo=ID_MN_RESI)
      #  dengue_dg                            <- df1 %>% filter(CLASSI_FIN == 12) %>% group_by(ID_MN_RESI) %>% summarise(DG=n())  %>% rename(Codigo=ID_MN_RESI)
      #  dados.maps.pr                        <- left_join(dados.maps.pr,dengue_dsa,"Codigo")
      #  dados.maps.pr                        <- left_join(dados.maps.pr,dengue_dg,"Codigo")

       
       
       legend.label <- c("até 0,00", "  0,00 -----| 50,00 "," 50,00 ----| 100,00","100,00 --| 300,00","300,00 --| 500,00",paste("500,00 --|",round(max(dados.maps.pr$incidencia_auto,na.rm = T),2)))
       
       #as.Date(today()) - weeks(4)
     library(RColorBrewer)
     
     # brewer.pal.info["Browns",]
     # brewer.pal(n = 9,name = "Blues")
     # display.brewer.pal(n = 9,name = "Reds")
     
      cor.lia <- sapply(1:length(dados.lia$Condição),FUN = function(i) getColor.lia(dados.lia$Condição[i]))
      cores  <- c()
      cores2  <- c()
      
      cores <- sapply(1:length(dados.maps.pr$incidencia_auto),FUN = function(i) getColor.inc(dados.maps.pr$incidencia_auto[i]))
      dados.maps.pr$cores <- cores
      
      cores2 <- sapply(1:length(dados.maps.pr$incidencia_auto_4semanas),FUN = function(i) getColor.inc(dados.maps.pr$incidencia_auto_4semanas[i]))
      dados.maps.pr$cores2 <- cores2
      
      cores3 <- sapply(1:length(dados.maps.pr$Obitos),FUN = function(i) getColor.obt(dados.maps.pr$Obitos[i]))
      dados.maps.pr$cores3 <- cores3
   
      
      maps.label.pr <- sprintf(
         "<strong>%s</strong><br/>
  <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>",
         
         paste0("<b><h1>",dados.maps.pr$`Município [-]`,"</h1></b>"),
         paste0("<b>Macroregião :</b>",dados.maps.pr$macroregional),
         paste0("<b>Regional de Saúde :</b>",dados.maps.pr$regional,"ª"),
         paste0("<b>Longitude :</b>",dados.maps.pr$LONGITUDE),
         paste0("<b>Latitude :</b>",dados.maps.pr$LATITUDE),
         paste0("<b>Área Territorial :</b>",dados.maps.pr$`Área Territorial - km² [2019]`,"Km²"),
         paste0("<b>População Estimada 2019 :</b>",dados.maps.pr$`População estimada - pessoas [2019]`), 
         paste0("<b>Casos :</b>",dados.maps.pr$Casos),
         paste0("<b>Incidência :</b>",dados.maps.pr$incidencia),
         paste0("<b>Incidência 4 Ult. Semanas :</b>",format(dados.maps.pr$incidencia_auto_4semanas,scientific = F)),
         paste0("<b>Óbitos :</b>",dados.maps.pr$Obitos)
         
      ) %>% lapply(htmltools::HTML)
      
      
      map.incidencia4semanas<<-leaflet(dados.maps.pr,
                                       options = list(zoomControl = F)
      ) %>% addTiles() %>%
         setView(lng = setview$lng, lat = setview$lat, zoom=7)  %>%
         
         addPolygons(
            fillColor = ~cores2,
            weight = 2,
            opacity = 1,label = maps.label.pr,
            color = "black",fill = "black",stroke = T,
            dashArray = "3",
            fillOpacity = .95,
            highlight = highlightOptions(
               weight = 5,
               color = "#666",
               dashArray = "",
               fillOpacity = 0.5,
               bringToFront = TRUE),
            labelOptions = labelOptions(
               style = list("font-weight" = "normal", padding = "3px 8px"),
               textsize = "15px",
               direction = "auto")) %>%
         addLegend(colors  = c("white","lightgray","yellow","orange","red","saddlebrown"),labels = legend.label, opacity = 1, title = "Legenda Incidência",
                   position = "topleft")
      library("ggspatial")
     map_inc4 <- ggplot() +
         geom_sf(data=dados.maps.pr, size=1, show.legend = TRUE,fill=cores2) +
         ggtitle(label = "Incidências para os casos referente as 12 últimas semanas para o Estado do Paraná")+
         xlab("Longitude") + ylab("Latitude") + axis.theme()+  labs(fill = "Lengenda Incidências")+
        scale_fill_manual(values = c("white","lightgray","yellow","orange","red","saddlebrown"))+
        annotation_north_arrow(location = "bl", which_north = "true", 
                               pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                               style = north_arrow_fancy_orienteering)
     map_inc4
     
     ggsave(filename = "map_inc4.png",plot = map_inc4,width = 12,height = 7)
     
     map_inc <- ggplot() +
        geom_sf(data=dados.maps.pr, size=1, show.legend = TRUE,fill=cores) +
        ggtitle(label = "Incidências para o Estado do Paraná")+
        xlab("Longitude") + ylab("Latitude") + axis.theme()+  labs(fill = "Lengenda Incidências")+
        scale_fill_manual(values = c("white","lightgray","yellow","orange","red","saddlebrown")) +
        annotation_north_arrow(location = "bl", which_north = "true", 
                               pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                               style = north_arrow_fancy_orienteering)
     map_inc
     ggsave(filename = "map_inc.png",plot = map_inc,width = 12,height = 7)
     
     
     map_obt <- ggplot() +
        geom_sf(data=dados.maps.pr, size=1, show.legend = TRUE,fill=cores3) +
        ggtitle(label = "Óbitos para o Estado do Paraná")+
        xlab("Longitude") + ylab("Latitude") + axis.theme()+  labs(fill = "Lengenda Incidências")+
        scale_fill_manual(values = c("white","lightgray","yellow","orange","red","saddlebrown"))+
        annotation_north_arrow(location = "bl", which_north = "true", 
                               pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                               style = north_arrow_fancy_orienteering)
     map_obt
     ggsave(filename = "map_obt.png",plot = map_obt,width = 12,height = 7)
     
     
     map_lia <- ggplot() +
        geom_sf(data=dados.lia, size=1, show.legend = TRUE,fill=cor.lia) +
        ggtitle(label = "Classificação de Infestação para as Cidades do Estado do Paraná")+
        xlab("Longitude") + ylab("Latitude") + axis.theme()+  labs(fill = "Lengenda Incidências")+
        scale_fill_manual(values = c("white","lightgray","yellow","orange","red","saddlebrown"))+
        annotation_north_arrow(location = "bl", which_north = "true", 
                               pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                               style = north_arrow_fancy_orienteering)
     map_lia
     ggsave(filename = "map_lia.png",plot = map_lia,width = 12,height = 7)
     
     
      map.incidencia<<-leaflet(dados.maps.pr,
                               options = list(zoomControl = F)
      ) %>% addTiles() %>%
         setView(lng = setview$lng, lat = setview$lat, zoom=7)  %>%
         
         addPolygons(
            fillColor = ~cores,
            weight = 2,
            opacity = 1,label = maps.label.pr,
            color = "black",fill = "black",stroke = T,
            dashArray = "3",
            fillOpacity = .95,
            highlight = highlightOptions(
               weight = 5,
               color = "#666",
               dashArray = "",
               fillOpacity = 0.5,
               bringToFront = TRUE),
            labelOptions = labelOptions(
               style = list("font-weight" = "normal", padding = "3px 8px"),
               textsize = "15px",
               direction = "auto")) %>%
         addLegend(colors  = c("white","lightgray","yellow","orange","red","saddlebrown"),labels = legend.label, opacity = 1, title = "Legenda Incidência",
                   position = "topleft")
         
        
         
         
        
         
        if(input$select.mapinc == "inc4"){
           
           
        
           
           
           map.incidencia4semanas
           
        }else if(input$select.mapinc == "obitos"){
           
           map.obitos<<-leaflet(dados.maps.pr,
                                options = list(zoomControl = F)
           ) %>% addTiles() %>%
              setView(lng = setview$lng, lat = setview$lat, zoom=7)  %>%
              
              addPolygons(
                 fillColor = ~cores3,
                 weight = 2,
                 opacity = 1,label = maps.label.pr,
                 color = "black",fill = "black",stroke = T,
                 dashArray = "3",
                 fillOpacity = .95,
                 highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.5,
                    bringToFront = TRUE),
                 labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
              addLegend(colors  = c("black"),labels = "Cidades com Óbitos", opacity = 1, title = "Legenda",
                        position = "topleft")
           
           
           
           map.obitos
           
        }else if(input$select.mapinc == "lia"){
           
           
           map.lia<<-leaflet(dados.lia,
                             options = list(zoomControl = F)
           ) %>% addTiles() %>%
              setView(lng = setview$lng, lat = setview$lat, zoom=7)  %>%

              addPolygons(
                 fillColor = cor.lia,
                 weight = 2,
                 opacity = 1,label = maps.label.pr,
                 color = "black",fill = "black",stroke = T,
                 dashArray = "3",
                 fillOpacity = .95,
                 highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.5,
                    bringToFront = TRUE),
                 labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
              addLegend(colors  = c("green","red"),labels = c("Não Infestado","Infestado"), opacity = 1, title = "Legenda",
                        position = "topleft")

           map.lia
           
        }else{
           
           
       
           
           map.incidencia
        }
      
      
      
         
      
      
      
   })
   
   
   output$plot.pie.dengues <- renderPlotly({
      
      resumo.dengues <- df1 %>% summarise(Dengue=sum(CLASSI_FIN==10,na.rm = T),
                                          DSA=sum(CLASSI_FIN==11,na.rm = T),
                                          DG=sum(CLASSI_FIN==12,na.rm = T)
                                       )
      
      
      
     df <- stack(resumo.dengues)    %>% rename(categorie = ind,n.Freq=values)
      
      plotly.pie(data = df,title = '',h=600)
   })
   
   
   
   #w <- as.Date(today()) - weeks(12)
   w <- as.Date(df1$DT_NOTIFIC) - weeks(12)
   rankcity     <- df1 %>% filter(SG_UF == 41 & as.Date(DT_NOTIFIC) > w) %>% group_by(ID_MN_RESI) %>%
      summarise(Freq=n()) %>% filter(Freq >= 100) %>% mutate(rank=rank(desc(Freq))) %>% filter(rank <= 10) %>% 
      rename(Codigo=ID_MN_RESI)
   rankcity <- left_join(rankcity,dados.maps.pr[,c(1,2,6,7)])
   rankcity <- rankcity %>% arrange(rank)
   rankcity$geometry <- NULL
   
   
   output$plot.bar.rank10city <- renderPlotly({
      
      
    
      # resumo.dengues <- df1 %>% summarise(Dengue=sum(CLASSI_FIN==10,na.rm = T),
      #                                     DSA=sum(CLASSI_FIN==11,na.rm = T),
      #                                     DG=sum(CLASSI_FIN==12,na.rm = T)
      # )
      
      
      fig<-plot_ly(y = ~ str_to_title(rankcity$`Município [-]`), x = ~ rankcity$Freq, type="bar",orientation = 'h', 
                   text = "", marker=list(color = c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2")), size=10, opacity=1), 
                   name = 'Cidades')
      
      fig <- fig %>% layout(hovermode = TRUE, spikedistance =  -1,margin = c(4,0,0,0),
                            title = list(text='<b>Rank das 10 Cidades com mais do que 100 casos nas últimas semanas</b>'),titlefont=list(size=24),
                            xaxis = list(title = "<b>NÚMERO DE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
                                         spikemode  = 'across', #toaxis, across, marker
                                         spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                         showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                                          showgrid=TRUE), 
                            yaxis = list (title = "<b>CIDADES</b>",
                                          spikemode  = 'across', #toaxis, across, marker
                                          spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                          categoryorder = "array",
                                          categoryarray = ~sort(rankcity$rank,decreasing = T),
                                          showline=TRUE,tickfont = list(size = 24),
                                          showgrid=TRUE),      
                                        
                           
                            autosize = T,height= 600) %>% config(displayModeBar = FALSE)
      
      
      fig  
   
      
    
   })
   
   
   
   output$plot_diagrama_controle <- renderPlotly({
      dbf2007_2020          <- readxl::read_xlsx(path = "www/Casos Consolidados Notificados 2007 a 2020 BaseDBF.xlsx",sheet = "Notificado")
      
      dbf_sem_epi           <- dbf2007_2020 %>% group_by(as.numeric(SEM_PRI)) %>% summarise(freq=n()) %>% rename(Semana=`as.numeric(SEM_PRI)`)
      
      dbf_sem_epi$semana   <- str_sub(string = dbf_sem_epi$Semana,start = -2)
      dbf_sem_epi$ano      <- str_sub(string = dbf_sem_epi$Semana,start = 1,end = 4)
      
      k=0
      kinf=30
      anosepi <-c()
      for(i in 1:(length(unique(dbf_sem_epi$ano)))-1){
         ksup  = kinf + 52 - 1
         teste <-dbf_sem_epi[c(kinf:(ksup)),]
         teste$anoepi <- paste0("Ano",i)
         anosepi <- rbind(anosepi,teste)
         kinf = ksup +1
         
      }
      
      anosepi <- anosepi %>% filter(!( anoepi == "Ano13"))
      lab <- paste0("SEM_",unique(anosepi$semana))
      anosepi[which(anosepi$anoepi %in% "Ano0"),'semana'] <- 
      anosepi[which(anosepi$anoepi %in% "Ano1"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano2"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano3"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano4"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano5"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano6"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano7"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano8"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano9"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano10"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano11"),'semana'] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano12"),'semana'] <- lab
      
      
      analise <-anosepi %>%
         ggplot(aes(x = semana, y = freq,group=ano)) + 
         geom_line(aes(color=anoepi),size=1.1) +
         scale_color_manual(values = c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2"))) +
         axis.theme(x.angle = 45,vjust = 0.5,hjust = 0.5)
      ggsave(filename = "anos_serie.png",analise,width = 12,height = 7)
      analise <- ggplotly(analise)  %>% layout(hovermode = TRUE, spikedistance =  -1,margin = c(4,0,0,0),
                                               title = list(text='<b>Análise das Séries Casos de Dengue</b>'),titlefont=list(size=20),
                                               xaxis = list(title = "<b>SEMANAS</b>", showspikes = TRUE, titlefont = list(size = 20),
                                                            spikemode  = 'across', #toaxis, across, marker
                                                            spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                                            showline=TRUE,tickfont = list(size = 20),fixedrange=TRUE,
                                                            showgrid=TRUE), 
                                               yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                                             spikemode  = 'across', #toaxis, across, marker
                                                             spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                                             categoryorder = "array",
                                                             categoryarray = ~sort(rankcity$rank,decreasing = T),
                                                             showline=TRUE,tickfont = list(size = 24),
                                                             showgrid=TRUE),      
                                               
                                               
                                               autosize = T,height= 450) %>% config(displayModeBar = FALSE)
      
      
      t<-tapply(X = anosepi$freq,INDEX = anosepi$anoepi,rollmean,k=5,na.pad=T,fill="extend")
      t$Ano12 <- NULL
      
      
      t2 <-c()
      for(i in 1:length(t)){
         
         t2<- cbind(t2,t[[i]])  
      }
      
      t2 <- as.data.frame(t2)
      t2$media <- apply(X = t2,1,mean,na.rm=T)
      t2$sd   <-  apply(X = t2,1,sd,na.rm=T)
      t2$ls   <-  t2$media+(1.96*t2$sd)
      write.csv2(t2,"base_full.csv", sep = ";", dec = ",",fileEncoding = 'iso-8859-1')
      
      
      canalendemico=data.frame(Semana=paste0("CanaEndemico",'01':'52'),freq=t2$ls[1:52],semana=unique(dbf_sem_epi$semana),ano="CanalEndemico",anoepi="CanalEndemico")
      media=data.frame(Semana=paste0("MédiaMóvel",'01':'52'),freq=t2$media[1:52],semana=unique(dbf_sem_epi$semana),ano="MédiaMóvel",anoepi="MédiaMóvel")
      write.csv2(canalendemico,"canal_endemico.csv", sep = ";", dec = ",",fileEncoding = 'iso-8859-1')
      
      anosepi2<-c()
      anosepi2 <- rbind(anosepi,canalendemico,media)
      anosepi2 <- anosepi2 %>% filter(!is.na(Semana))
      anosepi2[which(anosepi2$anoepi %in% "Ano12"),'semana'] <- anosepi2$Semana[anosepi2$anoepi=="Ano12"]
      anosepi2[which(anosepi2$anoepi %in% "CanalEndemico"),'semana'] <- anosepi2$Semana[anosepi2$anoepi=="Ano12"]
      anosepi2[which(anosepi2$anoepi %in% "MédiaMóvel"),'semana'] <- anosepi2$Semana[anosepi2$anoepi=="Ano12"]
      
      
      pos.ticks <- seq(2,length(anosepi2$semana),2)
      ticks.labels <- unique(anosepi2$semana)[pos.ticks]
      
      plot <- anosepi2 %>% filter(anoepi == "Ano12" | anoepi == 'MédiaMóvel' | anoepi == 'CanalEndemico') %>%
         
         ggplot(aes(x = semana, y = freq,group=ano)) + 
         geom_line(aes(color=anoepi),size=1.1) +
         ggtitle(label = "Diagrama Controle") + 
         xlab(label = "SEMANAS") + ylab(label = "NÚMERO DE CASOS") + 
         scale_color_manual(values = c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2"))) +
         axis.theme(x.angle = 45,vjust = 0.5,hjust = 0.5)  + scale_x_discrete(breaks = ticks.labels)
      
      diagrama_controle <- ggplotly(plot) %>% layout(hovermode = TRUE, spikedistance =  -1,margin = c(4,0,0,0),
                                                                  title = list(text='<b>Diagrama Controle</b>'),titlefont=list(size=18),
                                                                  xaxis = list(title = "<b>SEMANAS</b>", showspikes = TRUE, titlefont = list(size = 18),
                                                                               spikemode  = 'across', #toaxis, across, marker
                                                                               spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                                                                               showline=TRUE,tickfont = list(size = 18),fixedrange=TRUE,
                                                                               showgrid=TRUE), 
                                                                  yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                                                                                spikemode  = 'across', #toaxis, across, marker
                                                                                spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),fixedrange=TRUE,
                                                                                categoryorder = "array",
                                                                                categoryarray = ~sort(rankcity$rank,decreasing = T),
                                                                                showline=TRUE,tickfont = list(size = 24),
                                                                                showgrid=TRUE),      
                                                                  
                                                                  
                                                                  autosize = T,height= 450) %>% config(displayModeBar = FALSE)
      ggsave(filename = "diagramacontrole.png",plot,width = 12,height = 7)
      
      
      output$analise_serie <- renderPlotly({ analise})
      # if(input$select.dicontrol == "analise"){
      #    
      #    analise
      #    
      # }else if (input$select.dicontrol == "di_control" ){
      #    
      #    
      #    
      # }
      diagrama_controle
      
   })
   
   
   

   
   #==============================================================
   #   RELATORIO - RESUMO
   #==============================================================
   
   
   observeEvent(input$open.modal,{


      # showModal(modalDialog(
      #    title = "Relatório",size = "l",
      #    fade = T,
      #    easyClose = TRUE,
      #    footer = NULL,
      #    actionBttn(inputId = "form_generate",label = "Atualizar",icon =icon(name = "sync-alt"),block = T,style = "fill"),
      #    uiOutput("relatorio")
      # ))

      
      show_alert(
         
         title = NULL,
         btn_labels = NA,
         showCloseButton = TRUE,
         text =    fluidRow(column(width=8,
                                   withSpinner(uiOutput("relatorio"))),
                            column(width = 4,
                                   actionBttn(inputId = "form_generate",label = "Atualizar",icon =icon(name = "sync-alt"),block = T,style = "fill")
                                   )),
         html = TRUE,
         width = "100%")
      

   })

   
   
   
   # table <- as.data.frame(dados.maps.pr.incidencias) %>% select(-geometry) %>%  filter(!is.na(Casos)) %>% summarise(Municipios=length(unique(Codigo)),
   #                                                                                                                  Regional=length(unique(regional)),
   #                                                                                                                  Casos = sum(Casos,na.rm = T),
   #                                                                                                                  Epidemia=sum(incidencia>300),
   #                                                                                                                  Alerta=sum(incidencia<100),
   #                                                                                                                  Baixo=sum(incidencia>=100&incidencia<=300)
   # )
   # 
   # 
   # 
   # table <- table %>% mutate(Mun.Not = nrow(df.notificados),
   #                           Total.Not=sum(df.notificados$Freq))
   library(animation)
   observeEvent(input$form_generate, {


      showNotification("CARREGANDO MAPAS ... ",duration = 5)

      # if(dir.exists("temp4semanas")){
      #    
      #    unlink(x = "temp4semanas")
      #    unlink(x = "temp4.html")
      #    unlink(x = "Rplot4semanas.png")
      #    
      #    saveWidget(map.incidencia4semanas, "temp4.html", selfcontained = TRUE)
      #    webshot("temp4.html", file = "Rplot4semanas.png",
      #            cliprect = "viewport")
      # }else{
      #    
      #    saveWidget(map.incidencia4semanas, "temp4.html", selfcontained = TRUE)
      #    webshot("temp4.html", file = "Rplot4semanas.png",
      #            cliprect = "viewport")
      #    
      # }
      # 
      # if(dir.exists("tempinc")){
      #    
      #    unlink(x = "tempinc")
      #    unlink(x = "tempinc.html")
      #    unlink(x = "Rplot.png")
      #    
      #    saveWidget(map.incidencia4semanas, "tempinc.html", selfcontained = TRUE)
      #    webshot("tempinc.html", file = "Rplot.png",
      #            cliprect = "viewport")
      # }else{
      #    
      #    saveWidget(map.incidencia, "tempinc.html", selfcontained = TRUE)
      #    webshot("tempinc.html", file = "Rplot.png",
      #            cliprect = "viewport")
      #    
      # }
     
      
      
      

      showNotification("GERANDO GRÁFICOS ... ")
      
     
     if( file.exists(paths = "Rplot1.png")){
        
        file.remove("Rplot1.png")
       ggsave(filename = "Rplot1.png",plot = fig,width = 12,height = 7)
        
     }else{
        
        ggsave(filename = "Rplot1.png",plot = fig,width = 12,height = 7)
        
        
     }
     library(animation)
     
      
      
      
    

      showNotification("GERANDO TABELAS ... ")



      r.names <- c("Municipios com Notificacao",
                   "Municipios com casos confirmados (Dengue, D.S.A, D.G)",
                   "Municipios Autoctones",
                   "Regionais com casos confirmados",
                   "Total de Casos Notificados",
                   "Total de Casos Confirmados (Dengue, D.S.A, D.G)",
                   "Dengue Sinais de Alarme",
                   "Dengue Grave",
                   "Total de Casos Autoctones",
                   "Municipios em Epidemia",
                   "Municipios em Alerta",
                   "Municipios com indice baixo",
                   "Municipios sem casos",
                   "Número de Obitos")

      table.df <- data.frame(resumo = c(table_resumo$Mun.Not,
                                        table_resumo$Municipios,
                                        table_resumo$Mun.Auto,
                                        table_resumo$Regional,
                                        table_resumo$Total.Not,
                                        table_resumo$Casos,
                                        table_resumo$DSA,
                                        table_resumo$DG,
                                        table_resumo$Total.Auto,
                                        table_resumo$Epidemia,
                                        table_resumo$Alerta,
                                        table_resumo$Baixo,
                                        399-sum(table_resumo$Epidemia,table_resumo$Alerta,table_resumo$Baixo),
                                        sum(dados.maps.pr$Obitos,na.rm = T)
                                        )
                             ,row.names = r.names)
      colnames(table.df) <- c(paste("Periodo ", data.range[1]," a ",data.range[2]))

      
     teste <- dados.maps.pr %>% group_by(regional) %>% filter(!is.na(regional))  %>%  summarise(Macro = unique(macroregional),
                                                                `Regionais de Saude` = unique(regional),
                                                                 Populacao = sum(`População estimada - pessoas [2019]`,na.rm = T),
                                                                 Casos     = sum(Casos,na.rm = T) ,
                                                                 DSA       = sum(DSA,na.rm = T),
                                                                 DG        = sum(DG,na.rm=T),
                                                                 Obitos    = sum(Obitos,na.rm = T),
                                                                 Incidencia = (sum(Casos,na.rm = T)/sum(`População estimada - pessoas [2019]`,na.rm = T))*100000)
     teste$geometry <- NULL
      
     
     table.rank <- rankcity[,c(6,5,4,2)]
     colnames(table.rank) <- c("Macrorregional","Regional de Saude","Municipio","Casos")
     table.rank$Municipio <- str_to_title(table.rank$Municipio)
     
     showNotification("GERANDO FORMULÁRIO ... ")
      fileName <- "main.tex"
      if(file.exists(fileName)){
         unlink(fileName)
      }
      #\\vspace*{\\fill} \n
      name_body<-"body.tex"
      sink(fileName,append = F)

      cat("\\documentclass[10pt,a4paper]{article} \n")
      cat("\\usepackage[utf8]{inputenc}\n")
      cat("\\usepackage[T1]{fontenc}\n")
      cat("\\usepackage{amsmath}\n")
      cat("\\usepackage{amsfonts}\n")
      cat("\\usepackage{amssymb}\n")
      cat("\\usepackage{booktabs }\n")
      cat("\\usepackage{graphicx}\n")
      cat("\\usepackage[left=1cm,right=1cm,top=3cm,bottom=1cm]{geometry}\n")
      cat("\\usepackage{caption} \n \\usepackage{subcaption}\n")
      cat("\\usepackage{multicol}\n")
      cat("\\usepackage{tikz}\n")
      cat("\\usetikzlibrary{calc,positioning,arrows,shapes,shadows,fit,patterns,quotes,spy} \n \\usepackage{lipsum}\n")
      cat("\\usepackage{fancyhdr}\n")
      cat("\\pagestyle{fancy}\n")
      cat("\\usepackage{eso-pic,transparent}\n \\usepackage{tikz}\n")
      #cat("\\AddToShipoutPictureBG{\\includegraphics[width=\\paperwidth]{www/header_informe_dateless.png}}\n\n
      cat("\\chead{\\includegraphics[width=\\headwidth]{www/header_informe_dateless.png}} \n\n")
      cat("\\usepackage[onehalfspacing]{setspace}\n")
      cat("\\setlength{\\parindent}{2em}\n")
      cat("\\setlength{\\parskip}{1.0em}\n")
      cat("\\geometry{a4paper,includehead,top=0cm,left=1cm}\n")
      cat("\\fancyheadoffset{0.005\\textwidth}")
      cat("\\setlength\\headheight{3cm}\n")
      cat("\\setlength\\headwidth{\\paperwidth}\n")
      
      cat("\\begin{document}\n\n")
     
     #  cat("\\begin{titlepage}  \n
     # 
     #  \\begin{center}\n
     #    \\includegraphics[scale=0.3]{www/logosec.png} \n
     #   {  \\bf \\Large Secretaria de Estado de Saude }\n\n
     #      {  \\bf \\Large Diretoria de Atencao e Vigilancia em Saude }\n\n
     #      {  \\bf \\Large Coordenadoria de Vigilancia Ambiental }\n\n
     #  {\\bf \\Large  Coordenadoria de Vigilancia Epidemiologica }\\\\[2.5cm]\n
     #      {\\bf \\huge  Situacao da Dengue }\\\\[2.5cm]\n
     #  \\end{center}  \n
     # 
     # 
     # 
     #     \\vspace*{\\fill} \n
     # \\begin{center} \n
     #  {\\large Maringa}\\\\[0.2cm]\n
     #  {\\large \\today}\n
     #  \\end{center}\n
     #  \\end{titlepage}\n")



      cat("\\input{body} \n\n")
      cat("\\end{document}")

      sink()

      if(file.exists("body.tex")){
         unlink("body.tex")
      }



      inc<-format((table.df[9,1]/11433957)*100000,scientific = F)
         sink(name_body,append = F)

         cat("\\clearpage \n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/h1.png} \n\n ")
        
         cat("  \n \\includegraphics[width=\\textwidth ]{www/h2_resumo.png} \n \\end{center} \n ")
         
         cat("\\vspace{-1.5cm} \n  \\begin{flushleft} \n
              \\begin{tabular}{ c c c c c c }\n",
                 " \\hspace{0.5cm} {\\Large ", table.df[5,1] ,"} & ", "\\hspace{1.0cm} {\\Large ",   table.df[6,1] ,"} & ", "\\hspace{1.0cm} {\\Large ", table.df[9,1] ,"} & ", "\\hspace{1.0cm} {\\Large ",  inc ,"} & ", "\\hspace{1.1cm} {\\Large ",  table.df[1,1] ,"} & ", "\\hspace{1.8cm} {\\Large ",  table.df[14,1], "} \\\\ \n", 
               " \\end{tabular}\n
                 \\end{flushleft}\n")
         
         # cat( table$Total.Not," \\hspace{2cm} ",
         #      table$Casos,
         #      table$Total.Auto)
         
         cat(kable_data(data = table.df,cap = paste0("Resumo de informacoes dos casos de Dengue, Dengue com Sinais de Alarme (D.S.A) e Dengue Grave (D.G) referente ao periodo de " ,data.range[1]," a ",data.range[2])))
         
        
         
         
         cat("\\clearpage \n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/h2.png} \n\n \\end{center} \n\n")
         cat("Definicao: Descreve de forma resumida a distribuicao de frequencias da doenca para o periodo de um ano, baseado no 
         comportamento observado da doenca durante varios anos previos (dez anos, excluindo-se os anos epidemico) e em sequencia,
         em determinada populacao. Auxilia na determinacao de situacoes de alerta epidemico e previsao de epidemias, atraves da 
         sobreposicao da curva epidemica do periodo de interesse (frequencia observada do ano atual) ao canal endemico (frequencia esperada). \n ") 
        
          cat("  \n \\includegraphics[width=16cm]{diagramacontrole.png} \n  \n ")
         
         cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h3.png}  \n\n")
         cat(" \n \\includegraphics[width=16cm ]{Rplot1.png} \n\n")
         
         cat("\\clearpage \n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/h4.png}  \n\n")
         cat("(N de casos autoctones/100.000habitantes. Parana). \\end{center} \n\n\n")
         
         cat("\\begin{figure}[h] \n
         \\begin{minipage}[b]{0.5\\textwidth} \n
         \\includegraphics[width=\\textwidth]{map_inc.png} \n
         \\caption{Incidencias para casos autoctonos por 100.000 habitantes} \n
         \\label{fig:1} \n
         \\end{minipage} 
         \\hfill 
         \\begin{minipage}[b]{0.5\\textwidth} \n
         \\includegraphics[width=\\textwidth]{map_inc4.png} \n
         \\caption{Incidencias para casos autoctonos por 100.000 habitantes das ultimas 4 semanas.} \n
         \\label{fig:2} \n
         \\end{minipage} \n
         \\end{figure} \n")
         
         cat("\\begin{figure}[h] \n
         \\begin{minipage}[b]{0.5\\textwidth} \n
         \\includegraphics[width=\\textwidth]{map_obt.png} \n
         \\caption{Cidades com Obitos para o Estado do Parana.} \n
         \\label{fig:1} \n
         \\end{minipage} 
         \\hfill 
         \\begin{minipage}[b]{0.5\\textwidth} \n
         \\includegraphics[width=\\textwidth]{map_lia.png} \n
         \\caption{LIA} \n
         \\label{fig:2} \n
         \\end{minipage} \n
         \\end{figure} \n")
         
       
         
         
         #cat("\\centering  \n \\includegraphics[width=16cm ]{Rplot.png} \n\n")
         
         cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h5.png}  \n\n")
         cat(kable_data(data = table.rank,cap = paste0("Municipios com maior numero de casos das 12 ultimas semanas (> 100)")))
         
         cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h6.png}  \n\n ")
         cat(kable_data(data = teste,cap = paste0("Resumo dos casos por Regional de Saude")))
         
         
         cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h7.png}  \n\n ")
         cat(" \n \\includegraphics[width=16cm ]{www/risco_climatico.png} \n\n")
         
         cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h8.png}  \n\n ")
        cat("O quadro abaixo apresenta a série histórica do sorotipo viral de dengue desde o ano de 1991. Observa-se uma predominância do sorotipo DEVN1 até 2018, e do sorotipo DENV2 a partir de 2019.
         De janeiro a 11 de julho de 2020 foram processadas 11.594 amostras para vigilância epidemiológica da circulação viral dos 4 sorotipos. Em 79,7 % das amostras positivas para dengue foi encontrado o sorotipo DENV2.\n\n")
         
        
        
         cat("  \n \\includegraphics[width=16cm ]{www/quadro_laboratorial.png} \n\n")
         cat("  \n \\includegraphics[width=16cm ]{www/mapa_laboratorial.png} \n\n")
        
         
         
         
         
         cat("\\clearpage \n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/header_zika.png} \n\n ")
         
         cat("  \n \\includegraphics[width=\\textwidth ]{www/h2_resumo.png} \n \\end{center} \n ")
         
         cat("\\vspace{-1.5cm} \n  \\begin{flushleft} \n
              \\begin{tabular}{ c c c c c c }\n",
             " \\hspace{0.5cm} {\\Large ", table.df[5,1] ,"} & ", "\\hspace{1.0cm} {\\Large ",   table.df[6,1] ,"} & ", "\\hspace{1.0cm} {\\Large ", table.df[9,1] ,"} & ", "\\hspace{1.0cm} {\\Large ",  inc ,"} & ", "\\hspace{1.1cm} {\\Large ",  table.df[1,1] ,"} & ", "\\hspace{1.8cm} {\\Large ",  table.df[14,1], "} \\\\ \n", 
             " \\end{tabular}\n
                 \\end{flushleft}\n")
         
         cat("\n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/header_chikungunya.png} \n\n ")
         
         cat("  \n \\includegraphics[width=\\textwidth ]{www/h2_resumo.png} \n \\end{center} \n ")
         
         cat("\\vspace{-1.5cm} \n  \\begin{flushleft} \n
              \\begin{tabular}{ c c c c c c }\n",
             " \\hspace{0.5cm} {\\Large ", table.df[5,1] ,"} & ", "\\hspace{1.0cm} {\\Large ",   table.df[6,1] ,"} & ", "\\hspace{1.0cm} {\\Large ", table.df[9,1] ,"} & ", "\\hspace{1.0cm} {\\Large ",  inc ,"} & ", "\\hspace{1.1cm} {\\Large ",  table.df[1,1] ,"} & ", "\\hspace{1.8cm} {\\Large ",  table.df[14,1], "} \\\\ \n", 
             " \\end{tabular}\n
                 \\end{flushleft}\n")
         
       
         sink()

      showNotification("CARREGANDO ... ")
      latexmk("main.tex")
      pdffile="main.pdf"
      pdf_folder <- "pdf_folder"
      if(!file.exists(pdf_folder))
         dir.create("pdf_folder")
      temp<-"pdf_folder/formulario.pdf"
      file.create(temp)
      file.rename(from = "main.pdf",to = "pdf_folder/formulario.pdf")
      addResourcePath("pdf_folder",pdf_folder)
      showNotification("FORMULÁRIO GERADO COM SUCESSO!!! . ")
      output$relatorio<- renderUI({ tags$iframe(src=temp,align="left",width=800,height=600,
                                                style="overflow-x:hidden;overflow-y:hidden;border-width:10;")  })
   })
   
   
   
}
