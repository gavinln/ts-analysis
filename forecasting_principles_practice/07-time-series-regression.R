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

# 7.4 useful time series predictors

recent_production <- aus_production %>%
  filter(year(Quarter) >= 1992)

recent_production %>%
  autoplot(Beer) +
  labs(y = "Megalitres",
       title = "Australian quarterly beer production")

fit_beer <- recent_production %>%
  model(TSLM(Beer ~ trend() + season()))

report(fit_beer)

fit_beer %>% gg_tsresiduals()

augment(fit_beer) %>%
  ggplot(aes(x = Quarter)) +
  geom_line(aes(y = Beer, color = "Data")) +
  geom_line(aes(y = .fitted, color = "Fitted")) +
  labs(y = "megalitres",
       title = "Australian quarterly beer produciton")  +
  guides(color = guide_legend(title = "Series"))

augment(fit_beer) %>%
  ggplot(aes(x = Beer, y = .fitted,
             color = factor(quarter(Quarter)))) +
  geom_point() +
  labs(y = "Fitted", x = "Actual values",
       title = "Australian quarterly beer production") +
  geom_abline(intercept = 0, slope = 1) +
  guides(color = guide_legend(title = "Quarter"))

# Fourier series

fourier_beer <- recent_production %>%
  model(TSLM(Beer ~ trend() + fourier(K = 2)))
report(fourier_beer)

fourier_beer %>% gg_tsresiduals()

# 7.6 Forecasting with regression

recent_production <- aus_production %>%
  filter(year(Quarter) >= 1992)

fit_beer <-  recent_production %>%
  model(TSLM(Beer ~ trend() + season()))

fc_beer <- forecast(fit_beer)

fc_beer %>%
  autoplot(recent_production) +
  labs(
    title = "Forecasts of beer production using regression",
    y = "mealiters"
  )

# forecasting scenarios

fit_consBest <- us_change %>%
  model(
    lm = TSLM(Consumption ~ Income + Savings + Unemployment)
  )

future_scenarios <- scenarios(
  Increase = new_data(us_change, 4) %>%
    mutate(Income=1, Savings=0.5, Unemployment=0),
  Decrease = new_data(us_change, 4) %>%
    mutate(Income=-1, Savings=-0.5, Unemployment=0),
  names_to = "Scenario")

fc <- forecast(fit_consBest, new_data = future_scenarios)

us_change %>%
  autoplot(Consumption) +
  autolayer(fc) +
  labs(title = "US consumption", y = "% change")

fit_cons <- us_change %>%
  model(TSLM(Consumption ~ Income))

new_cons <- scenarios(
  Average_increase = new_data(us_change, 4) %>%
    mutate(Income = mean(us_change$Income)),
  Extreme_increase = new_data(us_change, 4) %>%
    mutate(Income = 12),
  names_to = "Scenario"
)

fcast <- forecast(fit_cons, new_cons)

us_change %>%
  autoplot(Consumption) +
  autolayer(fcast) +
  labs(title = "US sonsumption predicted mean vs 12% increase",
       y = "% change")


# 7.7 Non-linear regression

boston_men <- boston_marathon %>%
  filter(Year >= 1924) %>%
  filter(Event == "Men's open division") %>%
  mutate(Minutes = as.numeric(Time)/60)

boston_men %>%
  ggplot(aes(x = Year, y=Minutes)) +
  geom_line() +
  labs(title = "Boston marathon winning times",
       y = "Minutes") +
  geom_smooth(method = "lm", se = FALSE)

fit_boston_men <- boston_men %>%
  model(tslm = TSLM(Minutes ~ Year))

augment(fit_boston_men) %>%
  ggplot(aes(x = Year, y=.resid)) +
  geom_line() +
  labs(y = "Minutes",
       title = "Residuals from a linear trend")

# fit multiple models

fit_trends <- boston_men %>%
  model(
    linear = TSLM(Minutes ~ trend()),
    exponential = TSLM(log(Minutes) ~ trend()),
    piecewise = TSLM(Minutes ~ trend(knots = c(1950, 1980)))
  )

fc_trends <- fit_trends %>% forecast(h=10)

boston_men %>%
  autoplot(Minutes) +
  geom_line(data = fitted(fit_trends),
            aes(y = .fitted, color = .model)) +
  autolayer(fc_trends, alpha = 0.5, level = 95) +
  labs(y = "Minutes",
       title = "Boston marathon winning times")



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
