test_that("Attach and Detach models works", {
  mod <- lm(Sepal.Length ~ Sepal.Width + Species, data = iris)
  expect_identical(
    mod,
    mod |> tidy_and_attach(model_matrix_attr = FALSE) |> tidy_get_model()
  )

  tb <- broom::tidy(mod)
  expect_equal(
    tb,
    tb |> tidy_attach_model(mod) |> tidy_detach_model(),
    ignore_attr = TRUE
  )

  # an error should occur if 'exponentiate = TRUE' for a linear model
  expect_error(
    mod |> tidy_and_attach(exponentiate = TRUE)
  )
})

test_that("tidy_and_attach() handles models without exponentiate arguments", {
  skip_if_not_installed("lavaan")
  skip_on_cran()
  df <- lavaan::HolzingerSwineford1939
  df$grade <- factor(df$grade, ordered = TRUE)
  HS.model <- "visual  =~ x1 + x2 + x3
               textual =~ x4 + x5 + x6 + grade
               speed   =~ x7 + x8 + x9 "
  mod <- lavaan::lavaan(HS.model,
    data = df,
    auto.var = TRUE, auto.fix.first = TRUE,
    auto.cov.lv.x = TRUE
  )
  expect_error(mod |> tidy_and_attach(exponentiate = TRUE))
  expect_no_error(mod |> tidy_and_attach())
})
