source("renv/activate.R")

# O app usa `app.R` para controlar explicitamente a ordem de carregamento
# (bootstrap -> módulos -> shell). O autoload padrão do Shiny para `R/`
# (alfabético) rodaria `app_server.R`/`app_ui.R` antes de `bootstrap.R`
# terminar de sourcear os módulos, quebrando a app.
options(shiny.autoload.r = FALSE)
