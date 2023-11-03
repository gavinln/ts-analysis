# Load packages -----------------------------------------------------------
library(datasets)  # load/unload packages manually

# Load data
?lynx

hist(lynx)

hist(lynx,
     breaks=14,
     freq=FALSE,
     col="thistle1",  # color
     main=paste("Histogram of annual canadian lynx",
                "trappings, 1821-1934"),
     xlab="Number of lynx trapped"
     )

# add a normal distribution
curve(dnorm(x, mean=mean(lynx), sd=sd(lynx)),
      col="thistle4",
      lwd=2,  # line width
      add=TRUE)  # superimpose on previous graph

# add two kernel density estimators
lines(density(lynx), col="blue", lwd=2)
lines(density(lynx, adjust=3), col="purple", lwd=2)

# add a rug plot
rug(lynx, lwd=2, col="gray")

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
