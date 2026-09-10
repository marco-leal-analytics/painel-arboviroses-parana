# Módulos Shiny

Cada módulo tem um diretório próprio contendo:

```text
modulo/
├── ui.R
└── server.R
```

O arquivo `ui.R` expõe `modulo_ui(id)` (ou variações, quando o módulo tem mais
de um ponto de entrada de UI) e o arquivo `server.R` expõe `modulo_server(id, ...)`,
usando `NS(id)` e `moduleServer()`.

| Módulo | Responsabilidade | Migrado de |
| --- | --- | --- |
| `nivel_risco` | Indicadores de Epidemia/Alerta/Baixo/Sem Casos (aba Panorama) | `legacy/server.R` (`output$indicadores`, `ibox.*`, `table_*`) |
| `mapa_cidades` | Mapas Leaflet (incidência e macrorregião) | `legacy/server.R` (`map.descritive`, `map.descritive3`) |
| `comportamento_inicial` | Filtro `myfilters` e gráficos descritivos (sexo, idade, escolaridade, gestantes, série filtrada) | `legacy/server.R` (`observeEvent(res_mod())`) |
| `panorama_geral` | Composição da aba Panorama e séries/rank agregados | `legacy/server.R` + `legacy/ui.R` (`tabItem "tab1"`) |
| `diagrama_controle` | Análise de série histórica e canal endêmico (aba Diagrama Controle) | `legacy/server.R` (`output$plot_diagrama_controle`) |
| `relatorio` | Geração do relatório em PDF | `legacy/server.R` (`observeEvent(input$open.modal/form_generate)`) |
| `sobre` | Conteúdo institucional estático | `legacy/ui.R` (`tabItem "tab4"`) |

Dados e agregados usados por mais de um módulo (`df1`, `dados.maps.pr`,
`table_resumo`, `rankcity`, etc.) são montados uma única vez por
`R/shared_data.R::build_shared_data()` e passados como argumento `shared_data`
para os módulos — não há mais variáveis globais (`<<-`) entre módulos.

A implementação original permanece em `legacy/` como referência histórica até
a validação completa da versão modular.
