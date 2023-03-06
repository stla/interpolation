library(interpolation)

a <- 0.2; bx <- 0.3; by <- -0.4; cxx <- 2.7; cyy <- -0.5; cxy <- 0
h <- function(x, y) a + bx*x + by*y + cxx*x^2 + cyy*y^2 + cxy*x*y

x0 <- y0 <- seq(1, 10, by = 1)
Grid <- expand.grid(X = x0, Y = y0)
x <- Grid$X; y <- Grid$Y
z <- h(x, y)
xnew <- ynew <- seq(1.25, 9.25, by = 1)

fun <- interpfun(x, y, z, "sibson")
znew <- fun(xnew, ynew)

znew
h(xnew, ynew)
