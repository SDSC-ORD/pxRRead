#' Scan a px cube file and return px data and metadata
#'
#' @param px_file px cube file
#'
#' @return list with the dataframe as a tibble and the metadata as a list
#' @export
#'
#' @examples scan_px_file("px-x-0102020203_110.px")
scan_px_file <- function (px_file) {
  scanned_lines <- scan(px_file, what = "list", sep = ";", quote = NULL,
                        quiet = TRUE, encoding = "latin1", multi.line = TRUE)
  px_rows <- list()
  lines <- c()
  for (line in scanned_lines) {
    if (line != "") {
      lines <- append(lines, line)
    } else {
      if (length(lines) > 0) {
        px_rows <- append(px_rows, get_keyword_values_pair(lines))
        lines <- c()
      }
    }
  }
  data <- vectorize_px_data(lines)
  metadata <- process_px_metadata(px_rows)
  df <- expand.grid(c(metadata$HEADING, metadata$STUB))
  df[, 'DATA'] = data
  df <- janitor::clean_names(df)
  output <- list('metadata' = metadata,
                 'dataframe' = tibble::as_tibble(df))
  return(output)
}

