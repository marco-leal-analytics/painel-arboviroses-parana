# Mapa de cidades

Mapas Leaflet e o *join* geográfico com `maps.cities2`/`dados.maps.pr`.
Expõe duas UIs a partir do mesmo módulo: `mapa_cidades_incidencia_ui(id)`
(card "INCIDÊNCIAS" da aba Panorama, `output$map.descritive3`) e
`mapa_cidades_macro_ui(id)` (card "MAPA POR MACRORREGIÃO" da aba Descritivo,
`output$map.descritive`). Migrado de `legacy/server.R`.

`mapa_cidades_server(id, shared_data, res_mod)` recebe o resultado reativo do
filtro `myfilters` (`res_mod`, produzido por [[comportamento_inicial]]) para
atualizar a opacidade do mapa macrorregional — a mesma dependência cruzada que
existia no legado (`observeEvent(res_mod())`), agora explícita como argumento
em vez de variável global.

Como efeito colateral, este módulo grava `map_inc.png`, `map_inc4.png`,
`map_obt.png` e `map_lia.png` em `output/relatorio/` (via
`R/utils.R::report_output_dir()`) sempre que `map.descritive3` é renderizado
— esses arquivos alimentam o módulo [[relatorio]].
