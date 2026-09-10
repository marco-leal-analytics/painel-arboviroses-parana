comportamento_inicial_filtro_ui <- function(id) {
  ns <- shiny::NS(id)

  bs4Dash::bs4Card(
    title = shiny::fluidRow(
      shiny::HTML('<i class="fa fa-map-marked-alt" style = "color:#0072B2;font-size:25px"></i>'),
      shiny::tags$b("FILTRO", style = "padding-left:10px;"),
      style = "font-size:24px"
    ),
    width = 12,
    closable = FALSE,
    maximizable = TRUE,
    collapsible = TRUE,
    collapsed = FALSE,
    labelText = shiny::icon("question"),
    labelTooltip = shiny::HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
    shiny::fluidRow(
      shinyWidgets::selectizeGroupUI(
        id = ns("myfilters"), inline = FALSE,
        params = list(
          macroregional = list(inputId = "macroregional", title = "Macroregional:"),
          regional = list(inputId = "regional", title = "Regional:", width = 12),
          nome.x = list(inputId = "nome", title = "Cidade:")
        )
      )
    )
  )
}

comportamento_inicial_painel_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shinyjs::useShinyjs(),
    bs4Dash::bs4Card(
      title = shiny::fluidRow(
        shiny::HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
        shiny::tags$b("PAINEL"),
        style = "font-size:24px"
      ),
      width = 12,
      closable = FALSE,
      maximizable = TRUE,
      collapsible = TRUE,
      collapsed = FALSE,
      labelText = shiny::icon("question"),
      labelTooltip = shiny::HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
      shinycssloaders::withSpinner(plotly::plotlyOutput(ns("descritive.sexo"), height = 550)),
      shinycssloaders::withSpinner(plotly::plotlyOutput(ns("descritive.idade"), height = 550)),
      shinycssloaders::withSpinner(plotly::plotlyOutput(ns("descritive.escolaridade"), height = 550)),
      bs4Dash::bs4Card(
        title = shiny::fluidRow(
          shiny::HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
          shiny::tags$b("CASOS NÃO GESTANTES"),
          style = "font-size:24px"
        ),
        width = 12,
        closable = FALSE,
        maximizable = TRUE,
        collapsible = TRUE,
        collapsed = FALSE,
        labelText = shiny::icon("question"),
        labelTooltip = shiny::HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
        espaco_html(4),
        shinycssloaders::withSpinner(plotly::plotlyOutput(ns("descritive.gestante"), height = 700))
      ),
      bs4Dash::bs4Card(
        title = shiny::fluidRow(
          shiny::HTML('<i class="fa fa-th-largestyle = "color:#0072B2;font-size:25px"></i>'),
          shiny::tags$b("CASOS GESTANTES"),
          style = "font-size:24px"
        ),
        width = 12,
        closable = FALSE,
        maximizable = TRUE,
        collapsible = TRUE,
        collapsed = FALSE,
        labelText = shiny::icon("question"),
        labelTooltip = shiny::HTML("Clieque no icone '+' para ver mais informações. Clique no icone [ ] para ampliar para tela cheia."),
        espaco_html(4),
        shinycssloaders::withSpinner(plotly::plotlyOutput(ns("descritive.gestante2"), height = 600))
      ),
      shiny::fluidRow(
        bsplus::bs_embed_tooltip(
          shinyWidgets::prettySwitch(
            inputId = ns("switch.serie"),
            label = shiny::strong(shiny::textOutput(ns("Habilitar Série com Barras"))), width = 30,
            fill = TRUE, status = "primary"
          ),
          placement = "left", title = "Habilitar Barchart"
        ),
        style = "padding-left:50px;paddint-top:10px;"
      ),
      shinycssloaders::withSpinner(plotly::plotlyOutput(ns("plot.serie"), height = 550))
    )
  )
}
