plotly.pie <- function(data = data, title = "PROPORÇÃO DE CASOS POR SEXO", h = 500) {
  dblu <- "rgb(0, 0, 102)"

  plt <- data %>%
    plotly::plot_ly() %>%
    plotly::config(
      displayModeBar = TRUE,
      displaylogo = FALSE,
      modeBarButtonsToRemove = c(
        "lasso2d", "select2d", "toggleSpikelines",
        "hoverCompareCartesian", "hoverClosestCartesian", "autoScale2d"
      ),
      toImageButtonOptions = list(format = "png", filename = "pie.chart")
    ) %>%
    plotly::layout(
      margin = c(0, 0, 0, 10),
      uniformtext = list(minsize = 20, mode = "hide"),
      title = list(text = paste0("<b>", title, "</b>"), font = list(size = 24)),
      xaxis = list(
        title = "<b>SEMANAS</b>", showspikes = TRUE,
        textfont = list(family = "Times", size = c(20, 20, 20), color = c("black")),
        spikemode = "across", spikesnap = "cursor", ticks = "outside", tickangle = -45,
        showline = TRUE, tickfont = list(size = 14), fixedrange = TRUE, showgrid = TRUE
      ),
      yaxis = list(
        title = "<b>NÚMERO DE CASOS</b>",
        spikemode = "across", spikesnap = "cursor", zeroline = FALSE, titlefont = list(size = 20),
        showline = TRUE, tickfont = list(size = 24), fixedrange = TRUE, showgrid = TRUE
      ),
      height = h,
      legend = list(x = 0.03, y = 0.97, bgcolor = "rgba(240, 240, 240, 0.5)"),
      font = list(family = "Arial", size = 10),
      dragmode = FALSE,
      modebar = list(orientation = "v")
    ) %>%
    plotly::add_annotations(
      text = paste0("Atualizado em/Updated on ", "data"),
      x = 0.99, y = -0.032, xref = "paper", yref = "paper",
      font = list(family = "Arial", size = 10), align = "right", showarrow = FALSE
    ) %>%
    plotly::add_annotations(
      text = "Fonte/Source: SESA/PR",
      x = 0, y = -0.032, xref = "paper", yref = "paper",
      font = list(family = "Arial", size = 10, color = " rgba(128, 128, 128, 0.5)"),
      align = "left", showarrow = FALSE
    )

  plt %>%
    plotly::add_trace(
      labels = ~categorie, values = ~n.Freq, type = "pie", hole = 0.6,
      textposition = "outside",
      textfont = list(family = "Times", size = c(20, 20, 20), color = c("black")),
      textinfo = "label+percent",
      insidetextfont = list(color = "#FFFFFF", size = 25),
      hoverinfo = "text",
      insidetextorientation = "horizontal",
      text = ~ paste(data$n.Freq, " casos"),
      marker = list(
        colors = c("red", "black", dblu),
        line = list(color = "#FFFFFF", width = 1, size = 25)
      ),
      showlegend = FALSE
    )
}

plot.sexo <- function(df) {
  tab.sexo01 <- table(df$CS_SEXO)
  data_sexo <- data.frame(n = tab.sexo01, categorie = c("FEMININO", "INDEFINIDO", "MASCULINO"))
  plotly.pie(data = data_sexo)
}

plot.idade <- function(df) {
  nascimento <- df$DT_NASC
  notificacao <- df$DT_NOTIFIC
  idade <- as.numeric(floor((as.Date(notificacao) - as.Date(nascimento)) / 365.25))
  id <- data.frame(idade, nascimento, notificacao)

  id$clas.idade <- ifelse(id$idade < 11, "0-10",
    ifelse(id$idade < 21, "11-20",
      ifelse(id$idade < 31, "21-30",
        ifelse(id$idade < 41, "31-40",
          ifelse(id$idade < 51, "41-50",
            ifelse(id$idade < 61, "51-60",
              ifelse(id$idade < 71, "61-70",
                ifelse(id$idade < 81, "71-80", "80 ou mais")
              )
            )
          )
        )
      )
    )
  )

  d <- data.frame(prop.table(table(id$clas.idade, sexo = df$CS_SEXO)))
  d.casos <- as.data.frame(table(id$clas.idade, sexo = df$CS_SEXO))
  d$casos <- d.casos$Freq
  d <- d[d$sexo != "I", ]

  p <- ggplot2::ggplot(
    data = d,
    mapping = ggplot2::aes(
      x = Var1,
      y = ifelse(test = sexo == "F", yes = -Freq, no = Freq),
      fill = sexo,
      label = paste(round(Freq * 100, 1), "%", sep = "")
    )
  ) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::geom_text(nudge_y = ifelse(test = d$sexo == "F", yes = -0.01, no = 0.01), size = 6, colour = "#505050") +
    ggplot2::scale_y_continuous(labels = abs, limits = max(d$Freq) * c(-1, 1) * 1.1) +
    ggplot2::scale_fill_manual(values = as.vector(c("#CE1256", "#08519C"))) +
    ggplot2::coord_flip() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(size = 18),
      legend.position = "none",
      legend.text = ggplot2::element_text(size = 20),
      axis.ticks = ggplot2::element_blank()
    ) + ggplot2::ylab("") + ggplot2::xlab(" ") + axis.theme()

  plotly::ggplotly(p, height = 550) %>%
    plotly::layout(title = list(text = paste0("<b>", "CASOS POR FAIXA ETÁRIA", "</b>"), font = list(size = 24)), margin = c(0, 0, 0, 10))
}

plot.escolaridade <- function(df) {
  Escolaridade <- factor(df$CS_ESCOL_N,
    levels = c(0:10),
    labels = c(
      "Analfabeto", "Fundamental I incompleto", "Fundamental I completo",
      "Fundamental II incompleto", "Fundamental II completo",
      "Médio incompleto", "Médio completo",
      "Superior incompleto", "Superior completo", "Ignorado", "Não se aplica"
    )
  )
  esc.dt <- as.data.frame(table(Escolaridade))
  Percentuais <- esc.dt$Freq / sum(esc.dt$Freq)
  d <- data.frame(esc.dt, Percentuais, q.val = c(1:11))

  p <- ggplot2::ggplot(
    data = d,
    mapping = ggplot2::aes(
      x = Escolaridade,
      y = Percentuais,
      fill = factor(q.val),
      label = paste(round(Percentuais * 100, 0), "%", sep = "")
    )
  ) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::geom_text(hjust = .001, size = 6) +
    ggplot2::scale_fill_manual(name = " ", values = c(RColorBrewer::brewer.pal(n = 9, name = "Set1"), RColorBrewer::brewer.pal(n = 6, name = "Dark2"))) +
    ggplot2::coord_flip() + ggplot2::ylim(0, max(Percentuais) + .02) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(size = 18),
      legend.position = "none",
      legend.text = ggplot2::element_text(size = 20),
      axis.ticks = ggplot2::element_blank()
    ) + ggplot2::ylab("") + ggplot2::xlab(" ") + axis.theme()

  plotly::ggplotly(p, height = 550) %>%
    plotly::layout(title = list(text = paste0("<b>", "CASOS POR GRAU DE ESCOLARIDADE", "</b>"), font = list(size = 24)), margin = c(0, 0, 0, 10))
}
