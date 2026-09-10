# Dicionário de dados

Este documento descreve os campos efetivamente usados pela aplicação, suas
origens e as tabelas de código→significado (SINAN). Serve de referência para
quem for dar manutenção em `R/data_loader.R`, `R/shared_data.R` ou em
qualquer módulo que consuma `df1`/`shared_data`.

## 1. Fontes de dados (`data/raw/`)

| Arquivo | Carregado por | Conteúdo | Colunas relevantes |
| --- | --- | --- | --- |
| `dbase_reduzido.csv` (em `data/processed/`, não versionado) | `load_dengue_data()` | Base individualizada de notificações (SINAN), já reduzida às colunas necessárias | ver seção 2 |
| `Casos Consolidados Notificados 2007 a 2020 BaseDBF.xlsx` | `load_casos_consolidados()` | Série histórica semanal de notificações (2007–2020), usada no Diagrama de Controle | `NU_ANO`, `SEM_PRI`, `ID_MN_RESI`, `Semana Inicio Sintomas`, `Município de Residência` |
| `Planilha IIP.xls` (aba `Plan1`) | `load_lia()` | Levantamento de Índice de Infestação (LIA/IIP) por município | `Código IBGE`→`Codigo`, `Condição`, `Método` |
| `regionais.xlsx` (aba `Planilha1`) | `load_regionais()` | De/para município → Regional/Macrorregional de Saúde | `nome`, `regional`, `macroregional`, `macroid` |
| `Coordenadas_Municipios.xls` (aba `Cidades`) | `load_coordenadas_municipios()` | Latitude/longitude por município | `GEOCODIGO_MUNICIPIO`→`Codigo`, `NOME_MUNICIPIO`, `LONGITUDE`, `LATITUDE` |
| `dados.pr.xlsx` (aba `Worksheet`) | `load_dados_pr()` | Indicadores socioeconômicos por município (IPARDES) | `Município [-]`, `Código [-]`→`Codigo`, `População estimada - pessoas [2019]`, `Área Territorial - km² [2019]` |
| `legado/` | — | Material exploratório histórico, não referenciado por nenhum código ativo | — |

A malha geográfica dos municípios (polígonos `sf`) vem do pacote
`brazilmaps` (`load_maps_cities()`), não de um arquivo local.

## 2. Base individualizada de casos (`df1`)

Campos exigidos por `load_dengue_data()` (o carregamento falha se algum
faltar): `SG_UF`, `ID_MN_RESI`, `CLASSI_FIN`, `DT_NOTIFIC`.

| Campo | Descrição | Domínio / códigos | Onde é usado |
| --- | --- | --- | --- |
| `SG_UF` | UF de notificação | `41` = Paraná (app filtra por esse valor em vários agregados) | `shared_data.R`, `comportamento_inicial` |
| `ID_MN_RESI` | Código IBGE do município de residência | 6-7 dígitos | chave de junção com `dados.maps.pr$Codigo` em todo o app |
| `DT_NOTIFIC` | Data de notificação | data | séries temporais, semana epidemiológica |
| `DT_NASC` | Data de nascimento | data | `plot.idade()` (cálculo de faixa etária) |
| `CLASSI_FIN` | Classificação final do caso | ver tabela 2.1 (app usa só `10`, `11`, `12`) | filtro principal em `shared_data.R`; `modules/relatorio` |
| `CS_SEXO` | Sexo | `F`, `M`, `I` (indefinido) | `plot.sexo()`, `plot.idade()` |
| `CS_GESTANT` | Situação gestacional | ver tabela 2.2 | `comportamento_inicial` (gráficos de gestantes) |
| `CS_ESCOL_N` | Grau de escolaridade | ver tabela 2.3 | `plot.escolaridade()` |
| `EVOLUCAO` | Evolução do caso | ver tabela 2.4 | contagem de óbitos (`Obitos`, `ibox.6`) |
| `TPAUTOCTO` | Caso autóctone (adquirido localmente) | ver tabela 2.5 | casos autóctones, incidência autóctone |
| `SEM_NOT` | Semana epidemiológica de notificação | `AAAASS` | séries temporais (Panorama, Descritivo) |
| `SEM_PRI` | Semana epidemiológica dos primeiros sintomas | `AAAASS` | Diagrama de Controle (só na base consolidada 2007–2020) |

### 2.1 `CLASSI_FIN` — Classificação final

| Código | Significado |
| --- | --- |
| 5 | Descartado |
| 10 | Dengue |
| 11 | Dengue com Sinais de Alarme (D.S.A.) |
| 12 | Dengue Grave (D.G.) |
| 13 | Chikungunya |

> A aplicação restringe a análise a `10`/`11`/`12` (`R/shared_data.R`) —
> descartados e Chikungunya ficam fora do painel atual.

### 2.2 `CS_GESTANT` — Situação gestacional (conforme usado no app)

| Código | Significado |
| --- | --- |
| 1 | 1º Trimestre |
| 2 | 2º Trimestre |
| 3 | 3º Trimestre |
| 4 | Idade Gestacional Ignorada (IGI) |
| 5 | Não |
| 6 | Não se aplica (NSA) |
| 9 | Ignorado |

Ver `modules/comportamento_inicial/server.R` (`output$descritive.gestante`).

### 2.3 `CS_ESCOL_N` — Escolaridade

| Código | Significado |
| --- | --- |
| 0 | Analfabeto |
| 1 | Fundamental I incompleto |
| 2 | Fundamental I completo |
| 3 | Fundamental II incompleto |
| 4 | Fundamental II completo |
| 5 | Médio incompleto |
| 6 | Médio completo |
| 7 | Superior incompleto |
| 8 | Superior completo |
| 9 | Ignorado |
| 10 | Não se aplica |

Ver `R/plot_helpers.R::plot.escolaridade()`.

### 2.4 `EVOLUCAO` — Evolução do caso

| Código | Significado |
| --- | --- |
| 1 | Cura |
| 2 | Óbito pelo agravo |
| 3 | Óbito por outras causas |
| 4 | Óbito em investigação |
| 9 | Ignorado |

O app conta como "Óbitos" os casos com `EVOLUCAO == 2`.

### 2.5 `TPAUTOCTO` — Autoctonia

| Código | Significado |
| --- | --- |
| 1 | Sim (caso autóctone) |
| 2 | Não |
| 3 | Indeterminado |

O app conta como "casos autóctones" os registros com `TPAUTOCTO == 1`.

### 2.6 `CS_RACA` — Raça/cor (referência SINAN, não usada no app hoje)

| Código | Significado |
| --- | --- |
| 1 | Branca |
| 2 | Preta |
| 3 | Amarela |
| 4 | Parda |
| 5 | Indígena |
| 9 | Ignorado |

### 2.7 Critério de confirmação (referência SINAN, não usada no app hoje)

| Código | Significado |
| --- | --- |
| 1 | Laboratório |
| 2 | Clínico-Epidemiológico |
| 3 | Em investigação |

## 3. Campos derivados (`dados.maps.pr`, `table_resumo`, ver `R/shared_data.R`)

| Campo | Cálculo | Descrição |
| --- | --- | --- |
| `Codigo` | `ID_MN_RESI` / `Código [-]` / `GEOCODIGO_MUNICIPIO` normalizados | chave de junção entre todas as fontes municipais |
| `macroregional`, `regional` | `regionais.xlsx` | agrupamento administrativo de saúde |
| `Casos` | contagem de `df1` por `ID_MN_RESI` (já filtrado a `CLASSI_FIN` 10/11/12) | casos confirmados por município |
| `Obitos` | contagem de `EVOLUCAO == 2` por município | óbitos por agravo |
| `DSA`, `DG` | contagem por `CLASSI_FIN == 11` / `== 12` | casos com sinais de alarme / graves |
| `incidencia` | `Casos / População estimada × 100.000` | incidência por 100 mil habitantes |
| `Casos Autóctones`, `incidencia_auto` | idem, restrito a `TPAUTOCTO == 1` | autóctones e sua incidência |
| `Casos Autóctones 4 Últimas Semanas`, `incidencia_auto_4semanas` | idem, `DT_NOTIFIC` dentro das últimas 4 semanas | usado no mapa `map_inc4.png` |
| `Condição`, `Método` | `Planilha IIP.xls` | situação do Levantamento de Índice de Infestação (LIA) por município |

Os níveis de risco em `modules/nivel_risco` classificam `incidencia` em:
**Epidemia** (`> 300`), **Alerta** (`100`–`300`), **Baixo** (`< 100`) e
**Sem Casos** (`incidencia` ausente).

## 4. Fontes de referência completas (não versionadas)

A pasta local `DengueEstatistica/` (fora do controle de versão — ver
`.gitignore`) contém o material de origem usado para montar este
dicionário, incluindo os dicionários de dados oficiais do SINAN:

- `Informacoes/DICIONARIOS _DADOS_NET---Notificao-Individual_rev CAMPOS 01 A 30.pdf`
- `Informacoes/DICIONARIOS_DADOS_ONLINE CAMPOS 31 EM DIANTE.pdf`
- `Informacoes/Ficha_DENGCHIK_FINAL.pdf` (ficha de notificação/investigação)
- `Informacoes/Instrucional_DENGUE_CHIK.pdf`
- `Informacoes/{Autoctonia,Classificação Final,Critério de Confirmação,Evolução,Raça,Meses}.xlsx`
  (tabelas de código→significado, usadas para montar as seções 2.1–2.7 acima)

Esses arquivos não fazem parte do repositório por serem material de
referência externo e volumoso; consulte-os localmente se precisar validar um
código não coberto aqui.
