# s.NLS.R
# ::rtemis::
# 2018 Efstathios D. Gennatas egenn.lambdamd.org

#' Nonlinear Least Squares (NLS) [R]
#'
#' Build a NLS model
#'
#' @inheritParams s.GLM
#' @param ... Additional arguments to be passed to \code{nls}
#' @return Object of class \pkg{rtemis}
#' @author Efstathios D. Gennatas
#' @seealso \link{elevate} for external cross-validation
#' @family Supervised Learning
#' @export

s.NLS <- function(x, y = NULL,
                  x.test = NULL, y.test = NULL,
                  formula = NULL,
                  weights = NULL,
                  start = NULL,
                  control = nls.control(maxiter = 200),
                  .type = NULL,
                  default.start = .1,
                  algorithm = "default",
                  nls.trace = FALSE,
                  x.name = NULL, y.name = NULL,
                  save.func = TRUE,
                  print.plot = TRUE,
                  plot.fitted = NULL,
                  plot.predicted = NULL,
                  plot.theme = getOption("rt.fit.theme", "lightgrid"),
                  question = NULL,
                  rtclass = NULL,
                  verbose = TRUE,
                  trace = 0,
                  outdir = NULL,
                  save.mod = ifelse(!is.null(outdir), TRUE, FALSE), ...) {

  # [ INTRO ] ====
  if (missing(x)) {
    print(args(s.NLS))
    return(invisible(9))
  }
  if (!is.null(outdir)) outdir <- normalizePath(outdir, mustWork = FALSE)
  logFile <- if (!is.null(outdir)) {
    paste0(outdir, "/", sys.calls()[[1]][[1]], ".", format(Sys.time(), "%Y%m%d.%H%M%S"), ".log")
  } else {
    NULL
  }
  start.time <- intro(verbose = verbose, logFile = logFile)
  mod.name <- "NLS"

  # [ ARGUMENTS ] ====
  if (is.null(x.name)) x.name <- getName(x, "x")
  if (is.null(y.name)) y.name <- getName(y, "y")
  if (!verbose) print.plot <- FALSE
  verbose <- verbose | !is.null(logFile)
  if (save.mod & is.null(outdir)) outdir <- paste0("./s.", mod.name)
  if (!is.null(outdir)) outdir <- paste0(normalizePath(outdir, mustWork = FALSE), "/")

  # [ DATA ] ====
  dt <- dataPrepare(x, y, x.test, y.test)
  x <- dt$x
  y <- dt$y
  x.test <- dt$x.test
  y.test <- dt$y.test
  xnames <- dt$xnames
  type <- dt$type
  checkType(type, "Regression", mod.name)
  if (verbose) dataSummary(x, y, x.test, y.test, type)
  df <- data.frame(x, y = y)
  if (print.plot) {
    if (is.null(plot.fitted)) plot.fitted <- if (is.null(y.test)) TRUE else FALSE
    if (is.null(plot.predicted)) plot.predicted <- if (!is.null(y.test)) TRUE else FALSE
  } else {
    plot.fitted <- plot.predicted <- FALSE
  }

  # [ FORMULA ] ====
  if (is.null(.type)) {
    if (is.null(formula)) {
      feature.names <- colnames(df)[-NCOL(df)]
      weight.names <- paste0("w", seq(feature.names))
      formula <- as.formula(paste("y ~ b +", paste0(weight.names, "*", feature.names, collapse = " + ")))
      params <- getTerms2(formula, data = df)
      if (is.null(start)) {
        lincoefs <- lincoef(x, y)
        start <- as.list(lincoefs)
        names(start) <- params
      }
    }
    if (is.null(start)) {
      if (verbose) msg("Initializing all parameters as", default.start, newline.pre = TRUE)
      params <- getTerms2(formula, data = df)
      start <- lapply(seq(params), function(i) start[[i]] <- default.start)
      names(start) <- params
    }
  } else if (.type == "sig") {
    feature.names <- colnames(df)[-NCOL(df)]
    weight.names <- paste0("w", seq(feature.names))
    wxf <- paste0(weight.names, "*", feature.names, collapse = " + ")
    params <- c("b_o", "W_o", "b_h", weight.names)
    if (is.null(start)) {
      start <- lapply(seq(params), function(i) start[[i]] <- default.start)
      names(start) <- params
    }
    formula <- as.formula(paste0("y ~ b_o + W_o * sigmoid(b_h + ", wxf,")"))
  }

  # [ NLS ] ====
  if (verbose) msg("Training NLS model...", newline.pre = TRUE)
  mod <- nls(formula,
             data = df,
             start = start,
             control = control,
             algorithm = algorithm,
             trace = nls.trace, ...)
  if (trace > 0) print(summary(mod))


  if (save.func) {
    func <- as.character(formula)
    .func <- paste("y =", func[3])
    coefs <- coef(mod)
    for (i in seq(params)) {
      .func <- gsub(params[i], ddSci(coefs[params[i]]), .func)
    }
  }

  # [ FITTED ] ====
  fitted <- predict(mod, x)
  error.train <- modError(y, fitted)
  if (verbose) errorSummary(error.train, mod.name)

  # [ PREDICTED ] ====
  predicted <- error.test <- NULL
  if (!is.null(x.test)) {
    predicted <- predict(mod, x.test)
    if (!is.null(y.test)) {
      error.test <- modError(y.test, predicted)
      if (verbose) errorSummary(error.test, mod.name)
    }
  }

  # [ OUTRO ] ====
  extra <- list(formula = formula,
                .type = .type)
  if (save.func) extra$model <- .func
  rt <- rtModSet(rtclass = "rtMod",
                 mod = mod,
                 mod.name = mod.name,
                 type = type,
                 y.train = y,
                 y.test = y.test,
                 x.name = x.name,
                 y.name = y.name,
                 xnames = xnames,
                 fitted = fitted,
                 varimp = coef(mod),
                 se.fit = NULL,
                 error.train = error.train,
                 predicted = predicted,
                 se.prediction = NULL,
                 error.test = error.test,
                 question = question,
                 extra = extra)

  rtMod.out(rt,
            print.plot,
            plot.fitted,
            plot.predicted,
            y.test,
            mod.name,
            outdir,
            save.mod,
            verbose,
            plot.theme)

  outro(start.time, verbose = verbose, sinkOff = ifelse(is.null(logFile), FALSE, TRUE))
  rt

} # rtemis::s.NLS


#' Get terms of a formula
#'
#' @param formula formula with more than x & y, e.g. \code{y ~ b * m ^ x}

getTerms <- function(formula) {

  terms <- as.character(formula)
  if (length(terms) < 3) stop("Incorrect formula supplied")
  terms <- terms[3]
  terms <- strsplit(terms, "^")[[1]]
  terms[terms %in% letters[-24]]

} # rtemis::getTerms

getTerms2 <- function(formula, data = NULL) {

  terms <- as.character(formula)
  if (length(terms) < 3) stop("Incorrect formula supplied")
  terms <- terms[3]
  # Remove spaces
  terms <- gsub(" *", "", terms)
  # Replace anything not a letter or number
  terms <- gsub("[[:punct:]]", "#", terms)
  # Split terms
  terms <- strsplit(terms, "#")[[1]]
  # Exclude predictors from terms
  if (!is.null(data)) if (!is.null(colnames(data))) terms <- setdiff(terms, colnames(data))
  terms

} # rtemis::getTerms

s.POWER <- function(x, y,
                    x.test, y.test,
                    formula = y ~ b * m ^ x,
                    start = NULL,
                    control = nls.control(),
                    default.start = 1,
                    algorithm = "default",
                    x.name = NULL, y.name = NULL,
                    print.plot = TRUE,
                    plot.fitted = NULL,
                    plot.predicted = NULL,
                    plot.theme = getOption("rt.fit.theme", "lightgrid"),
                    question = NULL,
                    rtclass = NULL,
                    verbose = TRUE,
                    outdir = NULL,
                    save.mod = ifelse(!is.null(outdir), TRUE, FALSE), ...) {

  s.NLS(x, y,
        x.test, y.test,
        formula = formula,
        start = start,
        control = control,
        default.start = default.start,
        algorithm = algorithm,
        x.name = x.name, y.name = y.name,
        print.plot = print.plot,
        plot.fitted = plot.fitted,
        plot.predicted = plot.predicted,
        plot.theme = plot.theme,
        question = question,
        rtclass = rtclass,
        verbose = verbose,
        outdir = outdir,
        save.mod = save.mod, ...)

} # rtemis::s.POWER
