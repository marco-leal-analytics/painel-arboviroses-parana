# Relatório

Geração do relatório em PDF: modal de abertura, botão "Atualizar"
(`form_generate`), montagem de `main.tex`/`body.tex`, compilação via
`tinytex::latexmk` e exibição do PDF resultante em `pdf_folder/formulario.pdf`.

A parte pesada (montar as tabelas de resumo, escrever o LaTeX e compilar o
PDF) é feita por funções puras em `R/report_builder.R`
(`build_relatorio_tabelas()`, `write_relatorio_tex()`,
`compile_relatorio_pdf()`), sem dependência de Shiny. `server.R` deste módulo
só cuida da orquestração reativa: notificações de progresso, salvar
`Rplot1.png`, chamar os helpers e tratar erro de compilação na UI. Todos os
artefatos gerados (mapas, gráficos, `main.tex`/`main.pdf`) ficam em
`output/relatorio/` (ver `R/utils.R::report_output_dir()`), fora da raiz do
projeto.

`relatorio_open_button_ui(id)` expõe o botão a ser embutido na
`dashboardControlbar` do app shell (`R/app_ui.R`).

`relatorio_server(id, shared_data, fig)` recebe `table_resumo`, `rankcity`,
`dados.maps.pr` e `data.range` via `shared_data`, e o gráfico da série de
casos (`fig`, um `reactiveVal`) retornado por [[panorama_geral]] para gerar
`Rplot1.png`. Também depende, como efeito colateral, de arquivos já gravados
em disco por [[mapa_cidades]] (`map_inc*.png`, `map_obt.png`, `map_lia.png`) e
[[diagrama_controle]] (`diagramacontrole.png`) — é responsabilidade do
usuário visitar essas abas antes de gerar o relatório.
