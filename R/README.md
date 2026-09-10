# Código da aplicação

Camada de infraestrutura compartilhada por todos os módulos (`modules/`).
Carregada, em ordem, por `R/bootstrap.R`:

- `packages.R`: catálogo e carregamento centralizado das dependências;
- `utils.R`: funções utilitárias genéricas (remoção de acentos, paleta de
  cores por indicador, tema `ggplot2`, `kable_data()`,
  `report_output_dir()`);
- `plot_helpers.R`: gráficos reutilizados por mais de um módulo
  (`plotly.pie()`, `plot.sexo()`, `plot.idade()`, `plot.escolaridade()`);
- `data_loader.R`: leitura e validação dos dados brutos (`load_dengue_data()`,
  `load_lia()`, `load_regionais()`, `load_coordenadas_municipios()`,
  `load_dados_pr()`, `load_casos_consolidados()`, `load_maps_cities()`);
- `shared_data.R`: `build_shared_data()` monta, uma única vez por sessão, os
  datasets e agregados consumidos por mais de um módulo (base de casos,
  malha municipal enriquecida, resumos, ranking) e devolve tudo como uma
  lista (`shared_data`) passada a cada `modulo_server()`;
- `report_builder.R`: geração do relatório em PDF — funções puras, sem
  Shiny (`build_relatorio_tabelas()`, `write_relatorio_tex()`,
  `compile_relatorio_pdf()`), usadas pelo módulo `modules/relatorio`.

Depois do bootstrap, `app.R` carrega o *app shell*:

- `app_ui.R`: layout `bs4DashPage` (cabeçalho, sidebar com as 4 abas,
  controlbar com o botão de relatório, rodapé) e a composição de cada
  `tabItem` a partir das UIs dos módulos;
- `app_server.R`: função `server` de nível superior — chama
  `build_shared_data()` uma vez por sessão e inicializa o `_server()` de cada
  módulo, repassando `shared_data`.

O ponto de entrada da aplicação é o `app.R` na raiz do projeto.
