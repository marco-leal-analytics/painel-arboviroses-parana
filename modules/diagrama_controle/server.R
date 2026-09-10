diagrama_controle_server <- function(id, shared_data) {
  shiny::moduleServer(id, function(input, output, session) {
    rankcity <- shared_data$rankcity

    output$plot_diagrama_controle <- plotly::renderPlotly({
      dbf2007_2020 <- load_casos_consolidados()

      dbf_sem_epi <- dbf2007_2020 %>%
        dplyr::group_by(as.numeric(SEM_PRI)) %>%
        dplyr::summarise(freq = dplyr::n()) %>%
        dplyr::rename(Semana = `as.numeric(SEM_PRI)`)

      dbf_sem_epi$semana <- stringr::str_sub(string = dbf_sem_epi$Semana, start = -2)
      dbf_sem_epi$ano <- stringr::str_sub(string = dbf_sem_epi$Semana, start = 1, end = 4)

      kinf <- 30
      anosepi <- c()
      for (i in 1:(length(unique(dbf_sem_epi$ano))) - 1) {
        ksup <- kinf + 52 - 1
        teste <- dbf_sem_epi[c(kinf:(ksup)), ]
        teste$anoepi <- paste0("Ano", i)
        anosepi <- rbind(anosepi, teste)
        kinf <- ksup + 1
      }

      anosepi <- anosepi %>% dplyr::filter(!(anoepi == "Ano13"))
      lab <- paste0("SEM_", unique(anosepi$semana))
      anosepi[which(anosepi$anoepi %in% "Ano0"), "semana"] <-
        anosepi[which(anosepi$anoepi %in% "Ano1"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano2"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano3"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano4"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano5"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano6"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano7"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano8"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano9"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano10"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano11"), "semana"] <- lab
      anosepi[which(anosepi$anoepi %in% "Ano12"), "semana"] <- lab

      analise <- anosepi %>%
        ggplot2::ggplot(ggplot2::aes(x = semana, y = freq, group = ano)) +
        ggplot2::geom_line(ggplot2::aes(color = anoepi), size = 1.1) +
        ggplot2::scale_color_manual(values = c(RColorBrewer::brewer.pal(n = 9, name = "Set1"), RColorBrewer::brewer.pal(n = 6, name = "Dark2"))) +
        axis.theme(x.angle = 45, vjust = 0.5, hjust = 0.5)
      ggplot2::ggsave(filename = "anos_serie.png", analise, width = 12, height = 7)
      analise_plotly <- plotly::ggplotly(analise) %>%
        plotly::layout(
          hovermode = TRUE, spikedistance = -1, margin = c(4, 0, 0, 0),
          title = list(text = "<b>Análise das Séries Casos de Dengue</b>"), titlefont = list(size = 20),
          xaxis = list(
            title = "<b>SEMANAS</b>", showspikes = TRUE, titlefont = list(size = 20),
            spikemode = "across", spikesnap = "cursor", ticks = "outside", tickangle = -45,
            showline = TRUE, tickfont = list(size = 20), fixedrange = TRUE, showgrid = TRUE
          ),
          yaxis = list(
            title = "<b>NÚMERO DE CASOS</b>", spikemode = "across", spikesnap = "cursor", zeroline = FALSE,
            titlefont = list(size = 24), fixedrange = TRUE, categoryorder = "array",
            categoryarray = ~ sort(rankcity$rank, decreasing = TRUE),
            showline = TRUE, tickfont = list(size = 24), showgrid = TRUE
          ),
          autosize = TRUE, height = 450
        ) %>%
        plotly::config(displayModeBar = FALSE)

      t <- tapply(X = anosepi$freq, INDEX = anosepi$anoepi, zoo::rollmean, k = 5, na.pad = TRUE, fill = "extend")
      t$Ano12 <- NULL

      t2 <- c()
      for (i in 1:length(t)) {
        t2 <- cbind(t2, t[[i]])
      }
      t2 <- as.data.frame(t2)
      t2$media <- apply(X = t2, 1, mean, na.rm = TRUE)
      t2$sd <- apply(X = t2, 1, sd, na.rm = TRUE)
      t2$ls <- t2$media + (1.96 * t2$sd)
      if (!dir.exists(file.path("data", "processed"))) {
        dir.create(file.path("data", "processed"), recursive = TRUE)
      }
      write.csv2(t2, file.path("data", "processed", "base_full.csv"), sep = ";", dec = ",", fileEncoding = "iso-8859-1")

      canalendemico <- data.frame(Semana = paste0("CanaEndemico", "01":"52"), freq = t2$ls[1:52], semana = unique(dbf_sem_epi$semana), ano = "CanalEndemico", anoepi = "CanalEndemico")
      media <- data.frame(Semana = paste0("MédiaMóvel", "01":"52"), freq = t2$media[1:52], semana = unique(dbf_sem_epi$semana), ano = "MédiaMóvel", anoepi = "MédiaMóvel")
      write.csv2(canalendemico, file.path("data", "processed", "canal_endemico.csv"), sep = ";", dec = ",", fileEncoding = "iso-8859-1")

      anosepi2 <- rbind(anosepi, canalendemico, media)
      anosepi2 <- anosepi2 %>% dplyr::filter(!is.na(Semana))
      anosepi2[which(anosepi2$anoepi %in% "Ano12"), "semana"] <- anosepi2$Semana[anosepi2$anoepi == "Ano12"]
      anosepi2[which(anosepi2$anoepi %in% "CanalEndemico"), "semana"] <- anosepi2$Semana[anosepi2$anoepi == "Ano12"]
      anosepi2[which(anosepi2$anoepi %in% "MédiaMóvel"), "semana"] <- anosepi2$Semana[anosepi2$anoepi == "Ano12"]

      pos.ticks <- seq(2, length(anosepi2$semana), 2)
      ticks.labels <- unique(anosepi2$semana)[pos.ticks]

      plot <- anosepi2 %>%
        dplyr::filter(anoepi == "Ano12" | anoepi == "MédiaMóvel" | anoepi == "CanalEndemico") %>%
        ggplot2::ggplot(ggplot2::aes(x = semana, y = freq, group = ano)) +
        ggplot2::geom_line(ggplot2::aes(color = anoepi), size = 1.1) +
        ggplot2::ggtitle(label = "Diagrama Controle") +
        ggplot2::xlab(label = "SEMANAS") + ggplot2::ylab(label = "NÚMERO DE CASOS") +
        ggplot2::scale_color_manual(values = c(RColorBrewer::brewer.pal(n = 9, name = "Set1"), RColorBrewer::brewer.pal(n = 6, name = "Dark2"))) +
        axis.theme(x.angle = 45, vjust = 0.5, hjust = 0.5) + ggplot2::scale_x_discrete(breaks = ticks.labels)

      diagrama_controle <- plotly::ggplotly(plot) %>%
        plotly::layout(
          hovermode = TRUE, spikedistance = -1, margin = c(4, 0, 0, 0),
          title = list(text = "<b>Diagrama Controle</b>"), titlefont = list(size = 18),
          xaxis = list(
            title = "<b>SEMANAS</b>", showspikes = TRUE, titlefont = list(size = 18),
            spikemode = "across", spikesnap = "cursor", ticks = "outside", tickangle = -45,
            showline = TRUE, tickfont = list(size = 18), fixedrange = TRUE, showgrid = TRUE
          ),
          yaxis = list(
            title = "<b>NÚMERO DE CASOS</b>", spikemode = "across", spikesnap = "cursor", zeroline = FALSE,
            titlefont = list(size = 24), fixedrange = TRUE, categoryorder = "array",
            categoryarray = ~ sort(rankcity$rank, decreasing = TRUE),
            showline = TRUE, tickfont = list(size = 24), showgrid = TRUE
          ),
          autosize = TRUE, height = 450
        ) %>%
        plotly::config(displayModeBar = FALSE)
      ggplot2::ggsave(filename = "diagramacontrole.png", plot, width = 12, height = 7)

      output$analise_serie <- plotly::renderPlotly({
        analise_plotly
      })

      diagrama_controle
    })

    invisible(NULL)
  })
}
