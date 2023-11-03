# Load packages -----------------------------------------------------------
library(datasets)  # load/unload packages manually

# Load data
?mtcars  # motor trend cars

head(mtcars)

# need a table with frequencies for each category
cylinders <- table(mtcars$cyl)
barplot(cylinders)
plot(cylinders)

# list objects in memory
ls()

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
