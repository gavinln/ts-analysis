# Load packages -----------------------------------------------------------
library(datasets)  # load/unload packages manually

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr, psych)

p_help(psych, web=FALSE)  # info on package in a web browser

describe(iris$Sepal.Length)
describe(iris)

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
