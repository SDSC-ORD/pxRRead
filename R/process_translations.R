process_translations <- function(px_rows, metadata, default_language, languages) {
  translations <- list()
  for (lang in languages) {
    translations[[lang]] = c(list())
  }
  dimensions <- get_dimension_with_translations(
    px_rows = px_rows,
    default_language = default_language,
    languages = languages)
  dimension_pattern <- get_dimension_pattern(dimensions)
  language_pattern <- get_language_pattern(languages)
  for (i in 1:length(px_rows)) {
    key <- names(px_rows)[i]
    key_in_default_language <- !is_language_specific(key, language_pattern)
    key_without_dimensions <- !belongs_to_dimensions(key, dimension_pattern)
    if (startsWith(key, "STUB") || startsWith(key, "HEADING")) {
      next
    }
    if (key_in_default_language && key_without_dimensions) {
      default_key <- key
      default_value <- px_rows[[default_key]]
    } else if (key_without_dimensions) {
      value <- px_rows[[key]]
      lang <- stringr::str_extract(key, "[[:lower:]]{2}") %>% unlist()
      if (default_value != value) {
        translations[[lang]][[default_value]] <- value
      }
    } else if (startsWith(key, 'VALUES')) {
      if (key_in_default_language) {
        default_key <- key
        default_values <- px_rows[[default_key]] %>% unlist()
      } else {
        values <- px_rows[[key]] %>% unlist()
        if (length(setdiff(default_values, values)) != 0) {
          lang <- stringr::str_extract(key, "[[:lower:]]{2}") %>% unlist()
          for (i in 1:length(default_values)) {
            to_translate <- default_values[i]
            translation <- values[i]
            translations[[lang]][[to_translate]] <- translation
          }
        }
      }
    }
  }
  for (lang in languages) {
    if (lang != default_language) {
      json_export <- jsonlite::toJSON(
        translations[[lang]],
        pretty = TRUE,
        auto_unbox = TRUE
      )
      file_path <- paste0(lang, ".json")
      write(json_export, file_path)
    }
  }
  return(translations)
}
