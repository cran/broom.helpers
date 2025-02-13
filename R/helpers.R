#' Escapes any characters that would have special
#' meaning in a regular expression
#'
#' This functions has been adapted from `Hmisc::escapeRegex()`
#' @param string (`string`)\cr
#' A character vector.
#' @export
#' @family other_helpers
.escape_regex <- function(string) {
  gsub(
    "([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1",
    string
  )
}

#' Remove backticks around variable names
#'
#' @param x (`string`)\cr
#' A character vector to be cleaned.
#' @param variable_names (`string`)\cr
#' Optional vector of variable names, could be obtained with
#' [model_list_variables(only_variable = TRUE)][model_list_variables()],
#' to properly take into account interaction only terms/variables.
#' @export
#' @family other_helpers
.clean_backticks <- function(x, variable_names = x) {
  saved_names <- names(x)

  variable_names <- variable_names |>
    stats::na.omit() |>
    unique() |>
    .escape_regex()

  # cleaning existing backticks in variable_names
  variable_names <- ifelse(
    # does string starts and ends with backticks
    stringr::str_detect(variable_names, "^`.*`$"),
    # if yes remove first and last character of string
    stringr::str_sub(variable_names, 2, -2),
    # otherwise, return original string
    variable_names
  )

  # cleaning x, including interaction terms
  for (v in variable_names) {
    x <- stringr::str_replace_all(
      x,
      paste0("`", v, "`"),
      v
    )
  }
  names(x) <- saved_names
  x
}

# copied from broom
.exponentiate <- function(data, col = "estimate") {
  data <- data |>
    dplyr::mutate(
      dplyr::across(dplyr::all_of(col), exp)
    )
  if ("conf.low" %in% colnames(data)) {
    data <- data |>
      dplyr::mutate(
        dplyr::across(dplyr::any_of(c("conf.low", "conf.high")), exp)
      )
  }
  data
}
