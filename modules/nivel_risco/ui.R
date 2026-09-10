nivel_risco_ui <- function(id) {
  ns <- shiny::NS(id)

  bs4Dash::bs4Card(
    title = shiny::fluidRow(
      shiny::HTML('<i class="fa fa-home" style = "color:#0072B2;font-size:25px"></i>'),
      shiny::tags$b("PRINCIPAIS INDICADORES", style = "padding-left:10px;"),
      style = "font-size:24px"
    ),
    width = 12,
    solidHeader = FALSE,
    headerBorder = FALSE,
    maximizable = FALSE,
    collapsible = FALSE,
    closable = FALSE,
    shiny::fluidRow(
      shiny::column(
        width = 4,
        shiny::div(
          style = "text-align:center",
          shinyWidgets::radioGroupButtons(
            inputId = ns("select.indicadores"),
            label = "Escolha:",
            choiceNames = c("Epidemia", "Alerta", "Baixo", "Sem Casos", "Outros"),
            choiceValues = c("epidemia", "alerta", "baixo", "na", "oindicadores")
          )
        )
      )
    ),
    espaco_html(2),
    shinycssloaders::withSpinner(shiny::uiOutput(ns("indicadores")))
  )
}
