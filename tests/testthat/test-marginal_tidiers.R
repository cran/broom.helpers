test_that("tidy_margins()", {
  skip_on_cran()
  skip_if_not_installed("margins")

  mod <- lm(Petal.Length ~ Petal.Width + Species, data = iris)
  expect_error(
    t <- tidy_margins(mod),
    NA
  )
  expect_error(
    tidy_margins(mod, exponentiate = TRUE)
  )
  expect_error(
    res <- tidy_plus_plus(mod, tidy_fun = tidy_margins),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t) + 1 # due to adding ref row
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Average Marginal Effects"
  )
  expect_error(
    tidy_plus_plus(
      mod,
      tidy_fun = tidy_margins,
      add_pairwise_contrasts = TRUE
    )
  )
})

test_that("tidy_all_effects()", {
  skip_on_cran()
  skip_if_not_installed("effects")

  mod <- lm(Petal.Length ~ Petal.Width + Species, data = iris)
  expect_error(
    t <- tidy_all_effects(mod),
    NA
  )
  expect_error(
    tidy_all_effects(mod, exponentiate = TRUE)
  )
  expect_error(
    res <- tidy_plus_plus(mod, tidy_fun = tidy_all_effects),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Predictions at the Mean"
  )
  expect_error(
    tidy_plus_plus(
      mod,
      tidy_fun = tidy_all_effects,
      add_pairwise_contrasts = TRUE
    )
  )
})

test_that("tidy_ggpredict()", {
  skip_on_cran()
  skip_if_not_installed("ggeffects")

  mod <- lm(Petal.Length ~ Petal.Width + Species, data = iris)
  expect_error(
    t <- tidy_ggpredict(mod),
    NA
  )
  expect_error(
    tidy_ggpredict(mod, exponentiate = TRUE)
  )
  expect_error(
    res <- tidy_plus_plus(mod, tidy_fun = tidy_ggpredict),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Predictions"
  )
  expect_error(
    tidy_plus_plus(
      mod,
      tidy_fun = tidy_ggpredict,
      add_pairwise_contrasts = TRUE
    )
  )
})

test_that("tidy_marginal_predictions()", {
  skip_on_cran()
  skip_if_not_installed("marginaleffects")

  mod <- lm(Petal.Length ~ Petal.Width * Species + Sepal.Length, data = iris)
  expect_error(
    t <- tidy_marginal_predictions(mod),
    NA
  )
  expect_error(
    tidy_marginal_predictions(mod, exponentiate = TRUE)
  )
  expect_error(
    res <- tidy_plus_plus(mod, tidy_fun = tidy_marginal_predictions),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Average Marginal Predictions"
  )
  expect_true(any(res$var_type == "interaction"))
  expect_error(
    tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_predictions,
      add_pairwise_contrasts = TRUE
    )
  )

  expect_error(
    t <- tidy_marginal_predictions(mod, "no_interaction"),
    NA
  )
  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_predictions,
      variables_list = "no_interaction"
    ),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_false(any(res$var_type == "interaction"))

  expect_error(
    t <- tidy_marginal_predictions(mod, newdata = "mean"),
    NA
  )
  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_predictions,
      newdata = "mean"
    ),
    NA
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Predictions at the Mean"
  )

  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_predictions,
      newdata = "marginalmeans"
    ),
    NA
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Predictions at Marginal Means"
  )
  expect_type(
    p <- plot_marginal_predictions(mod),
    "list"
  )
  expect_length(p, 2)
  expect_type(
    p <- plot_marginal_predictions(mod, variables_list = "no_interaction"),
    "list"
  )
  expect_length(p, 3)
})

test_that("tidy_avg_slopes()", {
  skip_on_cran()
  skip_if_not_installed("marginaleffects")

  mod <- lm(Petal.Length ~ Petal.Width * Species + Sepal.Length, data = iris)
  expect_error(
    t <- tidy_avg_slopes(mod),
    NA
  )
  expect_error(
    tidy_avg_slopes(mod, exponentiate = TRUE)
  )
  expect_error(
    res <- tidy_plus_plus(mod, tidy_fun = tidy_avg_slopes),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Average Marginal Effects"
  )
  expect_error(
    tidy_plus_plus(
      mod,
      tidy_fun = tidy_avg_slopes,
      add_pairwise_contrasts = TRUE
    )
  )

  expect_error(
    t <- tidy_avg_slopes(mod, newdata = "mean"),
    NA
  )
  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_avg_slopes,
      newdata = "mean"
    ),
    NA
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Effects at the Mean"
  )

  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_avg_slopes,
      newdata = "marginalmeans"
    ),
    NA
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Effects at Marginal Means"
  )
})

test_that("tidy_marginal_contrasts()", {
  skip_on_cran()
  skip_if_not_installed("marginaleffects")

  mod <- lm(Petal.Length ~ Petal.Width * Species + Sepal.Length, data = iris)
  expect_error(
    t <- tidy_marginal_contrasts(mod),
    NA
  )
  expect_error(
    tidy_marginal_contrasts(mod, exponentiate = TRUE)
  )
  expect_error(
    res <- tidy_plus_plus(mod, tidy_fun = tidy_marginal_contrasts),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Average Marginal Contrasts"
  )
  expect_true(any(res$var_type == "interaction"))
  expect_error(
    tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_contrasts,
      add_pairwise_contrasts = TRUE
    )
  )

  expect_error(
    t <- tidy_marginal_contrasts(mod, "no_interaction"),
    NA
  )
  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_contrasts,
      variables_list = "no_interaction"
    ),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_false(any(res$var_type == "interaction"))

  expect_error(
    t <- tidy_marginal_contrasts(mod, newdata = "mean"),
    NA
  )
  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_contrasts,
      newdata = "mean"
    ),
    NA
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Contrasts at the Mean"
  )

  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_contrasts,
      newdata = "marginalmeans"
    ),
    NA
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Contrasts at Marginal Means"
  )
})

test_that("tidy_marginal_means()", {
  skip_on_cran()
  skip_if_not_installed("marginaleffects")

  mod <- lm(Petal.Length ~ Petal.Width * Species + Sepal.Length, data = iris)
  expect_error(
    t <- tidy_marginal_means(mod),
    NA
  )
  expect_error(
    tidy_marginal_means(mod, exponentiate = TRUE)
  )
  expect_error(
    res <- tidy_plus_plus(mod, tidy_fun = tidy_marginal_means),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Means"
  )
  expect_error(
    tidy_plus_plus(
      mod,
      tidy_fun = tidy_marginal_means,
      add_pairwise_contrasts = TRUE
    )
  )
})

test_that("tidy_avg_comparisons()", {
  skip_on_cran()
  skip_if_not_installed("marginaleffects")

  mod <- lm(Petal.Length ~ Petal.Width * Species + Sepal.Length, data = iris)
  expect_error(
    t <- tidy_avg_comparisons(mod),
    NA
  )
  expect_error(
    tidy_avg_comparisons(mod, exponentiate = TRUE)
  )
  expect_error(
    res <- tidy_plus_plus(mod, tidy_fun = tidy_avg_comparisons),
    NA
  )
  expect_equal(
    nrow(res),
    nrow(t)
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Average Marginal Contrasts"
  )
  expect_error(
    tidy_plus_plus(
      mod,
      tidy_fun = tidy_avg_comparisons,
      add_pairwise_contrasts = TRUE
    )
  )

  expect_error(
    t <- tidy_avg_comparisons(mod, newdata = "mean"),
    NA
  )
  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_avg_comparisons,
      newdata = "mean"
    ),
    NA
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Contrasts at the Mean"
  )

  expect_error(
    res <- tidy_plus_plus(
      mod,
      tidy_fun = tidy_avg_comparisons,
      newdata = "marginalmeans"
    ),
    NA
  )
  expect_equal(
    attr(res, "coefficients_label"),
    "Marginal Contrasts at Marginal Means"
  )
})