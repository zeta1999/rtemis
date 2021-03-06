# mplot3.box
# ::rtemis::
# 2017 Efstathios D. Gennatas egenn.lambdamd.org
# TODO: make x vector or list

#' \code{mplot3}: Boxplot
#'
#' Draw boxplots
#'
#' @inheritParams mplot3.xy
#' @param x Matrix: Each column will be drawn as a box
#' @param col Vector of colors to use
#' @param alpha Float: Alpha to be applied to \code{col}
#' @param border Color for lines around boxes
#' @param ... Additional arguments to \code{graphics::boxplot}
#' @author Efstathios D. Gennatas
#' @examples
#' \dontrun{
#' x <- rnormmat(200, 4, return.df = TRUE, seed = 2019)
#' colnames(x) <- c("mango", "banana", "tangerine", "sugar")
#' mplot3.box(x)
#' }
#' @export

mplot3.box <- function(x,
                       col = NULL,
                       alpha = .66,
                       border = NULL,
                       border.alpha = 1,
                       space = NULL,
                       xlim = NULL,
                       ylim = NULL,
                       xlab = NULL,
                       # xlab.line = 1.5,
                       ylab = NULL,
                       # ylab.line = 1.5,
                       main = NULL,
                       names.arg = NULL,
                       axisnames = FALSE,
                       xnames = NULL,
                       xnames.at = NULL,
                       xnames.y = NULL,
                       xnames.font = 1,
                       xnames.adj = c(.5, 1),
                       xnames.pos = NULL,
                       xnames.srt = 0,
                       legend = FALSE,
                       legend.names = NULL,
                       legend.position = "topright",
                       legend.inset = c(0, 0),
                       mar = NULL,
                       pty = "m",
                       cex.axis = cex,
                       cex.names = cex,
                       yaxis = TRUE,
                       ylim.pad = 0,
                       # y.axis.line = 0,
                       # y.axis.las = 0,
                       # y.axis.padj = 1,
                       # y.axis.hadj = .5,
                       theme = getOption("rt.theme", "lightgrid"),
                       autolabel = letters,
                       palette = getOption("rt.palette", "rtCol1"),
                       par.reset = TRUE,
                       pdf.width = 6,
                       pdf.height = 6,
                       filename = NULL, ...) {

  # [ ARGUMENTS ] ====
  if (is.character(palette)) palette <- rtPalette(palette)
  if (is.null(col)) {
    if (length(x) == 1) {
      col <- palette[1]
    } else {
      col <- palette[seq(length(x))]
    }
  }
  if (is.null(mar)) {
    mar <- if (is.null(main)) c(2.5, 3, 1, 1) else c(2.5, 3, 2, 1)
  }

  # Group names
  if (is.null(xnames)) {
    if (!is.null(names(x))) xnames <- names(x)
  }

  if (!is.null(xnames)) {
    if (is.null(xnames.at)) {
      xnames.at <- seq(length(x))
    }
  }

  col.alpha <- colorAdjust(col, alpha = alpha)
  if (is.null(border)) border <- colorAdjust(col, alpha = border.alpha)
  if (exists("rtpar", envir = rtenv)) par.reset <- FALSE
  par.orig <- par(no.readonly = TRUE)
  if (par.reset) on.exit(suppressWarnings(par(par.orig)))

  # Output directory
  if (!is.null(filename))
    if (!dir.exists(dirname(filename)))
      dir.create(dirname(filename), recursive = TRUE)

  # [ THEME ] ====
  extraargs <- list(...)
  if (is.character(theme)) {
    theme <- do.call(paste0("theme_", theme), extraargs)
  } else {
    for (i in seq(extraargs)) {
      theme[[names(extraargs)[i]]] <- extraargs[[i]]
    }
  }

  # [ XLIM & YLIM ] ====
  xv <- unlist(x)
  if (is.null(xlim)) xlim <- c(.5, length(x) + .5)
  if (is.null(ylim)) ylim <- c(min(xv) - .06 * abs(min(xv)), max(xv) + .05 * abs(max(xv)))

  # [ PLOT ] ====
  if (!is.null(filename)) pdf(filename, width = pdf.width, height = pdf.height, title = "rtemis Graphics")
  par(mar = mar, bg = theme$bg, pty = pty, cex = theme$cex)
  plot(NULL, NULL, xlim = xlim, ylim = ylim, bty = "n",
       axes = FALSE, ann = FALSE,
       xaxs = "i", yaxs = "i")

  # [ PLOT BG ] ====
  if (!is.na(theme$plot.bg)) {
    rect(xlim[1], ylim[1], xlim[2], ylim[2], border = NA, col = theme$plot.bg)
  }

  # [ GRID ] ====
  if (theme$grid) {
    grid(0,
         ny = theme$grid.ny,
         col = colorAdjust(theme$grid.col, theme$grid.alpha),
         lty = theme$grid.lty,
         lwd = theme$grid.lwd)
  }

  # [ BOXPLOT ] ====
  bp <- boxplot(x, col = col.alpha,
                pch = theme$pch,
                border = border,
                ylim = ylim,
                axes = FALSE,
                add = TRUE,
                xlab = NULL, ...)

  # [ y AXIS ] ====
  if (yaxis) {
    axis(side = 2,
         # at = y.axis.at,
         # labels = y.axis.labs,
         line = theme$y.axis.line,
         las = theme$y.axis.las,
         padj = theme$y.axis.padj,
         hadj = theme$y.axis.hadj,
         col.ticks = adjustcolor(theme$tick.col, theme$tick.alpha),
         col.axis = theme$tick.labels.col, # the axis numbers i.e. tick labels
         tck = theme$tck,
         tcl = theme$tcl,
         cex = theme$cex,
         family = theme$font.family)
  }

  # [ MAIN TITLE ] ====
  if (exists("autolabel", envir = rtenv)) {
    autolab <- autolabel[rtenv$autolabel]
    main <- paste(autolab, main)
    rtenv$autolabel <- rtenv$autolabel + 1
  }

  if (!is.null(main)) {
    mtext(main, line = theme$main.line,
          font = theme$main.font, adj = theme$main.adj,
          cex = theme$cex, col = theme$main.col,
          family = theme$font.family)
  }

  # [ GROUP NAMES ] ====
  if (is.null(xnames.y)) {
    xnames.y <- min(ylim) - diff(ylim) * .06
  }
  if (!is.null(xnames)) {
    text(x = xnames.at, y = xnames.y,
         labels = xnames,
         adj = xnames.adj,
         pos = xnames.pos,
         srt = xnames.srt, xpd = TRUE,
         font = xnames.font,
         col = theme$labs.col,
         family = theme$font.family)
  }

  # [ AXIS LABS ] ====
  if (!is.null(xlab))  mtext(xlab, 1, cex = theme$cex, line = theme$xlab.line)
  if (!is.null(ylab))  mtext(ylab, 2, cex = theme$cex, line = theme$ylab.line)

  if (!is.null(xlab)) mtext(xlab, side = theme$x.axis.side,
                            line = theme$xlab.line, cex = theme$cex,
                            # adj = xlab.adj,
                            col = theme$labs.col,
                            family = theme$font.family)
  if (!is.null(ylab)) mtext(ylab, side = theme$y.axis.side,
                            line = theme$ylab.line, cex = theme$cex,
                            # adj = ylab.adj,
                            col = theme$labs.col,
                            family = theme$font.family)

  # [ OUTRO ] ====
  if (!is.null(filename)) dev.off()
  invisible(bp)

} # rtemis::mplot3.box
