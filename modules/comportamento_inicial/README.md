# Comportamento inicial

Filtro "myfilters" (aba Descritivo) e os gráficos descritivos derivados dele:
sexo, idade, escolaridade, gestantes e a série filtrada. Migrado do bloco
`observeEvent(list(res_mod()), ...)` de `legacy/server.R`.

`comportamento_inicial_ui` é dividida em `comportamento_inicial_filtro_ui(id)`
(card "FILTRO") e `comportamento_inicial_painel_ui(id)` (card "PAINEL").

`comportamento_inicial_server(id, shared_data)` retorna `list(res_mod = ...)`
— o resultado reativo do filtro é consumido pelo módulo [[mapa_cidades]] para
atualizar a opacidade do mapa macrorregional, reproduzindo a dependência
cruzada que existia via variável global no legado.
