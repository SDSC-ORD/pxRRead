#' Scan a px cube file and return px data and metadata
#'
#' @param px_file px cube file
#'
#' @return list with the dataframe as a tibble and the metadata as a list
#' @export
#'
#' @examples scan_px_file("px-x-0102020203_110.px")
scan_px_file <- function (file_or_url) {
  tryCatch(
    {
      valid_px_file_or_url <- check_file_or_url(file_or_url)
      scanned_lines <- scan(file_or_url, what = "list", sep = ";", quote = NULL,
                            quiet = TRUE, encoding = "latin1", multi.line = TRUE)
    },
    error = function(error_message) {
      stop(error_message)
    }
  )
  # make sure the last scanned line is an empty line
  scanned_lines <- append(scanned_lines, "")
  px_rows <- list()
  px_Line_group <- c()
  for (line in scanned_lines) {
    # the empty line separate the px key value blocks after scanning
    if (line != "") {
      px_Line_group <- append(px_Line_group, line)
    } else {
      if (length(px_Line_group) > 0) {
        px_key <- get_keyword_from_lines(px_Line_group[1])
        if (px_key == "DATA") {
          data <- vectorize_px_data(px_Line_group)
        } else if (grepl('[A-Z-]', px_key)) {
          px_rows <- append(px_rows, get_keyword_values_pair(px_Line_group))
        }
        px_Line_group <- c()
      }
    }
  }
  metadata <- process_px_metadata(px_rows)
  df <- expand.grid(c(metadata$HEADING, metadata$STUB))
  df[, 'DATA'] = data
  df <- janitor::clean_names(df)
  output <- list('metadata' = metadata,
                 'dataframe' = tibble::as_tibble(df))
  return(output)
}
