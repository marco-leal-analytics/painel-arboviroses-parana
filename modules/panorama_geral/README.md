# Panorama geral

Composição da aba "Panorama": embute [[nivel_risco]] (indicadores) e
[[mapa_cidades]] (mapa de incidência), e implementa `plot.serie.dengue`,
`plot.pie.dengues` e `plot.bar.rank10city`. Migrado de `legacy/server.R` e
`legacy/ui.R` (`tabItem(tabName = "tab1")`).

`panorama_geral_server(id, shared_data)` retorna `list(fig = <reactiveVal>)`
com o último gráfico ggplot de `plot.serie.dengue` — usado pelo módulo
[[relatorio]] para gerar `Rplot1.png`. No legado esse gráfico era guardado na
variável global `fig`, sobrescrita também pelo gráfico equivalente de
[[comportamento_inicial]]; aqui a fonte usada pelo relatório é explícita e
determinística (sempre a série da aba Panorama).
