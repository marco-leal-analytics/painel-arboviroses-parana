# Relatório

Geração do relatório em PDF: modal de abertura, botão "Atualizar"
(`form_generate`), montagem de `main.tex`/`body.tex`, compilação via
`tinytex::latexmk` e exibição do PDF resultante em `pdf_folder/formulario.pdf`.
Migrado de `legacy/server.R` (`observeEvent(input$open.modal, ...)` e
`observeEvent(input$form_generate, ...)`); `legacy/script_form.R` era um
rascunho anterior da mesma lógica e não é mais a referência ativa.

`relatorio_open_button_ui(id)` expõe o botão a ser embutido na
`dashboardControlbar` do app shell (`R/app_ui.R`).

`relatorio_server(id, shared_data, fig)` recebe `table_resumo`, `rankcity`,
`dados.maps.pr` e `data.range` via `shared_data`, e o gráfico da série de
casos (`fig`, um `reactiveVal`) retornado por [[panorama_geral]] para gerar
`Rplot1.png`. Também depende, como efeito colateral, de arquivos já gravados
em disco por [[mapa_cidades]] (`map_inc*.png`, `map_obt.png`, `map_lia.png`) e
[[diagrama_controle]] (`diagramacontrole.png`) — assim como no legado, é
responsabilidade do usuário visitar essas abas antes de gerar o relatório.
