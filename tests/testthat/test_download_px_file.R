test_that("px file can be downloaded", {
  px_id <- 'px-x-0102020203_110'
  px_download_url <-"https://www.bfs.admin.ch/bfsstatic/dam/assets/23244083/master"
  rc <- download_px_file(px_download_url, px_id)
  expect_equal(rc, 0)
})
