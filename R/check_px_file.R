#' Check download url whether it is a px cube
#'
#' @importFrom dplyr %>%
#' @param px_download_url url to download a px cube
#'
#' @return file_is_px_axis_file
#' @export
#'
#' @examples check_px_cube_url('https://www.pxweb.bfs.admin.ch/DownloadFile.aspx?file=px-x-0102020207_102')
check_file_or_url <- function(file_or_url) {
  tryCatch(
    {
      lines <- readr::read_lines(file_or_url,  n_max = 5)
      keywords <- get_keyword_from_lines(lines)
      file_is_px_axis_file <- ('AXIS-VERSION' %in% keywords)
      if (!('AXIS-VERSION' %in% keywords )) {
        stop("File is not a px cube: could not find AXIS-VERSION statement")
      }
      if (!('CHARSET=\"ANSI\";' %in% lines)) {
        stop("File has not the expected ANSI encoding: file an issue and ask for an extensions to other encodings")
      }
    },
    error = function(error_message) {
      stop(error_message)
    }
  )
}
