# Dados

Organização:

- `raw/`: arquivos originais usados pelo app, sem transformação (planilhas de
  LIA/IIP, regionais, coordenadas de municípios, base de casos consolidados);
- `raw/legado/`: arquivos de exploração/versões antigas não referenciados por
  nenhum código ativo (planilhas, shapefiles e `.rds` órfãos, logos não
  utilizados). Mantidos por precaução histórica; podem ser removidos com
  segurança se ninguém precisar deles;
- `processed/`: arquivos derivados e validados, gerados a partir de `raw/`;
- `external/`: dados obtidos de fontes externas (ex.: malhas municipais via
  `geobr`/`brmap`);
- `temp/`: arquivos temporários gerados durante a execução (não versionado).

O carregamento centralizado é feito por funções em `R/data_loader.R`, e o
estado compartilhado entre módulos (datasets já processados e reutilizados por
mais de uma aba) é montado por `R/shared_data.R`.

Bases muito grandes e não utilizadas pelo app (`DengueEstatistica/`,
`painel_dengue.rar`) foram removidas do controle de versão (ver `.gitignore`)
mas permanecem no disco local.

Para o significado de cada campo (códigos SINAN de classificação final,
evolução, autoctonia, situação gestacional, escolaridade etc.) e a origem de
cada arquivo em `raw/`, ver [`docs/dicionario_dados.md`](../docs/dicionario_dados.md).
