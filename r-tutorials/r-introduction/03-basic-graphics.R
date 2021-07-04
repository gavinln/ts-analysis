# Load packages -----------------------------------------------------------
library(datasets)  # load/unload packages manually

head(iris)

?plot

plot(iris$Species)  # categorical variable
plot(iris$Petal.Length)  # quantitative variable
plot(iris$Species, iris$Petal.Width)  # categorical vs quantitative
plot(iris$Petal.Length,iris$Petal.Width)  # categorical vs quantitative
plot(iris)

# plot with options
plot(iris$Petal.Length, iris$Petal.Width,
     col="#cc0000",  # hex code fo red
     pch=19,  # solid circles for points (point character)
     main = "Iris: Petal Length vs Petal Width",
     xlab = "Petal Length",
     ylab = "Petal Width")

# plot formulas
plot(cos, 0, 2 * pi)
plot(exp, 1, 5)
plot(dnorm, -3, +3)

# plot with options
plot(dnorm, -3, +3,
     col="#cc0000",
     lwd=5,
     main="Standard Normal Distribution",
     xlab="z-scores"
     ylab="Density")

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()

