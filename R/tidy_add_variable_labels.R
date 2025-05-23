#' Add variable labels
#'
#' Will add variable labels in a `var_label` column, based on:
#' 1. labels provided in `labels` argument if provided;
#' 2. variable labels defined in the original data frame with
#'    the `label` attribute (cf. [labelled::var_label()]);
#' 3. variable name otherwise.
#'
#' @details
#' If the `variable` column is not yet available in `x`,
#' [tidy_identify_variables()] will be automatically applied.
#'
#' It is possible to pass a custom label for an interaction
#' term in `labels` (see examples).
#' @param x (`data.frame`)\cr
#' A tidy tibble as produced by `tidy_*()` functions.
#' @param labels ([`formula-list-selector`][gtsummary::syntax])\cr
#' An optional named list or a named vector of custom variable labels.
#' @param instrumental_suffix (`string`)\cr
#' Suffix added to variable labels for instrumental variables (`fixest` models).
#' `NULL` to add nothing.
#' @param model (a model object, e.g. `glm`)\cr
#' The corresponding model, if not attached to `x`.
#' @inheritParams tidy_plus_plus
#' @export
#' @family tidy_helpers
#' @examples
#' df <- Titanic |>
#'   dplyr::as_tibble() |>
#'   dplyr::mutate(Survived = factor(Survived, c("No", "Yes"))) |>
#'   labelled::set_variable_labels(
#'     Class = "Passenger's class",
#'     Sex = "Sex"
#'   )
#'
#' glm(Survived ~ Class * Age * Sex, data = df, weights = df$n, family = binomial) |>
#'   tidy_and_attach() |>
#'   tidy_add_variable_labels(
#'     labels = list(
#'       "(Intercept)" ~ "Custom intercept",
#'       Sex ~ "Gender",
#'       "Class:Age" ~ "Custom label"
#'     )
#'   )
tidy_add_variable_labels <- function(x,
                                     labels = NULL,
                                     interaction_sep = " * ",
                                     instrumental_suffix = " (instrumental)",
                                     model = tidy_get_model(x)) {
  if (is.null(model)) {
    cli::cli_abort(c(
      "{.arg model} is not provided.",
      "You need to pass it or to use {.fn tidy_and_attach}."
    ))
  }

  if ("header_row" %in% names(x)) {
    cli::cli_abort(paste(
      "{.fn tidy_add_variable_labels} cannot be applied",
      "after {.fn tidy_add_header_rows}."
    ))
  }

  .attributes <- .save_attributes(x)

  if ("var_label" %in% names(x)) {
    x <- x |> dplyr::select(-dplyr::all_of("var_label"))
  }

  if (!"variable" %in% names(x) || !"var_type" %in% names(x)) {
    x <- x |> tidy_identify_variables(model = model)
  }

  if (is.atomic(labels)) labels <- as.list(labels) # vectors allowed
  cards::process_formula_selectors(
    data = scope_tidy(x),
    labels = labels
  )
  labels <- unlist(labels)

  # start with the list of terms
  var_labels <- unique(x$term)
  names(var_labels) <- var_labels

  # add the list of variables from x
  additional_labels <- x$variable[!is.na(x$variable)] |> unique()
  names(additional_labels) <- additional_labels
  var_labels <- var_labels |>
    .update_vector(additional_labels)

  # add the list of variables from model_list_variables
  variable_list <- model_list_variables(
    model,
    labels = labels,
    instrumental_suffix = instrumental_suffix
  )
  additional_labels <- variable_list$var_label
  names(additional_labels) <- variable_list$variable
  var_labels <- var_labels |>
    .update_vector(additional_labels)

  var_labels <- var_labels |>
    .update_vector(labels)

  # save custom labels
  .attributes$variable_labels <- labels

  # management of interaction terms
  interaction_terms <- x$variable[!is.na(x$var_type) & x$var_type == "interaction"]
  # do not treat those specified in labels
  interaction_terms <- setdiff(interaction_terms, names(labels))
  names(interaction_terms) <- interaction_terms
  # compute labels for interaction terms
  interaction_terms <- interaction_terms |>
    strsplit(":") |>
    lapply(function(x) {
      paste(var_labels[x], collapse = interaction_sep)
    }) |>
    unlist()
  var_labels <- var_labels |> .update_vector(interaction_terms)

  x |>
    dplyr::left_join(
      tibble::tibble(
        variable = names(var_labels),
        var_label = var_labels
      ),
      by = "variable"
    ) |>
    tidy_attach_model(model = model, .attributes = .attributes)
}
