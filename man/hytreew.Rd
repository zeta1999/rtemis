% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hytreew.R
\name{hytreew}
\alias{hytreew}
\title{\code{rtemis internal}: Low-level Hybrid Tree procedure}
\usage{
hytreew(
  x,
  y,
  max.depth = 5,
  weights = rep(1, NROW(y)),
  init = mean(y),
  gamma = 0.1,
  shrinkage = 1,
  lin.type = "glmnet",
  cv.glmnet.nfolds = 5,
  which.cv.glmnet.lambda = "lambda.min",
  alpha = 1,
  lambda = 0.05,
  lambda.seq = NULL,
  minobsinnode = 2,
  minobsinnode.lin = 10,
  part.minsplit = 2,
  part.xval = 0,
  part.max.depth = 1,
  part.cp = 0,
  part.minbucket = 5,
  save.fitted = FALSE,
  verbose = TRUE,
  trace = 0,
  n.cores = rtCores
)
}
\arguments{
\item{x}{data.frame}

\item{y}{Numeric vector of outcome, i.e. dependent variable}

\item{max.depth}{[gS] Integer: Max depth of additive tree. Default = 3}

\item{weights}{Numeric vector: Weights for cases. For classification, \code{weights} takes precedence
over \code{ipw}, therefore set \code{weights = NULL} if using \code{ipw}.
Note: If \code{weight} are provided, \code{ipw} is not used. Leave NULL if setting \code{ipw = TRUE}. Default = NULL}

\item{lin.type}{String: "glmnet", "cv.glmnet" use the equivalent \code{glmnet} functions.
"lm.ridge" uses the MASS function of that name, "glm" uses \code{lm.fit},
"forward.stagewise" and "stepwise" use \code{lars::lars} with \code{type} defined accordingly}

\item{alpha}{[gS] Float: \code{lincoef} alpha Overrides \code{lincoef.params} alpha}

\item{lambda}{[gS] Float: \code{lincoef} lambda. Overrides \code{lincoef.params} lambda}

\item{minobsinnode}{[gS] Integer: Minimum N observations needed in node, before considering splitting}

\item{part.max.depth}{Integer: Max depth for each tree model within the additive tree}

\item{part.cp}{[gS] Float: Minimum complexity needed to allow split by \code{rpart}. Default = 0}

\item{verbose}{Logical: If TRUE, print summary to screen.}

\item{trace}{Integer: If higher than 0, will print more information to the console. Default = 0}
}
\description{
Train a Hybrid Tree for Regression
}
\details{
Note that lambda is treated differently by \code{glmnet::glmnet} and \code{MASS::lm.ridge}
}
\author{
Efstathios D. Gennatas
}
