# Diagrama controle

Aba "Diagrama Controle": análise da série histórica de casos (2007-2020) e o
diagrama de controle epidemiológico (canal endêmico). Define também
`output$analise_serie` internamente (mesmo bloco reativo).

Como efeito colateral, grava `anos_serie.png` e `diagramacontrole.png` em
`output/relatorio/` (via `R/utils.R::report_output_dir()`; `diagramacontrole.png`
é consumido pelo módulo [[relatorio]]) e `data/processed/base_full.csv` /
`data/processed/canal_endemico.csv`.
