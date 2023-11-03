# Load packages -----------------------------------------------------------

# install pacman for managing add-on packages
install.packages("pacman")

# load the package using either of the following:
require(pacman)  # shows a confirmation message
library(pacman)  # no message

# Get packages from CRAN, Crantastic or github
# Popular r packages
# dplyr, tidyr, stringr, lubridate, httr,
# ggvis, ggplot2, shiny, rio, rmarkdown
# pacman

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)
library(datasets)  # load/unload packages manually

# Clean up
p_unload(dplr, stringr)  # clear specific packages
p_unload(all)  # clears all add-ons

detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
