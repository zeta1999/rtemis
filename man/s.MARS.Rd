% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/s.MARS.R
\name{s.MARS}
\alias{s.MARS}
\title{Multivariate adaptive regression splines (MARS) [C, R]}
\usage{
s.MARS(
  x,
  y = NULL,
  x.test = NULL,
  y.test = NULL,
  x.name = NULL,
  y.name = NULL,
  grid.resample.rtset = rtset.grid.resample(),
  weights = NULL,
  ipw = TRUE,
  ipw.type = 2,
  upsample = FALSE,
  downsample = FALSE,
  resample.seed = NULL,
  glm = NULL,
  degree = 2,
  penalty = 3,
  nk = NULL,
  thresh = 0,
  minspan = 0,
  endspan = 0,
  newvar.penalty = 0,
  fast.k = 2,
  fast.beta = 1,
  linpreds = FALSE,
  pmethod = "forward",
  nprune = NULL,
  nfold = 4,
  ncross = 1,
  stratify = TRUE,
  wp = NULL,
  na.action = na.fail,
  metric = NULL,
  maximize = NULL,
  n.cores = rtCores,
  print.plot = TRUE,
  plot.fitted = NULL,
  plot.predicted = NULL,
  plot.theme = getOption("rt.fit.theme", "lightgrid"),
  question = NULL,
  verbose = TRUE,
  trace = 0,
  save.mod = FALSE,
  outdir = NULL,
  ...
)
}
\arguments{
\item{x}{Numeric vector or matrix of features, i.e. independent variables}

\item{y}{Numeric vector of outcome, i.e. dependent variable}

\item{x.test}{(Optional) Numeric vector or matrix of validation set features
must have set of columns as \code{x}}

\item{y.test}{(Optional) Numeric vector of validation set outcomes}

\item{degree}{[gS] Integer: Maximum degree of interaction. Default = 2}

\item{penalty}{[gS] Float: GCV penalty per knot. 0 penalizes only terms, not knots.
-1 means no penalty. Default = 3}

\item{nk}{[gS] Integer: Maximum number of terms created by the forward pass.
See \code{earth::earth}}

\item{pmethod}{[gS] Character: Pruning method: "backward", "none", "exhaustive", "forward",
"seqrep", "cv". Default = "forward"}

\item{nprune}{[gS] Integer: Max N of terms (incl. intercept) in the pruned model}

\item{...}{Additional parameters to pass to \code{earth::earth}}
}
\value{
Object of class \link{rtMod}
}
\description{
Trains a MARS model using \code{earth::earth}.
[gS] in Arguments description indicates that hyperparameter will be tuned if more than one value are provided
For more info on algorithm hyperparameters, see \code{?earth::earth}
}
\seealso{
\link{elevate} for external cross-validation

Other Supervised Learning: 
\code{\link{s.ADABOOST}()},
\code{\link{s.ADDTREE}()},
\code{\link{s.BART}()},
\code{\link{s.BAYESGLM}()},
\code{\link{s.BRUTO}()},
\code{\link{s.C50}()},
\code{\link{s.CART}()},
\code{\link{s.CTREE}()},
\code{\link{s.DA}()},
\code{\link{s.ET}()},
\code{\link{s.EVTREE}()},
\code{\link{s.GAM.default}()},
\code{\link{s.GAM.formula}()},
\code{\link{s.GAMSELX2}()},
\code{\link{s.GAMSELX}()},
\code{\link{s.GAMSEL}()},
\code{\link{s.GAM}()},
\code{\link{s.GBM3}()},
\code{\link{s.GBM}()},
\code{\link{s.GLMNET}()},
\code{\link{s.GLM}()},
\code{\link{s.GLS}()},
\code{\link{s.H2ODL}()},
\code{\link{s.H2OGBM}()},
\code{\link{s.H2ORF}()},
\code{\link{s.IRF}()},
\code{\link{s.KNN}()},
\code{\link{s.LDA}()},
\code{\link{s.LM}()},
\code{\link{s.MLRF}()},
\code{\link{s.NBAYES}()},
\code{\link{s.NLA}()},
\code{\link{s.NLS}()},
\code{\link{s.NW}()},
\code{\link{s.POLYMARS}()},
\code{\link{s.PPR}()},
\code{\link{s.PPTREE}()},
\code{\link{s.QDA}()},
\code{\link{s.QRNN}()},
\code{\link{s.RANGER}()},
\code{\link{s.RFSRC}()},
\code{\link{s.RF}()},
\code{\link{s.SGD}()},
\code{\link{s.SPLS}()},
\code{\link{s.SVM}()},
\code{\link{s.TFN}()},
\code{\link{s.XGBLIN}()},
\code{\link{s.XGB}()}
}
\author{
Efstathios D. Gennatas
}
\concept{Supervised Learning}
