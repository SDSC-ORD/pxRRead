download_px_file <- function(px_download_url, px_id) {
  destfile <- paste0(tempdir(), px_id, '.txt')
  rc <- download.file(px_download_url, destfile=destfile)
}
