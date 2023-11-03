# load libraries

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr)


scriptDir <- dirname(rstudioapi::getSourceEditorContext()$path)

rio_csv <- import(file.path(scriptDir, 'titanic.csv'))
titanic <- as_tibble(rio_csv)

glimpse(titanic)

# set up factors
titanic$Pclass <- as.factor(titanic$Pclass)
titanic$Survived<- as.factor(titanic$Survived)
titanic$Sex <- as.factor(titanic$Sex)
titanic$Embarked <- as.factor(titanic$Embarked)

# What was the survival rate?
ggplot(titanic, aes(x=Survived)) + geom_bar()

# display percentages
prop.table(table(titanic$Survived))

# customization for labels and theme
ggplot(titanic, aes(x=Survived)) +
  theme_bw() +
  geom_bar() +
  labs(y="Passenger Count",
       title="Titanic survival rates")

# What was the survival rate by gender?
ggplot(titanic, aes(x=Sex, fill=Survived)) +
  theme_bw() +
  geom_bar() +
  labs(y="Passenger Count",
       title="Titanic survival rates by gender")

# What was the survival rate by class?
ggplot(titanic, aes(x=Pclass, fill=Survived)) +
  theme_bw() +
  geom_bar() +
  labs(y="Passenger Count",
       title="Titanic survival rates by Pclass")

# What was the survival rate by class of ticket and gender?
ggplot(titanic, aes(x=Sex, fill=Survived)) +
  theme_bw() +
  facet_wrap(~Pclass) +
  geom_bar() +
  labs(y="Passenger Count",
       title="Titanic survival rates by Pclass and gender")

# What is the distribution of passenger ages?
ggplot(titanic, aes(x=Age)) +
  theme_bw() +
  geom_histogram(binwidth=5) +
  labs(y="Passenger count",
       x="Age (binwidth=5)",
       title="Titanic age distribution")

# What are the survival rates by age?
ggplot(titanic, aes(x=Age, fill=Survived)) +
  theme_bw() +
  geom_histogram(binwidth=5) +
  labs(y="Passenger count",
       x="Age (binwidth=5)",
       title="Titanic survival rates by age")

# What are the survival rates by age?
ggplot(titanic, aes(x=Survived, y=Age)) +
  theme_bw() +
  geom_boxplot() +
  labs(y="Age",
       x="Survived",
       title="Titanic survival rates by age")

# What are the survival rates by age when segmented by gender and class?
ggplot(titanic, aes(x=Age, fill=Survived)) +
  theme_bw() +
  facet_wrap(Sex ~ Pclass) +
  geom_density(alpha=0.5) +
  labs(y="Age",
       x="Survived",
       title="Titanic survival rates by Age, Pclass and Sex")

# Survival rates by age when segmented by gender and class using histograms?
ggplot(titanic, aes(x=Age, fill=Survived)) +
  theme_bw() +
  facet_wrap(Sex ~ Pclass) +
  geom_histogram(binwidth=5) +
  labs(y="Age",
       x="Survived",
       title="Titanic survival rates by Age, Pclass and Sex")

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
