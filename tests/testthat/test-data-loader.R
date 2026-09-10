test_that("o carregador valida e lê a base de dengue", {
  data_path <- testthat::test_path("../../data/processed/dbase_reduzido.csv")
  testthat::skip_if_not(file.exists(data_path))
  data <- load_dengue_data(data_path)
  testthat::expect_true(nrow(data) > 0)
  testthat::expect_true(all(c("SG_UF", "ID_MN_RESI", "CLASSI_FIN", "DT_NOTIFIC") %in% names(data)))
})