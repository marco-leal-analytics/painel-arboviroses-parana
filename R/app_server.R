server <- function(input, output, session) {
  shared_data <- build_shared_data()

  comportamento <- comportamento_inicial_server("comportamento_inicial", shared_data)
  mapa_cidades_server("mapa_cidades", shared_data, comportamento$res_mod)
  nivel_risco_server("nivel_risco", shared_data)
  panorama <- panorama_geral_server("panorama_geral", shared_data)
  diagrama_controle_server("diagrama_controle", shared_data)
  relatorio_server("relatorio", shared_data, panorama$fig)
  sobre_server("sobre")
}
