library(interpolation)

theta <- seq(0, 2*pi, length.out = 13L)[-13L]
x <- cos(theta)
y <- sin(theta)
z <- theta %% pi
f <- interpfun(x, y, z)

theta_new <- seq(0, pi, length.out = 25L)[-25L]
x_new <- cos(theta_new) / 2
y_new <- sin(theta_new) / 2

f(x_new, y_new)
theta_new
