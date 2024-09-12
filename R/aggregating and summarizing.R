#### Aggregating and Summarizing data ####
#R training day 3

#load library
library(readxl)
library(dplyr)
library(ggplot2)

#load data
df <- read_excel("Data/icebreaker_answers.xlsx")

#custom summaries of a dataframe
df |> summarize(
  avg_dist = mean(travel_distance),
  sd_dist = sd(travel_distance),
  pct60_dist = quantile(travel_distance, prob = 0.6),
  avg_time = mean(travel_time)
)
#assign summary
df_summ <- df |> summarize(
  avg_dist = mean(travel_distance),
  sd_dist = sd(travel_distance),
  pct60_dist = quantile(travel_distance, prob = 0.6),
  avg_time = mean(travel_time)
)

#if you want an integer, must specify
df |> mutate(travel_time = as.integer(travel_time))

#aggregating by using group by and summarize
df <- df |> mutate(
  travel_speed = travel_distance / travel_time *60)

#average speed
df |> summarize(
  avg_speed = mean(travel_speed)
)

#average speed by mode
df |> group_by(travel_mode) |>
  summarize(avg_speed = mean(travel_speed)
)
#sort by avg speed instead

df |> group_by(travel_mode) |>
      summarize(avg_speed = mean(travel_speed)) |>
      arrange(desc(avg_speed)
  )

#group by alone adds groups to the data frame
#shows up in description at top of the tibble
df_mode_grp <- df |> group_by(travel_mode)
str(df_mode_grp)

#grouping by multiple variables
#tibble doesn't show the serial_comma as grouped. It leaves off the last group level.
#by default summarize will leave data grouped by next higher level
df |> group_by(travel_mode, serial_comma) |>
  summarize(avg_speed = mean(travel_speed))

#can ungroup data
#should do at the end so you don't forget about the grouping
df_mode_comma <- df |> group_by(travel_mode, serial_comma) |>
  summarize(avg_speed = mean(travel_speed)) |>
  ungroup()

#frequencies so common there are shortcuts
#count
#long way
df |> group_by(serial_comma) |>
  summarize(n = n())
#short cut (avoids naming a new variable in summarize)
df |> group_by(serial_comma) |> 
  tally()
#another short cut (uses count to avoid grouping first)
df |> count(serial_comma)
#can add sort
df |> count(serial_comma, sort=T)

#calculate a mode split percent
df |> group_by(travel_mode) |> 
  summarize(mode_split = n() / nrow(df) * 100) |> 
  arrange(desc(mode_split))
