dbf2007_2020          <- readxl::read_xlsx(path = "data/raw/Casos Consolidados Notificados 2007 a 2020 BaseDBF.xlsx",sheet = "Notificado")

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

analise <-anosepi %>%
ggplot(aes(x = semana, y = freq,group=ano)) + 
  geom_line(aes(color=anoepi),size=1.1) +
  scale_color_manual(values = c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2"))) +
  axis.theme(x.angle = 45,vjust = 0.5,hjust = 0.5)

ggplotly(analise)


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



canalendemico=data.frame(Semana=paste0("CanaEndemico",'01':'52'),freq=t2$ls[1:52],semana=unique(dbf_sem_epi$semana),ano="CanalEndemico",anoepi="CanalEndemico")
media=data.frame(Semana=paste0("MédiaMóvel",'01':'52'),freq=t2$media[1:52],semana=unique(dbf_sem_epi$semana),ano="MédiaMóvel",anoepi="MédiaMóvel")


anosepi2<-c()
anosepi2 <- rbind(anosepi,canalendemico,media)
anosepi2 <- anosepi2 %>% filter(!is.na(Semana))
anosepi2[which(anosepi2$anoepi %in% "Ano12"),'semana'] <- anosepi2$Semana[anosepi2$anoepi=="Ano12"]
anosepi2[which(anosepi2$anoepi %in% "CanalEndemico"),'semana'] <- anosepi2$Semana[anosepi2$anoepi=="Ano12"]
anosepi2[which(anosepi2$anoepi %in% "MédiaMóvel"),'semana'] <- anosepi2$Semana[anosepi2$anoepi=="Ano12"]

anosepi2 %>% filter(anoepi == "Ano12" | anoepi == 'MédiaMóvel' | anoepi == 'CanalEndemico') %>%

ggplot(aes(x = semana, y = freq,group=ano)) + 
  geom_line(aes(color=anoepi),size=1.1) +
  scale_color_manual(values = c(brewer.pal(n = 9,name = "Set1"),brewer.pal(n = 6,name = "Dark2"))) +
  axis.theme(x.angle = 45,vjust = 0.5,hjust = 0.5)











#ggmap(ggmap = dados.maps.pr)
# cores               <- c()
# col.brew            <- brewer.pal(n = 6, name = "Set1")
# colors              <- col.brew
# cores               <- sapply(1:length(dados.maps.pr$macroregional),FUN = function(i) getColor(as.character(dados.maps.pr$macroregional[i])))
# dados.maps.pr$cores <- cores
# 
# 
# ggplot() +
#    geom_sf(data=dados.maps.pr, size=.15, show.legend = TRUE,aes(color=cores,fillcolor=cores)) +
#   ggtitle(label = "Densidade de Casos para o Estado do Paraná")+
#    scale_fill_gradientn(colours=dados.maps.pr$cores,name='Distribuição')+
#    xlab("Longitude") + ylab("Latitude") + axis.theme()
