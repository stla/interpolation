library(interpolation)

a <- 0.2; bx <- 0.3; by <- -0.4
x <- y <- seq(1, 10, by = 1)
y <- y + 6*rnorm(10)
z <- a + bx*x + by*y

xnew <- ynew <- seq(3, 12, by = 1)
# oo <- xnew>3 & ynew>6 & xnew<8 & ynew < 12
# xnew <- xnew[oo]
# ynew <- ynew[oo]
znew <- test(x, y, z, xnew, ynew)

plot(x, y, pch=19)
points(xnew, ynew, pch=19, col="red")

znew
a + bx*xnew + by*ynew
