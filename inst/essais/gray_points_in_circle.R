library(interpolation)
library(uniformly)

h <- function(x, y) sqrt(x^2 + y^2)
set.seed(666L)

theta <- seq(0, 2*pi, length.out = 60L)[-1L]
x <- cos(theta)
y <- sin(theta)
xy <- runif_in_sphere(400L, 2)
x <- c(x, xy[, 1L])
y <- c(y, xy[, 2L])
z <- h(x, y)
f <- interpfun(x, y, z, "sibson")

theta <- seq(0, 2*pi, length.out = 120L)[-1L]
r <- seq(0.01, 0.99, length.out = 30)
Grid <- expand.grid(R = r, Theta = theta)
x_new <- with(Grid, R * cos(Theta))
y_new <- with(Grid, R * sin(Theta))
z_new <- f(x_new, y_new)
oo <- is.na(z_new)
z_new[oo] <- 0
colors <- rgb(z_new, z_new, z_new)
colors[oo] <- "red"

plot(x_new, y_new, asp = 1, pch = 19, col = colors)
points(x, y, pch=19, col="blue", cex=0.5)