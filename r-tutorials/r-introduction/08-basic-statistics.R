# Load packages -----------------------------------------------------------
library(datasets)  # load/unload packages manually

# 52 minutes in video https://www.youtube.com/watch?v=_V8eKsto3Ug

head(iris)
summary(iris$Species)
summary(iris$Sepal.Length)
summary(iris)  # entire data frame

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
