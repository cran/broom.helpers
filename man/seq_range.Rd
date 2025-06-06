% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/broom.helpers-package.R
\name{seq_range}
\alias{seq_range}
\title{Sequence generation between min and max}
\usage{
seq_range(x, length.out = 25)
}
\arguments{
\item{x}{(\code{numeric})\cr
A numeric vector.}

\item{length.out}{(\code{integer})\cr
Desired length of the sequence (a positive integer).}
}
\value{
a numeric vector
}
\description{
Sequence generation between min and max
}
\details{
\code{seq_range(x, length.out)} is a shortcut for
\code{seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length.out = length.out)}
}
\examples{
seq_range(iris$Petal.Length)
}
