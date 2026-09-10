relatorio_server <- function(id, shared_data, fig) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    shiny::observeEvent(input$open.modal, {
      shinyWidgets::show_alert(
        title = NULL,
        btn_labels = NA,
        showCloseButton = TRUE,
        text = shiny::fluidRow(
          shiny::column(width = 8, shinycssloaders::withSpinner(shiny::uiOutput(ns("relatorio")))),
          shiny::column(width = 4, shinyWidgets::actionBttn(inputId = ns("form_generate"), label = "Atualizar", icon = shiny::icon(name = "sync-alt"), block = TRUE, style = "fill"))
        ),
        html = TRUE,
        width = "100%"
      )
    })

    shiny::observeEvent(input$form_generate, {
      shiny::showNotification("CARREGANDO MAPAS ... ", duration = 5)
      shiny::showNotification("GERANDO GRÁFICOS ... ")

      out_dir <- report_output_dir()

      current_fig <- fig()
      if (!is.null(current_fig)) {
        rplot_path <- file.path(out_dir, "Rplot1.png")
        if (file.exists(rplot_path)) {
          file.remove(rplot_path)
        }
        ggplot2::ggsave(filename = rplot_path, plot = current_fig, width = 12, height = 7)
      }

      shiny::showNotification("GERANDO TABELAS ... ")
      tabelas <- build_relatorio_tabelas(shared_data)

      shiny::showNotification("GERANDO FORMULÁRIO ... ")
      write_relatorio_tex(out_dir, tabelas)

      shiny::showNotification("CARREGANDO ... ")
      tryCatch(
        {
          compile_relatorio_pdf(out_dir)
          shiny::addResourcePath("pdf_folder", "pdf_folder")
          shiny::showNotification("FORMULÁRIO GERADO COM SUCESSO!!!", type = "message")
          output$relatorio <- shiny::renderUI({
            shiny::tags$iframe(
              src = paste0("pdf_folder/formulario.pdf?version=", as.integer(Sys.time())),
              align = "left", width = 800, height = 600,
              style = "overflow-x:hidden;overflow-y:hidden;border-width:10px;"
            )
          })
        },
        error = function(error) {
          shiny::showNotification(paste("Erro ao gerar o relatório:", conditionMessage(error)),
            type = "error", duration = NULL
          )
          output$relatorio <- shiny::renderUI({
            shiny::tags$p("Não foi possível gerar o relatório em PDF.", class = "text-danger")
          })
        }
      )
    })

    invisible(NULL)
  })
}
