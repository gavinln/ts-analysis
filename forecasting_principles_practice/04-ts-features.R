# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)

pacman::p_load(tsibble, tsibbledata)
pacman::p_load(feasts)
pacman::p_load(fpp3)

pacman::p_load(broom)

# Chapter 4 Time series features ------------------------------------------

# 4.1 Some simple features ================================================

glimpse(tourism)

tourism %>%
  features(Trips, list(mean = mean)) %>%
  arrange(mean)

tourism %>%
  features(Trips, quantile)

tourism %>%
  features(Trips, feat_acf)

# 4.3 STL features ========================================================

tourism %>%
  features(Trips, feat_stl)

tourism %>%
  features(Trips, feat_stl) %>%
  ggplot(aes(x = trend_strength, y = seasonal_strength_year,
             col = Purpose)) +
  geom_point() +
  facet_wrap(vars(State))

tourism %>%
  features(Trips, feat_stl) %>%
  filter(
    seasonal_strength_year == max(seasonal_strength_year)
  ) %>%
  left_join(tourism, by = c("State", "Region", "Purpose")) %>%
  ggplot(aes(x = Quarter, y = Trips)) +
  geom_line() +
  facet_grid(vars(State, Region, Purpose))

tourism_features <- tourism %>%
  features(Trips, feature_set(pkgs = "feasts"))

tourism_features
# there are 48 features for 3 key variables (Region, State, Purpose)
glimpse(tourism_features)

library(glue)
tourism_features %>%
  select_at(vars(contains("season"), Purpose)) %>%
  mutate(
    seasonal_peak_year = seasonal_peak_year +
      4*(seasonal_peak_year==0),
    seasonal_trough_year = seasonal_trough_year +
      4*(seasonal_trough_year==0),
    seasonal_peak_year = glue("Q{seasonal_peak_year}"),
    seasonal_trough_year = glue("Q{seasonal_trough_year}"),
  ) %>%
  GGally::ggpairs(mapping = aes(colour = Purpose))

# library(broom)

pcs <- tourism_features %>%
  select(-State, -Region, -Purpose) %>%
  prcomp(scale = TRUE) %>%
  augment(tourism_features)
pcs %>%
  ggplot(aes(x = .fittedPC1, y = .fittedPC2, col = Purpose)) +
  geom_point() +
  theme(aspect.ratio = 1)

outliers <- pcs %>%
  filter(.fittedPC1 > 10) %>%
  select(Region, State, Purpose, .fittedPC1, .fittedPC2)
outliers

outliers %>%
  left_join(tourism, by = c("State", "Region", "Purpose")) %>%
  mutate(
    Series = glue("{State}", "{Region}", "{Purpose}",
                  .sep = "\n\n")
  ) %>%
  ggplot(aes(x = Quarter, y = Trips)) +
  geom_line() +
  facet_grid(Series ~ ., scales = "free") +
  labs(title = "Outlying time series in PC space")

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
