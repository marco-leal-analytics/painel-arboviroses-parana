project_packages <- c(
  "brazilmaps", "sf", "maps", "mapdata", "raster", "dplyr",
  "RColorBrewer", "shiny", "bs4Dash", "leaflet", "shinyWidgets",
  "shinycssloaders", "shinyBS", "shinyjs", "plotly", "RCurl", "readr",
  "ggplot2", "lubridate", "ggrepel", "tidyverse", "dygraphs", "V8",
  "knitr", "tinytex", "kableExtra", "bsplus", "astsa", "TSA", "forecast",
  "foreign", "geobr", "ggmap", "readxl", "htmlwidgets", "webshot",
  "mapview", "zoo", "shinydashboard", "ggspatial", "animation", "DT"
)

load_project_packages <- function(packages = project_packages) {
  missing_packages <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing_packages) > 0) {
    stop(
      "Dependências ausentes no ambiente renv: ",
      paste(missing_packages, collapse = ", "),
      call. = FALSE
    )
  }

  invisible(lapply(packages, library, character.only = TRUE))
}

load_project_packages()