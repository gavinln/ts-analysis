# import data

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)
pacman::p_load(rstudioapi)
library(datasets)  # load/unload packages manually

# https://www.youtube.com/watch?v=_V8eKsto3Ug location 1 hour 38 minutes

scriptDir <- dirname(rstudioapi::getSourceEditorContext()$path)

rio_csv <- import(file.path(scriptDir, 'example-data.csv'))
View(rio_csv)

rio_txt <- import(file.path(scriptDir, 'example-data.txt'))
View(rio_txt)

r_txt = read.table(file.path(scriptDir, 'example-data.txt'),
                   header=TRUE, sep='\t')

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
