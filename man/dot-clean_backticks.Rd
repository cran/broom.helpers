% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{.clean_backticks}
\alias{.clean_backticks}
\title{Remove backticks around variable names}
\usage{
.clean_backticks(x, variable_names = x)
}
\arguments{
\item{x}{a character vector to be cleaned}

\item{variable_names}{list of variable names,
could be obtained with
\link[=model_list_variables]{model_list_variables(only_variable = TRUE)}
to properly take into account interaction only terms/variables}
}
\description{
Remove backticks around variable names
}
\seealso{
Other other_helpers: 
\code{\link{.escape_regex}()}
}
\concept{other_helpers}
