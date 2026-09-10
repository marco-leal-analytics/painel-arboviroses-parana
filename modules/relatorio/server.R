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
      table_resumo <- shared_data$table_resumo
      rankcity <- shared_data$rankcity
      dados.maps.pr <- shared_data$dados.maps.pr
      data.range <- shared_data$data.range

      shiny::showNotification("CARREGANDO MAPAS ... ", duration = 5)
      shiny::showNotification("GERANDO GRÁFICOS ... ")

      out_dir <- report_output_dir()
      project_root <- normalizePath(getwd(), winslash = "/")

      current_fig <- fig()
      if (!is.null(current_fig)) {
        rplot_path <- file.path(out_dir, "Rplot1.png")
        if (file.exists(rplot_path)) {
          file.remove(rplot_path)
        }
        ggplot2::ggsave(filename = rplot_path, plot = current_fig, width = 12, height = 7)
      }

      shiny::showNotification("GERANDO TABELAS ... ")

      r.names <- c(
        "Municipios com Notificacao",
        "Municipios com casos confirmados (Dengue, D.S.A, D.G)",
        "Municipios Autoctones",
        "Regionais com casos confirmados",
        "Total de Casos Notificados",
        "Total de Casos Confirmados (Dengue, D.S.A, D.G)",
        "Dengue Sinais de Alarme",
        "Dengue Grave",
        "Total de Casos Autoctones",
        "Municipios em Epidemia",
        "Municipios em Alerta",
        "Municipios com indice baixo",
        "Municipios sem casos",
        "Número de Obitos"
      )

      table.df <- data.frame(
        resumo = c(
          table_resumo$Mun.Not,
          table_resumo$Municipios,
          table_resumo$Mun.Auto,
          table_resumo$Regional,
          table_resumo$Total.Not,
          table_resumo$Casos,
          table_resumo$DSA,
          table_resumo$DG,
          table_resumo$Total.Auto,
          table_resumo$Epidemia,
          table_resumo$Alerta,
          table_resumo$Baixo,
          399 - sum(table_resumo$Epidemia, table_resumo$Alerta, table_resumo$Baixo),
          sum(dados.maps.pr$Obitos, na.rm = TRUE)
        ),
        row.names = r.names
      )
      colnames(table.df) <- c(paste("Periodo ", data.range[1], " a ", data.range[2]))

      teste <- dados.maps.pr %>%
        dplyr::group_by(regional) %>%
        dplyr::filter(!is.na(regional)) %>%
        dplyr::summarise(
          Macro = unique(macroregional),
          `Regionais de Saude` = unique(regional),
          Populacao = sum(`População estimada - pessoas [2019]`, na.rm = TRUE),
          Casos = sum(Casos, na.rm = TRUE),
          DSA = sum(DSA, na.rm = TRUE),
          DG = sum(DG, na.rm = TRUE),
          Obitos = sum(Obitos, na.rm = TRUE),
          Incidencia = (sum(Casos, na.rm = TRUE) / sum(`População estimada - pessoas [2019]`, na.rm = TRUE)) * 100000
        )
      teste$geometry <- NULL

      table.rank <- rankcity[, c(6, 5, 4, 2)]
      colnames(table.rank) <- c("Macrorregional", "Regional de Saude", "Municipio", "Casos")
      table.rank$Municipio <- stringr::str_to_title(table.rank$Municipio)

      shiny::showNotification("GERANDO FORMULÁRIO ... ")
      fileName <- file.path(out_dir, "main.tex")
      if (file.exists(fileName)) {
        unlink(fileName)
      }
      name_body <- file.path(out_dir, "body.tex")
      sink(fileName, append = FALSE)

      cat("\\documentclass[10pt,a4paper]{article} \n")
      cat("\\usepackage[utf8]{inputenc}\n")
      cat("\\usepackage[T1]{fontenc}\n")
      cat("\\usepackage{amsmath}\n")
      cat("\\usepackage{amsfonts}\n")
      cat("\\usepackage{amssymb}\n")
      cat("\\usepackage{booktabs }\n")
      cat("\\usepackage{graphicx}\n")
      cat(paste0("\\graphicspath{{", project_root, "/}{", normalizePath(out_dir, winslash = "/"), "/}}\n"))
      cat("\\usepackage[left=1cm,right=1cm,top=3cm,bottom=1cm]{geometry}\n")
      cat("\\usepackage{caption} \n \\usepackage{subcaption}\n")
      cat("\\usepackage{multicol}\n")
      cat("\\usepackage{tikz}\n")
      cat("\\usetikzlibrary{calc,positioning,arrows,shapes,shadows,fit,patterns,quotes,spy} \n \\usepackage{lipsum}\n")
      cat("\\usepackage{fancyhdr}\n")
      cat("\\pagestyle{fancy}\n")
      cat("\\usepackage{eso-pic,transparent}\n \\usepackage{tikz}\n")
      cat("\\chead{\\includegraphics[width=\\headwidth]{www/header_informe_dateless.png}} \n\n")
      cat("\\usepackage[onehalfspacing]{setspace}\n")
      cat("\\setlength{\\parindent}{2em}\n")
      cat("\\setlength{\\parskip}{1.0em}\n")
      cat("\\geometry{a4paper,includehead,top=0cm,left=1cm}\n")
      cat("\\fancyheadoffset{0.005\\textwidth}")
      cat("\\setlength\\headheight{3cm}\n")
      cat("\\setlength\\headwidth{\\paperwidth}\n")
      cat("\\begin{document}\n\n")
      cat("\\input{body} \n\n")
      cat("\\end{document}")

      sink()

      if (file.exists(name_body)) {
        unlink(name_body)
      }

      inc <- format((table.df[9, 1] / 11433957) * 100000, scientific = FALSE)
      sink(name_body, append = FALSE)

      cat("\\clearpage \n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/h1.png} \n\n ")
      cat("  \n \\includegraphics[width=\\textwidth ]{www/h2_resumo.png} \n \\end{center} \n ")

      cat(
        "\\vspace{-1.5cm} \n  \\begin{flushleft} \n
              \\begin{tabular}{ c c c c c c }\n",
        " \\hspace{0.5cm} {\\Large ", table.df[5, 1], "} & ", "\\hspace{1.0cm} {\\Large ", table.df[6, 1], "} & ", "\\hspace{1.0cm} {\\Large ", table.df[9, 1], "} & ", "\\hspace{1.0cm} {\\Large ", inc, "} & ", "\\hspace{1.1cm} {\\Large ", table.df[1, 1], "} & ", "\\hspace{1.8cm} {\\Large ", table.df[14, 1], "} \\\\ \n",
        " \\end{tabular}\n
                 \\end{flushleft}\n"
      )

      cat(kable_data(data = table.df, cap = paste0("Resumo de informacoes dos casos de Dengue, Dengue com Sinais de Alarme (D.S.A) e Dengue Grave (D.G) referente ao periodo de ", data.range[1], " a ", data.range[2])))

      cat("\\clearpage \n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/h2.png} \n\n \\end{center} \n\n")
      cat("Definicao: Descreve de forma resumida a distribuicao de frequencias da doenca para o periodo de um ano, baseado no
         comportamento observado da doenca durante varios anos previos (dez anos, excluindo-se os anos epidemico) e em sequencia,
         em determinada populacao. Auxilia na determinacao de situacoes de alerta epidemico e previsao de epidemias, atraves da
         sobreposicao da curva epidemica do periodo de interesse (frequencia observada do ano atual) ao canal endemico (frequencia esperada). \n ")
      cat("  \n \\includegraphics[width=16cm]{diagramacontrole.png} \n  \n ")

      cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h3.png}  \n\n")
      cat(" \n \\includegraphics[width=16cm ]{Rplot1.png} \n\n")

      cat("\\clearpage \n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/h4.png}  \n\n")
      cat("(N de casos autoctones/100.000habitantes. Parana). \\end{center} \n\n\n")

      cat("\\begin{figure}[h] \n
         \\begin{minipage}[b]{0.5\\textwidth} \n
         \\includegraphics[width=\\textwidth]{map_inc.png} \n
         \\caption{Incidencias para casos autoctonos por 100.000 habitantes} \n
         \\label{fig:1} \n
         \\end{minipage}
         \\hfill
         \\begin{minipage}[b]{0.5\\textwidth} \n
         \\includegraphics[width=\\textwidth]{map_inc4.png} \n
         \\caption{Incidencias para casos autoctonos por 100.000 habitantes das ultimas 4 semanas.} \n
         \\label{fig:2} \n
         \\end{minipage} \n
         \\end{figure} \n")

      cat("\\begin{figure}[h] \n
         \\begin{minipage}[b]{0.5\\textwidth} \n
         \\includegraphics[width=\\textwidth]{map_obt.png} \n
         \\caption{Cidades com Obitos para o Estado do Parana.} \n
         \\label{fig:1} \n
         \\end{minipage}
         \\hfill
         \\begin{minipage}[b]{0.5\\textwidth} \n
         \\includegraphics[width=\\textwidth]{map_lia.png} \n
         \\caption{LIA} \n
         \\label{fig:2} \n
         \\end{minipage} \n
         \\end{figure} \n")

      cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h5.png}  \n\n")
      cat(kable_data(data = table.rank, cap = paste0("Municipios com maior numero de casos das 12 ultimas semanas (> 100)")))

      cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h6.png}  \n\n ")
      cat(kable_data(data = teste, cap = paste0("Resumo dos casos por Regional de Saude")))

      cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h7.png}  \n\n ")
      cat(" \n \\includegraphics[width=16cm ]{www/risco_climatico.png} \n\n")

      cat("\\clearpage \n\n \\includegraphics[width=\\textwidth ]{www/h8.png}  \n\n ")
      cat("O quadro abaixo apresenta a série histórica do sorotipo viral de dengue desde o ano de 1991. Observa-se uma predominância do sorotipo DEVN1 até 2018, e do sorotipo DENV2 a partir de 2019.
         De janeiro a 11 de julho de 2020 foram processadas 11.594 amostras para vigilância epidemiológica da circulação viral dos 4 sorotipos. Em 79,7 % das amostras positivas para dengue foi encontrado o sorotipo DENV2.\n\n")

      cat("  \n \\includegraphics[width=16cm ]{www/quadro_laboratorial.png} \n\n")
      cat("  \n \\includegraphics[width=16cm ]{www/mapa_laboratorial.png} \n\n")

      cat("\\clearpage \n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/header_zika.png} \n\n ")
      cat("  \n \\includegraphics[width=\\textwidth ]{www/h2_resumo.png} \n \\end{center} \n ")

      cat(
        "\\vspace{-1.5cm} \n  \\begin{flushleft} \n
              \\begin{tabular}{ c c c c c c }\n",
        " \\hspace{0.5cm} {\\Large ", table.df[5, 1], "} & ", "\\hspace{1.0cm} {\\Large ", table.df[6, 1], "} & ", "\\hspace{1.0cm} {\\Large ", table.df[9, 1], "} & ", "\\hspace{1.0cm} {\\Large ", inc, "} & ", "\\hspace{1.1cm} {\\Large ", table.df[1, 1], "} & ", "\\hspace{1.8cm} {\\Large ", table.df[14, 1], "} \\\\ \n",
        " \\end{tabular}\n
                 \\end{flushleft}\n"
      )

      cat("\n\n  \\begin{center} \n \\includegraphics[width=\\textwidth ]{www/header_chikungunya.png} \n\n ")
      cat("  \n \\includegraphics[width=\\textwidth ]{www/h2_resumo.png} \n \\end{center} \n ")

      cat(
        "\\vspace{-1.5cm} \n  \\begin{flushleft} \n
              \\begin{tabular}{ c c c c c c }\n",
        " \\hspace{0.5cm} {\\Large ", table.df[5, 1], "} & ", "\\hspace{1.0cm} {\\Large ", table.df[6, 1], "} & ", "\\hspace{1.0cm} {\\Large ", table.df[9, 1], "} & ", "\\hspace{1.0cm} {\\Large ", inc, "} & ", "\\hspace{1.1cm} {\\Large ", table.df[1, 1], "} & ", "\\hspace{1.8cm} {\\Large ", table.df[14, 1], "} \\\\ \n",
        " \\end{tabular}\n
                 \\end{flushleft}\n"
      )

      sink()

      shiny::showNotification("CARREGANDO ... ")
      tryCatch(
        {
          old_wd <- setwd(out_dir)
          on.exit(setwd(old_wd), add = TRUE)
          tinytex::latexmk("main.tex", clean = TRUE)
          setwd(old_wd)
          pdf_folder <- "pdf_folder"
          if (!dir.exists(pdf_folder)) {
            dir.create(pdf_folder, recursive = TRUE)
          }
          temp <- file.path(pdf_folder, "formulario.pdf")
          main_pdf <- file.path(out_dir, "main.pdf")
          if (!file.exists(main_pdf)) {
            stop("A compilação não gerou main.pdf.")
          }
          if (file.exists(temp)) {
            unlink(temp)
          }
          if (!file.copy(main_pdf, temp, overwrite = TRUE)) {
            stop("Não foi possível copiar o PDF para a pasta pública.")
          }
          shiny::addResourcePath("pdf_folder", pdf_folder)
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
