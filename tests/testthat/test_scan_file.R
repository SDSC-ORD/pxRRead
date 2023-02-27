test_that("scan px cube file: check that all lines are received", {
  path <- here::here("tests/testthat/data/px-x-0102020203_110.px")
  output <- scan_px_file(path)
  expect_equal(length(output$metadata), 36)
  expect_equal(dim(output$tdf), c(5402, 3))
  expect_vector(output$metadata)
})

test_that("scan another px cube file: check that all lines are received", {
  path <- here::here("tests/testthat/data/px-x-1003020000_201.px")
  output <- scan_px_file(path)
  expect_equal(length(output$metadata), 46)
  expect_equal(dim(output$tdf), c(108160, 5))
  expect_vector(output$metadata)
})
