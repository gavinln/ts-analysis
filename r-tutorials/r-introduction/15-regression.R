# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)
library(datasets)  # load/unload packages manually

head(USJudgeRatings)
data <- USJudgeRatings

x <- as.matrix(data[-12])
y <- data[, 12]

reg1 <- lm(y ~ x)

reg1 <- lm(RTEN ~ CONT + INTG + DMNR + DILG +
           CFMG + DECI + PREP + FAMI + ORAL +
           WRIT + PHYS + RTEN,
           data=USJudgeRatings)

reg1  # coefficients only
summary(reg1)

anova(reg1)
coef(reg1)
confint(reg1)
resid(reg1)
hist(residuals(reg1))

# use two additional libraries
p_load(lars, caret)

stepwise <- lars(x, y, type="stepwise")

forward <- lars(x, y, type="forward.stagewise")

# LAR: Least angle regression
lar <- lars(x, y, type="lar")

# LASSO: Least Absolute Shrinkage and Selection operator
lasso <- lars(x, y, type="lasso")

# compare R^2 for new models
r2comp <- c(stepwise$R2[6], forward$R2[6],
            lar$R2[6], lasso$R2[6]) %>%
            round(2)
names(r2comp) <- c("stepwise", "forward", "lar", "lasso")
r2comp

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
