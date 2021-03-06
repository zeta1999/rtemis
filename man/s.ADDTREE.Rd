% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/s.ADDTREE.R
\name{s.ADDTREE}
\alias{s.ADDTREE}
\title{Additive Tree: Tree-Structured Boosting [C]}
\usage{
s.ADDTREE(
  x,
  y = NULL,
  x.test = NULL,
  y.test = NULL,
  x.name = NULL,
  y.name = NULL,
  weights = NULL,
  update = c("exponential", "polynomial"),
  min.update = ifelse(update == "polynomial", 0.035, 1000),
  min.hessian = 0.001,
  min.membership = 1,
  steps.past.min.membership = 0,
  gamma = 0.8,
  max.depth = 30,
  learning.rate = 0.1,
  ipw = TRUE,
  ipw.type = 2,
  upsample = FALSE,
  downsample = FALSE,
  resample.seed = NULL,
  imetrics = TRUE,
  grid.resample.rtset = rtset.resample("kfold", 5),
  metric = "Balanced Accuracy",
  maximize = TRUE,
  rpart.parms = NULL,
  match.rules = TRUE,
  print.plot = TRUE,
  plot.fitted = NULL,
  plot.predicted = NULL,
  plot.theme = getOption("rt.fit.theme", "lightgrid"),
  question = NULL,
  rtclass = NULL,
  verbose = TRUE,
  prune.verbose = FALSE,
  trace = 1,
  grid.verbose = TRUE,
  diagnostics = FALSE,
  outdir = NULL,
  save.rpart = FALSE,
  save.mod = ifelse(!is.null(outdir), TRUE, FALSE),
  n.cores = rtCores,
  ...
)
}
\arguments{
\item{x}{N x D matrix of N examples with D features}

\item{y}{N x 1 vector of labels with values in {-1,1}}

\item{x.test}{Numeric vector or matrix / data frame of testing set features
Columns must correspond to columns in \code{x}}

\item{y.test}{Numeric vector of testing set outcome}

\item{x.name}{Character: Name for feature set}

\item{y.name}{Character: Name for outcome}

\item{weights}{Numeric vector: Weights for cases. For classification, \code{weights} takes precedence
over \code{ipw}, therefore set \code{weights = NULL} if using \code{ipw}.
Note: If \code{weight} are provided, \code{ipw} is not used. Leave NULL if setting \code{ipw = TRUE}. Default = NULL}

\item{min.hessian}{[gS] Minimum second derivative to continue splitting. Default = .001}

\item{min.membership}{Integer: Minimum number of cases in a node. Default = 1}

\item{gamma}{[gS] acceleration factor = lambda / (1 + lambda). Default = .8}

\item{max.depth}{[gS] maximum depth of the tree. Default = 30}

\item{learning.rate}{[gS] learning rate for the Newton Raphson step that updates the function values
of the node}

\item{ipw}{Logical: If TRUE, apply inverse probability weighting (for Classification only).
Note: If \code{weights} are provided, \code{ipw} is not used. Default = TRUE}

\item{ipw.type}{Integer {0, 1, 2}
1: class.weights as in 0, divided by max(class.weights)
2: class.weights as in 0, divided by min(class.weights)
Default = 2}

\item{upsample}{Logical: If TRUE, upsample cases to balance outcome classes (for Classification only)
Caution: upsample will randomly sample with replacement if the length of the majority class is more than double
the length of the class you are upsampling, thereby introducing randomness}

\item{resample.seed}{Integer: If provided, will be used to set the seed during upsampling.
Default = NULL (random seed)}

\item{match.rules}{Logical: If TRUE, match cases to rules to get statistics per node, i.e. what
percent of cases match each rule. If available, these are used by \link{dplot3.addtree} when plotting. Default = TRUE}

\item{print.plot}{Logical: if TRUE, produce plot using \code{mplot3}
Takes precedence over \code{plot.fitted} and \code{plot.predicted}. Default = TRUE}

\item{plot.fitted}{Logical: if TRUE, plot True (y) vs Fitted}

\item{plot.predicted}{Logical: if TRUE, plot True (y.test) vs Predicted.
Requires \code{x.test} and \code{y.test}}

\item{plot.theme}{Character: "zero", "dark", "box", "darkbox"}

\item{question}{Character: the question you are attempting to answer with this model, in plain language.}

\item{rtclass}{Character: Class type to use. "S3", "S4", "RC", "R6"}

\item{verbose}{Logical: If TRUE, print summary to screen.}

\item{trace}{Integer: If higher than 0, will print more information to the console. Default = 0}

\item{outdir}{Path to output directory.
If defined, will save Predicted vs. True plot, if available,
as well as full model output, if \code{save.mod} is TRUE}

\item{save.mod}{Logical: If TRUE, save all output to an RDS file in \code{outdir}
\code{save.mod} is TRUE by default if an \code{outdir} is defined. If set to TRUE, and no \code{outdir}
is defined, outdir defaults to \code{paste0("./s.", mod.name)}}

\item{...}{Additional arguments}

\item{catPredictors}{Logical vector with the same length as the feature vector, where TRUE
means that the corresponding column of x is a categorical variable}
}
\value{
Object of class \link{rtMod}
}
\description{
Train an Additive Tree model
}
\details{
This function is for binary classification. The outcome must be a factor with two levels, the first level
is the 'positive' class. Ensure there are no missing values in the data and that variables are either numeric
(including integers) or factors. Use \link{preprocess} as needed to impute and convert characters to factors.

Factor levels should not contain the "/" character (it is used to separate conditions
in the addtree object)

[gS] Indicates that more than one value can be supplied, which will result in grid search using
internal resampling
lambda <- gamma/(1 - gamma)
}
\references{
Jose Marcio Luna, Efstathios D Gennatas, Lyle H Ungar, Eric Eaton, Eric S Diffenderfer, Shane T Jensen,
Charles B Simone, Jerome H Friedman, Timothy D Solberg, Gilmer Valdes
Building more accurate decision trees with the additive tree
Proc Natl Acad Sci U S A. 2019 Oct 1;116(40):19887-19893. doi: 10.1073/pnas.1816748116
}
\seealso{
Other Supervised Learning: 
\code{\link{s.ADABOOST}()},
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
\code{\link{s.MARS}()},
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

Other Tree-based methods: 
\code{\link{s.ADABOOST}()},
\code{\link{s.BART}()},
\code{\link{s.C50}()},
\code{\link{s.CART}()},
\code{\link{s.CTREE}()},
\code{\link{s.ET}()},
\code{\link{s.EVTREE}()},
\code{\link{s.GBM3}()},
\code{\link{s.GBM}()},
\code{\link{s.H2OGBM}()},
\code{\link{s.H2ORF}()},
\code{\link{s.IRF}()},
\code{\link{s.MLRF}()},
\code{\link{s.PPTREE}()},
\code{\link{s.RANGER}()},
\code{\link{s.RFSRC}()},
\code{\link{s.RF}()},
\code{\link{s.XGB}()}

Other Interpretable models: 
\code{\link{s.C50}()},
\code{\link{s.CART}()},
\code{\link{s.GLMNET}()},
\code{\link{s.GLM}()}
}
\author{
Efstathios D. Gennatas
}
\concept{Interpretable models}
\concept{Supervised Learning}
\concept{Tree-based methods}
