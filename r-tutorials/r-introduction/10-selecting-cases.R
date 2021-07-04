# Load packages -----------------------------------------------------------
library(datasets)  # load/unload packages manually

head(iris)
hist(iris$Petal.Length)
summary(iris$Petal.Length)

summary(iris$Species)

# Versicolor
hist(iris$Petal.Length[iris$Species == "versicolor"],
     main="Petal Length: Versicolor")

# Virginica 
hist(iris$Petal.Length[iris$Species == "virginica"],
     main="Petal Length: Verginica")

# Setosa
hist(iris$Petal.Length[iris$Species == "setosa"],
     main="Petal Length: Setosa")

# Short petals only (all Setosa)
hist(iris$Petal.Length[iris$Petal.Length < 2],
     main="Petal Length < 2")

# Virginica 
hist(iris$Petal.Length[iris$Species == "virginica" &
     iris$Petal.Length < 5.5],
     main="Petal Length: Verginica")

i.setosa <- iris[iris$Species == "setosa", ]

head(i.setosa)
summary(i.setosa$Petal.Length)
hist(i.setosa$Petal.Length)

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()

