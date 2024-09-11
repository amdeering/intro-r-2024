#### Practice Problem: Loading and manipulating a data frame ####
# Don't forget: Comment anywhere the code isn't obvious to you!

# Load the readxl and dplyr packages
library(readxl)
library(dplyr)

# Use the read_excel function to load the class survey data
icebreaker_answers <- read_excel("data/icebreaker_answers.xlsx") #copied this from import tool

# Take a peek!
head(icebreaker_answers)

# Create a travel_speed column in your data frame using vector operations and 
#   assignment
icebreaker_answers$travel_speed <- icebreaker_answers$travel_distance / icebreaker_answers$travel_time *60

# Look at a summary of the new variable--seem reasonable?
view(icebreaker_answers)

# Choose a travel mode, and use a pipe to filter the data by your travel mode
bycar <- icebreaker_answers |>
  filter(travel_mode == "car")

# Note the frequency of the mode (# of rows returned)
nrow(bycar) #note to self: nrow is not plural!
#answer is 8

# Repeat the above, but this time assign the result to a new data frame
# I already did this, see bycar

# Look at a summary of the speed variable for just your travel mode--seem 
#   reasonable?
summary(bycar)

# Filter the data by some arbitrary time, distance, or speed threshold
bycar |>
  filter(travel_speed >= 25) #have to use filter within the pipe structure

# Stretch yourself: Repeat the above, but this time filter the data by two 
#   travel modes (Hint: %in%)
bytransit <- icebreaker_answers |>
  filter(travel_mode %in% c("bus", "light rail", "street car"))

#extras
boxplot(icebreaker_answers$travel_speed ~ icebreaker_answers$travel_mode)
hist(icebreaker_answers$travel_speed)
#my own tests
agg_icebreakers <- aggregate(travel_speed ~ travel_mode, data=icebreaker_answers, FUN = mean)
# cols to average ~ cols to keep, data = df
