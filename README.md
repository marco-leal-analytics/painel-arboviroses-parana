# Painel de Arboviroses do Paraná

Aplicação Shiny para monitoramento epidemiológico de arboviroses no Paraná.

## Estrutura

```text
app.R                  # ponto de entrada único
R/                      # bootstrap, dependências, dados compartilhados e app shell (ui/server)
modules/                # módulos Shiny (ui.R + server.R), um por funcionalidade
data/                   # dados brutos (raw/), derivados (processed/) e externos (external/)
assets/                 # recursos de desenvolvimento
www/                    # recursos publicados pelo Shiny (logos, imagens do relatório)
pipeline/               # preparação de dados fora da inicialização
tests/                  # testes unitários e de interface
renv/                   # ambiente reprodutível
```

## Módulos

A aplicação é composta por sete módulos Shiny (`modules/`), cada um expondo
`modulo_ui(id)` / `modulo_server(id, ...)` com `NS(id)`/`moduleServer()`:
`panorama_geral`, `mapa_cidades`, `comportamento_inicial`, `nivel_risco`,
`diagrama_controle`, `relatorio` e `sobre`. Ver `modules/README.md` para o
mapeamento completo e as dependências entre módulos.

Dados e agregados usados por mais de um módulo (base de casos, dados
municipais enriquecidos, resumos e ranking) são montados uma única vez por
`R/shared_data.R::build_shared_data()` e passados como `shared_data` para cada
módulo — não há variáveis globais entre módulos. O *shell* da aplicação
(`bs4DashPage` e o `server` de nível superior) fica em `R/app_ui.R` e
`R/app_server.R`.

## Execução

Abra o projeto `painel_dengue.Rproj` e execute `app.R`. O bootstrap
(`R/bootstrap.R`) ativa o ambiente `renv`, carrega as dependências
centralizadas, os utilitários, a camada de dados compartilhada e os módulos
antes de inicializar a aplicação.

Para restaurar as dependências em outra máquina, use `renv::restore()` a partir
da raiz do projeto.

## Dados

Arquivos originais ficam em `data/raw/` (e `data/raw/legado/` para material
exploratório não usado pelo app), arquivos derivados em `data/processed/` e
dados externos em `data/external/`. Ver `data/README.md`. Relatórios e imagens
geradas em tempo de execução não são versionados (`.gitignore`).

