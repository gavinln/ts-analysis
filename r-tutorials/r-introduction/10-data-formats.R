# Data types

# numeric
n1 <- 15  # double precsion
typeof(n1)

n2 <- 1.5
typeof(n2)

c1 <- "c"
typeof(c1)

c2 <- "a string of text"

l1 <- TRUE
typeof(l1)

l2 <- F
typeof(l2)

# vector

v1 <- c(1, 2, 3, 4, 5)
is.vector(v1)

v2 <- c("a", "b", "c")
is.vector(v2)

v3 <- c(T, T, F, F, T)
is.vector(v3)

# matrix
m1 <- matrix(c(T, T, F, F, T, F), nrow=2)
m1

m2 <- matrix(c("a", "b",
               "c", "d"),
               nrow=2)
m2

# array
a1 <- array(c(1:24), c(4, 3, 2))  # 3 dimensions rwos, columns, tables
a1

# data frame
vNumeric <- c(1, 2, 3)
vCharacter <- c("a", "b", "c")
vLogical <- c(T, F, T)

dfa <- cbind(vNumeric, vCharacter, vLogical)
dfa  # Matrix of most general data type, character

df <- as.data.frame(cbind(vNumeric, vCharacter, vLogical))
df

# List
obj1 <- c(1, 2, 3)
obj2 <- c("a", "b", "c", "d")
obj3 <- c(T, F, T, T, F)

list1 <- list(obj1, obj2, obj3)
list1

# list of lists
list2 <- list(obj1, obj2, obj3, list1)

coerce1 <- c(1, "b", T)
typeof(coerce1)

coerce2 <- 5
typeof(coerce2)

coerce3 <- as.integer(5)
typeof(coerce3)

coerce4 <- c("1", "2", "3")
typeof(coerce1)

coerce5 <- as.numeric(c("1", "2", "3"))
typeof(coerce5)

coerce6 <- matrix(1:9, nrow=3)
is.matrix(coerce6)

coerce7 <- as.data.frame(matrix(1:9, nrow=3))
is.data.frame(coerce7)

# clear environment
rm(list=ls())

# Clean up
detach("package:datasets", unload=TRUE)

# clear console
cat("\014")  # ctrl+l

# Clean plots
dev.off()
