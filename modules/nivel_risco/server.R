nivel_risco_server <- function(id, shared_data) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    dados.maps.pr <- shared_data$dados.maps.pr
    table_resumo <- shared_data$table_resumo

    output$indicadores <- shiny::renderUI({
      if (input$select.indicadores == "epidemia") {
        epi.city <- dados.maps.pr %>%
          dplyr::filter(incidencia > 300) %>%
          dplyr::select(c(nome, Codigo, `População estimada - pessoas [2019]`, regional, macroregional, Casos, DSA, DG, Obitos, incidencia))
        epi.city$geometry <- NULL

        res_mod_epi <- shiny::callModule(
          module = shinyWidgets::selectizeGroupServer,
          id = "ftable1",
          data = epi.city,
          vars = c("macroregional", "regional", "nome")
        )
        output$table_epi <- DT::renderDataTable(res_mod_epi(),
          options = list(pageLength = 10, scrollX = TRUE, searching = FALSE, autoWidth = FALSE)
        )

        shiny::fluidRow(
          shiny::fluidRow(
            shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
            shiny::tags$b(paste0("Municípios em Epidemia - ", table_resumo$Epidemia), style = "padding-left:10px;"),
            style = "font-size:24px"
          ),
          shiny::fluidRow(
            shinyWidgets::selectizeGroupUI(
              id = ns("ftable1"), inline = FALSE,
              params = list(
                macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                regional = list(inputId = "regional", title = "Regional:"),
                nome = list(inputId = "nome", title = "Cidade:")
              )
            ),
            shinycssloaders::withSpinner(DT::dataTableOutput(outputId = ns("table_epi")))
          )
        )
      } else if (input$select.indicadores == "alerta") {
        epi.city <- dados.maps.pr %>%
          dplyr::filter(incidencia >= 100 & incidencia <= 300) %>%
          dplyr::select(c(nome, Codigo, `População estimada - pessoas [2019]`, regional, macroregional, Casos, DSA, DG, Obitos, incidencia))
        epi.city$geometry <- NULL

        res_mod_alerta <- shiny::callModule(
          module = shinyWidgets::selectizeGroupServer,
          id = "ftable2",
          data = epi.city,
          vars = c("macroregional", "regional", "nome")
        )
        output$table_alerta <- DT::renderDataTable(res_mod_alerta(),
          options = list(pageLength = 10, scrollX = TRUE, searching = FALSE, autoWidth = FALSE)
        )

        shiny::fluidRow(
          shiny::fluidRow(
            shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
            shiny::tags$b(paste0("Municípios em Alerta - ", table_resumo$Alerta), style = "padding-left:10px;"),
            style = "font-size:24px"
          ),
          shiny::fluidRow(
            shinyWidgets::selectizeGroupUI(
              id = ns("ftable2"), inline = FALSE,
              params = list(
                macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                regional = list(inputId = "regional", title = "Regional:", width = 12),
                nome = list(inputId = "nome", title = "Cidade:")
              )
            ),
            shinycssloaders::withSpinner(DT::dataTableOutput(outputId = ns("table_alerta")))
          )
        )
      } else if (input$select.indicadores == "baixo") {
        epi.city <- dados.maps.pr %>%
          dplyr::filter(incidencia < 100) %>%
          dplyr::select(c(nome, Codigo, `População estimada - pessoas [2019]`, regional, macroregional, Casos, DSA, DG, Obitos, incidencia))
        epi.city$geometry <- NULL

        res_mod_baixo <- shiny::callModule(
          module = shinyWidgets::selectizeGroupServer,
          id = "ftable3",
          data = epi.city,
          vars = c("macroregional", "regional", "nome")
        )
        output$table_baixo <- DT::renderDataTable(res_mod_baixo(),
          options = list(pageLength = 10, scrollX = TRUE, searching = FALSE, autoWidth = FALSE)
        )

        shiny::fluidRow(
          shiny::fluidRow(
            shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
            shiny::tags$b(paste0("Municípios com Baixo Indice - ", table_resumo$Baixo), style = "padding-left:10px;"),
            style = "font-size:24px"
          ),
          shiny::fluidRow(
            shinyWidgets::selectizeGroupUI(
              id = ns("ftable3"), inline = FALSE,
              params = list(
                macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                regional = list(inputId = "regional", title = "Regional:", width = 12),
                nome = list(inputId = "nome", title = "Cidade:")
              )
            ),
            shinycssloaders::withSpinner(DT::dataTableOutput(outputId = ns("table_baixo")))
          )
        )
      } else if (input$select.indicadores == "na") {
        epi.city <- dados.maps.pr %>%
          dplyr::filter(is.na(incidencia)) %>%
          dplyr::select(c(nome, Codigo, `População estimada - pessoas [2019]`, regional, macroregional, Casos, Obitos, incidencia))
        epi.city$geometry <- NULL

        res_mod_scasos <- shiny::callModule(
          module = shinyWidgets::selectizeGroupServer,
          id = "ftable4",
          data = epi.city,
          vars = c("macroregional", "regional", "nome")
        )
        output$table_scasos <- DT::renderDataTable(res_mod_scasos(),
          options = list(pageLength = 10, scrollX = TRUE, searching = FALSE, autoWidth = FALSE)
        )

        shiny::fluidRow(
          shiny::fluidRow(
            shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
            shiny::tags$b(paste0("Municípios sem Casos - ", 399 - (table_resumo$Baixo + table_resumo$Alerta + table_resumo$Epidemia)), style = "padding-left:10px;"),
            style = "font-size:24px"
          ),
          shiny::fluidRow(
            shinyWidgets::selectizeGroupUI(
              id = ns("ftable4"), inline = FALSE,
              params = list(
                macroregional = list(inputId = "macroregional", title = "Macroregional:"),
                regional = list(inputId = "regional", title = "Regional:", width = 12),
                nome = list(inputId = "nome", title = "Cidade:")
              )
            ),
            shinycssloaders::withSpinner(DT::dataTableOutput(outputId = ns("table_scasos")))
          )
        )
      } else {
        shiny::fluidRow(
          shiny::fluidRow(
            shinycssloaders::withSpinner(bs4Dash::bs4InfoBoxOutput(ns("ibox.1"), width = 12)),
            shinycssloaders::withSpinner(bs4Dash::bs4InfoBoxOutput(ns("ibox.2"), width = 12)),
            shinycssloaders::withSpinner(bs4Dash::bs4InfoBoxOutput(ns("ibox.3"), width = 12)),
            shinycssloaders::withSpinner(bs4Dash::bs4InfoBoxOutput(ns("ibox.4"), width = 12)),
            shinycssloaders::withSpinner(bs4Dash::bs4InfoBoxOutput(ns("ibox.5"), width = 12)),
            shinycssloaders::withSpinner(bs4Dash::bs4InfoBoxOutput(ns("ibox.6"), width = 12))
          )
        )
      }
    })

    output$`ibox.1` <- bs4Dash::renderbs4InfoBox({
      bs4Dash::bs4InfoBox(title = "Munícipios com notificação", width = 12, status = "primary", value = table_resumo$Mun.Not, icon = "tachometer-alt")
    })
    output$`ibox.2` <- bs4Dash::renderbs4InfoBox({
      bs4Dash::bs4InfoBox(title = shiny::HTML("Munícipios com casos confirmados <br> (Dengue, D.S.A, D.G)"), width = 12, status = "info", value = table_resumo$Municipios, icon = "tachometer-alt")
    })
    output$`ibox.3` <- bs4Dash::renderbs4InfoBox({
      bs4Dash::bs4InfoBox(title = "Regionais com casos confirmados", width = 12, status = "primary", value = table_resumo$Regional, icon = "tachometer-alt")
    })
    output$`ibox.4` <- bs4Dash::renderbs4InfoBox({
      bs4Dash::bs4InfoBox(title = "Total de casos notificados", width = 12, status = "info", value = table_resumo$Total.Not, icon = "tachometer-alt")
    })
    output$`ibox.5` <- bs4Dash::renderbs4InfoBox({
      bs4Dash::bs4InfoBox(title = shiny::HTML("Total de casos Confirmados <br> (Dengue, D.S.A, D.G)"), width = 12, status = "primary", value = table_resumo$Casos, icon = "tachometer-alt")
    })
    output$`ibox.6` <- bs4Dash::renderbs4InfoBox({
      bs4Dash::bs4InfoBox(title = "Número de Óbitos", width = 12, status = "info", value = sum(dados.maps.pr$Obitos, na.rm = TRUE), icon = "tachometer-alt")
    })

    invisible(NULL)
  })
}
