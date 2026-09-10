panorama_geral_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::fluidRow(
      shiny::column(
        width = 12,
        shiny::HTML('<i class="fa fa-home"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                       <b style = "padding-left:15px;color:#000000;font-size:30px;">PANORAMA GERAL - DASHBOARD ARBOVIROSES </b>')
      )
    ),
    nivel_risco_ui("nivel_risco"),
    mapa_cidades_incidencia_ui("mapa_cidades"),
    bs4Dash::bs4Card(
      title = shiny::fluidRow(
        shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
        shiny::tags$b("CASOS DENGUE, D.S.A E D.G", style = "padding-left:10px;"),
        style = "font-size:24px"
      ),
      width = 12, solidHeader = FALSE, headerBorder = FALSE, maximizable = TRUE, collapsible = FALSE, closable = FALSE,
      shiny::tags$style(type = "text/css", "#plot.serie.dengue {height: calc(100vh - 80px) !important;}"),
      shinycssloaders::withSpinner(plotly::plotlyOutput(outputId = ns("plot.serie.dengue"), height = 600))
    ),
    bs4Dash::bs4Card(
      title = shiny::fluidRow(
        shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
        shiny::tags$b("PROPORÇÃO DE CASOS DENGUE, D.S.A E D.G", style = "padding-left:10px;"),
        style = "font-size:24px"
      ),
      width = 12, solidHeader = FALSE, headerBorder = FALSE, maximizable = TRUE, collapsible = FALSE, closable = FALSE,
      shinycssloaders::withSpinner(plotly::plotlyOutput(outputId = ns("plot.pie.dengues"), height = 600))
    ),
    bs4Dash::bs4Card(
      title = shiny::fluidRow(
        shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
        shiny::tags$b("RANK CIDADES", style = "padding-left:10px;"),
        style = "font-size:24px"
      ),
      width = 12, solidHeader = FALSE, headerBorder = FALSE, maximizable = TRUE, collapsible = FALSE, closable = FALSE,
      shinycssloaders::withSpinner(plotly::plotlyOutput(outputId = ns("plot.bar.rank10city"), height = 600))
    )
  )
}
