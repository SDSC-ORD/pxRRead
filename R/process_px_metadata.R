#' Transform px dimension into a px dimension values key
#'
#' @param dimension_name such as "Jahr"
#'
#' @return VALUES px key such as VALUES("Year")
#' @noRd
#'
#' @examples get_dimension_key("Jahr")
get_dimension_key <- function(dimension_name) {
  dimension_key <- paste0('VALUES("', dimension_name, '")')
  return(dimension_key)
}

#' Get dimension values for a px_variable such as STUB or HEADING
#'
#' @importFrom dplyr %>%
#'
#' @param px_rows as key value pairs of a px file
#' @param dimension_name dimension name such as "Jahr"
#'
#' @return values for the px dimension key
#' @noRd
#'
#' @examples get_dimension_values(list('VALUES("Jahr")'= c('1876','1877','1878'), 'STUB'='Jahr'), 'STUB')
get_dimension_values <- function(px_rows, px_variable) {
  dimension_names <- px_rows[[px_variable]]
  dimensions <- list()
  for (dimension_name in dimension_names) {
    values_key <- get_dimension_key(dimension_name)
    dimension_values <- px_rows[[values_key]] %>% list()
    names(dimension_values) = dimension_name
    dimensions <- append(dimensions, dimension_values)
  }
  return(dimensions)
}

#' Get metadata as a named list of px keys and values
#'
#' @param px_rows as px key value pairs
#' @param default_language language code or NULL
#' @param languages language codes or NULL where translations exist
#' @param locale chosen locale
#'
#' @return px metadata as a list of key value pairs
#' @noRd
#'
#' @examples process_px_metadata(list('DESCRIPTION'='Heiraten seit 1876'))
process_px_metadata <- function(px_rows, languages) {
  language_pattern <- get_language_pattern(languages)
  keys <- get_px_keys(px_rows, language_pattern)
  metadata <- list()
  for (px_key in keys) {
    metadata[[px_key]] <- px_rows[[px_key]]
  }
  stub <- get_dimension_values(px_rows, "STUB")
  heading <- get_dimension_values(px_rows, "HEADING")
  metadata[['STUB']] = stub
  metadata[['HEADING']] = heading
  return(metadata)
}

get_dimensions <- function(px_rows) {
  stub <- get_dimension_values(px_rows, "STUB")
  heading <- get_dimension_values(px_rows, "HEADING")
  metadata <- list()
  metadata[['STUB']] = stub
  metadata[['HEADING']] = heading
}

get_language_pattern <- function(languages) {
  language_pattern <- paste0("[[](", paste(languages, collapse = "|"), ")[]]")
  return(language_pattern)
}

get_dimension_with_translations <- function(px_rows, default_language, languages) {
  dimensions <- c(px_rows$STUB, px_rows$HEADING)
  for (lang in languages) {
    if (lang != default_language) {
      stub_locale <- paste0("STUB", '[', lang, ']')
      heading_locale <- paste0("HEADING", '[', lang, ']')
      dimensions <- c(dimensions, c(px_rows[[stub_locale]],
                                    px_rows[[heading_locale]]))
    }
  }
  return(dimensions)
}

get_dimension_pattern <- function(dimensions) {
  grepl('\\(("Jahr"|"More and More")\\)', 'VALUES("Jahr")')
  dimension_pattern <- paste0('(', paste(dimensions, collapse = '|'), ')')
  return(dimension_pattern)
}

#' Check px key whether it is a basic key or belongs to a translation
#'
#' @param key one px key
#'
#' @return bool that indicates whether the key is a basic key
#' @noRd
#'
#' @examples is_language_specific('TITLE[fr]')
is_language_specific <- function(key, language_pattern) {
  key_contains_language <- grepl(pattern=language_pattern, x=key)
  return(key_contains_language)
}

#' Get non language px_keys
#'
#' @param keys vector of px keys
#'
#' @return vector of px keys that are not keys for translations
#' @noRd
#'
#' @examples get_non_language_px_keys(c('DESCRIPTION', 'TITLE[fr]'))
get_non_language_px_keys <- function(keys, language_pattern) {
  selected <- keys[!is_language_specific(keys, language_pattern)]
  return(selected)
}

#' Get px keys
#'
#' @param px_rows as key value pairs of a px file
#' @param include_translations include px_keys for translations
#'
#' @return vector of px keys
#' @noRd
#'
#' @examples get_px_keys(list('DESCRIPTION="Scheidungen seit 1876"'))
get_px_keys <- function(px_rows, language_pattern) {
  px_keys <- names(px_rows)
  base_px_keys <- get_non_language_px_keys(px_keys, language_pattern)
  return(base_px_keys)
}

belongs_to_dimensions <- function(key, dimension_pattern) {
  key_contains_dimensions <- grepl(pattern=dimension_pattern, x=key)
  return(key_contains_dimensions)
}
