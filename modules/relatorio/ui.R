# Botão que abre o modal do relatório (para embutir na controlbar do app shell).
relatorio_open_button_ui <- function(id) {
  ns <- shiny::NS(id)
  shinyWidgets::actionBttn(
    inputId = ns("open.modal"),
    label = "Relatório",
    icon = shiny::icon(name = "file-pdf"),
    block = TRUE,
    style = "material-flat"
  )
}
