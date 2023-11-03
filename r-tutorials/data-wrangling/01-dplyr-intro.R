# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)

pacman::p_install_gh("rstudio/EDAWR")  # install from github

# create a tidy data frame column by column
tbl1 <- tibble(x = 1:5, y = 1, z = x ^ 2 + y)
tbl1

# create a tidy data frame row by row
tbl2 <- tribble(
  ~x, ~y,  ~z,
  "a", 2,  3.6,
  "b", 1,  8.5
)
tbl2

head(EDAWR::cases)
tidyr::gather(EDAWR::cases, "year", "n", 2:4)

head(EDAWR::pollution)
tidyr::spread(EDAWR::pollution, "size", "amount")

head(EDAWR::storms)
storms2 <- tidyr::separate(
  EDAWR::storms, "date", into=c("year", "month", "day"),
  sep="-")
storms2

tidyr::unite(storms2, "date", year, month, day, sep="-")

# work with the data frame

head(EDAWR::storms)
select(EDAWR::storms, wind:date)
filter(EDAWR::storms, wind >= 50)
filter(EDAWR::storms, wind >= 50,
       storm %in% c("Alberto", "Alex", "Allison"))
mutate(EDAWR::storms, ratio=pressure/wind)
mutate(EDAWR::storms, ratio=pressure/wind, inverse=ratio^-1)

head(EDAWR::pollution)
summarise(EDAWR::pollution, median=median(amount),
          variance=var(amount))

head(EDAWR::storms)
arrange(EDAWR::storms, wind)
arrange(EDAWR::storms, desc(wind))
arrange(EDAWR::storms, wind, date)

# pipe multiple operations
EDAWR::storms %>%
  filter(wind >= 50) %>%
  select(storm, pressure)

EDAWR::storms %>%
  mutate(ratio=pressure/wind) %>%
  select(storm, ratio)

# unit of analysis
head(EDAWR::pollution)
EDAWR::pollution %>%
  group_by(city) %>%
  summarise(mean=mean(amount), sum=sum(amount), n=n())

# remove grouping with ungroup()

head(tb)
EDAWR::tb %>%
  mutate(cases=child + adult + elderly)  %>%
  group_by(country, year) %>%
  drop_na() %>%
  summarise(cases=sum(cases))  %>%
  summarise(cases=sum(cases)) %>%
  summarise(cases=sum(cases))


# join along columns
tb1 <- tibble(x = 1:2, y = 1)
tb1

tb2 <- tibble(x = 2:3, y = 1)
tb2

tb3 <- dplyr::bind_rows(tb1, tb2)
tb3

tb4 <- tibble(z=tb3$x ^ 2 + tb3$y)
tb4

tb5 <- dplyr::bind_cols(tb3, tb4)
tb5

dplyr::union(tb1, tb2)
dplyr::intersect(tb1, tb2)
dplyr::setdiff(tb1, tb2)

person_fruit <- tibble(
  name=c('Alice', 'Bob', 'Carol', 'David'),
  fruit=c('Strawberry', 'Cantaloupe', 'Blueberry', 'Watermelon'))
person_fruit

fruit_type <- tibble(
  fruit=c('Strawberry', 'Cantaloupe', 'Watermelon', 'Raspberry'),
  species=c('Berry', 'Melon', 'Melon', 'Berry'))
fruit_type

dplyr::inner_join(person_fruit, fruit_type)

dplyr::left_join(person_fruit, fruit_type)
dplyr::right_join(person_fruit, fruit_type)

dplyr::full_join(person_fruit, fruit_type)

dplyr::semi_join(person_fruit, fruit_type)
dplyr::anti_join(person_fruit, fruit_type)

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
