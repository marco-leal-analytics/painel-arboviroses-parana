source("R/bootstrap.R", local = .GlobalEnv)
source("R/app_ui.R", local = .GlobalEnv)
source("R/app_server.R", local = .GlobalEnv)

shiny::shinyApp(ui = ui, server = server)
