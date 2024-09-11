### Transforming data part 2

#load libraries
library(readxl)
library(dplyr)

#read in data
traveldata <- read_excel("data/icebreaker_answers.xlsx")

#preparing data to test out new functions
traveldata <- traveldata |> bind_rows(slice_tail(traveldata)) #take last row and add to end of df

#remove that row
traveldata <- traveldata |> distinct() #can put column names in paren.
#distinct is similar to unique in base r. distinct is similar to sql 

#selecting columns
#different methods
#list all columns to keep, in the order you want
traveldata |> select(travel_mode, travel_distance, travel_time)
#list column to drop
traveldata |> select(-serial_comma)
#use ranges
traveldata |> select(travel_mode:travel_distance)
#use starts with or ends with
traveldata |> select(starts_with("travel_"))

df_travel <- traveldata |> select(-serial_comma)

#mutate and rename
#old way to add a new column
df_travel$travel_speed <- (df_travel$travel_distance /
                            df_travel$travel_time *60) #mph

#new way to add column with mutate
df_travel <- df_travel |>
  mutate(travel_speed = travel_distance / travel_time * 60) #mph
#can add multiple columns, just add a comma in mutate

#renaming with mutate
df_travel <- df_travel |> 
  rename(travel_mph = travel_speed) #new name = old col
#look at colnames
colnames(df_travel)

#adding logic to mutate
df_travel <- df_travel |>
  mutate(long_trip = if_else(travel_distance > 20,
                             1, 0))
#case when
df_travel <- df_travel |>
  mutate(slow_trip = 
           case_when(
             travel_mode == "bike" & travel_mph < 12 ~ 1,
             travel_mode == "car" & travel_mph < 25 ~ 1,
             travel_mode == "bus" & travel_mph < 15 ~ 1,
             travel_mode == "light rail" & travel_mph < 20 ~ 1,
             .default = 0 #all else = 0
           ))

#use arrange to sort output
df_travel |> arrange(travel_mph) #from slowest to fastest, defaults ascending
df_travel |> arrange(travel_mode, travel_mph) #sorts in order of columns listed
df_travel |> arrange(desc(travel_mph)) #from fastest to slowest





