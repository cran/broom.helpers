## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  rows.print = 25
)

# one of the functions below needs emmeans, so dont evaluate code check in vignette
# on old R versions where emmeans is not available
if (!rlang::is_installed("emmeans")) {
  knitr::opts_chunk$set(eval = FALSE)
}

## ----setup, warning=FALSE, message=FALSE--------------------------------------
library(broom.helpers)
library(gtsummary)
library(ggplot2)
library(dplyr)

# paged_table() was introduced only in rmarkdwon v1.2
print_table <- function(tab) {
  if (packageVersion("rmarkdown") >= "1.2") {
    rmarkdown::paged_table(tab)
  } else {
    knitr::kable(tab)
  }
}

## -----------------------------------------------------------------------------
model_logit <- glm(response ~ trt + grade, trial, family = binomial)
broom::tidy(model_logit)

## -----------------------------------------------------------------------------
tidy_forest <-
  model_logit |>
  # perform initial tidying of the model
  tidy_and_attach(exponentiate = TRUE, conf.int = TRUE) |>
  # adding in the reference row for categorical variables
  tidy_add_reference_rows() |>
  # adding a reference value to appear in plot
  tidy_add_estimate_to_reference_rows() |>
  # adding the variable labels
  tidy_add_term_labels() |>
  # removing intercept estimate from model
  tidy_remove_intercept()
tidy_forest

## ----warning=FALSE------------------------------------------------------------
tidy_forest |>
  mutate(
    plot_label = paste(var_label, label, sep = ":") |>
      forcats::fct_inorder() |>
      forcats::fct_rev()
  ) |>
  ggplot(aes(x = plot_label, y = estimate, ymin = conf.low, ymax = conf.high, color = variable)) +
  geom_hline(yintercept = 1, linetype = 2) +
  geom_pointrange() +
  coord_flip() +
  theme(legend.position = "none") +
  labs(
    y = "Odds Ratio",
    x = " ",
    title = "Forest Plot using broom.helpers"
  )

## -----------------------------------------------------------------------------
tidy_table <-
  model_logit |>
  # perform initial tidying of the model
  tidy_and_attach(exponentiate = TRUE, conf.int = TRUE) |>
  # adding in the reference row for categorical variables
  tidy_add_reference_rows() |>
  # adding the variable labels
  tidy_add_term_labels() |>
  # add header row
  tidy_add_header_rows() |>
  # removing intercept estimate from model
  tidy_remove_intercept()

# print summary table
options(knitr.kable.NA = "")
tidy_table |>
  # format model estimates
  select(label, estimate, conf.low, conf.high, p.value) |>
  mutate(across(all_of(c("estimate", "conf.low", "conf.high")), style_ratio)) |>
  mutate(across(p.value, style_pvalue)) |>
  print_table()

## -----------------------------------------------------------------------------
model_logit |>
  tidy_plus_plus(exponentiate = TRUE)

## -----------------------------------------------------------------------------
model_logit |>
  tidy_plus_plus(exponentiate = TRUE) |>
  print_table()

## -----------------------------------------------------------------------------
model_poly <- glm(response ~ poly(age, 3) + ttdeath, na.omit(trial), family = binomial)

model_poly |>
  tidy_plus_plus(
    exponentiate = TRUE,
    add_header_rows = TRUE,
    variable_labels = c(age = "Age in years")
  ) |>
  print_table()

## -----------------------------------------------------------------------------
model_poly2 <- glm(response ~ poly(age, 3, raw = TRUE) + ttdeath, na.omit(trial), family = binomial)

model_poly2 |>
  tidy_plus_plus(
    exponentiate = TRUE,
    add_header_rows = TRUE,
    variable_labels = c(age = "Age in years"),
    relabel_poly = TRUE
  ) |>
  print_table()

## -----------------------------------------------------------------------------
model_1 <- glm(
  response ~ stage + grade * trt,
  gtsummary::trial,
  family = binomial
)

model_1 |>
  tidy_and_attach(exponentiate = TRUE) |>
  tidy_add_reference_rows() |>
  tidy_add_estimate_to_reference_rows(exponentiate = TRUE) |>
  tidy_add_term_labels() |>
  print_table()

## -----------------------------------------------------------------------------
model_2 <- glm(
  response ~ stage + grade * trt,
  gtsummary::trial,
  family = binomial,
  contrasts = list(
    stage = contr.treatment(4, base = 3),
    grade = contr.treatment(3, base = 2),
    trt = contr.treatment(2, base = 2)
  )
)

model_2 |>
  tidy_and_attach(exponentiate = TRUE) |>
  tidy_add_reference_rows() |>
  tidy_add_estimate_to_reference_rows(exponentiate = TRUE) |>
  tidy_add_term_labels() |>
  print_table()

## -----------------------------------------------------------------------------
model_3 <- glm(
  response ~ stage + grade * trt,
  gtsummary::trial,
  family = binomial,
  contrasts = list(
    stage = contr.sum,
    grade = contr.sum,
    trt = contr.sum
  )
)

model_3 |>
  tidy_and_attach(exponentiate = TRUE) |>
  tidy_add_reference_rows() |>
  tidy_add_estimate_to_reference_rows(exponentiate = TRUE) |>
  tidy_add_term_labels() |>
  print_table()

## -----------------------------------------------------------------------------
model_4 <- glm(
  response ~ stage + grade * trt,
  gtsummary::trial,
  family = binomial,
  contrasts = list(
    stage = contr.poly,
    grade = contr.helmert,
    trt = contr.poly
  )
)

model_4 |>
  tidy_and_attach(exponentiate = TRUE) |>
  tidy_add_reference_rows() |>
  tidy_add_estimate_to_reference_rows(exponentiate = TRUE) |>
  tidy_add_term_labels() |>
  print_table()

## -----------------------------------------------------------------------------
model_logit <- glm(response ~ age + trt + grade, trial, family = binomial)

model_logit |>
  tidy_and_attach() |>
  tidy_add_pairwise_contrasts() |>
  print_table()

model_logit |>
  tidy_and_attach(exponentiate = TRUE) |>
  tidy_add_pairwise_contrasts() |>
  print_table()

model_logit |>
  tidy_and_attach(exponentiate = TRUE) |>
  tidy_add_pairwise_contrasts(pairwise_reverse = FALSE) |>
  print_table()

model_logit |>
  tidy_and_attach(exponentiate = TRUE) |>
  tidy_add_pairwise_contrasts(keep_model_terms = TRUE) |>
  print_table()

## ----echo=FALSE---------------------------------------------------------------
# nolint start
tibble::tribble(
  ~Column, ~Function, ~Description,
  "original_term", "`tidy_disambiguate_terms()`, `tidy_multgee()`, `tidy_zeroinfl()` or `tidy_identify_variables()`", "Original term before disambiguation. This columns is added only when disambiguation is needed (i.e. for mixed models). Also used for \"multgee\", \"zeroinfl\" and \"hurdle\" models. For instrumental variables in \"fixest\" models, the \"fit_\" prefix is removed, and the original terms is stored in this column.",
  "variable", "`tidy_identify_variables()`", "String of variable names from the model. For categorical variables and polynomial terms defined with `stats::poly()`, terms belonging to the variable are identified.",
  "var_class", "`tidy_identify_variables()`", "Class of the variable.",
  "var_type", "`tidy_identify_variables()`", "One of \"intercept\", \"continuous\", \"dichotomous\", \"categorical\", \"interaction\", \"ran_pars\" or \"ran_vals\"",
  "var_nlevels", "`tidy_identify_variables()`", "Number of original levels for categorical variables",
  "contrasts", "`tidy_add_contrasts()`", "Contrasts used for categorical variables.<br /><em>Require \"variable\" column. If needed, will automatically apply `tidy_identify_variables()`.</em>",
  "contrasts_type", "`tidy_add_contrasts()`", "Type of contrasts (\"treatment\", \"sum\", \"poly\", \"helmert\", \"sdif\", \"other\" or \"no.contrast\"). \"pairwise\ is used for pairwise contrasts computed with `tidy_add_pairwise_contrasts()`.",
  "reference_row", "`tidy_add_reference_rows()`", "Logical indicating if a row is a reference row for categorical variables using a treatment or a sum contrast. Is equal to `NA` for variables who do not have a reference row.<br /><em>Require \"contrasts\" column. If needed, will automatically apply `tidy_add_contrasts()`.<br />`tidy_add_reference_rows()` will not populate the label of the reference term. It is therefore better to apply `tidy_add_term_labels()` after `tidy_add_reference_rows()` rather than before.</em>",
  "var_label", "`tidy_add_variable_labels()`", "String of variable labels from the model. Columns labelled with the `labelled` package are retained. It is possible to pass a custom label for an interaction term with the `labels` argument. <br /><em>Require \"variable\" column. If needed, will automatically apply `tidy_identify_variables()`.",
  "label", "`tidy_add_term_labels()`", "String of term labels based on (1) labels provided in `labels` argument if provided; (2) factor levels for categorical variables coded with treatment, SAS or sum contrasts; (3) variable labels when there is only one term per variable; and (4) term name otherwise.<br /><em>Require \"variable_label\" column. If needed, will automatically apply `tidy_add_variable_labels()`.<br />Require \"contrasts\" column. If needed, will automatically apply `tidy_add_contrasts()`.</em>",
  "header_row", "`tidy_add_header_rows()`", "Logical indicating if a row is a header row for variables with several terms. Is equal to `NA` for variables who do not have an header row.</br><em>Require \"label\" column. If needed, will automatically apply `tidy_add_term_labels()`.<br />It is better to apply `tidy_add_header_rows()` after other `tidy_*` functions</em>",
  "n_obs", "`tidy_add_n()`", "Number of observations",
  "n_ind", "`tidy_add_n()`", "Number of individuals (for Cox models)",
  "n_event", "`tidy_add_n()`", "Number of events (for binomial and multinomial logistic models, Poisson and Cox models)",
  "exposure", "`tidy_add_n()`", "Exposure time (for Poisson and Cox models)",
  "instrumental", "`tidy_identify_variables()`", "For \"fixest\" models, indicate if a variable was instrumental.",
  "group_by", "`tidy_group_by()`", "Grouping variable (particularly for multinomial or multi-components models).",
) |>
  dplyr::arrange(Column, .locale = "en") |> 
  gt::gt() |>
  gt::fmt_markdown(columns = everything()) |>
  gt::tab_options(
    column_labels.font.weight = "bold"
  ) |>
  gt::opt_row_striping() |>
  gt::tab_style("vertical-align:top; font-size: 12px;", gt::cells_body())
# nolint end

## ----echo=FALSE---------------------------------------------------------------
tibble::tribble(
  ~Attribute, ~Function, ~Description,
  "exponentiate", "`tidy_and_attach()`", "Indicates if estimates were exponentiated",
  "conf.level", "`tidy_and_attach()`", "Level of confidence used for confidence intervals",
  "coefficients_type", "`tidy_add_coefficients_type()`", "Type of coefficients",
  "coefficients_label", "`tidy_add_coefficients_type()`", "Coefficients label",
  "variable_labels", "`tidy_add_variable_labels()`",
  "Custom variable labels passed to `tidy_add_variable_labels()`",
  "term_labels", "`tidy_add_term_labels()`",
  "Custom term labels passed to `tidy_add_term_labels()`",
  "N_obs", "`tidy_add_n()`", "Total number of observations",
  "N_event", "`tidy_add_n()`", "Total number of events",
  "N_ind", "`tidy_add_n()`", "Total number of individuals (for Cox models)",
  "Exposure", "`tidy_add_n()`", "Total of exposure time",
  "component", "`tidy_zeroinfl()`", "`component` argument passed to `tidy_zeroinfl()`"
) |>
  dplyr::arrange(Attribute, .locale = "en") |>
  gt::gt() |>
  gt::fmt_markdown(columns = everything()) |>
  gt::tab_options(column_labels.font.weight = "bold") |>
  gt::opt_row_striping() |>
  gt::tab_style("vertical-align:top; font-size: 12px;", gt::cells_body())

## ----echo=FALSE---------------------------------------------------------------
supported_models |>
  dplyr::rename_with(stringr::str_to_title) |>
  gt::gt() |>
  gt::fmt_markdown(columns = everything()) |>
  gt::tab_options(column_labels.font.weight = "bold") |>
  gt::opt_row_striping() |>
  gt::tab_style("vertical-align:top; font-size: 12px;", gt::cells_body())

