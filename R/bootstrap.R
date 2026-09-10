project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)

if (file.exists("renv/activate.R")) {
  source("renv/activate.R", local = .GlobalEnv)
}

source("R/packages.R", local = .GlobalEnv)
source("R/utils.R", local = .GlobalEnv)
source("R/plot_helpers.R", local = .GlobalEnv)
source("R/data_loader.R", local = .GlobalEnv)
source("R/shared_data.R", local = .GlobalEnv)

module_dirs <- list.dirs("modules", full.names = TRUE, recursive = FALSE)
module_dirs <- module_dirs[basename(module_dirs) != "_template"]
for (module_dir in module_dirs) {
  ui_file <- file.path(module_dir, "ui.R")
  server_file <- file.path(module_dir, "server.R")
  if (file.exists(ui_file)) source(ui_file, local = .GlobalEnv)
  if (file.exists(server_file)) source(server_file, local = .GlobalEnv)
}