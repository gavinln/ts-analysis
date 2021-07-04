# Load data
# From R programming tutorial video https://www.youtube.com/watch?v=_V8eKsto3Ug 

library(datasets)

# Summarize data

head(iris)
summary(iris)
plot(iris)

# Clean up

detach("package:datasets", unload=TRUE)

# Clean plots
dev.off()

