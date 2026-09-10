# Nível de risco

Card "PRINCIPAIS INDICADORES" da aba Panorama: classificação de municípios em
Epidemia/Alerta/Baixo/Sem Casos (`output$indicadores`) e os infoboxes/tabelas
associados. Migrado de `legacy/server.R` (bloco `output$indicadores`,
`ibox.1`-`ibox.6`, `table_epi`/`table_alerta`/`table_baixo`/`table_scasos`).

`nivel_risco_server(id, shared_data)` recebe `dados.maps.pr` e `table_resumo`
via `shared_data` (ver `R/shared_data.R`) em vez de variáveis globais.
