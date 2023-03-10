library(interpolation)

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

a <- 0.2; bx <- 0.3; by <- -0.4
x0 <- y0 <- seq(1, 10, by = 1)
Grid <- expand.grid(X = x0, Y = y0)
x <- Grid$X; y <- Grid$Y
z <- a + bx*x + by*y 
xnew <- ynew <- seq(2.5, 8.5, by = 1)
fun <- interpfun(x, y, z, "linear")
# computed values:
( znew <- fun(xnew, ynew) )
# true values:
a + bx*xnew + by*ynew


a <- 0.2; bx <- 0.3; by <- -0.4; c <- 0.5
x0 <- y0 <- seq(1, 10, by = 1)
Grid <- expand.grid(X = x0, Y = y0)
x <- Grid$X; y <- Grid$Y
z <- a + bx*x + by*y + c*(x^2 + y^2)
xnew <- ynew <- seq(1.5, 9.5, by = 1)

fun <- interpfun(x, y, z, "sibson")
znew <- fun(xnew, ynew)

znew
a + bx*xnew + by*ynew + c*(xnew^2 + ynew^2)
