library(interpolation)

a <- 0.2; bx <- 0.3; by <- -0.4
x <- y <- seq(1, 10, by = 1)
y <- y + 6*rnorm(10)
z <- a + bx*x + by*y

delxyz <- delaunayXYZ(x, y, z)

xnew <- ynew <- seq(3, 12, by = 1)
znew <- test2(delxyz, xnew, ynew)

znew
a + bx*xnew + by*ynew
