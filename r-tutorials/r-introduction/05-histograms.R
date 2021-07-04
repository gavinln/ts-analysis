# Load packages -----------------------------------------------------------
library(datasets)  # load/unload packages manually

# Load data
?iris

head(iris)

# basic histograms
hist(iris$Sepal.Length)
hist(iris$Sepal.Width)
hist(iris$Petal.Length)
hist(iris$Petal.Width)

# put graphs in 3 rows and 1 column
par(mfrow=c(3, 1))  # par - parameter

hist(iris$Petal.Width[iris$Species=="setosa"],
     xlim=c(0, 3),
     breaks=9,
     main="Petal Width for Setosa",
     xlab="",
     col="red")

hist(iris$Petal.Width[iris$Species=="versicolor"],
     xlim=c(0, 3),
     breaks=9,
     main="Petal Width for Versicolor",
     xlab="",
     col="purple")

hist(iris$Petal.Width[iris$Species=="virginica"],
     xlim=c(0, 3),
     breaks=9,
     main="Petal Width for Virginica",
     xlab="",
     col="blue")

# restore graphic parameter
par(mfrow=c(1, 1))


# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()

