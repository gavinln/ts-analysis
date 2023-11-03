# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)
library(datasets)  # load/unload packages manually

head(mtcars)
cars <- mtcars[, c(1:4, 6:7, 9:11)]
head(cars)

pc <- prcomp(cars,
             center=TRUE,
             scale=TRUE)
summary(pc)
plot(pc)

predict(pc) %>% round(2)  # load on principal components

biplot(pc)  # plot of first two components

# Clean up
p_unload(all)  # clears all add-ons

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
