# nCr.R
# ::rtemis::
# 2016 Efstathios D. Gennatas egenn.lambdamd.org

#' n Choose r
#'
#' Calculate number of combinations
#'
#' In plain language:
#'   You have \code{n} items. How many different cobinations of \code{r} items can you make?
#'
#' @param n Integer: Total number of items
#' @param r Integer: Number of items in each combination
#' @return Integer: Number of combinations
#' @author Efstathios D Gennatas
#' @export

nCr <- function(n, r) {

  if (n < r) {
    0
  } else {
    factorial(n) / (factorial(r) * factorial(n - r))
  }

} # rtemis::nCr
