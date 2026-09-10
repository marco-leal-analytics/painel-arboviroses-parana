# Monta, uma única vez por sessão, os datasets e agregados consumidos por mais
# de um módulo. O resultado é passado como `shared_data` para cada `modulo_server()`.
build_shared_data <- function() {
  df1 <- load_dengue_data()

  df.notificados <- df1 %>%
    dplyr::filter(SG_UF == 41) %>%
    dplyr::group_by(ID_MN_RESI) %>%
    dplyr::summarise(Freq = dplyr::n())

  df.notificados.serie2 <- df1 %>%
    dplyr::filter(SG_UF == 41) %>%
    dplyr::group_by(SEM_NOT) %>%
    dplyr::summarise(frequencia = dplyr::n())

  if (!dir.exists(file.path("data", "processed"))) {
    dir.create(file.path("data", "processed"), recursive = TRUE)
  }
  write.csv(x = df.notificados.serie2, file = file.path("data", "processed", "dadosdengue.csv"), row.names = FALSE)

  df.notificados.serie <- data.frame(
    labels = df.notificados.serie2$SEM_NOT,
    values = df.notificados.serie2$frequencia,
    row.names = df.notificados.serie2$SEM_NOT
  )

  df.autoctone <- df1 %>%
    dplyr::filter(TPAUTOCTO == 1 & SG_UF == 41) %>%
    dplyr::group_by(ID_MN_RESI) %>%
    dplyr::summarise(Freq = dplyr::n())

  df1 <- df1[df1$CLASSI_FIN == 10 | df1$CLASSI_FIN == 11 | df1$CLASSI_FIN == 12, ]

  df02 <- df1 %>%
    dplyr::mutate(
      date = format(as.Date(DT_NOTIFIC), format = "%Y-%U", digits = 1),
      date2 = cut.Date(as.Date(DT_NOTIFIC), breaks = "1 week", labels = FALSE)
    ) %>%
    dplyr::group_by(SEM_NOT) %>%
    dplyr::summarise(frequencia = dplyr::n())
  df02 <- data.frame(label = df02$SEM_NOT, values = df02$frequencia)
  df02 <- df02[-which(is.na(df02[, 1])), ]

  don2 <- data.frame(labels = df02$label, values = df02$values, row.names = df02$label)

  data.range <- range(as.Date(df1$DT_NOTIFIC), na.rm = TRUE)
  data.range <- format(data.range, format = "%d/%m/%Y")

  lia <- load_lia()
  regionais <- load_regionais()
  coordenadas.municipios <- load_coordenadas_municipios()
  maps.cities2 <- load_maps_cities(regionais)

  dados.maps.pr <- load_dados_pr()
  dados.maps.pr$`Município [-]` <- tolower(rm_accent(as.character(dados.maps.pr$`Município [-]`)))
  dados.maps.pr <- dplyr::left_join(dados.maps.pr, maps.cities2, by = "Codigo")
  dados.maps.pr[which(is.na(dados.maps.pr$macroregional)), "macroregional"] <- "Leste"
  dados.maps.pr <- sf::st_as_sf(x = dados.maps.pr)
  colnames(coordenadas.municipios)[1] <- "Codigo"
  coordenadas.municipios$Codigo <- as.numeric(coordenadas.municipios$Codigo)
  dados.maps.pr <- dplyr::left_join(dados.maps.pr, coordenadas.municipios, by = "Codigo") %>% dplyr::select(-NOME_MUNICIPIO)
  dados.maps.pr$Codigo <- as.numeric(gsub(".{1}$", "", dados.maps.pr$Codigo))

  casos <- df1 %>% dplyr::group_by(ID_MN_RESI) %>% dplyr::summarise(Casos = dplyr::n()) %>% dplyr::rename(Codigo = ID_MN_RESI)
  obitos <- df1 %>% dplyr::filter(EVOLUCAO == 2) %>% dplyr::group_by(ID_MN_RESI) %>% dplyr::summarise(Obitos = dplyr::n()) %>% dplyr::rename(Codigo = ID_MN_RESI)
  dados.maps.pr <- dplyr::left_join(dados.maps.pr, casos, by = "Codigo")
  dados.maps.pr <- dplyr::left_join(dados.maps.pr, obitos, by = "Codigo")
  dados.maps.pr <- dados.maps.pr %>% dplyr::mutate(incidencia = (as.numeric(Casos) / as.numeric(`População estimada - pessoas [2019]`)) * 100000)

  casos_auto <- df1 %>%
    dplyr::filter(TPAUTOCTO == 1 & SG_UF == 41) %>%
    dplyr::group_by(ID_MN_RESI) %>%
    dplyr::summarise(`Casos Autóctones` = dplyr::n()) %>%
    dplyr::mutate(Codigo = ID_MN_RESI)
  dados.maps.pr <- dplyr::left_join(dados.maps.pr, casos_auto, by = "Codigo")
  dados.maps.pr <- dados.maps.pr %>% dplyr::mutate(incidencia_auto = (as.numeric(`Casos Autóctones`) / as.numeric(`População estimada - pessoas [2019]`)) * 100000)

  w <- as.Date(lubridate::today()) - lubridate::weeks(4)
  casos_auto_4semanas <- df1 %>%
    dplyr::filter(TPAUTOCTO == 1 & SG_UF == 41 & as.Date(DT_NOTIFIC) > w) %>%
    dplyr::group_by(ID_MN_RESI) %>%
    dplyr::summarise(`Casos Autóctones 4 Útimas Semanas` = dplyr::n()) %>%
    dplyr::mutate(Codigo = ID_MN_RESI) %>%
    dplyr::select(-ID_MN_RESI)
  dados.maps.pr <- dplyr::left_join(dados.maps.pr, casos_auto_4semanas, by = "Codigo")
  dados.maps.pr <- dados.maps.pr %>% dplyr::mutate(incidencia_auto_4semanas = (as.numeric(`Casos Autóctones 4 Útimas Semanas`) / as.numeric(`População estimada - pessoas [2019]`)) * 100000)

  dengue_dsa <- df1 %>% dplyr::filter(CLASSI_FIN == 11) %>% dplyr::group_by(ID_MN_RESI) %>% dplyr::summarise(DSA = dplyr::n()) %>% dplyr::rename(Codigo = ID_MN_RESI)
  dengue_dg <- df1 %>% dplyr::filter(CLASSI_FIN == 12) %>% dplyr::group_by(ID_MN_RESI) %>% dplyr::summarise(DG = dplyr::n()) %>% dplyr::rename(Codigo = ID_MN_RESI)
  dados.maps.pr <- dplyr::left_join(dados.maps.pr, dengue_dsa, by = "Codigo")
  dados.maps.pr <- dplyr::left_join(dados.maps.pr, dengue_dg, by = "Codigo")

  dados.lia <- dplyr::left_join(dados.maps.pr, lia, by = "Codigo")
  dados.lia <- dplyr::distinct(dados.lia, "Codigo", .keep_all = TRUE)

  dados_descritive <- dados.maps.pr %>% dplyr::filter(!is.na(Casos))
  qtd_regionais <- unique(dados_descritive$regional)
  qtd_regionais <- length(qtd_regionais[!is.na(qtd_regionais)])

  table_resumo <- as.data.frame(dados.maps.pr) %>%
    dplyr::select(-geometry) %>%
    dplyr::filter(!is.na(Casos)) %>%
    dplyr::summarise(
      Municipios = length(unique(Codigo)),
      Regional = length(unique(regional)),
      Casos = sum(Casos, na.rm = TRUE),
      Epidemia = sum(incidencia > 300),
      Alerta = sum(incidencia >= 100 & incidencia <= 300),
      Baixo = sum(incidencia < 100),
      DSA = sum(DSA, na.rm = TRUE),
      DG = sum(DG, na.rm = TRUE)
    )
  table_resumo$Regional <- qtd_regionais
  table_resumo <- table_resumo %>%
    dplyr::mutate(
      Mun.Not = nrow(df.notificados),
      Total.Not = sum(df.notificados$Freq),
      Mun.Auto = nrow(df.autoctone),
      Total.Auto = sum(df.autoctone$Freq)
    )

  w_rank <- as.Date(df1$DT_NOTIFIC) - lubridate::weeks(12)
  rankcity <- df1 %>%
    dplyr::filter(SG_UF == 41 & as.Date(DT_NOTIFIC) > w_rank) %>%
    dplyr::group_by(ID_MN_RESI) %>%
    dplyr::summarise(Freq = dplyr::n()) %>%
    dplyr::filter(Freq >= 100) %>%
    dplyr::mutate(rank = rank(desc(Freq))) %>%
    dplyr::filter(rank <= 10) %>%
    dplyr::rename(Codigo = ID_MN_RESI)
  rankcity <- dplyr::left_join(rankcity, dados.maps.pr[, c(1, 2, 6, 7)])
  rankcity <- rankcity %>% dplyr::arrange(rank)
  rankcity$geometry <- NULL

  list(
    df1 = df1,
    df.notificados = df.notificados,
    df.notificados.serie = df.notificados.serie,
    df.notificados.serie2 = df.notificados.serie2,
    df.autoctone = df.autoctone,
    don2 = don2,
    data.range = data.range,
    lia = lia,
    regionais = regionais,
    coordenadas.municipios = coordenadas.municipios,
    maps.cities2 = maps.cities2,
    dados.maps.pr = dados.maps.pr,
    dados.lia = dados.lia,
    qtd_regionais = qtd_regionais,
    table_resumo = table_resumo,
    rankcity = rankcity,
    setview = data.frame(lng = -51.6391, lat = -24.5401)
  )
}
