# Load packages -----------------------------------------------------------
library(datasets)  # load/unload packages manually

# Load data
?mtcars

head(mtcars)

# check univariate distributions
hist(mtcars$wt)
hist(mtcars$mpg)

# basic x-y plot for two quantitative variables
plot(mtcars$wt, mtcars$mpg)

# plot options
plot(mtcars$wt, mtcars$mpg,
     pch=19,
     cex=1.5,  # 150% size
     col="#cc0000",
     main="MPG as a function of weight of cars",
     xlab="Weight (in 1,000 pounds)",
     ylab="MPG")

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
