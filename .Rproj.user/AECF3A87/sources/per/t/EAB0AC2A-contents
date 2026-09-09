
source(file = "librarys.R",encoding = "UTF-8",local = F)
source(file = "funcoes.R",encoding = "UTF-8",local = F)


    




# regionais               <- readxl::read_xlsx(path = "www/regionais.xlsx",sheet = "Planilha1")
# 
# coordenadas.municipios <- readxl::read_xls(path = "www/Coordenadas_Municipios.xls",sheet = "Cidades")
# #colnames(coordenadas.municipios)[1] <- "City"
#   #read.table(file = "www/regionais.csv",header = T,sep = ",")
# #readxl::read_xlsx(path = "www/regionais.xlsx",sheet = "Planilha1")
# regionais$nome      <- tolower(rm_accent(as.character(regionais$nome)))
# 
# maps.cities           <- get_brmap(geo = "City", geo.filter = list(State=41),class="sf")
# maps.cities$nome      <- tolower(rm_accent(as.character(maps.cities$nome)))
# maps.state            <- get_brmap(geo = "State", geo.filter = list(State=41),class = "sf")
# 
# cities          <- data.frame(nome=maps.cities$nome,City=maps.cities$City)
# cities.completo <- left_join(x = regionais,y = cities,"nome")
# 
# 
# maps.cities2    <<-  left_join(x = maps.cities,y = cities.completo,"City")
# 
# maps.cities2$macroregional[33]    <- "Oeste"
# maps.cities2$macroregional[131]   <- "Norte"
# maps.cities2$regional[33]         <- "Oeste"
# maps.cities2$regional[131]        <-  19
# maps.cities2$regional[33]         <-  8
# maps.cities2$macroid[131]         <-  1
# maps.cities2$macroid[33]          <-  4
# 
# 
# 
# col.brew <- brewer.pal(n = 6, name = "Set1")
# colors   <- col.brew
# 
# 
# cores <- c()
# 
# for(i in 1:length(maps.cities2$macroregional)){
# 
#   cores[i] <- getColor(maps.cities2$macroregional[i])
# 
# }
# col.brew2 <- c(brewer.pal(n = 9, name = "Set1"),brewer.pal(n = 8, name = "Dark2"),brewer.pal(n = 9, name = "Paired"))
# 
# 
# 
# cores2 <- c()
# 
# for(i in 1:length(maps.cities2$macroregional)){
# 
#   cores2[i] <- getColor2(maps.cities2$regional[i])
# 
# }
# 
# opacidades <- rep(1,length(maps.cities2$nome.x))
# 
# 
# #############
# 
# dados.pr <- readxl::read_xlsx(path = "www/dados.pr.xlsx",sheet = "Worksheet") %>% select(`Município [-]`,`Código [-]`,`População estimada - pessoas [2019]`,`Área Territorial - km² [2019]`) %>% rename(Codigo=`Código [-]`)
# 
# #dados.pr <- dados.pr %>%
# 
# maps.incidencias <-maps.cities2
# 
# #colnames(dados.pr)[2] <- "Codigo"
# colnames(maps.incidencias)[2] <- "Codigo"
# 
# dados.maps.pr <- full_join(dados.pr,maps.incidencias,"Codigo")
# dados.maps.pr <-  dados.maps.pr%>% select(-c(nome.y,nome.x))
# dados.maps.pr <- st_as_sf(x = dados.maps.pr)
# colnames(coordenadas.municipios)[1] <- "Codigo"
# coordenadas.municipios$Codigo <- as.numeric(coordenadas.municipios$Codigo)
# dados.maps.pr <- left_join(dados.maps.pr,coordenadas.municipios,"Codigo")
# 
# 
# 
# 
# df.incidencias                  <- df1 %>% group_by(ID_MN_RESI) %>% summarise(Casos=n())
# colnames(df.incidencias)[1] <- "Codigo"
# 
# unique(df.incidencias$Obito)
# 
# df.obitos <- df1 %>% filter(EVOLUCAO == 2) %>% group_by(ID_MN_RESI) %>% summarise(Obitos = n())
# colnames(df.obitos)[1] <- "Codigo"
# df.incidencias <- left_join(df.incidencias,df.obitos,"Codigo")
# 
# 
# 
# 
# dados.maps.pr.incidencias <- dados.maps.pr
# dados.maps.pr.incidencias$Codigo <- as.character(gsub('.{1}$', '', dados.maps.pr.incidencias$Codigo))
# #dados.maps.pr.incidencias$Codigo <- as.character(dados.maps.pr.incidencias$Codigo)
# df.incidencias$Codigo <- as.character(df.incidencias$Codigo)
# dados.maps.pr.incidencias <- left_join(dados.maps.pr.incidencias,df.incidencias )
# 
# 
# dados.maps.pr.incidencias <- dados.maps.pr.incidencias %>% mutate(incidencia=(as.numeric(Casos)/as.numeric(`População estimada - pessoas [2019]`))*100000)
#  #radius.inc <- findInterval(df.incidencias$incidencia,c(1,100,300,1000000)) * 3
#  
# 
# 
# 
# 
# cores.inc <- c()
# 
# for(i in 1:length(dados.maps.pr.incidencias$Codigo)){
# 
#   cores.inc[i] <- getColor.inc(dados.maps.pr.incidencias$incidencia[i])
# 
# }
# dados.maps.pr.incidencias$cores <- cores.inc
# 
# ##############################################################
# 
# # library(tidyverse)
# # df.coords <- df1 %>% mutate(Codigo=as.character(ID_MN_RESI)) 
# #  coordenadas.casos.maps <-   left_join(x = df.coords,y = dados.maps.pr.incidencias)
#  #coordenadas.casos.maps <- coordenadas.casos.maps %>% select(Codigo,LONGITUDE,LATITUDE)
# 
# ###############################################
#  
#  
#  
#  maps.label.pr <- sprintf(
#    "<strong>%s</strong><br/>
#   <strong>%s</strong><br/>
#    <strong>%s</strong><br/>
#    <strong>%s</strong><br/>
#    <strong>%s</strong><br/>
#    <strong>%s</strong><br/>
#    <strong>%s</strong><br/>
#    <strong>%s</strong><br/>
#    <strong>%s</strong><br/>
#    <strong>%s</strong><br/>",
#    
#    paste0("<b><h1>",dados.maps.pr$`Município [-]`,"</h1></b>"),
#    paste0("<b>Macroregião :</b>",dados.maps.pr$macroregional),
#    paste0("<b>Regional de Saúde :</b>",dados.maps.pr$regional,"ª"),
#    paste0("<b>Longitude :</b>",dados.maps.pr$LONGITUDE),
#    paste0("<b>Latitude :</b>",dados.maps.pr$LATITUDE),
#    paste0("<b>Área Territorial :</b>",dados.maps.pr$`Área Territorial - km² [2019]`,"Km²"),
#    paste0("<b>População Estimada 2019 :</b>",dados.maps.pr$`População estimada - pessoas [2019]`), 
#    paste0("<b>Casos :</b>",dados.maps.pr.incidencias$Casos),
#    paste0("<b>Incidência :</b>",dados.maps.pr.incidencias$incidencia),
#    paste0("<b>Óbitos :</b>",dados.maps.pr.incidencias$Obitos)
#    
#  ) %>% lapply(htmltools::HTML)