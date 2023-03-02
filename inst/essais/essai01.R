library(interpolation)

delaunayXYZ <- function(x, y, z) {
  delaunayXYZ_cpp(rbind(x, y, z))
}
interpolate <- function(delxyz, xnew, ynew) {
  interpolate_linear(delxyz, rbind(xnew, ynew))
}


a <- 0.2; bx <- 0.3; by <- -0.4
x <- y <- seq(1, 10, by = 1)
y <- y + 6*rnorm(10)
z <- a + bx*x + by*y
xnew <- ynew <- seq(3, 12, by = 1)

delxyz <- delaunayXYZ(x, y, z)
znew <- interpolate(delxyz, xnew, ynew)

znew
a + bx*xnew + by*ynew
