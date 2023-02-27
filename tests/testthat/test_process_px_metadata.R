test_that("get dimension px keyword for dimension name", {
  dimension_name <- "Jahr"
  expected_dimension_px_keyword <- 'VALUES("Jahr")'
  dimension_px_keyword <- get_dimension_key(dimension_name)
  expect_equal(dimension_px_keyword, expected_dimension_px_keyword)
})

test_that("get dimension values for px variable", {
  px_variable <- "STUB"
  dimension_values <- c("1876","1877","1878")
  px_rows = list('VALUES("Jahr")' = dimension_values, "STUB"="Jahr")
  expected_output = list("Jahr" = dimension_values)
  values <- get_dimension_values(px_rows, px_variable)
  expect_equal(values, expected_output)
})

test_that("process metadata from px rows", {
  px_rows <- list("TITLE"="Scheidungen seit 1876", "TITLE[en]"="Divorces since 1876")
  output <- process_px_metadata(px_rows)
  expected_output <- list("TITLE"="Scheidungen seit 1876", "STUB"=list(), "HEADING"=list())
  expect_equal(expected_output, output)
})

test_that("recognizes language specific px keys", {
  expect_equal(is_language_specific('TITLE[fr]'), TRUE)
  expect_equal(is_language_specific('TITLE'), FALSE)
})

test_that("get px keys that are not for translations", {
  px_keys <- c('DESCRIPTION', 'TITLE[fr]')
  expected_output <- c('DESCRIPTION')
  output <- get_non_language_px_keys(px_keys)
  expect_equal(output, expected_output)
})

test_that("get px base keys", {
  px_rows <- list("TITLE"="Scheidungen seit 1876", "TITLE[en]"="Divorces since 1876")
  expect_equal(get_px_keys(px_rows), "TITLE")
  expect_equal(get_px_keys(px_rows, include_translations = TRUE), c("TITLE", "TITLE[en]"))
})
