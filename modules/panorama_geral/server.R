panorama_geral_server <- function(id, shared_data) {
  shiny::moduleServer(id, function(input, output, session) {
    fig_reactive <- shiny::reactiveVal(NULL)

    output$plot.serie.dengue <- plotly::renderPlotly({
      df.notificados.serie <- shared_data$df.notificados.serie
      don2 <- shared_data$don2
      df.notificados.serie2 <- shared_data$df.notificados.serie2

      df.notificados.serie$variable <- "Casos Notificados"
      don2$variable <- "Casos Confirmados"
      data <- as.data.frame(rbind(df.notificados.serie, don2))
      data$labels <- as.character(data$labels)
      pos.ticks <- seq(2, length(df.notificados.serie2$SEM_NOT), 2)
      ticks.labels <- unique(df.notificados.serie2$SEM_NOT)[pos.ticks]

      fig <- data %>%
        ggplot2::ggplot(ggplot2::aes(x = labels, y = values, group = variable)) +
        ggplot2::geom_line(ggplot2::aes(color = variable), size = 1.1) +
        ggplot2::scale_color_manual(values = c(RColorBrewer::brewer.pal(n = 9, name = "Set1"), RColorBrewer::brewer.pal(n = 6, name = "Dark2"))) +
        ggplot2::ggtitle(label = "Casos notificados, cofirmados e Investigados") +
        axis.theme(x.angle = 45, vjust = 0.5, hjust = 0.5) +
        ggplot2::xlab(label = "Semanas Epidemiologicas") +
        ggplot2::ylab(label = "Número de Casos") + ggplot2::scale_x_discrete(breaks = ticks.labels)
      fig_reactive(fig)

      plotly::ggplotly(p = fig) %>%
        plotly::layout(
          hovermode = TRUE, spikedistance = -1, legend = list(orientation = "h", x = 0, y = 1.2),
          xaxis = list(
            title = "<b>DATAS</b>", showspikes = TRUE, titlefont = list(size = 24),
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
    })

    output$plot.pie.dengues <- plotly::renderPlotly({
      df1 <- shared_data$df1
      resumo.dengues <- df1 %>% dplyr::summarise(
        Dengue = sum(CLASSI_FIN == 10, na.rm = TRUE),
        DSA = sum(CLASSI_FIN == 11, na.rm = TRUE),
        DG = sum(CLASSI_FIN == 12, na.rm = TRUE)
      )
      df <- stack(resumo.dengues) %>% dplyr::rename(categorie = ind, n.Freq = values)
      plotly.pie(data = df, title = "", h = 600)
    })

    output$plot.bar.rank10city <- plotly::renderPlotly({
      rankcity <- shared_data$rankcity
      fig <- plotly::plot_ly(
        y = ~ stringr::str_to_title(rankcity$`Município [-]`), x = ~ rankcity$Freq, type = "bar", orientation = "h",
        text = "", marker = list(color = c(RColorBrewer::brewer.pal(n = 9, name = "Set1"), RColorBrewer::brewer.pal(n = 6, name = "Dark2")), size = 10, opacity = 1),
        name = "Cidades"
      )
      fig %>%
        plotly::layout(
          hovermode = TRUE, spikedistance = -1, margin = c(4, 0, 0, 0),
          title = list(text = "<b>Rank das 10 Cidades com mais do que 100 casos nas últimas semanas</b>"), titlefont = list(size = 24),
          xaxis = list(
            title = "<b>NÚMERO DE CASOS</b>", showspikes = TRUE, titlefont = list(size = 24),
            spikemode = "across", spikesnap = "cursor", ticks = "outside", tickangle = -45,
            showline = TRUE, tickfont = list(size = 24), fixedrange = TRUE, showgrid = TRUE
          ),
          yaxis = list(
            title = "<b>CIDADES</b>", spikemode = "across", spikesnap = "cursor", zeroline = FALSE,
            titlefont = list(size = 24), fixedrange = TRUE, categoryorder = "array",
            categoryarray = ~ sort(rankcity$rank, decreasing = TRUE),
            showline = TRUE, tickfont = list(size = 24), showgrid = TRUE
          ),
          autosize = TRUE, height = 600
        ) %>%
        plotly::config(displayModeBar = FALSE)
    })

    list(fig = fig_reactive)
  })
}
