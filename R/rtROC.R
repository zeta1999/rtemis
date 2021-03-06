# rtROC.R
# ::rtemis::
# 2018 Efstathios D. Gennatas egenn.lambdamd.org
# TODO: consider renaming to estimated.probabilities

#' Build an ROC curve
#'
#' Calculate the points of an ROC curve and the AUC
#'
#' \code{true.labels} should be a factor (will be coerced to one) where the first level is the
#' "positive" case. \code{predicted.probabilities} should be a vector of floats {0, 1} where \code{[0, .5)}
#' corresponds to the first level and \code{[.5, 1]} corresponds to the second level.
#' predicted.probabilities
#' @author Efstathios D. Gennatas
#' @export

rtROC <- function(true.labels, predicted.probabilities,
                  thresholds = NULL,
                  plot = FALSE,
                  theme = getOption("rt.theme", "lightgrid"),
                  verbose = TRUE) {

  true.labels <- as.factor(true.labels)
  true.levels <- levels(true.labels)
  n.classes <- length(true.levels)

  if (is.null(thresholds)) {
    thresholds <- sort(c(-Inf, unique(predicted.probabilities), Inf))
  }

  if (n.classes == 2) {

    predicted.labels <- lapply(thresholds, function(i) {
      # pred <- factor(as.integer(predicted.probabilities >= i), levels = c(1, 0))
      pred <- factor(ifelse(predicted.probabilities >= i, 1, 0), levels = c(1, 0))
      levels(pred) <- true.levels
      pred
    })
    predicted.labels <- as.data.frame(predicted.labels, col.names = paste0("t_", seq(thresholds)))
    sensitivity.t <- sapply(predicted.labels, function(i) sensitivity(true.labels, i))
    specificity.t <- sapply(predicted.labels, function(i) specificity(true.labels, i))
    .auc <- auc(predicted.probabilities, true.labels, verbose = FALSE)

  } else {
    stop("Multiclass ROC not yet supported")
  }

  # Plot ====
  if (plot) {
    mplot3.xy(1 - specificity.t, sensitivity.t, type = "l",
              zerolines = FALSE, diagonal = TRUE, xaxs = "i", yaxs = "i",
              order.on.x = FALSE,
              xlab = "False Positive Rate", ylab = "True Positive Rate",
              xlim = c(0, 1), ylim = c(0, 1),
              theme = theme)
  }

  out <- list(Sensitivity = sensitivity.t,
              Specificity = specificity.t,
              AUC = .auc,
              Thresholds = thresholds)
  class(out) <- "rtROC"
  if (verbose) {
    msg("Positive class:", true.levels[1])
    msg("AUC =", .auc)
  }
  invisible(out)

} # rtemis::rtROC
