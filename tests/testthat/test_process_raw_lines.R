test_that("get keyword from raw px line", {
  px_line <- 'LANGUAGE="de"'
  keyword <- "LANGUAGE"
  expect_equal(get_keyword_from_line(px_line), keyword)
})

test_that("get px_row as keyword values pair from group of px lines", {
  lines <- 'LANGUAGE="de"'
  keyword <- "LANGUAGE"
  values <- "de"
  px_row_expected <- list(values)
  names(px_row_expected) = keyword
  px_row <- get_keyword_values_pair(lines)
  expect_equal(px_row, px_row_expected)
  expect_equal(names(px_row_expected), keyword)
})

test_that("test vectorizing of px data lines", {
  lines <- c('1102 \"...\" \"...\"', '370 607 125')
  expected_output <- c(1102, NA, NA, 370, 607, 125)
  output <- vectorize_data(lines)
  expect_equal(output, expected_output)
})

test_that("test vectorizing of px data lines", {
  lines <- c('DATA=1102 \"...\" \"...\"', '370 607 125', ' ')
  expected_output <- c(1102, NA, NA, 370, 607, 125)
  output <- vectorize_px_data(lines)
  expect_equal(output, expected_output)
})

test_that("test vecorizing of px metadata lines", {
  lines <- c('\"Betriebe\",\"Zimmer\"', '\"Ankünfte\",\"Zimmernächte\"')
  expected_output <- c("Betriebe", "Zimmer", "Ankünfte", "Zimmernächte")
  output <- vectorize_raw_input(lines)
  expect_equal(output, expected_output)
})
