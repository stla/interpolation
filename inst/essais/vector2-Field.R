x <- y <- c(-5, -4, -3, -2, 2, 3, 4, 5)
From <- as.matrix(expand.grid(x0 = x, y0 = y))
f <- function(x0y0) {
  d <- c(-10, -5) - x0y0
  x0y0 + 0.8 * d / sqrt(c(crossprod(d)))
  # x0 <- x0y0[1L]; y0 <- x0y0[2L]
  # x1 <- -x0/d; y1 <- -y0/d
  # c(x1, y1)
}
To <- t(apply(From, 1L, f))
x0 <- From[, "x0"]; y0 <- From[, "y0"]
x1 <- To[, 1L]; y1 <- To[, 2L]

plot(
  x0, y0, asp = 1, pch = 19, xlab = "x", ylab = "y"
)
arrows(x0, y0, x1, y1, length = 0.1)


library(interpolation)

fun <- interpfun(x0, y0, To, method = "linear")

From_new <- rbind(
  as.matrix(expand.grid(x0 = c(-1, 0, 1), y0 = (-5):5)),
  as.matrix(expand.grid(x0 = c(-5, -4, -3, -2), y0 = c(-1, 0, 1))),
  as.matrix(expand.grid(x0 = c(2, 3, 4, 5), y0 = c(-1, 0, 1)))
)
To_new   <- fun(From_new)

x0 <- From_new[, "x0"]; y0 <- From_new[, "y0"]
x1 <- To_new[, 1L]; y1 <- To_new[, 2L]
points(x0, y0, pch = 19, col = "red")
arrows(x0, y0, x1, y1, length = 0.1, col = "red")
