# Diagrama controle

Aba "Diagrama Controle": análise da série histórica de casos (2007-2020) e o
diagrama de controle epidemiológico (canal endêmico). Módulo novo — a aba
existia em `legacy/ui.R` (`tabItem(tabName = "tab3")`) mas não tinha um
módulo dedicado no mapeamento original.

Migrado do bloco `output$plot_diagrama_controle` de `legacy/server.R`
(que também definia `output$analise_serie` internamente — mantido assim por
fidelidade). Como efeito colateral, grava `anos_serie.png` e
`diagramacontrole.png` na raiz do projeto (consumidos pelo módulo
[[relatorio]]) e `data/processed/base_full.csv` /
`data/processed/canal_endemico.csv`.
