#### R Basics ####
# "A foolish consistency is the hobgoblin of 
#   little minds"   -Ralph Waldo Emerson 

# Literals ----
"this is a string literal" #double quotes preferred in R but not required
42
T
TRUE

# Operators ----
2 + 3 #use spaces to make things more legible

##comparison
2 == 2 #tests for equality
2 != 1 # ! means not
2 < 3

TRUE == 1 #True has a value of 1, false = 0

#can also use isTRUE() function
?isTRUE #queries built-in help

2 < 3 & 1 < 2
2 < 3 | 2 > 3

#types

"joe" #string or character type
typeof("joe")
42 #numeric type (double precision, floating point)
typeof(42)
TRUE #logical or boolean
typeof(TRUE)

42 == "42" #equality can cross types. beware of rounding.
identical(42, "42") #type matters for identity

# variables ----

x <- "this is a string"

# data structures ----
# vectors have a single dimension, like a column or row of data

a <- c("1", "2", "3")
b <- c(1, 2, 3)
#vectorized operation
b + 1

#will allow mixed types, but converts all to the most workable type
c <- c(1, 2, "3") #turns to character

b < 3 #elementwise comparison
any(b < 3) #gives one answer
all(b < 3)

3 %in% b #testing membership in a vector
!4 %in% b #use ! for negation, placed ahead of 4

# data frames - the key structure for data science, multi-dimensional
#   collections of vectors
df <- data.frame(a = c(1, 2, 3),
                b = c("joe", "tammy", "matt"))
df$a #reference one column
df$mode <- c("bike", "walk", "car")
summary(df)


# Special type: factors, and putting it all together ----
# factors are categorical variables with a fixed set of
#   potential values


