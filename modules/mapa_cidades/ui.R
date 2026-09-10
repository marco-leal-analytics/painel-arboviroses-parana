mapa_cidades_incidencia_ui <- function(id) {
  ns <- shiny::NS(id)

  sobre_incidencia <- shinyWidgets::dropdown(
    shiny::fluidRow(shiny::column(width = 12)),
    shiny::fluidRow(shiny::column(
      width = 12,
      shiny::fluidRow(shiny::HTML('<i class="fa fa-info-circle"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                                     <b style = "padding-left:0px;color:#000000;font-size:30px;">
                                                     Coeficiente de Incidência </b>')),
      shiny::withMathJax(),
      "A incidência acumulada no Estado - período de 27 de julho de 2019 a 11 de julho de 2020 é de 1.803,44 casos por
100.000 hab. (204.785/11.348.937 hab.). Considera-se situação de Epidemia quando o espaço geográfico atinge
a incidência acumulada maior de 299,99 casos/100.000 hab, em um determinado período.", shiny::withMathJax(),
      "$$ \\frac{ \\text{Número de casos confirmados}} { \\text{População Total residente}} \\times 100.000 $$"
    )),
    style = "jelly", icon = shiny::icon("question"),
    status = "primary", width = "auto",
    tooltip = shinyWidgets::tooltipOptions(title = "Veja mais sobre este gráfico!", placement = "right"),
    animate = shinyWidgets::animateOptions(
      enter = shinyWidgets::animations$fading_entrances$fadeInLeftBig, duration = 0.25,
      exit = shinyWidgets::animations$fading_exits$fadeOutLeftBig
    )
  )

  bs4Dash::bs4Card(
    title = shiny::fluidRow(
      shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
      shiny::tags$b("INCIDÊNCIAS", style = "padding-left:10px;"),
      style = "font-size:24px",
      shiny::div(sobre_incidencia, style = "padding-left:175px;")
    ),
    width = 12,
    closable = FALSE,
    maximizable = TRUE,
    collapsible = TRUE,
    collapsed = FALSE,
    labelText = shiny::icon("question"),
    labelTooltip = shiny::HTML("Classificação dos municípios segundo incidência de dengue por 100.000
                                                  habitantes – Paraná – Semana Epidemiológica. Fonte: Coordenadoria de Vigilância Ambiental /SESA"),
    shinyWidgets::radioGroupButtons(
      inputId = ns("select.mapinc"),
      label = "Escolha:",
      choiceNames = c("Incidências", "Incidências 4 Últ. Semanas", "Óbitos", "LIA"),
      choiceValues = c("inc", "inc4", "obitos", "lia"),
      status = "primary"
    ),
    shinycssloaders::withSpinner(leaflet::leafletOutput(ns("map.descritive3"), height = 680))
  )
}

mapa_cidades_macro_ui <- function(id) {
  ns <- shiny::NS(id)

  bs4Dash::bs4Card(
    title = shiny::fluidRow(
      shiny::HTML('<i class="fa fa-map-marked-alt" style = "color:#0072B2;font-size:25px"></i>'),
      shiny::tags$b("MAPA POR MACRORREGIÃO", style = "padding-left:10px;"),
      style = "font-size:24px"
    ),
    width = 12,
    closable = FALSE,
    maximizable = TRUE,
    collapsible = TRUE,
    collapsed = FALSE,
    labelText = shiny::icon("question"),
    labelTooltip = shiny::HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia. Após realizar algum filtro, as cidades que não possuirem casos confirmados, permanecerão ocultas."),
    shinycssloaders::withSpinner(leaflet::leafletOutput(ns("map.descritive"), height = 600))
  )
}
