mapa_cidades_server <- function(id, shared_data, res_mod) {
  shiny::moduleServer(id, function(input, output, session) {
    dados.maps.pr <- shared_data$dados.maps.pr
    dados.lia <- shared_data$dados.lia
    maps.cities2 <- shared_data$maps.cities2
    setview <- shared_data$setview

    opac <- shiny::reactiveValues(values = rep(1, length(maps.cities2$nome)))

    shiny::observeEvent(list(res_mod()), ignoreInit = TRUE, {
      posna <- which(is.na(dados.maps.pr$Casos))
      repsna <- rep(1, length(posna))
      pos <- which(dados.maps.pr$Codigo %in% res_mod()$Codigo)
      qtd <- sum(dados.maps.pr$Codigo %in% res_mod()$Codigo)
      opac$values <- rep(0.1, length(dados.maps.pr$macroid))
      opac$values[posna] <- repsna
      opac$values[pos] <- rep(1.0, qtd)
    })

    output$map.descritive <- leaflet::renderLeaflet({
      col.brew <- RColorBrewer::brewer.pal(n = 6, name = "Set1")
      cores <- sapply(1:length(dados.maps.pr$macroregional), FUN = function(i) getColor(as.character(dados.maps.pr$macroregional[i])))
      dados.maps.pr$cores <- cores

      maps.label.pr <- sprintf(
        "<strong>%s</strong><br/>
  <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>",
        paste0("<b><h1>", dados.maps.pr$`Município [-]`, "</h1></b>"),
        paste0("<b>Macroregião :</b>", dados.maps.pr$macroregional),
        paste0("<b>Regional de Saúde :</b>", dados.maps.pr$regional, "ª"),
        paste0("<b>Longitude :</b>", dados.maps.pr$LONGITUDE),
        paste0("<b>Latitude :</b>", dados.maps.pr$LATITUDE),
        paste0("<b>Área Territorial :</b>", dados.maps.pr$`Área Territorial - km² [2019]`, "Km²"),
        paste0("<b>População Estimada 2019 :</b>", dados.maps.pr$`População estimada - pessoas [2019]`),
        paste0("<b>Casos :</b>", dados.maps.pr$Casos),
        paste0("<b>Incidência :</b>", dados.maps.pr$incidencia),
        paste0("<b>Óbitos :</b>", dados.maps.pr$Obitos)
      ) %>% lapply(htmltools::HTML)

      maps.cities2.sf <- sf::st_as_sf(x = maps.cities2)

      leaflet::leaflet(dados.maps.pr, options = list(zoomControl = FALSE)) %>%
        leaflet::addTiles() %>%
        leaflet::setView(lng = setview$lng, lat = setview$lat, zoom = 7) %>%
        leaflet::addPolygons(
          fillColor = cores, layerId = dados.maps.pr$macroid,
          weight = 2,
          opacity = opac$values, label = maps.label.pr,
          color = cores, fill = "black", stroke = TRUE,
          dashArray = "3",
          fillOpacity = opac$values,
          highlight = leaflet::highlightOptions(weight = 5, color = "#666", dashArray = "", fillOpacity = 0.5, bringToFront = TRUE),
          labelOptions = leaflet::labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto")
        ) %>%
        leaflet::addLegend(colors = unique(cores), labels = unique(maps.cities2.sf$macroregional), opacity = 1, title = "Macroregião", position = "topleft")
    })

    output$map.descritive3 <- leaflet::renderLeaflet({
      legend.label <- c(
        "até 0,00", "  0,00 -----| 50,00 ", " 50,00 ----| 100,00", "100,00 --| 300,00", "300,00 --| 500,00",
        paste("500,00 --|", round(max(dados.maps.pr$incidencia_auto, na.rm = TRUE), 2))
      )

      cor.lia <- sapply(1:length(dados.lia$Condição), FUN = function(i) getColor.lia(dados.lia$Condição[i]))
      cores <- sapply(1:length(dados.maps.pr$incidencia_auto), FUN = function(i) getColor.inc(dados.maps.pr$incidencia_auto[i]))
      dados.maps.pr$cores <- cores
      cores2 <- sapply(1:length(dados.maps.pr$incidencia_auto_4semanas), FUN = function(i) getColor.inc(dados.maps.pr$incidencia_auto_4semanas[i]))
      dados.maps.pr$cores2 <- cores2
      cores3 <- sapply(1:length(dados.maps.pr$Obitos), FUN = function(i) getColor.obt(dados.maps.pr$Obitos[i]))
      dados.maps.pr$cores3 <- cores3

      maps.label.pr <- sprintf(
        "<strong>%s</strong><br/>
  <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>
   <strong>%s</strong><br/>",
        paste0("<b><h1>", dados.maps.pr$`Município [-]`, "</h1></b>"),
        paste0("<b>Macroregião :</b>", dados.maps.pr$macroregional),
        paste0("<b>Regional de Saúde :</b>", dados.maps.pr$regional, "ª"),
        paste0("<b>Longitude :</b>", dados.maps.pr$LONGITUDE),
        paste0("<b>Latitude :</b>", dados.maps.pr$LATITUDE),
        paste0("<b>Área Territorial :</b>", dados.maps.pr$`Área Territorial - km² [2019]`, "Km²"),
        paste0("<b>População Estimada 2019 :</b>", dados.maps.pr$`População estimada - pessoas [2019]`),
        paste0("<b>Casos :</b>", dados.maps.pr$Casos),
        paste0("<b>Incidência :</b>", dados.maps.pr$incidencia),
        paste0("<b>Incidência 4 Ult. Semanas :</b>", format(dados.maps.pr$incidencia_auto_4semanas, scientific = FALSE)),
        paste0("<b>Óbitos :</b>", dados.maps.pr$Obitos)
      ) %>% lapply(htmltools::HTML)

      map.incidencia4semanas <- leaflet::leaflet(dados.maps.pr, options = list(zoomControl = FALSE)) %>%
        leaflet::addTiles() %>%
        leaflet::setView(lng = setview$lng, lat = setview$lat, zoom = 7) %>%
        leaflet::addPolygons(
          fillColor = ~cores2, weight = 2, opacity = 1, label = maps.label.pr,
          color = "black", fill = "black", stroke = TRUE, dashArray = "3", fillOpacity = .95,
          highlight = leaflet::highlightOptions(weight = 5, color = "#666", dashArray = "", fillOpacity = 0.5, bringToFront = TRUE),
          labelOptions = leaflet::labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto")
        ) %>%
        leaflet::addLegend(colors = c("white", "lightgray", "yellow", "orange", "red", "saddlebrown"), labels = legend.label, opacity = 1, title = "Legenda Incidência", position = "topleft")

      map_inc4 <- ggplot2::ggplot() +
        ggplot2::geom_sf(data = dados.maps.pr, size = 1, show.legend = TRUE, fill = cores2) +
        ggplot2::ggtitle(label = "Incidências para os casos referente as 12 últimas semanas para o Estado do Paraná") +
        ggplot2::xlab("Longitude") + ggplot2::ylab("Latitude") + axis.theme() + ggplot2::labs(fill = "Lengenda Incidências") +
        ggplot2::scale_fill_manual(values = c("white", "lightgray", "yellow", "orange", "red", "saddlebrown")) +
        ggspatial::annotation_north_arrow(location = "bl", which_north = "true", pad_x = ggplot2::unit(0.75, "in"), pad_y = ggplot2::unit(0.5, "in"), style = ggspatial::north_arrow_fancy_orienteering)
      ggplot2::ggsave(filename = "map_inc4.png", plot = map_inc4, width = 12, height = 7)

      map_inc <- ggplot2::ggplot() +
        ggplot2::geom_sf(data = dados.maps.pr, size = 1, show.legend = TRUE, fill = cores) +
        ggplot2::ggtitle(label = "Incidências para o Estado do Paraná") +
        ggplot2::xlab("Longitude") + ggplot2::ylab("Latitude") + axis.theme() + ggplot2::labs(fill = "Lengenda Incidências") +
        ggplot2::scale_fill_manual(values = c("white", "lightgray", "yellow", "orange", "red", "saddlebrown")) +
        ggspatial::annotation_north_arrow(location = "bl", which_north = "true", pad_x = ggplot2::unit(0.75, "in"), pad_y = ggplot2::unit(0.5, "in"), style = ggspatial::north_arrow_fancy_orienteering)
      ggplot2::ggsave(filename = "map_inc.png", plot = map_inc, width = 12, height = 7)

      map_obt <- ggplot2::ggplot() +
        ggplot2::geom_sf(data = dados.maps.pr, size = 1, show.legend = TRUE, fill = cores3) +
        ggplot2::ggtitle(label = "Óbitos para o Estado do Paraná") +
        ggplot2::xlab("Longitude") + ggplot2::ylab("Latitude") + axis.theme() + ggplot2::labs(fill = "Lengenda Incidências") +
        ggplot2::scale_fill_manual(values = c("white", "lightgray", "yellow", "orange", "red", "saddlebrown")) +
        ggspatial::annotation_north_arrow(location = "bl", which_north = "true", pad_x = ggplot2::unit(0.75, "in"), pad_y = ggplot2::unit(0.5, "in"), style = ggspatial::north_arrow_fancy_orienteering)
      ggplot2::ggsave(filename = "map_obt.png", plot = map_obt, width = 12, height = 7)

      map_lia <- ggplot2::ggplot() +
        ggplot2::geom_sf(data = dados.lia, size = 1, show.legend = TRUE, fill = cor.lia) +
        ggplot2::ggtitle(label = "Classificação de Infestação para as Cidades do Estado do Paraná") +
        ggplot2::xlab("Longitude") + ggplot2::ylab("Latitude") + axis.theme() + ggplot2::labs(fill = "Lengenda Incidências") +
        ggplot2::scale_fill_manual(values = c("white", "lightgray", "yellow", "orange", "red", "saddlebrown")) +
        ggspatial::annotation_north_arrow(location = "bl", which_north = "true", pad_x = ggplot2::unit(0.75, "in"), pad_y = ggplot2::unit(0.5, "in"), style = ggspatial::north_arrow_fancy_orienteering)
      ggplot2::ggsave(filename = "map_lia.png", plot = map_lia, width = 12, height = 7)

      map.incidencia <- leaflet::leaflet(dados.maps.pr, options = list(zoomControl = FALSE)) %>%
        leaflet::addTiles() %>%
        leaflet::setView(lng = setview$lng, lat = setview$lat, zoom = 7) %>%
        leaflet::addPolygons(
          fillColor = ~cores, weight = 2, opacity = 1, label = maps.label.pr,
          color = "black", fill = "black", stroke = TRUE, dashArray = "3", fillOpacity = .95,
          highlight = leaflet::highlightOptions(weight = 5, color = "#666", dashArray = "", fillOpacity = 0.5, bringToFront = TRUE),
          labelOptions = leaflet::labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto")
        ) %>%
        leaflet::addLegend(colors = c("white", "lightgray", "yellow", "orange", "red", "saddlebrown"), labels = legend.label, opacity = 1, title = "Legenda Incidência", position = "topleft")

      if (input$select.mapinc == "inc4") {
        map.incidencia4semanas
      } else if (input$select.mapinc == "obitos") {
        leaflet::leaflet(dados.maps.pr, options = list(zoomControl = FALSE)) %>%
          leaflet::addTiles() %>%
          leaflet::setView(lng = setview$lng, lat = setview$lat, zoom = 7) %>%
          leaflet::addPolygons(
            fillColor = ~cores3, weight = 2, opacity = 1, label = maps.label.pr,
            color = "black", fill = "black", stroke = TRUE, dashArray = "3", fillOpacity = .95,
            highlight = leaflet::highlightOptions(weight = 5, color = "#666", dashArray = "", fillOpacity = 0.5, bringToFront = TRUE),
            labelOptions = leaflet::labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto")
          ) %>%
          leaflet::addLegend(colors = c("black"), labels = "Cidades com Óbitos", opacity = 1, title = "Legenda", position = "topleft")
      } else if (input$select.mapinc == "lia") {
        leaflet::leaflet(dados.lia, options = list(zoomControl = FALSE)) %>%
          leaflet::addTiles() %>%
          leaflet::setView(lng = setview$lng, lat = setview$lat, zoom = 7) %>%
          leaflet::addPolygons(
            fillColor = cor.lia, weight = 2, opacity = 1, label = maps.label.pr,
            color = "black", fill = "black", stroke = TRUE, dashArray = "3", fillOpacity = .95,
            highlight = leaflet::highlightOptions(weight = 5, color = "#666", dashArray = "", fillOpacity = 0.5, bringToFront = TRUE),
            labelOptions = leaflet::labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto")
          ) %>%
          leaflet::addLegend(colors = c("green", "red"), labels = c("Não Infestado", "Infestado"), opacity = 1, title = "Legenda", position = "topleft")
      } else {
        map.incidencia
      }
    })

    invisible(NULL)
  })
}
