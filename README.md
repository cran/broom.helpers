
<!-- README.md is generated from README.Rmd. Please edit that file -->

# broom.helpers <img src="man/figures/broom.helpers.png" align="right" width="120" />

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R build
status](https://github.com/larmarange/broom.helpers/workflows/R-CMD-check/badge.svg)](https://github.com/larmarange/broom.helpers/actions)
[![Codecov test
coverage](https://codecov.io/gh/larmarange/broom.helpers/branch/main/graph/badge.svg)](https://app.codecov.io/gh/larmarange/broom.helpers?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/broom.helpers)](https://CRAN.R-project.org/package=broom.helpers)
[![DOI](https://zenodo.org/badge/286680847.svg)](https://zenodo.org/badge/latestdoi/286680847)
<!-- badges: end -->

The broom.helpers package provides suite of functions to work with
regression model `broom::tidy()` tibbles.

The suite includes functions to group regression model terms by
variable, insert reference and header rows for categorical variables,
add variable labels, and more.

`broom.helpers` is used, in particular, by `gtsummary::tbl_regression()`
for producing [nice formatted tables of model
coefficients](https://www.danieldsjoberg.com/gtsummary/articles/tbl_regression.html)
and by `ggstats::ggcoef_model()` for [plotting model
coefficients](https://larmarange.github.io/ggstats/articles/ggcoef_model.html).

## Installation & Documentation

To install **stable version**:

``` r
install.packages("broom.helpers")
```

Documentation of stable version:
<https://larmarange.github.io/broom.helpers/>

To install **development version**:

``` r
remotes::install_github("larmarange/broom.helpers")
```

Documentation of development version:
<https://larmarange.github.io/broom.helpers/dev/>

## Examples

### all-in-one wrapper

``` r
mod1 <- lm(Sepal.Length ~ Sepal.Width + Species, data = iris)
library(broom.helpers)
ex1 <- mod1 %>% tidy_plus_plus()
ex1
#> # A tibble: 4 × 17
#>   term     varia…¹ var_l…² var_c…³ var_t…⁴ var_n…⁵ contr…⁶ contr…⁷ refer…⁸ label
#>   <chr>    <chr>   <chr>   <chr>   <chr>     <int> <chr>   <chr>   <lgl>   <chr>
#> 1 Sepal.W… Sepal.… Sepal.… numeric contin…      NA <NA>    <NA>    NA      Sepa…
#> 2 Species… Species Species factor  catego…       3 contr.… treatm… TRUE    seto…
#> 3 Species… Species Species factor  catego…       3 contr.… treatm… FALSE   vers…
#> 4 Species… Species Species factor  catego…       3 contr.… treatm… FALSE   virg…
#> # … with 7 more variables: n_obs <dbl>, estimate <dbl>, std.error <dbl>,
#> #   statistic <dbl>, p.value <dbl>, conf.low <dbl>, conf.high <dbl>, and
#> #   abbreviated variable names ¹​variable, ²​var_label, ³​var_class, ⁴​var_type,
#> #   ⁵​var_nlevels, ⁶​contrasts, ⁷​contrasts_type, ⁸​reference_row
dplyr::glimpse(ex1)
#> Rows: 4
#> Columns: 17
#> $ term           <chr> "Sepal.Width", "Speciessetosa", "Speciesversicolor", "S…
#> $ variable       <chr> "Sepal.Width", "Species", "Species", "Species"
#> $ var_label      <chr> "Sepal.Width", "Species", "Species", "Species"
#> $ var_class      <chr> "numeric", "factor", "factor", "factor"
#> $ var_type       <chr> "continuous", "categorical", "categorical", "categorica…
#> $ var_nlevels    <int> NA, 3, 3, 3
#> $ contrasts      <chr> NA, "contr.treatment", "contr.treatment", "contr.treatm…
#> $ contrasts_type <chr> NA, "treatment", "treatment", "treatment"
#> $ reference_row  <lgl> NA, TRUE, FALSE, FALSE
#> $ label          <chr> "Sepal.Width", "setosa", "versicolor", "virginica"
#> $ n_obs          <dbl> 150, 50, 50, 50
#> $ estimate       <dbl> 0.8035609, 0.0000000, 1.4587431, 1.9468166
#> $ std.error      <dbl> 0.1063390, NA, 0.1121079, 0.1000150
#> $ statistic      <dbl> 7.556598, NA, 13.011954, 19.465255
#> $ p.value        <dbl> 4.187340e-12, NA, 3.478232e-26, 2.094475e-42
#> $ conf.low       <dbl> 0.5933983, NA, 1.2371791, 1.7491525
#> $ conf.high      <dbl> 1.013723, NA, 1.680307, 2.144481

mod2 <- glm(
  response ~ poly(age, 3) + stage + grade * trt,
  na.omit(gtsummary::trial),
  family = binomial,
  contrasts = list(
    stage = contr.treatment(4, base = 3),
    grade = contr.sum
  )
)
ex2 <- mod2 %>% 
  tidy_plus_plus(
    exponentiate = TRUE,
    variable_labels = c(age = "Age (in years)"),
    add_header_rows = TRUE,
    show_single_row = "trt"
  )
ex2
#> # A tibble: 17 × 19
#>    term  varia…¹ var_l…² var_c…³ var_t…⁴ var_n…⁵ heade…⁶ contr…⁷ contr…⁸ refer…⁹
#>    <chr> <chr>   <chr>   <chr>   <chr>     <int> <lgl>   <chr>   <chr>   <lgl>  
#>  1 <NA>  age     Age (i… nmatri… contin…      NA TRUE    <NA>    <NA>    NA     
#>  2 poly… age     Age (i… nmatri… contin…      NA FALSE   <NA>    <NA>    NA     
#>  3 poly… age     Age (i… nmatri… contin…      NA FALSE   <NA>    <NA>    NA     
#>  4 poly… age     Age (i… nmatri… contin…      NA FALSE   <NA>    <NA>    NA     
#>  5 <NA>  stage   T Stage factor  catego…       4 TRUE    contr.… treatm… NA     
#>  6 stag… stage   T Stage factor  catego…       4 FALSE   contr.… treatm… FALSE  
#>  7 stag… stage   T Stage factor  catego…       4 FALSE   contr.… treatm… FALSE  
#>  8 stag… stage   T Stage factor  catego…       4 FALSE   contr.… treatm… TRUE   
#>  9 stag… stage   T Stage factor  catego…       4 FALSE   contr.… treatm… FALSE  
#> 10 <NA>  grade   Grade   factor  catego…       3 TRUE    contr.… sum     NA     
#> 11 grad… grade   Grade   factor  catego…       3 FALSE   contr.… sum     FALSE  
#> 12 grad… grade   Grade   factor  catego…       3 FALSE   contr.… sum     FALSE  
#> 13 grad… grade   Grade   factor  catego…       3 FALSE   contr.… sum     TRUE   
#> 14 trtD… trt     Chemot… charac… dichot…       2 NA      contr.… treatm… FALSE  
#> 15 <NA>  grade:… Grade … <NA>    intera…      NA TRUE    <NA>    <NA>    NA     
#> 16 grad… grade:… Grade … <NA>    intera…      NA FALSE   <NA>    <NA>    NA     
#> 17 grad… grade:… Grade … <NA>    intera…      NA FALSE   <NA>    <NA>    NA     
#> # … with 9 more variables: label <chr>, n_obs <dbl>, n_event <dbl>,
#> #   estimate <dbl>, std.error <dbl>, statistic <dbl>, p.value <dbl>,
#> #   conf.low <dbl>, conf.high <dbl>, and abbreviated variable names ¹​variable,
#> #   ²​var_label, ³​var_class, ⁴​var_type, ⁵​var_nlevels, ⁶​header_row, ⁷​contrasts,
#> #   ⁸​contrasts_type, ⁹​reference_row
dplyr::glimpse(ex2)
#> Rows: 17
#> Columns: 19
#> $ term           <chr> NA, "poly(age, 3)1", "poly(age, 3)2", "poly(age, 3)3", …
#> $ variable       <chr> "age", "age", "age", "age", "stage", "stage", "stage", …
#> $ var_label      <chr> "Age (in years)", "Age (in years)", "Age (in years)", "…
#> $ var_class      <chr> "nmatrix.3", "nmatrix.3", "nmatrix.3", "nmatrix.3", "fa…
#> $ var_type       <chr> "continuous", "continuous", "continuous", "continuous",…
#> $ var_nlevels    <int> NA, NA, NA, NA, 4, 4, 4, 4, 4, 3, 3, 3, 3, 2, NA, NA, NA
#> $ header_row     <lgl> TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, F…
#> $ contrasts      <chr> NA, NA, NA, NA, "contr.treatment(base=3)", "contr.treat…
#> $ contrasts_type <chr> NA, NA, NA, NA, "treatment", "treatment", "treatment", …
#> $ reference_row  <lgl> NA, NA, NA, NA, NA, FALSE, FALSE, TRUE, FALSE, NA, FALS…
#> $ label          <chr> "Age (in years)", "Age (in years)", "Age (in years)²", …
#> $ n_obs          <dbl> NA, 92, 56, 80, NA, 46, 50, 35, 42, NA, 63, 53, 57, 90,…
#> $ n_event        <dbl> NA, 31, 17, 22, NA, 17, 12, 13, 12, NA, 20, 16, 18, 30,…
#> $ estimate       <dbl> NA, 20.2416394, 1.2337899, 0.4931553, NA, 1.0047885, 0.…
#> $ std.error      <dbl> NA, 2.3254455, 2.3512842, 2.3936657, NA, 0.4959893, 0.5…
#> $ statistic      <dbl> NA, 1.29340459, 0.08935144, -0.29533409, NA, 0.00963137…
#> $ p.value        <dbl> NA, 0.1958712, 0.9288026, 0.7677387, NA, 0.9923154, 0.1…
#> $ conf.low       <dbl> NA, 0.225454425, 0.007493208, 0.004745694, NA, 0.379776…
#> $ conf.high      <dbl> NA, 2315.587655, 100.318341, 74.226179, NA, 2.683385, 1…
```

### fine control

``` r
ex3 <- mod1 %>%
  # perform initial tidying of model
  tidy_and_attach() %>%
  # add reference row
  tidy_add_reference_rows() %>%
  # add term labels
  tidy_add_term_labels() %>%
  # remove intercept
  tidy_remove_intercept
ex3
#> # A tibble: 4 × 16
#>   term     varia…¹ var_l…² var_c…³ var_t…⁴ var_n…⁵ contr…⁶ contr…⁷ refer…⁸ label
#>   <chr>    <chr>   <chr>   <chr>   <chr>     <int> <chr>   <chr>   <lgl>   <chr>
#> 1 Sepal.W… Sepal.… Sepal.… numeric contin…      NA <NA>    <NA>    NA      Sepa…
#> 2 Species… Species Species factor  catego…       3 contr.… treatm… TRUE    seto…
#> 3 Species… Species Species factor  catego…       3 contr.… treatm… FALSE   vers…
#> 4 Species… Species Species factor  catego…       3 contr.… treatm… FALSE   virg…
#> # … with 6 more variables: estimate <dbl>, std.error <dbl>, statistic <dbl>,
#> #   p.value <dbl>, conf.low <dbl>, conf.high <dbl>, and abbreviated variable
#> #   names ¹​variable, ²​var_label, ³​var_class, ⁴​var_type, ⁵​var_nlevels,
#> #   ⁶​contrasts, ⁷​contrasts_type, ⁸​reference_row
dplyr::glimpse(ex3)
#> Rows: 4
#> Columns: 16
#> $ term           <chr> "Sepal.Width", "Speciessetosa", "Speciesversicolor", "S…
#> $ variable       <chr> "Sepal.Width", "Species", "Species", "Species"
#> $ var_label      <chr> "Sepal.Width", "Species", "Species", "Species"
#> $ var_class      <chr> "numeric", "factor", "factor", "factor"
#> $ var_type       <chr> "continuous", "categorical", "categorical", "categorica…
#> $ var_nlevels    <int> NA, 3, 3, 3
#> $ contrasts      <chr> NA, "contr.treatment", "contr.treatment", "contr.treatm…
#> $ contrasts_type <chr> NA, "treatment", "treatment", "treatment"
#> $ reference_row  <lgl> NA, TRUE, FALSE, FALSE
#> $ label          <chr> "Sepal.Width", "setosa", "versicolor", "virginica"
#> $ estimate       <dbl> 0.8035609, NA, 1.4587431, 1.9468166
#> $ std.error      <dbl> 0.1063390, NA, 0.1121079, 0.1000150
#> $ statistic      <dbl> 7.556598, NA, 13.011954, 19.465255
#> $ p.value        <dbl> 4.187340e-12, NA, 3.478232e-26, 2.094475e-42
#> $ conf.low       <dbl> 0.5933983, NA, 1.2371791, 1.7491525
#> $ conf.high      <dbl> 1.013723, NA, 1.680307, 2.144481

ex4 <- mod2 %>%
  # perform initial tidying of model
  tidy_and_attach(exponentiate = TRUE) %>%
  # add variable labels, including a custom value for age
  tidy_add_variable_labels(labels = c(age = "Age in years")) %>%
  # add reference rows for categorical variables
  tidy_add_reference_rows() %>%
  # add a, estimate value of reference terms
  tidy_add_estimate_to_reference_rows(exponentiate = TRUE) %>%
  # add header rows for categorical variables
  tidy_add_header_rows()
ex4
#> # A tibble: 20 × 17
#>    term  varia…¹ var_l…² var_c…³ var_t…⁴ var_n…⁵ heade…⁶ contr…⁷ contr…⁸ refer…⁹
#>    <chr> <chr>   <chr>   <chr>   <chr>     <int> <lgl>   <chr>   <chr>   <lgl>  
#>  1 (Int… (Inter… (Inter… <NA>    interc…      NA NA      <NA>    <NA>    NA     
#>  2 <NA>  age     Age in… nmatri… contin…      NA TRUE    <NA>    <NA>    NA     
#>  3 poly… age     Age in… nmatri… contin…      NA FALSE   <NA>    <NA>    NA     
#>  4 poly… age     Age in… nmatri… contin…      NA FALSE   <NA>    <NA>    NA     
#>  5 poly… age     Age in… nmatri… contin…      NA FALSE   <NA>    <NA>    NA     
#>  6 <NA>  stage   T Stage factor  catego…       4 TRUE    contr.… treatm… NA     
#>  7 stag… stage   T Stage factor  catego…       4 FALSE   contr.… treatm… FALSE  
#>  8 stag… stage   T Stage factor  catego…       4 FALSE   contr.… treatm… FALSE  
#>  9 stag… stage   T Stage factor  catego…       4 FALSE   contr.… treatm… TRUE   
#> 10 stag… stage   T Stage factor  catego…       4 FALSE   contr.… treatm… FALSE  
#> 11 <NA>  grade   Grade   factor  catego…       3 TRUE    contr.… sum     NA     
#> 12 grad… grade   Grade   factor  catego…       3 FALSE   contr.… sum     FALSE  
#> 13 grad… grade   Grade   factor  catego…       3 FALSE   contr.… sum     FALSE  
#> 14 grad… grade   Grade   factor  catego…       3 FALSE   contr.… sum     TRUE   
#> 15 <NA>  trt     Chemot… charac… dichot…       2 TRUE    contr.… treatm… NA     
#> 16 trtD… trt     Chemot… charac… dichot…       2 FALSE   contr.… treatm… TRUE   
#> 17 trtD… trt     Chemot… charac… dichot…       2 FALSE   contr.… treatm… FALSE  
#> 18 <NA>  grade:… Grade … <NA>    intera…      NA TRUE    <NA>    <NA>    NA     
#> 19 grad… grade:… Grade … <NA>    intera…      NA FALSE   <NA>    <NA>    NA     
#> 20 grad… grade:… Grade … <NA>    intera…      NA FALSE   <NA>    <NA>    NA     
#> # … with 7 more variables: label <chr>, estimate <dbl>, std.error <dbl>,
#> #   statistic <dbl>, p.value <dbl>, conf.low <dbl>, conf.high <dbl>, and
#> #   abbreviated variable names ¹​variable, ²​var_label, ³​var_class, ⁴​var_type,
#> #   ⁵​var_nlevels, ⁶​header_row, ⁷​contrasts, ⁸​contrasts_type, ⁹​reference_row
dplyr::glimpse(ex4)
#> Rows: 20
#> Columns: 17
#> $ term           <chr> "(Intercept)", NA, "poly(age, 3)1", "poly(age, 3)2", "p…
#> $ variable       <chr> "(Intercept)", "age", "age", "age", "age", "stage", "st…
#> $ var_label      <chr> "(Intercept)", "Age in years", "Age in years", "Age in …
#> $ var_class      <chr> NA, "nmatrix.3", "nmatrix.3", "nmatrix.3", "nmatrix.3",…
#> $ var_type       <chr> "intercept", "continuous", "continuous", "continuous", …
#> $ var_nlevels    <int> NA, NA, NA, NA, NA, 4, 4, 4, 4, 4, 3, 3, 3, 3, 2, 2, 2,…
#> $ header_row     <lgl> NA, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALS…
#> $ contrasts      <chr> NA, NA, NA, NA, NA, "contr.treatment(base=3)", "contr.t…
#> $ contrasts_type <chr> NA, NA, NA, NA, NA, "treatment", "treatment", "treatmen…
#> $ reference_row  <lgl> NA, NA, NA, NA, NA, NA, FALSE, FALSE, TRUE, FALSE, NA, …
#> $ label          <chr> "(Intercept)", "Age in years", "Age in years", "Age in …
#> $ estimate       <dbl> 0.5266376, NA, 20.2416394, 1.2337899, 0.4931553, NA, 1.…
#> $ std.error      <dbl> 0.4130930, NA, 2.3254455, 2.3512842, 2.3936657, NA, 0.4…
#> $ statistic      <dbl> -1.55229592, NA, 1.29340459, 0.08935144, -0.29533409, N…
#> $ p.value        <dbl> 0.1205914, NA, 0.1958712, 0.9288026, 0.7677387, NA, 0.9…
#> $ conf.low       <dbl> 0.227717775, NA, 0.225454425, 0.007493208, 0.004745694,…
#> $ conf.high      <dbl> 1.164600, NA, 2315.587655, 100.318341, 74.226179, NA, 2…
```
