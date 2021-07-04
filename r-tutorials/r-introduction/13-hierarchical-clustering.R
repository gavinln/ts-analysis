# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)
library(datasets)  # load/unload packages manually

head(mtcars)

cars <- mtcars[, c(1:4, 6:7, 9:11)]
head(cars)

hc <- cars  %>%  # get cars data
      dist  %>%  # compute distance/dissimilarity matrix
      hclust
      
plot(hc)

rect.hclust(hc, k=2, border="gray")
rect.hclust(hc, k=3, border="blue")
rect.hclust(hc, k=4, border="green4")
rect.hclust(hc, k=5, border="darkred")

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

