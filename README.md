# Painel de Arboviroses do Paraná

Aplicação [Shiny](https://shiny.posit.co/) para monitoramento epidemiológico
de arboviroses (dengue, dengue com sinais de alarme, dengue grave) no estado
do Paraná, a partir de dados de notificação do SINAN.

## Objetivo

Arboviroses como dengue, zika e chikungunya têm dinâmica sazonal e
territorial: o risco varia por município e por semana epidemiológica, e a
resposta (mobilização de equipes, comunicação, alocação de recursos de
combate ao vetor) precisa acompanhar essa variação. Na ponta, esse
acompanhamento costuma depender de planilhas e relatórios manuais,
produzidos sob pressão de tempo durante os picos de transmissão.

O objetivo deste painel é dar a gestores e equipes de vigilância
epidemiológica uma visão única, atualizável e navegável da situação
epidemiológica no estado — por município, por regional de saúde e ao longo
do tempo — sem depender de manipulação manual de planilha a cada atualização
da base.

## Solução

O painel consome a base de notificações individualizadas (SINAN) já
tratada e a cruza com três camadas de dados municipais (regionais de saúde,
população/território do IPARDES e a malha geográfica do IBGE via
`brazilmaps`) para produzir, em tempo real:

- **Panorama geral** — indicadores-chave (municípios notificantes, casos
  confirmados, óbitos), série temporal de notificados vs. confirmados,
  proporção por classificação final e ranking de municípios mais afetados.
- **Descritivo** — mapa interativo por macrorregião e o perfil
  sociodemográfico dos casos (sexo, faixa etária, escolaridade, gestantes),
  filtrável por macrorregional/regional/município.
- **Classificação de risco por incidência** — municípios agrupados em
  Epidemia (incidência > 300/100mil), Alerta (100–300), Baixo (< 100) e Sem
  Casos, cada faixa com tabela filtrável própria.
- **Diagrama de controle** — comparação da série do ano corrente contra o
  canal endêmico (média móvel histórica ± 1,96 desvio-padrão), o método
  clássico de vigilância para identificar quando a transmissão foge do
  padrão esperado.
- **Relatório em PDF sob demanda** — compila automaticamente, em LaTeX, um
  informe com os mapas, gráficos e tabelas do momento, pronto para
  distribuição.

Toda a preparação de dados (join geográfico, cálculo de incidência,
classificação de risco, agregados) roda uma única vez por sessão
(`R/shared_data.R`) e é compartilhada entre as abas — não há recomputação
redundante nem estado global entre módulos.

## Impacto

- **Redução do tempo de resposta**: o que antes exigia atualizar planilhas e
  montar um relatório manualmente passa a ser uma atualização de dados +
  clique no botão "Relatório".
- **Priorização territorial objetiva**: a classificação por faixa de
  incidência (Epidemia/Alerta/Baixo/Sem Casos) dá um critério padronizado
  para decidir onde concentrar ações de campo, em vez de depender de
  percepção qualitativa.
- **Detecção precoce de anomalias**: o diagrama de controle (canal endêmico)
  sinaliza visualmente quando a curva do ano foge do intervalo esperado,
  permitindo reação antes do pico.
- **Auditabilidade**: como o relatório em PDF é gerado a partir dos mesmos
  dados exibidos no painel, gestores podem comparar decisões passadas com o
  estado dos dados no momento em que foram tomadas.

## Estrutura do repositório

```text
app.R                        # ponto de entrada único (shiny::shinyApp)
painel_dengue.Rproj          # projeto RStudio

R/                           # bootstrap, dependências, dados compartilhados, app shell (ui/server)
├── bootstrap.R              # ativa renv e carrega, em ordem, todo o resto de R/ + modules/
├── packages.R               # catálogo centralizado de library()
├── utils.R                  # utilitários genéricos (cores, tema ggplot2, kable_data, report_output_dir)
├── plot_helpers.R           # gráficos reutilizados por mais de um módulo (pizza, sexo, idade, escolaridade)
├── data_loader.R            # leitura/validação de cada fonte em data/raw|processed
├── shared_data.R            # build_shared_data(): agregados montados 1x por sessão
├── report_builder.R         # geração do relatório em PDF (LaTeX), sem dependência de Shiny
├── app_ui.R                 # layout bs4Dash (sidebar com as 4 abas, controlbar, rodapé)
└── app_server.R             # server de nível superior — inicializa cada módulo

modules/                     # módulos Shiny (ui.R + server.R), um por funcionalidade — ver seção abaixo
├── panorama_geral/          # aba "Panorama"
├── nivel_risco/             # indicadores + tabelas por faixa de risco (embutido em panorama_geral)
├── mapa_cidades/            # mapas Leaflet (2 pontos de entrada: Panorama e Descritivo)
├── comportamento_inicial/   # aba "Descritivo": filtro + perfil sociodemográfico dos casos
├── diagrama_controle/       # aba "Diagrama Controle": canal endêmico
├── relatorio/                # orquestração do relatório em PDF (botão na controlbar)
├── sobre/                    # aba "Sobre": conteúdo institucional estático
└── _template/                 # esqueleto para criar um módulo novo (não carregado pelo bootstrap)

data/                         # dados — ver data/README.md e docs/dicionario_dados.md
├── raw/                       # fontes originais, sem transformação (planilhas, malhas)
│   └── legado/                 # material exploratório histórico não usado pelo app
├── processed/                 # arquivos derivados de raw/ (inclui a base individualizada tratada)
└── external/                   # dados obtidos de fontes externas (ex.: geobr/brmap)

docs/                          # documentação auxiliar
└── dicionario_dados.md         # dicionário de campos SINAN + tabelas de código→significado

www/                            # recursos estáticos publicados pelo Shiny (logos, imagens do relatório, favicon)
assets/                         # recursos de desenvolvimento (não publicados pelo Shiny)
pipeline/                       # scripts de aquisição/preparação de dados fora da inicialização do app
output/                         # artefatos gerados em runtime (mapas, LaTeX, PDF) — gitignored
pdf_folder/                     # PDF final publicado pelo Shiny (formulario.pdf) — gitignored
tests/                          # testes unitários (testthat) e de interface (shinytest2)
renv/                           # ambiente R reprodutível (renv::restore())
```

## Módulos

A aplicação é composta por sete módulos Shiny reais em `modules/` (o
`_template` é só um esqueleto para criar módulos novos), cada um expondo
`modulo_ui(id)` / `modulo_server(id, ...)` com `NS(id)`/`moduleServer()`:

| Módulo | Aba / onde aparece | Responsabilidade |
| --- | --- | --- |
| `panorama_geral` | Panorama (tab1) | Composição da aba: embute `nivel_risco` e `mapa_cidades`, plus série de notificados/confirmados, proporção por classificação e ranking de municípios |
| `nivel_risco` | Dentro de Panorama | Indicadores-chave (iboxes) e 4 tabelas filtráveis por faixa de incidência (Epidemia/Alerta/Baixo/Sem Casos) |
| `mapa_cidades` | Panorama + Descritivo | Mapas Leaflet (incidência e macrorregião); dois pontos de entrada de UI a partir do mesmo módulo |
| `comportamento_inicial` | Descritivo (tab2) | Filtro compartilhado (macrorregional/regional/cidade) + perfil sociodemográfico dos casos filtrados |
| `diagrama_controle` | Diagrama Controle (tab3) | Série histórica 2007–2020 e diagrama de controle (canal endêmico) |
| `relatorio` | Botão na controlbar | Geração do relatório em PDF a partir do estado atual dos dados |
| `sobre` | Sobre (tab4) | Conteúdo institucional estático |

Ver `modules/README.md` para o mapeamento completo, dependências entre
módulos (ex.: o filtro de `comportamento_inicial` também atualiza o mapa de
`mapa_cidades`) e o README de cada módulo para detalhes de implementação.

Dados e agregados usados por mais de um módulo (base de casos, dados
municipais enriquecidos, resumos e ranking) são montados uma única vez por
`R/shared_data.R::build_shared_data()` e passados como `shared_data` para
cada módulo — não há variáveis globais entre módulos.

## Execução

Abra o projeto `painel_dengue.Rproj` e execute `app.R`. O bootstrap
(`R/bootstrap.R`) ativa o ambiente `renv`, carrega as dependências
centralizadas, os utilitários, a camada de dados compartilhada e os módulos
antes de inicializar a aplicação.

Para restaurar as dependências em outra máquina, use `renv::restore()` a
partir da raiz do projeto.

Ao clicar em "Relatório" (controlbar), o app grava artefatos temporários
(mapas, gráficos, `.tex`, PDF) em `output/relatorio/` e publica o PDF final
em `pdf_folder/formulario.pdf` — ambos gitignored e recriados a cada geração
(ver `output/README.md`).

## Dados

Arquivos originais ficam em `data/raw/` (e `data/raw/legado/` para material
exploratório não usado pelo app), arquivos derivados em `data/processed/` e
dados externos em `data/external/` — ver `data/README.md`. Para o
significado de cada campo (códigos SINAN de classificação, evolução,
autoctonia, gestação, escolaridade etc.) e a origem de cada fonte, ver
[`docs/dicionario_dados.md`](docs/dicionario_dados.md).

Relatórios e imagens gerados em tempo de execução não são versionados
(`.gitignore`).
