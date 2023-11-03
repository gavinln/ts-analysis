# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)

pacman::p_load(tsibble, tsibbledata)
pacman::p_load(feasts)
pacman::p_load(fpp3)

# Chapter 3 Time series decomposition -------------------------------------

# 3.1 Transformation and adjustments ======================================

head(global_economy)

global_economy %>%
  filter(Country == "Australia") %>%
  autoplot(GDP/Population) +
  labs(title="GDP per capita", y="$US")

aus_economy <- global_economy %>%
  filter(Code == "AUS")

glimpse(aus_economy)

glimpse(aus_retail)

print_retail <- aus_retail %>%
  filter(Industry == "Newspaper and book retailing") %>%
  group_by(Industry) %>%
  index_by(Year = year(Month)) %>%
  summarise(Turnover = sum(Turnover))

# inflation adjusted Australian print media

aus_print_turnover <- print_retail %>%
  left_join(aus_economy, by = "Year") %>%
  mutate(Adjusted_turnover = Turnover / CPI * 100) %>%
  pivot_longer(c(Turnover, Adjusted_turnover),
               values_to = "Turnover") %>%
  mutate(name = factor(name, levels=c("Turnover", 'Adjusted_turnover"')))

aus_print_turnover %>%
  ggplot(aes(x = Year, y = Turnover)) +
  geom_line() +
  facet_grid(name ~ ., scales = "free_y") +
  labs(title = "Turnover; Australian print media industry",
       y = "$AU")

# 3.2 Time series components ==============================================

# additive decomposition
# y_t = S_t + T_t + R_t

# S_t is the seasonal component
# T_t is the trend component
# R_t is the remainder component

# multiplicative decomposition
# y_t = S_t * T_t * R_t
# log y_t = log S_t + log T_t + log R_t

# U.S. retail sector employment
head(us_employment)

us_retail_employment <- us_employment %>%
  filter(year(Month) >= 1990, Title == "Retail Trade") %>%
  select(-Series_ID)

autoplot(us_retail_employment, Employed) +
  labs(y = "Person (thousands)",
       title = "Total employment in US retail")

# STL decomposition
dcmp <- us_retail_employment %>%
  model(stl = STL(Employed))
components(dcmp)

components(dcmp) %>%
  as_tsibble() %>%
  autoplot(Employed, color = "gray") +
  geom_line(aes(y=trend), color = "#D44E00") +
  labs(x = "Persons (thousands)",
       title = "Total employment in US retail")

components(dcmp) %>% autoplot()

# seasonally adjusted data

components(dcmp) %>%
  as_tsibble() %>%
  autoplot(Employed, color="gray") +
  geom_line(aes(y=season_adjust), colour = "#0072B2") +
  labs(y = "Persons (thousands)",
       title = "Total employment in US retail")


# 3.3 Moving averages =====================================================

global_economy %>%
  filter(Country == "Australia") %>%
  autoplot(Exports) +
  labs(y = "% of GDP",
       title = "Total Australian exports")

aus_exports <- global_economy %>%
  filter(Country == "Australia") %>%
  mutate(S_MA = slider::slide_dbl(
    Exports, mean, .before = 2, .after = 2, complete = TRUE))

aus_exports %>%
  autoplot(Exports) +
  geom_line(aes(y = S_MA), color = "#D55E00") +
  labs(y = "% of GDP",
       title = "Total Australian exports") +
  guides(color = guide_legend(title = "series"))

# 3.4 Classical decomposition =============================================

# not used

# 3.5 Methods used by official statistics agencies ========================

# 3.6 STL decomposition ===================================================

# Seasonal and Trend decomposition using Loess

us_retail_employment %>%
  model(
    STL(Employed ~ trend(window = 7) +
          season(window = "period"),
        robust=TRUE)) %>%
  components() %>%
  autoplot()


head(us_retail_employment)

glimpse(us_retail_employment)

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
