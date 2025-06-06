#' List contrasts used by a model
#'
#' @param model (a model object, e.g. `glm`)\cr
#' A model object.
#' @return
#' A tibble with three columns:
#' * `variable`: variable name
#' * `contrasts`: contrasts used
#' * `contrasts_type`: type of contrasts
#'   ("treatment", "sum", "poly", "helmert", "sdiff, "other" or "no.contrast")
#' * `reference`: for variables with treatment, SAS
#'   or sum contrasts, position of the reference level
#' @details
#' For models with no intercept, no contrasts will be applied to one of the
#' categorical variable. In such case, one dummy term will be returned for each
#' level of the categorical variable.
#' @export
#' @family model_helpers
#' @examples
#' glm(
#'   am ~ mpg + factor(cyl),
#'   data = mtcars,
#'   family = binomial,
#'   contrasts = list(`factor(cyl)` = contr.sum)
#' ) |>
#'   model_list_contrasts()
model_list_contrasts <- function(model) {
  UseMethod("model_list_contrasts")
}

#' @export
#' @rdname model_list_contrasts
model_list_contrasts.default <- function(model) {
  model_contrasts <- model_get_contrasts(model)

  if (length(model_contrasts) == 0) {
    return(NULL)
  }

  contrasts_list <- tibble::tibble(
    variable = names(model_contrasts),
    contrasts = NA_character_,
    reference = NA_integer_
  )
  xlevels <- model_get_xlevels(model)
  model_variables <- model_identify_variables(model)

  for (i in seq_len(nrow(contrasts_list))) {
    n_levels <- length(xlevels[[contrasts_list$variable[i]]])
    n_terms <- model_variables |>
      dplyr::filter(.data$variable == contrasts_list$variable[i]) |>
      nrow()

    if (n_levels == n_terms) {
      contrasts_list$contrasts[[i]] <- "no.contrast"
    } else if (
      is.character(model_contrasts[[i]]) &&
        length(is.character(model_contrasts[[i]]) == 1)
    ) {
      contrasts_list$contrasts[[i]] <- model_contrasts[[i]]
      if (model_contrasts[[i]] == "contr.treatment") {
        contrasts_list$reference[[i]] <- 1
      }
      if (model_contrasts[[i]] == "contr.SAS" || model_contrasts[[i]] == "contr.sum") {
        contrasts_list$reference[[i]] <- n_levels
      }
      if (model_contrasts[[i]] == "contr.sdif") {
        contrasts_list$reference[[i]] <- NA
      }
    } else if (all(model_contrasts[[i]] == stats::contr.treatment(n_levels))) {
      contrasts_list$contrasts[[i]] <- "contr.treatment"
      contrasts_list$reference[[i]] <- 1
    } else if (all(model_contrasts[[i]] == stats::contr.sum(n_levels))) {
      contrasts_list$contrasts[[i]] <- "contr.sum"
      contrasts_list$reference[[i]] <- n_levels
    } else if (all(model_contrasts[[i]] == stats::contr.helmert(n_levels))) {
      contrasts_list$contrasts[[i]] <- "contr.helmert"
    } else if (all(model_contrasts[[i]] == stats::contr.poly(n_levels))) {
      contrasts_list$contrasts[[i]] <- "contr.poly"
    } else if (all(model_contrasts[[i]] == stats::contr.SAS(n_levels))) {
      contrasts_list$contrasts[[i]] <- "contr.SAS"
      contrasts_list$reference[[i]] <- n_levels
    } else if (
      .assert_package("MASS", boolean = TRUE) &&
        all(model_contrasts[[i]] == MASS::contr.sdif(n_levels))
    ) {
      contrasts_list$contrasts[[i]] <- "contr.sdif"
      contrasts_list$reference[[i]] <- NA
    } else {
      for (j in 2:n_levels) { # testing treatment coding width different value for base variable
        if (all(model_contrasts[[i]] == stats::contr.treatment(n_levels, base = j))) {
          contrasts_list$contrasts[[i]] <- paste0("contr.treatment(base=", j, ")")
          contrasts_list$reference[[i]] <- j
        }
      }
    }

    # if still not found, just indicate custom contrast
    if (is.na(contrasts_list$contrasts[[i]])) {
      contrasts_list$contrasts[[i]] <- "custom"
    }
  }
  contrasts_list |>
    dplyr::mutate(
      contrasts_type = dplyr::case_when(
        .data$contrasts |> stringr::str_starts("contr.treatment") ~ "treatment",
        .data$contrasts == "contr.SAS" ~ "treatment",
        .data$contrasts == "contr.sum" ~ "sum",
        .data$contrasts == "contr.helmert" ~ "helmert",
        .data$contrasts == "contr.poly" ~ "poly",
        .data$contrasts == "contr.sdif" ~ "sdif",
        .data$contrasts == "no.contrast" ~ "no.contrast",
        TRUE ~ "other"
      )
    )
}
