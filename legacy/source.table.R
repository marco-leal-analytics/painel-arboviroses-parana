table <- as.data.frame(dados.maps.pr.incidencias) %>% select(-geometry) %>%  filter(!is.na(Freq)) %>% summarise(Municipios=length(unique(Codigo)),
                                                                             Regional=length(unique(regional)),
                                                                             Casos = sum(Freq,na.rm = T),
                                                                             Epidemia=sum(incidencia>300),
                                                                             Alerta=sum(incidencia<100),
                                                                             Baixo=sum(incidencia>=100&incidencia<=300)
                                                                             )

# as.data.frame(dados.maps.pr.incidencias) %>% filter(!is.na(Freq)) %>% select(-geometry) %>% summarise(Regional=length(unique(Codigo)))
# dados.maps.pr.incidencias$incidencia >300
