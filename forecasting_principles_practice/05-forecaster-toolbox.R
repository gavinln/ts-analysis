# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)

pacman::p_load(tsibble, tsibbledata)
pacman::p_load(feasts)
pacman::p_load(fpp3)

# Chapter 5 Forecasters toolbox -------------------------------------------

# 5.1 Forecasting workflow ================================================

glimpse(global_economy)

gdppc <- global_economy %>%
  mutate(GDP_per_capita = GDP/Population)

glimpse(gdppc)

gdppc %>%
  filter(Country == "Sweden") %>%
  autoplot(GDP_per_capita) +
  labs(y = "$US", title = "GDP per capita for Sweden")

fit <- gdppc %>%
  model(tremd_model = TSLM(GDP_per_capita ~ trend()))

fit %>%
  forecast(h = "3 years") %>%
  filter(Country == "Sweden") %>%
  autoplot(gdppc) +
  labs(y = "$US", title = "GDP per capita for Sweden")

bricks %>% model(MEAN(Bricks))

bricks %>% model(NAIVE(Bricks))  # or random-walk model RW()

# seasonal random walk or naive

bricks %>% model(SNAIVE(Bricks ~ lag("year")))

bricks %>%  model(RW(Bricks ~ drift()))


train <- aus_production %>%
  filter_index("1992 Q1" ~ "2006 Q4")

beer_fit <- train %>%
  model(Mean = MEAN(Beer), Naive = NAIVE(Beer),
        Seasonal_naive = SNAIVE(Beer))

beer_fc <-  beer_fit %>% forecast(h = 14)

beer_fc %>%
  autoplot(train, level = NULL) +
  autolayer(filter_index(aus_production, "2007 Q1" ~ .),
            color = "black") +
  labs(y = "Megalitres",
       title = "Forcase for quarterly beer production") +
  guides(color = guide_legend(title = "Forecast"))

google_stock <- gafa_stock %>%
  filter(Symbol == "GOOG", year(Date) >= 2015) %>%
  mutate(day = row_number()) %>%
  update_tsibble(index = day, regular = TRUE)

google_2015 <- google_stock %>% filter(year(Date) == 2015)

google_fit <- google_2015 %>%
  model(Mean = MEAN(Close), Naive = NAIVE(Close),
        Drift = NAIVE(Close ~ drift()))

google_jan_2016 <- google_stock %>%
  filter(yearmonth(Date) == yearmonth("2016 Jan"))

google_fc <-  google_fit %>%
  forecast(new_data = google_jan_2016)

google_fc %>%
  autoplot(google_2015, level = NULL) +
  autolayer(google_jan_2016, Close, color = "black") +
  labs(y = "$US",
       title = "Google daily closing stock prices",
       subtitle = "Jan 2015 - Jan 2016") +
  guides(color = guide_legend(title = "Forecast"))

# Residual diagnostics

aug <- google_2015 %>%
  model(NAIVE(Close)) %>%
  augment()

glimpse(aug)

autoplot(aug, .innov) +
  labs(y = "$US",
       title = "Residuals from the Naive method")

aug %>%
  ggplot(aes(x = .innov)) +
  geom_histogram() +
  labs(title = "Histogram of residuals")

aug %>%
  ACF(.innov) %>%
  autoplot() +
  labs(title = "Residuals from the Naive method")

google_2015 %>%
  model(NAIVE(Close)) %>%
  gg_tsresiduals()

# Portmanteau test for autocorrelation

aug %>% features(.innov, box_pierce, lag = 10, dof = 0)

aug %>% features(.innov, ljung_box, lag = 10, dof = 0)

# using the drift method with one degree of freedom

fit <- google_2015 %>% model(RW(Close ~ drift()))
tidy(fit)

augment(fit) %>% features(.innov, ljung_box, lag=10, dof=1)

# TODO: Incomplete

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
