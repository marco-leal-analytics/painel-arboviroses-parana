load_dengue_data <- function(path = file.path("data", "processed", "dbase_reduzido.csv")) {
  if (!file.exists(path)) {
    stop("Arquivo de dados não encontrado: ", path, call. = FALSE)
  }

  data <- read.table(path, header = TRUE, sep = ",", check.names = FALSE)
  required_columns <- c("SG_UF", "ID_MN_RESI", "CLASSI_FIN", "DT_NOTIFIC")
  missing_columns <- setdiff(required_columns, names(data))

  if (length(missing_columns) > 0) {
    stop(
      "Colunas obrigatórias ausentes em ", path, ": ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  data
}

load_lia <- function(path = file.path("data", "raw", "Planilha IIP.xls")) {
  lia <- readxl::read_xls(path = path, sheet = "Plan1")
  lia <- lia %>%
    dplyr::filter(!is.na(`Código IBGE`)) %>%
    dplyr::select(`Código IBGE`, Condição, Método) %>%
    dplyr::rename(Codigo = `Código IBGE`)
  lia$Codigo <- as.numeric(lia$Codigo)
  lia
}

load_regionais <- function(path = file.path("data", "raw", "regionais.xlsx")) {
  regionais <- readxl::read_xlsx(path = path, sheet = "Planilha1")
  regionais$nome <- tolower(rm_accent(as.character(regionais$nome)))
  regionais
}

load_coordenadas_municipios <- function(path = file.path("data", "raw", "Coordenadas_Municipios.xls")) {
  readxl::read_xls(path = path, sheet = "Cidades") %>%
    dplyr::rename(Codigo = GEOCODIGO_MUNICIPIO)
}

load_dados_pr <- function(path = file.path("data", "raw", "dados.pr.xlsx")) {
  readxl::read_xlsx(path = path, sheet = "Worksheet") %>%
    dplyr::select(
      `Município [-]`, `Código [-]`,
      `População estimada - pessoas [2019]`, `Área Territorial - km² [2019]`
    ) %>%
    dplyr::rename(Codigo = `Código [-]`)
}

load_casos_consolidados <- function(path = file.path("data", "raw", "Casos Consolidados Notificados 2007 a 2020 BaseDBF.xlsx")) {
  readxl::read_xlsx(path = path, sheet = "Notificado")
}

load_maps_cities <- function(regionais) {
  maps.cities2 <- brazilmaps::get_brmap(level = "municipality", filters = list(state_code = 41), output = "sf") %>%
    dplyr::select(name, municipality_code) %>%
    dplyr::rename(nome = name, Codigo = municipality_code)
  maps.cities2$nome <- tolower(rm_accent(as.character(maps.cities2$nome)))
  dplyr::left_join(x = regionais, y = maps.cities2, by = "nome")
}
