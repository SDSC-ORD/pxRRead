#' Derive key value px row from raw px lines
#'
#' @importFrom dplyr %>%
#'
#' @param lines scanned lines as raw input for a px row
#'
#' @return named vector with keywords as names for values
#' @noRd
#'
#' @example get_keyword_values_pair('LANGUAGE="de"')
get_keyword_values_pair <- function (lines) {
  key_value_pair <- strsplit(lines[1], split='\\=') %>% unlist()
  keyword <- head(key_value_pair, 1)
  lines[1] <- tail(key_value_pair, 1)
  px_row <- vectorize_raw_input(lines) %>% list()
  names(px_row) = keyword
  return(px_row)
}

#' Vectorize scanned lines into value vectors
#'
#' @importFrom dplyr %>%
#'
#' @param lines scanned px_lines as strings
#'
#' @return scanned lines as vector of values
#' @noRd
#'
#' @example vectorize_raw_input(c('\"Betriebe\",\"Zimmer\"', '\"Ankünfte\",\"Zimmernächte\"'))
vectorize_raw_input <- function(lines) {
  lines <- strsplit(lines, split='\",\"') %>% unlist()
  values <- stringr::str_replace_all(lines, '\"', "")
  return(values)
}

#' Get keyword from lines of a px file
#'
#' @param lines as raw string scanned from the px file
#'
#' @return keyword
#' @noRd
#'
#' @example get_keyword('LANGUAGE="de"')
get_keyword_from_lines <- function (lines) {
  line_parts <- strsplit(lines, split='\\=')
  keywords <- sapply(line_parts, getElement, 1)
  return(keywords)
}

#' Process the raw px lines that start with the DATA keyword
#'
#' @importFrom dplyr %>%
#'
#' @param lines raw data lines
#'
#' @return vectorized data as numericals
#' @noRd
#'
#' @examples vectorize_px_data(c('DATA=1102 \"...\" \"...\"', '370 607 125', ' '))
vectorize_px_data <- function (lines) {
  lines[1] <- stringr::str_replace(lines[1], 'DATA=', '')
  lines <- lines[lines != ""]
  data <- vectorize_data(lines)
  return(data)
}

#' Turn raw px data lines into a numeric vector
#'
#' @importFrom dplyr %>%
#'
#' @param rows scanned rows of a px file
#'
#' @return rows as numeric
#' @noRd
#'
#' @examples vectorize_data(c('1102 \"...\" \"...\"', '370 607 125'))
vectorize_data <- function(lines) {
  values <- trimws(lines) %>% strsplit(split=' ') %>% unlist()
  suppressWarnings(values <- as.numeric(values))
  return(values)
}

