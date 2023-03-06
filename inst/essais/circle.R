library(interpolation)

h <- function(x, y) x + y

theta <- seq(0, 2*pi, length.out = 100L)[-1L]
x <- c(cos(theta), cos(theta)/2)
y <- c(sin(theta), sin(theta)/2)
z <- h(x, y)
f <- interpfun(x, y, z, "sibson")

theta_new <- seq(0, 2*pi, length.out = 25L)[-1L]
x_new <- cos(theta_new) / 2
y_new <- sin(theta_new) / 2

f(x_new, y_new)
h(x_new, y_new)

