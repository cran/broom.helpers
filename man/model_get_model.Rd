% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model_get_model.R
\name{model_get_model}
\alias{model_get_model}
\alias{model_get_model.default}
\alias{model_get_model.mira}
\title{Get the model from model objects}
\usage{
model_get_model(model)

\method{model_get_model}{default}(model)

\method{model_get_model}{mira}(model)
}
\arguments{
\item{model}{(a model object, e.g. \code{glm})\cr
A model object.}
}
\description{
Most model objects are proper R model objects. There are, however, some
model objects that store the proper object internally (e.g. mice models).
This function extracts that model object in those cases.
}
\examples{
lm(hp ~ mpg + factor(cyl), mtcars) |>
  model_get_model()
}
\seealso{
Other model_helpers: 
\code{\link{model_compute_terms_contributions}()},
\code{\link{model_get_assign}()},
\code{\link{model_get_coefficients_type}()},
\code{\link{model_get_contrasts}()},
\code{\link{model_get_model_frame}()},
\code{\link{model_get_model_matrix}()},
\code{\link{model_get_n}()},
\code{\link{model_get_nlevels}()},
\code{\link{model_get_offset}()},
\code{\link{model_get_pairwise_contrasts}()},
\code{\link{model_get_response}()},
\code{\link{model_get_response_variable}()},
\code{\link{model_get_terms}()},
\code{\link{model_get_weights}()},
\code{\link{model_get_xlevels}()},
\code{\link{model_identify_variables}()},
\code{\link{model_list_contrasts}()},
\code{\link{model_list_higher_order_variables}()},
\code{\link{model_list_terms_levels}()},
\code{\link{model_list_variables}()}
}
\concept{model_helpers}
