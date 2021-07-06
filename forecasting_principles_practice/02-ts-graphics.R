# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)

pacman::p_load(tsibble, tsibbledata)
pacman::p_load(feasts)

# Chapter 2 Time series graphics ------------------------------------------

# 2.1 tsibble objects =====================================================

glimpse(olympic_running)

# create a tsibble object
y <- tsibble(
  Year = 2015:2019,
  Observation = c(123, 39, 78, 52, 110),
  index = Year
)

z <- tibble(
  Month=c("2019 Jan", "2019 Feb", "2019 Mar", "2019 Apr", "2019 May"),
  Observation=c(50, 23, 34, 30, 25)
)

z %>%
  mutate(Month=yearmonth(Month)) %>%  
  as_tsibble(index=Month)

# time class functions
# Annual start:end
# Quarterly yearquarter()
# Monthly yearmonth()
# Weekly yearweek()
# daily as_date()
# sub-daily as_datetime()

# work with tsibble objects
olympic_running %>% 
  distinct(Sex)

# Australia medical prescription data
glimpse(PBS)

PBS %>% 
  filter(ATC2 == "A10")

PBS %>% 
  filter(ATC2 == "A10") %>% 
  select(Month, Concession, Type, Cost)

PBS %>% 
  filter(ATC2 == "A10") %>% 
  select(Month, Concession, Type, Cost) %>% 
  summarise(TotalC = sum(Cost))

a10 <- PBS %>% 
  filter(ATC2 == "A10") %>% 
  select(Month, Concession, Type, Cost) %>% 
  summarise(TotalC = sum(Cost)) %>% 
  mutate(Cost = TotalC/1e6)

rio_csv <- rio::import("https://OTexts.com/fpp3/extrafiles/prison_population.csv")
prison <- as_tibble(rio_csv)

glimpse(prison)

prison <- prison %>% 
  mutate(Quarter = yearquarter(Date)) %>% 
  select(-Date) %>% 
  as_tsibble(key = c(State, Gender, Legal, Indigenous),
             index = Quarter)
prison

# 2.2 Time plots ==========================================================

# Plot Melbourne-Sydney flights on Ansett airlines

melsyd_economy <- ansett %>% 
  filter(Airports == "MEL-SYD", Class == "Economy") %>%
  mutate(Passengers = Passengers/1000)

autoplot(melsyd_economy, Passengers) +
  labs(title = "Ansett airlines economy class",
       subtitle = "Melbourne-Sydney",
       y = "Passengers ('000)")

# Austalian antidiabetic drug sales
autoplot(a10, Cost) + 
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales")

# 2.4 Seasonal plots ======================================================

a10 %>% 
  gg_season(Cost, labels = "both") + 
  labs(y = "$ (millions)",
       title = "Seasonal plot: Antidiabetic drug sales")

# electricity demand in Victoria
vic_elec %>% 
  gg_season(Demand, period = "day") +
  theme(legend.position = "none") + 
  labs(y="MW", title="Electricity demand: Victoria")

# weekly
vic_elec %>% 
  gg_season(Demand, period = "week") +
  theme(legend.position = "none") + 
  labs(y="MW", title="Electricity demand: Victoria")

# yearly
vic_elec %>% 
  gg_season(Demand, period = "year") +
  labs(y="MW", title="Electricity demand: Victoria")

# 2.5 Seasonal sub-series plots ======================================================

a10 %>% 
  gg_subseries(Cost) + 
  labs(
    y="$ (millions)",
    title = "Australian antidiabetic drug sales"
  )

holidays <- tourism %>% 
  filter(Purpose == "Holiday") %>% 
  group_by(State) %>% 
  summarise(Trips = sum(Trips))
holidays

autoplot(holidays, Trips) + 
  labs(y = "Overnight trips ('000)",
       title = "Australian domestic holidays")

gg_season(holidays, Trips) + 
  labs(y = "Overnight trips ('000)",
       title = "Australian domestic holidays")

holidays %>% 
  gg_subseries(Trips) + 
  labs(y = "Overnight trips ('000)",
       title = "Australian domestic holidays")

# 2.6 Scatterplots ===================================================================

vic_elec %>% 
  filter(year(Time) == 2014) %>% 
  autoplot(Demand) +
  labs(y = "GW",
       title = "Half-hourly electricity demand: Victoria")

vic_elec %>% 
  filter(year(Time) == 2014) %>% 
  autoplot(Temperature) +
  labs(y = "Degrees Celsius",
       title = "Half-hourly temperature demand: Victoria")

vic_elec %>% 
  filter(year(Time) == 2014) %>% 
  ggplot(aes(x = Temperature, y = Demand)) +
  geom_point() + 
  labs(x = "Temperature (degrees Celsius",
       y = "Electricity demand (GW)")

visitors <- tourism %>% 
  group_by(State) %>% 
  summarise(Trips = sum(Trips))

visitors %>% 
  ggplot(aes(x = Quarter, y = Trips)) +
  geom_line() + 
  facet_grid(vars(State), scales = "free_y") + 
  labs(x = "Australian domestic tourism",
       y = "Overnight trips ('000)")

visitors %>% 
  pivot_wider(values_from=Trips, names_from=State) %>% 
  GGally::ggpairs(columns = 2:9) 

# 2.7 Lag plots ======================================================================

recent_production <- aus_production %>% 
  filter(year(Quarter) >= 2000)

recent_production %>% 
  gg_lag(Beer, geom = "point") + 
  labs(y = "lag(Beer, k)")

# 2.8 Autocorrelation ================================================================
recent_production %>% 
  ACF(Beer, lag_max=9)

recent_production %>% 
  ACF(Beer) %>% 
  autoplot() +
  labs(title = "Australian beer production")

a10 %>% 
  ACF(Cost, lag_max = 48) %>% 
  autoplot() +
  labs(title="Australian antidiabetic drug sales")

# 2.9 White noise ====================================================================
set.seed(30)
y <- tsibble(sample = 1:50, wn = rnorm(50), index = sample)
y %>% autoplot(wn) + labs(title = "White noise", y="")

y %>% 
  ACF(wn) %>% 
  autoplot() + labs(title = "White noise")

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

