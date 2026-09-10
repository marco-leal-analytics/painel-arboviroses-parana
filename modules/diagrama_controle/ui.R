diagrama_controle_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::fluidRow(shiny::column(
      width = 12,
      shiny::HTML('<i class="fa fa-chart-line"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                  <b style = "padding-left:15px;color:#000000;font-size:30px;">DIAGRAMA CONTROLE </b>')
    )),
    shiny::fluidRow(
      shiny::column(
        width = 12,
        bs4Dash::bs4Card(
          title = shiny::fluidRow(
            shiny::HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
            shiny::tags$b("COMPARAÇÃO DAs SÉRIES TEMPORAIS DOS CASOS DE DENGUE - 2007 a 2020"),
            style = "font-size:24px"
          ),
          width = 12,
          closable = FALSE,
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          labelText = shiny::icon("question"),
          labelTooltip = shiny::HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
          shinycssloaders::withSpinner(plotly::plotlyOutput(ns("analise_serie")))
        ),
        espaco_html(4),
        bs4Dash::bs4Card(
          title = shiny::fluidRow(
            shiny::HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
            shiny::tags$b("DIAGRAMA CONTROLE"),
            style = "font-size:24px"
          ),
          width = 12,
          closable = FALSE,
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          labelText = shiny::icon("question"),
          labelTooltip = shiny::HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
          shinycssloaders::withSpinner(plotly::plotlyOutput(ns("plot_diagrama_controle")))
        )
      ),
      shiny::column(width = 4)
    )
  )
}
