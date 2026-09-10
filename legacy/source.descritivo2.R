library(brazilmaps)
library(sf)
library(maps)
library(mapdata)
library(raster)
library(dplyr)
library(RColorBrewer)
library(shiny)
library(bs4Dash)
library(leaflet)
library(shinyWidgets)
library(shinycssloaders)
library(shinyBS)
library(shinyjs)
library(plotly)
library(RCurl)
library(readr)
library(ggplot2)
library(lubridate)
library(tidyverse)
library(ggrepel)
library(foreign)
textsize <- 18
textsize2 <- 18

axis.theme <- function(x.angle = 0,vjust=0,hjust=0.5){
  
  
  theme_bw()  +
    theme(
      axis.text.x = element_text(angle = x.angle,face = "bold",size = textsize,hjust=hjust, vjust=vjust),
      axis.text.y = element_text(angle = 0,face = "bold",size = textsize),
      legend.background = element_rect(fill = "transparent", colour = NA,size = 2),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "white", colour = NA),
      axis.title.x = element_text(colour = "black",size = textsize,face = "bold"),
      axis.title.y = element_text(colour = "black",size = textsize,face = "bold"),
      legend.title = element_text(colour = "black",size = 10),
      legend.position = "top",
      legend.text = element_text(colour = "black",size = 14,face = "bold"),
      panel.grid = element_line(linetype="dashed"),
      panel.grid.major = element_line(colour = "gray"),
      title =element_text(size=18, face='bold',hjust = 0.5),
      plot.title = element_text(hjust = 0.5),
      axis.title = element_text(color="#000000", face="bold", size=textsize,lineheight = 2))
  
}


#setwd("C:/Users/Dani Granzotto/Google Drive/DengueEstatistica/Dados")
# df1 <- read.dbf("www/DENGON193152se29.dbf")
# df2 <- read.dbf("www/DENGON200129se29.dbf")
# df0 <- rbind(df1,df2)
# 
# 
# unique(df0$EVOLUCAO)
# 
# unique(df0$CRITERIO)
# 
# unique(df0$CLASSI_FIN)
# 
# unique(df0$TPAUTOCTO)
# 
# df0$SEM_NOT
# colunas <- c("CS_SEXO","DT_NASC","CS_ESCOL_N","CS_GESTANT","DT_NOTIFIC","SEM_NOT","ID_MN_RESI","ID_BAIRRO","NM_BAIRRO","CLASSI_FIN","EVOLUCAO","CRITERIO","TPAUTOCTO","SG_UF")
# df <- df0[,colunas]
# write.csv(x = df,file = "dbase_reduzido.csv",row.names = F)




################################# SEXO #####################################################################

plotly.pie <- function(data = data,title = "PROPORÇÃO DE CASOS POR SEXO", h = 500){
  # data=data_sexo
  # title = "PROPORÇÃO DE CASOS POR SEXO"
  blu    <- 'rgb(100, 140, 240)'
  dblu   <- 'rgb(0, 0, 102)'
  red    <- 'rgb(200, 30, 30)'
  dred   <- 'rgb(100, 30, 30)'
  f1     <- list(family = "Arial", size = 10, color = "rgb(30, 30, 30)")
  plt <- data %>%
    plot_ly() %>%
    plotly::config(displayModeBar = TRUE,  # Include ModeBar
                   displaylogo = FALSE,    # Remove some buttons to simplify
                   modeBarButtonsToRemove = c("lasso2d", "select2d",
                                              "toggleSpikelines", "hoverCompareCartesian",
                                              "hoverClosestCartesian", "autoScale2d"),
                   toImageButtonOptions = list(format = "png", filename = "pie.chart")) %>%
    layout(margin = c(0,0,0,10),
           ## Add country and state to title
           uniformtext=list(minsize=20, mode='hide'),
           title = list(text = paste0("<b>", title, "</b>"),font=list(size=24)),
           
           xaxis = list(title = "<b>SEMANAS</b>", showspikes = TRUE, textfont = list(family= "Times", size= c(20, 20, 20), color= c("black")),
                        spikemode  = 'across', #toaxis, across, marker
                        spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
                        showline=TRUE,tickfont = list(size = 14),fixedrange=TRUE,
                        showgrid=TRUE),
           yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
                         spikemode  = 'across', #toaxis, across, marker
                         spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 20),
                         showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
                         showgrid=TRUE),height=h,
           
           
           legend = list(
             x = 0.03,
             y = 0.97,                             # Legend position
             bgcolor = 'rgba(240, 240, 240, 0.5)'
           ),
           font = list(family = "Arial", size = 10),
           dragmode = FALSE,                                             # To avoid zoom when the graph starts
           modebar = list(orientation = "v")                             # Modebar orientation
    ) %>%
    
    add_annotations(text = paste0("Atualizado em/Updated on ", "data"),
                    x = 0.99, y = -0.032, xref = "paper", yref = "paper",
                    font = list(family = "Arial", size = 10), align = "right",
                    showarrow = FALSE) %>%
    add_annotations(text = "Fonte/Source: SESA/PR",
                    x = 0, y = -0.032, xref = "paper", yref = "paper",
                    font = list(family = "Arial", size = 10, color =' rgba(128, 128, 128, 0.5)'), align = "left",
                    showarrow = FALSE)
  
  plt <- plt %>%
    add_trace( labels = ~categorie, values = ~n.Freq, type = 'pie',hole = 0.6,
               textposition = 'outside',
               textfont = list(family= "Times", size= c(20, 20, 20), color= c("black")),
               textinfo = 'label+percent',
               insidetextfont = list(color = '#FFFFFF',size=25),
               hoverinfo = 'text',
               insidetextorientation='horizontal',
               text = ~paste( data$n.Freq, ' casos'),
               marker = list(colors = c("red","black",dblu),
                             line = list(color = '#FFFFFF', width = 1,size=25)),
               showlegend = FALSE)
  
  plt
  
}

plot.sexo<-function(df){
  tab.sexo01 <-table(df$CS_SEXO)#J? multiplicado por 100%, ORDEM: FEM, INDETERMINADO, MASC
  
  tab.sexo0 <-round(prop.table(table(df$CS_SEXO))*100,2)#J? multiplicado por 100%, ORDEM: FEM, INDETERMINADO, MASC
  
  tab.sexo <- paste(round(prop.table(table(df$CS_SEXO))*100,2),"%") #J? multiplicado por 100%, ORDEM: FEM, INDETERMINADO, MASC
  data_sexo <- data.frame(n = tab.sexo01,categorie = c("FEMININO","INDEFINIDO","MASCULINO"))
  
  
 
  
  plot.sexo <- plotly.pie(data = data_sexo)
  
  plot.sexo
}



# ################################# IDADE ####################################################################

plot.idade <- function(df){
  
  #df<-df1
  nascimento  <- df$DT_NASC
  notificacao <- df$DT_NOTIFIC
  idade<-as.numeric(floor((as.Date(notificacao)-as.Date(nascimento))/365.25))
  id<-data.frame(idade,nascimento,notificacao)
  
  id$clas.idade <- ifelse(id$idade < 11, "0-10",
                          ifelse(id$idade < 21, "11-20",
                                 ifelse(id$idade < 31, "21-30",
                                        ifelse(id$idade < 41, "31-40",
                                               ifelse(id$idade < 51, "41-50",
                                                      ifelse(id$idade < 61, "51-60",
                                                             ifelse(id$idade < 71, "61-70",
                                                                    ifelse(id$idade < 81, "71-80","80 ou mais"))))))))
  
  d<-data.frame(prop.table(table(id$clas.idade,sexo=df$CS_SEXO)))
  d.casos <- as.data.frame(table(id$clas.idade,sexo=df$CS_SEXO))
  d$casos <- d.casos$Freq
  d <- d[d$sexo!="I",]
  
  plot.idade <- ggplot(data = d,
                       mapping = aes(
                         x = Var1,
                         y = ifelse(test = sexo == "F",  yes = -Freq, no = Freq),
                         fill = sexo,
                         label=paste(round(Freq*100, 1), "%", sep="")
                       )) +
    geom_bar(stat = "identity") +
    geom_text(nudge_y =ifelse(test = d$sexo == "F",  yes = -0.01, no = 0.01), size=6, colour="#505050") +
    scale_y_continuous(labels = abs, limits = max(d$Freq) * c(-1,1) * 1.1) +
    scale_fill_manual(values=as.vector(c("#CE1256","#08519C"))) +
    #labs(x = "",y = "",fill="",family=fontsForCharts ) +
    #theme_minimal(base_family=fontsForCharts, base_size=20) +
   
    coord_flip() +
    theme(
      axis.text.x=element_blank(),
      axis.text.y=element_text(size=18),
      legend.position="none",
      legend.text=element_text(size=20),
      axis.ticks = element_blank()
    )+ ylab("")+xlab(" ")  + axis.theme()
  
  ggplotly(plot.idade,height=550)  %>%
    layout( title = list(text = paste0("<b>", "CASOS POR FAIXA ETÁRIA", "</b>"),font=list(size=24)),margin = c(0,0,0,10))
  
  # fig<-plot_ly(x = ifelse(test = d$sexo == "F",  yes = -d$Freq, no = d$Freq) , y =as.factor(d$Var1) , type="bar", color = d$sexo,colors = c("red","blue"),orientation = 'h',
  #              text = d$sexo)
  # fig <- fig %>% layout(hovermode = TRUE, autosize = T,spikedistance =  -1,text= list(size=30)) %>% config(displayModeBar = FALSE)
  # fig
  
}





# # ################################# ESCOLARIDADE ################################################################

plot.escolaridade <- function(df){
  tab.escolaridade <- paste(round(prop.table(table(df$CS_SEXO))*100,2),"%") #J? multiplicado por 100%,
  verde <- brewer.pal(n=9,"Greens")
  cores3<- c("#CB181D",rep(verde[c(9,8,7,6)],each=2),"#F7FCB9","#F7FCB9")
  
  Escolaridade <- factor(df$CS_ESCOL_N,
                         levels=c(0:10),
                         labels=c("Analfabeto", "Fundamental I incompleto", "Fundamental I completo",
                                  "Fundamental II incompleto", "Fundamental II completo",
                                  "Médio incompleto", "Médio completo",
                                  "Superior incompleto", "Superior completo", "Ignorado","Não se aplica"))
  esc.dt <- as.data.frame(table(Escolaridade))
  Percentuais <- esc.dt$Freq / sum(esc.dt$Freq)
  d <- data.frame(esc.dt,Percentuais,q.val=c(1:11))
  
  plot.escolaridade <- ggplot(data = d,
                              mapping = aes(
                                x = Escolaridade,
                                y = Percentuais,
                                fill = factor(q.val),
                                label=paste(round(Percentuais*100, 0), "%", sep="")
                              )) +
    geom_bar(stat = "identity") +
    geom_text(hjust=.001, size=6) +
    scale_fill_manual(name = " ",  values =c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2")))+
    coord_flip() + ylim(0,max(Percentuais)+.02)+
    theme(
      axis.text.x=element_blank(),
      axis.text.y=element_text(size=18),
      legend.position="none",
      legend.text=element_text(size=20),
      axis.ticks = element_blank()
    )+ ylab("")+xlab(" ") + axis.theme()
  
  
  ggplotly(plot.escolaridade,height=550) %>%
    layout( title = list(text = paste0("<b>", "CASOS POR GRAU DE ESCOLARIDADE", "</b>"),font=list(size=24)),margin = c(0,0,0,10))
}



# # ################################# GESTANTE #####################################################################

plot.gestantes <- function(df){
  
  
  tab.gestante <- paste(round(prop.table(table(df$CS_GESTANT))*100,2),"%") #J? multiplicado por 100%, ORDEM: FEM, INDETERMINADO, MASC
  
  
  Gestante<- ifelse(df$CS_GESTANT==9,"Ignorado",
                    ifelse(df$CS_GESTANT==6,"NSA",
                           ifelse(df$CS_GESTANT==5,"Não","Sim")))
  esc.dt<-as.data.frame(table(Gestante))
  
  esc.dt$fraction1 <- as.numeric(round(esc.dt$Freq / sum(esc.dt$Freq),4))
  esc.dt$ymax = cumsum(esc.dt$fraction)
  esc.dt$ymin = c(0, head(esc.dt$ymax, n=-1))
  esc.dt$labelPosition <- (esc.dt$ymax + esc.dt$ymin) / 2
  esc.dt$fraction <- format(round(esc.dt$fraction1*100, 1), nsmall = 1)
  esc.dt$label <- paste0(esc.dt$fraction,"%")
  
  cores4 <- c("#006D2C","#41AB5D","#F7FCB9","#A50F15")
  
  
  
  plot.gestante <- ggplot(esc.dt, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Gestante)) +
    geom_rect() +
    geom_label_repel( x=3.5, aes(x = " ",y=labelPosition, label=label), data = esc.dt, size=6, show.legend = F, nudge_x = 1)+
    scale_fill_brewer(name = " ", palette = "Paired")+
    coord_polar(theta="y") + # Try to remove that to understand how the chart is built initially
    xlim(c(2, 4))+
    theme_void() +
    theme(legend.position = "bottom",
          legend.text = element_text(size=14))
  
  
  
  
  S_Gestante <- as.numeric(df$CS_GESTANT)[Gestante=="Sim"]
  esc.dt <- as.data.frame(table(S_Gestante))
  Percentuais <- esc.dt$Freq / sum(esc.dt$Freq)
  d <- data.frame(esc.dt,Percentuais,q.val=c(1:4))

  plot.gestante2 <- ggplot(data = d,
                           mapping = aes(
                             x = c("1º Trimestre","2º Trimestre","3º Trimestre","Ignorado"),
                             y = Percentuais,
                             fill = factor(q.val),
                             label=paste(round(Percentuais*100, 0), "%", sep="")
                           )) +
    geom_bar(stat = "identity") +
    geom_text(hjust=.001, size=6) +
    scale_fill_brewer(name = " ",  palette ="Blues")+
    coord_flip() + ylim(0,max(Percentuais)+.02)+
    theme(
      axis.text.x=element_blank(),
      axis.text.y=element_text(size=18),
      legend.position="none",
      legend.text=element_text(size=20),
      axis.ticks = element_blank()
    )+ ylab("")+xlab(" ") + axis.theme()
 
  
  
  return(list(plot1=ggplotly(plot.gestante,height=550) %>%
                layout( title = list(text = paste0("<b>", "CASOS NÃO GESTANTES", "</b>"),font=list(size=24)),margin = c(0,0,0,10)),plot2=ggplotly(plot.gestante2,height=550) %>%
                layout( title = list(text = paste0("<b>", "CASOS GESTANTES", "</b>"),font=list(size=24)),margin = c(0,0,0,10))))
  
}





# # ################################# SERIE CASOS MENSAIS ######################################################
# 
# library(lubridate)
# df01 <- df %>%
#   mutate(date = ymd(DT_NOTIFIC),
#          dia = day(DT_NOTIFIC),
#          mes = month(DT_NOTIFIC),
#          ano = year(DT_NOTIFIC),
#          semana = format(DT_NOTIFIC, format="%Y-%U")) %>%
#   group_by(semana) %>%
#   summarise(frequencia = n())
# df01 <-data.frame(label=df01$semana,values=df01$frequencia)
# df01 <-df01[1:355,]
# 
# plotly.series <- function(data = data,title = "SÉRIE DOS CASOS"){
#   # data=data_sexo
#   # title = "PROPORÇÃO DE CASOS POR SEXO"
#   blu    <- 'rgb(100, 140, 240)'
#   dblu   <- 'rgb(0, 0, 102)'
#   red    <- 'rgb(200, 30, 30)'
#   dred   <- 'rgb(100, 30, 30)'
#   f1     <- list(family = "Arial", size = 10, color = "rgb(30, 30, 30)")
#   plt <- data %>%
#     plot_ly() %>%
#     plotly::config(displayModeBar = TRUE,  # Include ModeBar
#                    displaylogo = FALSE,    # Remove some buttons to simplify
#                    modeBarButtonsToRemove = c("lasso2d", "select2d",
#                                               "toggleSpikelines", "hoverCompareCartesian",
#                                               "hoverClosestCartesian", "autoScale2d"),
#                    toImageButtonOptions = list(format = "png", filename = "pie.chart")) %>%
#     layout(
#       ## Add country and state to title
#       title = list(text = paste0("<b>", title, "</b>"),size = 24),
#       xaxis = list(title = "<b>SEMANAS</b>", showspikes = TRUE, titlefont = list(size = 24),
#                    spikemode  = 'across', #toaxis, across, marker
#                    spikesnap = 'cursor',  ticks = "outside",tickangle = -45,
#                    showline=TRUE,tickfont = list(size = 14),fixedrange=TRUE,
#                    showgrid=TRUE),
#       yaxis = list (title = "<b>NÚMERO DE CASOS</b>",
#                     spikemode  = 'across', #toaxis, across, marker
#                     spikesnap = 'cursor', zeroline=FALSE,titlefont = list(size = 24),
#                     showline=TRUE,tickfont = list(size = 24),fixedrange=TRUE,
#                     showgrid=TRUE),
# 
# 
#       legend = list(
#         x = 0.03,
#         y = 0.97,                             # Legend position
#         bgcolor = 'rgba(240, 240, 240, 0.5)'
#       ),
#       font = list(family = "Arial", size = 10),
#       dragmode = FALSE,                                             # To avoid zoom when the graph starts
#       modebar = list(orientation = "v")                             # Modebar orientation
#     ) %>%
# # Add update date
#     add_annotations(text = paste0("Atualizado em/Updated on ", "data"),
#                     x = 0.99, y = -0.033, xref = "paper", yref = "paper",
#                     font = list(family = "Arial", size = 11), align = "right",
#                     showarrow = FALSE) %>%
#     add_annotations(text = "Fonte/Source: SESA/PR",
#                     x = 0, y = -0.033, xref = "paper", yref = "paper",
#                     font = list(family = "Arial", size = 11, color =' rgba(128, 128, 128, 0.5)'), align = "left",
#                     showarrow = FALSE)
# 
#   plt <- plt %>%
#     add_trace(
#       x = ~ label, y = ~ values,
#       type = 'scatter', mode = 'lines+markers', hoverinfo = "x+y",
#       name = "ESTADO",
#        fill = 'tonexty',
#        fillcolor = 'rgba(100, 100, 100, 0.5)',
#       marker = list(
#         color = dblu,
#         line = list(color = dblu, width = 1),
#         size = 5
#       ),
#       line = list(
#         color = dblu,
#         width = 1.5
#       )
#     )
# 
#   plt
# 
# }
# 
# plot.series <- plotly.series(data = df01)
# 
# 
# 
# plot.serie <- function(df,pos){
#   
#   #df <- df[c(pos),]
# 
# str(pos)
# 
# df01 <- df %>%
#     mutate(date = ymd(DT_NOTIFIC),
#            dia = day(DT_NOTIFIC),
#            mes = month(DT_NOTIFIC),
#            ano = year(DT_NOTIFIC),
#            semana = format(DT_NOTIFIC, format="%Y-%U")) %>%
#     group_by(semana) %>%
#     summarise(frequencia = n())
#   df01 <-data.frame(label=df01$semana,values=df01$frequencia)
#   pos1 <-which(str_detect(as.character(df01[,1]),pattern = "NA"))
#  df01 <- df01[-pos1,]
# 
# blu <- 'rgb(100, 140, 240)'
# dblu <- 'rgb(0, 0, 102)'
# red <- 'rgb(200, 30, 30)'
# dred <- 'rgb(100, 30, 30)'
# df.label <- ymd(as.Date(df01$label))
# df01$label <- df.label
# 
# str(df01)
# 
# don <- data.frame(values=df01$values,row.names = df01$label )
# 
# str(don)
# 
# plot.serie_dygraph <- dygraph(don) %>%
#   dyOptions(labelsUTC = TRUE, fillGraph=TRUE, fillAlpha=0.1, drawGrid = FALSE, colors=dblu) %>%
#   dyRangeSelector() %>%
#   dyCrosshair(direction = "vertical") %>%
#   dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE)  %>%
#   dyRoller(rollPeriod = 1)
# 
# return(plot.serie_dygraph)
#   
# }


###########################################################################










