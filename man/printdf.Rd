% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/printls.R
\name{printdf}
\alias{printdf}
\title{Print data frame}
\usage{
printdf(
  x,
  pad = 0,
  spacing = 1,
  ddSci.dp = NULL,
  transpose = FALSE,
  justify = "right",
  colnames = TRUE,
  rownames = TRUE,
  column.col = rtHighlight$bold,
  row.col = silver,
  newline.pre = FALSE,
  newline = FALSE
)
}
\arguments{
\item{x}{data frame}

\item{pad}{Integer: Pad output with this many spaces. Default = 2}

\item{spacing}{Integer: Number of spaces between columns. Default = 1}

\item{ddSci.dp}{Integer: Number of decimal places to print using \link{ddSci}. Default = NULL for no
formatting}

\item{transpose}{Logical: If TRUE, transpose \code{x} before printing. Default = FALSE}

\item{justify}{Character: "right", "left". Default = "right"}

\item{colnames}{Logical: If TRUE, print column names. Default = TRUE}

\item{rownames}{Logical: If TRUE, print row names. Default = TRUE}

\item{column.col}{\code{crayon} color for printing column names. Default = \pkg{rtemis} default highlight}

\item{row.col}{\code{crayon} color for printing row names. Default = silver}

\item{newline.pre}{Logical: If TRUE, print a new line before printing data frame. Default = FALSE}

\item{newlin}{Logical: If TRUE, print a new line after printing data frame. Default = FALSE}
}
\description{
Pretty print a data frame
}
\details{
By design, numbers will not be justified, but using ddSci.dp will convert to characters,
which will be justified. This is intentional for internal use.
}
\author{
Efstathios D. Gennatas
}
