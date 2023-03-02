#' @title Interpolation function
#' @description Generates a function \code{f(x,y)} that interpolates the known 
#'   function values at some given \code{(x,y)}-coordinates. 
#'
#' @param x,y two numeric vectors of the same size
#' @param z a nummeric vector of the same size as \code{x} and \code{y}
#' @param method method of interpolation, either \code{"linear"} or 
#'   \code{"sibson"}
#'
#' @return A function whose graph interpolates the points \code{((x,y), z)}. 
#' @export
#'
#' @examples 
#' library(interpolation)
interpfun <- function(x, y, z, method = "linear") {
  method <- match.arg(method, c("linear", "sibson"))
  XYZ <- rbind(x, y, z)
  storage.mode(XYZ) <- "double"
  if(anyNA(XYZ)) {
    stop("Found missing values.")
  }
  if(method == "linear") {
    delxyz <- delaunayXYZ_linear(XYZ)
    out <- function(xnew, ynew) {
      interpolate_linear(delxyz, rbind(xnew, ynew))
    }
  } else {
    delxyz <- delaunayXYZ_sibson(XYZ)
    out <- function(xnew, ynew) {
      interpolate_sibson(delxyz, rbind(xnew, ynew))
    }
  }
  attr(out, "method") <- method
  out
}
