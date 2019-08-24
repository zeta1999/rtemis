# dplot3.x.R
# ::rtemis::
# 2019 Efstathios D. Gennatas egenn.github.io

#' Interactive Univariate Plots
#'
#' Draw interactive univariate plots using \code{plotly}
#'
#' @inheritParams dplot3.bar
#' @param x Numeric, vector: Input
#' @param axes.square Logical: If TRUE: draw a square plot to fill the graphic device.
#' Default = FALSE. Note: If TRUE, the device size at time of call is captured and height and width are set so as
#' to draw the largest square available. This means that resizing the device window will not automatically resize the
#' plot.
#' @param legend Logical: If TRUE, draw legend. Default = NULL, which will be set to TRUE if x is a list of more than
#' 1 element
#' @param zerolines Logical: If TRUE: draw lines at y = 0. Default = FALSE
#' @param histnorm Character: NULL, "percent", "probability", "density", "probability density"
#' @param histfunc Character: "count", "sum", "avg", "min", "max". Default = "count"
#' @param hist.n.bins Integer: Number of bins to use if type = "histogram". Default = 20
#' @param width Float: Force plot size to this width. Default = NULL, i.e. fill available space
#' @param height Float: Force plot size to this height. Default = NULL, i.e. fill available space
#' @author Efstathios D. Gennatas
#' @export
#' @examples
#' \dontrun{
#' dplot3.x(split(iris$Sepal.Length, iris$Species))
#' }

dplot3.x <- function(x,
                     type = c("density", "histogram", "index", "path", "qqline"),
                     main = NULL,
                     xlab = NULL,
                     ylab = NULL,
                     col = NULL,
                     alpha = .75,
                     bg = NULL,
                     plot.bg = NULL,
                     theme = getOption("rt.theme", "light"),
                     palette = getOption("rt.palette", "rtCol1"),
                     axes.square = FALSE,
                     zero.lines = TRUE,
                     group.names = NULL,
                     font.size = 16,
                     font.alpha = .8,
                     font.col = NULL,
                     font.family = "Helvetica Neue",
                     main.col = NULL,
                     axes.col = NULL,
                     labs.col = NULL,
                     grid.col = NULL,
                     grid.lwd = 1,
                     grid.alpha = .8,
                     tick.col = NULL,
                     legend = NULL,
                     legend.xy = c(0, 1),
                     legend.col = NULL,
                     legend.bg = "#FFFFFF00",
                     legend.border.col = "#FFFFFF00",
                     margin = list(t = 35),
                     zerolines = FALSE,
                     histnorm = c(NULL, "percent", "probability", "density",
                                  "probability density"),
                     histfunc = c("count", "sum", "avg", "min", "max"),
                     hist.n.bins = 20,
                     barmode = "overlay", # TODO: alternatives
                     width = NULL,
                     height = NULL,
                     filename = NULL,
                     file.width = 500,
                     file.height = 500) {

  # [ DEPENDENCIES ] ====
  if (!depCheck("plotly", verbose = FALSE)) {
    cat("\n"); stop("Please install dependencies and try again")
  }

  # [ ARGUMENTS ] ====
  type <- match.arg(type)
  if (!is.null(main)) main <- paste0("<b>", main, "</b>")

  # [ DATA ] ====
  if (!is.list(x)) x <- list(x)
  if (is.null(legend)) legend <- length(x) > 1
  .names <- names(x)
  if (is.null(.names)) .names <- paste("Feature", seq_along(x))

  # Colors ====
  if (is.character(palette)) palette <- rtPalette(palette)
  n.groups <- length(x)
  if (is.null(col)) {
    if (n.groups == 1) {
      col <- palette[1]
    } else {
      col <- palette[seq_len(n.groups)]
    }
  }

  if (length(col) < n.groups) col <- rep(col, n.groups/length(col))

  # Themes ====
  # Defaults: no box
  axes.visible <- FALSE
  axes.mirrored <- FALSE

  if (theme %in% c("lightgrid", "darkgrid")) {
    grid <- TRUE
  } else {
    grid <- FALSE
  }
  if (theme == "lightgrid") {
    theme <- "light"
    if (is.null(plot.bg)) plot.bg <- plotly::toRGB("gray90")
    grid <- TRUE
    if (is.null(grid.col)) grid.col <- "rgba(255,255,255,1)"
    if (is.null(tick.col)) tick.col <- "rgba(0,0,0,1)"
  }
  if (theme == "darkgrid") {
    theme <- "dark"
    if (is.null(plot.bg)) plot.bg <- plotly::toRGB("gray15")
    grid <- TRUE
    if (is.null(grid.col)) grid.col <- "rgba(0,0,0,1)"
    if (is.null(tick.col)) tick.col <- "rgba(255,255,255,1)"
  }
  themes <- c("light", "dark", "lightbox", "darkbox")
  if (!theme %in% themes) {
    warning(paste(theme, "is not an accepted option; defaulting to \"light\""))
    theme <- "light"
  }

  if (theme == "light") {
    if (is.null(bg)) bg <- "white"
    if (is.null(tick.col)) tick.col <- plotly::toRGB("gray10")
    if (is.null(labs.col)) labs.col <- plotly::toRGB("gray10")
    if (is.null(main.col)) main.col <- "rgba(0,0,0,1)"
  } else if (theme == "dark") {
    if (is.null(bg)) bg <- "black"
    if (is.null(tick.col)) tick.col <- plotly::toRGB("gray90")
    if (is.null(labs.col)) labs.col <- plotly::toRGB("gray90")
    if (is.null(main.col)) main.col <- "rgba(255,255,255,1)"
    if (is.null(grid.col)) grid.col <- "rgba(0,0,0,1)"
    # gen.col <- "white"
  } else if (theme == "lightbox") {
    axes.visible <- axes.mirrored <- TRUE
    if (is.null(bg)) bg <- "rgba(255,255,255,1)"
    if (is.null(plot.bg)) plot.bg <- "rgba(255,255,255,1)"
    if (is.null(axes.col)) axes.col <- adjustcolor("white", alpha.f = 0)
    if (is.null(tick.col)) tick.col <- plotly::toRGB("gray10")
    if (is.null(labs.col)) labs.col <- plotly::toRGB("gray10")
    if (is.null(main.col)) main.col <- "rgba(0,0,0,1)"
    if (is.null(grid.col)) grid.col <- "rgba(255,255,255,1)"
    # gen.col <- "black"
  } else if (theme == "darkbox") {
    axes.visible <- axes.mirrored <- TRUE
    if (is.null(bg)) bg <- "rgba(0,0,0,1)"
    if (is.null(plot.bg)) plot.bg <- "rgba(0,0,0,1)"
    if (is.null(tick.col)) tick.col <- plotly::toRGB("gray90")
    if (is.null(labs.col)) labs.col <- plotly::toRGB("gray90")
    if (is.null(main.col)) main.col <- "rgba(255,255,255,1)"
    if (is.null(grid.col)) grid.col <- "rgba(0,0,0,1)"
    # gen.col <- "white"
  }

  # Derived
  if (is.null(legend.col)) legend.col <- labs.col

  # [ SIZE ] ====
  if (axes.square) {
    width <- height <- min(dev.size("px")) - 10
  }

  # [ plotly ] ====
  # '- { Density } ====
  if (type ==  "density") {
    if (is.null(ylab)) ylab <- "Density"
    xl.density <- lapply(x, density)
    .text <- lapply(x, function(i) paste("mean =", ddSci(mean(i))))

    # '-  PLOT ====
    plt <- plotly::plot_ly(width = width,
                           height = height)
    for (i in seq_len(n.groups)) {
      plt <- plotly::add_trace(plt, x = xl.density[[i]]$x,
                               y = xl.density[[i]]$y,
                               type = "scatter",
                               mode = "none",
                               fill = 'tozeroy',
                               fillcolor = plotly::toRGB(col[[i]], alpha),
                               name = .names[i],
                               text = .text[[i]],
                               hoverinfo = "text",
                               showlegend = legend)
    }

  } # End mode == "density"

  # '- { Histogram } ====
  if (type == "histogram") {
    histnorm <- match.arg(histnorm)
    histfunc <- match.arg(histfunc)
    # if (is.null(ylab)) ylab <- "Count"

    # '-  PLOT ====
    plt <- plotly::plot_ly(width = width,
                           height = height)
    for (i in seq_len(n.groups)) {
      plt <- plotly::add_histogram(plt, x = x[[i]],
                                   marker = list(color = plotly::toRGB(col[i], alpha)),
                                   name = .names[i],
                                   histnorm = histnorm,
                                   histfunc = histfunc,
                                   nbinsx = hist.n.bins,
                                   showlegend = legend)
    }
    plt <- plotly::layout(plt, barmode = barmode)
  }

  # [ Layout ] ====
  # '- layout ====
  f <- list(family = font.family,
            size = font.size,
            color = labs.col)
  tickfont <- list(family = font.family,
                   size = font.size,
                   color = tick.col)
  .legend <- list(x = legend.xy[1],
                  y = legend.xy[2],
                  font = list(family = font.family,
                              size = font.size,
                              color = legend.col),
                  bgcolor = legend.bg,
                  bordercolor = legend.border.col)

  plt <- plotly::layout(plt,
                        yaxis = list(title = ylab,
                                     showline = axes.visible,
                                     mirror = axes.mirrored,
                                     titlefont = f,
                                     showgrid = grid,
                                     gridcolor = grid.col,
                                     gridwidth = grid.lwd,
                                     tickcolor = tick.col,
                                     tickfont = tickfont,
                                     zeroline = zerolines),
                        xaxis = list(title = xlab,
                                     showline = axes.visible,
                                     mirror = axes.mirrored,
                                     titlefont = f,
                                     showgrid = grid,
                                     gridcolor = grid.col,
                                     gridwidth = grid.lwd,
                                     tickcolor = tick.col,
                                     tickfont = tickfont,
                                     zeroline = FALSE),
                        # barmode = barmode,  # group works without actual groups too
                        # title = main,
                        title = list(text = main,
                                     font = list(family = font.family,
                                                 size = font.size,
                                                 color = main.col)),
                        # titlefont = list(),
                        paper_bgcolor = bg,
                        plot_bgcolor = plot.bg,
                        margin = margin,
                        showlegend = legend,
                        legend = .legend)

  # Remove padding
  plt$sizingPolicy$padding <- 0

  # Write to file ====
  if (!is.null(filename)) {
    filename <- file.path(filename)
    plotly::plotly_IMAGE(plt, width = file.width, height = file.height, out_file = filename)
  }
  plt

}  # rtemis::dplot3.x