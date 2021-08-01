# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)

pacman::p_load(tsibble, tsibbledata)
pacman::p_load(feasts)
pacman::p_load(fpp3)

# Chapter 7 Time series regression ----------------------------------------

glimpse(us_change)

us_change %>%
  pivot_longer(c(Consumption, Income), names_to="Series") %>%  
  autoplot(value) + 
  labs(y = "% change")

us_change %>% 
  ggplot(aes(x = Income, y = Consumption)) +
  labs(y = "Consumption quarterly % change",
       x = "Income quarterly % change") + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE)

us_change %>% 
  model(TSLM(Consumption ~ Income)) %>% 
  report()

glimpse(us_change)

us_change %>% 
  GGally::ggpairs(columns = 2:6)

fit_consMR <- us_change %>% 
  model(tslm = TSLM(
    Consumption ~ Income + Production + Unemployment + Savings))

report(fit_consMR)
  
augment(fit_consMR) %>% 
  ggplot(aes(x = Quarter)) + 
  geom_line(aes(y = Consumption, color = "Data")) +
  geom_line(aes(y = .fitted, color = "Fitted")) +
  labs(y = NULL,
       title = "Percent change in US consumption") + 
  guides(color = guide_legend(title = NULL))

augment(fit_consMR) %>% 
  ggplot(aes(x = Consumption, y = .fitted)) + 
  geom_point() + 
  labs(
    y = "Fitted (predicted values)",
    x = "Data (actual values)",
    title = "Percent change in US consumption expendicture"
  ) + geom_abline(intercept = 0, slope = 1)

# 7.3 Evaluating the regression model

us_change %>% 
  left_join(residuals(fit_consMR), by = "Quarter") %>% 
  pivot_longer(Income:Unemployment,
               names_to = "regressor", values_to = "x") %>%  
  ggplot(aes(x = x, y = .resid)) +
  geom_point() +
  facet_wrap(. ~ regressor, scales = "free_x") +
  labs(y = "Residuals", x="")

augment(fit_consMR) %>% 
  ggplot(aes(x = .fitted, y = .resid)) + 
  geom_point() + labs(x = "Fitted", y = "Residuals")

# spurious regressions

fit <- aus_airpassengers %>% 
  filter(Year <= 2011) %>% 
  left_join(guinea_rice, by = "Year") %>% 
  model(TSLM(Passengers ~ Production))

report(fit)
  
fit %>% gg_tsresiduals()

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

