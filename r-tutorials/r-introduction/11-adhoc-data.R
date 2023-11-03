# colon operator

x1 <- 0:10

x2 <- 10:0

# seq
x3 <- seq(10)
c3 <- seq(30, 0, by=-3)

# multiple values with c

x5 <- c(5, 4, 1, 6, 7, 2, 2, 3, 2, 8)

# scan to read
x6 <- scan()
x6

# rep
x7 <- rep(TRUE, 5)

# repeat sets
x8 <- rep(c(TRUE, FALSE))
x8

x9 <- rep(c(TRUE, FALSE), each=5)
x9

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
