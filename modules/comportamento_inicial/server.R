comportamento_inicial_server <- function(id, shared_data) {
  shiny::moduleServer(id, function(input, output, session) {
    df1 <- shared_data$df1
    don2 <- shared_data$don2
    dados_descritive <- shared_data$dados.maps.pr %>% dplyr::filter(!is.na(Casos))

    res_mod <- shiny::callModule(
      module = shinyWidgets::selectizeGroupServer,
      id = "myfilters",
      data = dados_descritive,
      vars = c("macroregional", "regional", "nome")
    )

    shiny::observeEvent(list(res_mod()), {
      pos <- which(df1$ID_MN_RESI %in% res_mod()$Codigo)
      df <- df1[c(as.numeric(pos)), ]

      output$descritive.sexo <- plotly::renderPlotly({
        plot.sexo(df)
      })
      output$descritive.idade <- plotly::renderPlotly({
        plot.idade(df)
      })
      output$descritive.escolaridade <- plotly::renderPlotly({
        plot.escolaridade(df)
      })

      output$descritive.gestante <- plotly::renderPlotly({
        tab.gestante <- df %>%
          dplyr::filter(SG_UF == 41) %>%
          dplyr::group_by(CS_GESTANT) %>%
          dplyr::summarise(Freq = dplyr::n()) %>%
          dplyr::filter(!is.na(CS_GESTANT))

        Gestante <- ifelse(tab.gestante$CS_GESTANT == 1, "1º Trimeste",
          ifelse(tab.gestante$CS_GESTANT == 2, "2º Trimeste",
            ifelse(tab.gestante$CS_GESTANT == 3, "3º Trimeste",
              ifelse(tab.gestante$CS_GESTANT == 4, "Idade Gestacional Ignorada",
                ifelse(tab.gestante$CS_GESTANT == 5, "Não",
                  ifelse(tab.gestante$CS_GESTANT == 6, "NSA",
                    ifelse(tab.gestante$CS_GESTANT == 9, "Ignorado", "")
                  )
                )
              )
            )
          )
        )
        tab.gestante$CS_GESTANT <- Gestante
        tab.gestante <- tab.gestante %>% dplyr::rename(n.Freq = Freq, categorie = CS_GESTANT)

        plotly.pie(data = tab.gestante, title = "Proporção de Gestantes e Não Gestantes", h = 600)
      })

      output$descritive.gestante2 <- plotly::renderPlotly({
        tab.gestante <- df %>%
          dplyr::filter(SG_UF == 41) %>%
          dplyr::group_by(CS_GESTANT) %>%
          dplyr::filter(CS_GESTANT == 1 | CS_GESTANT == 2 | CS_GESTANT == 3 | CS_GESTANT == 4) %>%
          dplyr::summarise(Freq = dplyr::n()) %>%
          dplyr::filter(!is.na(CS_GESTANT))

        Gestante <- ifelse(tab.gestante$CS_GESTANT == 1, "1º Trimeste",
          ifelse(tab.gestante$CS_GESTANT == 2, "2º Trimeste",
            ifelse(tab.gestante$CS_GESTANT == 3, "3º Trimeste",
              ifelse(tab.gestante$CS_GESTANT == 4, "IGI", "")
            )
          )
        )
        tab.gestante$CS_GESTANT <- Gestante
        tab.gestante <- tab.gestante %>% dplyr::rename(n.Freq = Freq, categorie = CS_GESTANT)

        fig <- plotly::plot_ly(
          y = ~ tab.gestante$n.Freq, x = ~ tab.gestante$categorie, type = "bar", orientation = "v",
          text = "", marker = list(color = c(RColorBrewer::brewer.pal(n = 9, name = "Set1"), RColorBrewer::brewer.pal(n = 6, name = "Dark2")), size = 10, opacity = 1),
          name = "Cidades"
        )
        fig %>%
          plotly::layout(
            hovermode = TRUE, spikedistance = -1, margin = c(0, 0, 0, 10),
            xaxis = list(
              title = "<b>NÚMERO DE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
              spikemode = "across", spikesnap = "cursor", ticks = "outside", tickangle = -45,
              showline = TRUE, tickfont = list(size = 24), fixedrange = TRUE, showgrid = TRUE
            ),
            yaxis = list(
              title = "<b>CIDADES</b>", spikemode = "across", spikesnap = "cursor", zeroline = FALSE,
              titlefont = list(size = 24), showline = TRUE, tickfont = list(size = 24), fixedrange = TRUE, showgrid = TRUE
            ),
            autosize = TRUE, height = 600
          ) %>%
          plotly::config(displayModeBar = FALSE)
      })

      output$plot.serie <- plotly::renderPlotly({
        df01 <- df %>%
          dplyr::mutate(
            date = format(as.Date(DT_NOTIFIC), format = "%Y-%U", digits = 1),
            date2 = cut.Date(as.Date(DT_NOTIFIC), breaks = "1 week", labels = FALSE)
          ) %>%
          dplyr::group_by(SEM_NOT) %>%
          dplyr::summarise(frequencia = dplyr::n())
        df01 <- data.frame(label = df01$SEM_NOT, values = df01$frequencia)

        don <- data.frame(labels = df01$label, values = df01$values, row.names = df01$label)
        don$variable <- "Casos Parciais"

        if (!isTRUE(input$switch.serie)) {
          don2$variable <- "Casos Confirmados"
          data <- as.data.frame(rbind(don, don2))
          data$labels <- as.character(data$labels)
          pos.ticks <- seq(2, length(shared_data$df.notificados.serie2$SEM_NOT), 2)
          ticks.labels <- unique(shared_data$df.notificados.serie2$SEM_NOT)[pos.ticks]

          fig <- data %>%
            ggplot2::ggplot(ggplot2::aes(x = labels, y = values, group = variable)) +
            ggplot2::geom_line(ggplot2::aes(color = variable), size = 1.1) +
            ggplot2::scale_color_manual(values = c(RColorBrewer::brewer.pal(n = 9, name = "Set1"), RColorBrewer::brewer.pal(n = 6, name = "Dark2"))) +
            ggplot2::ggtitle(label = "Casos notificados, cofirmados e Investigados") +
            axis.theme(x.angle = 45, vjust = 0.5, hjust = 0.5) +
            ggplot2::xlab(label = "Semanas Epidemiologicas") +
            ggplot2::ylab(label = "Número de Casos") + ggplot2::scale_x_discrete(breaks = ticks.labels)

          plotly::ggplotly(p = fig) %>%
            plotly::layout(
              hovermode = TRUE, spikedistance = -1, legend = list(orientation = "h", x = 0, y = 1.2),
              xaxis = list(
                title = "<b>SEMANAS</b>", showspikes = TRUE, titlefont = list(size = 24),
                spikemode = "across", spikesnap = "cursor", ticks = "outside", tickangle = -45,
                showline = TRUE, tickfont = list(size = 24), fixedrange = TRUE, showgrid = TRUE
              ),
              yaxis = list(
                title = "<b>NÚMERO DE CASOS</b>", spikemode = "across", spikesnap = "cursor", zeroline = FALSE,
                titlefont = list(size = 24), fixedrange = TRUE, showline = TRUE, tickfont = list(size = 24), showgrid = TRUE
              ),
              height = 600
            ) %>%
            plotly::config(displayModeBar = TRUE)
        }
      })
    })

    list(res_mod = res_mod)
  })
}
