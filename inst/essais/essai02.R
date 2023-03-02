library(interpolation)

delaunayXYZ <- function(x, y, z, method = "linear") {
  method <- match.arg(method, c("linear", "sibson"))
  if(method == "linear") {
    out <- delaunayXYZ_linear(rbind(x, y, z))
  } else {
    out <- delaunayXYZ_sibson(rbind(x, y, z))
  }
  attr(out, "method") <- method
  out
}

interpolate <- function(delxyz, xnew, ynew) {
  method <- attr(delxyz, "method")
  if(method == "linear") {
    interpolate_linear(delxyz, rbind(xnew, ynew))
  } else {
    interpolate_sibson(delxyz, rbind(xnew, ynew))
  }
}


a <- 0.2; bx <- 0.3; by <- -0.4; c <- 0.5
x <- y <- seq(1, 10, by = .25)
y <- y + 6*rnorm(10)
z <- a + bx*x + by*y + c*(x^2 + y^2)
xnew <- ynew <- seq(3, 12, by = 1)

delxyz <- delaunayXYZ(x, y, z, "sibson")
znew <- interpolate(delxyz, xnew, ynew)

znew
a + bx*xnew + by*ynew + c*(xnew^2 + ynew^2)
