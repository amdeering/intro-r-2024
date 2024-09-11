####Intro to ggplot2 and visualization####

#load library
library(dplyr)
library(ggplot2)
library(readxl)

#load data
df_ice <- read_excel("data/icebreaker_answers.xlsx")

#dygraph for time series

#ggplot2

tt_mi_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,y = travel_distance)
    ) +
      geom_point()

tt_mi_comma_fig <- df_ice |>
  ggplot(
    aes(x = travel_time, y=travel_distance, color = serial_comma)
  ) +
  geom_point() +
  xlab("Travel Time") +
  ylab("Travel Distance") #use + to add each layer onto ggplot

#can build on top of figures
tt_mi_2 <- tt_mi_comma_fig +
  theme_bw()
#I like the themes!

#create new figure with color by mode
tt_mi_mode_fig <- df_ice |>
  ggplot(
    aes(x = travel_time, y=travel_distance, color = travel_mode)
  ) +
  geom_point() +
  labs(x = "Travel Time", y = "Travel Distance", color = "Travel Mode") +
  theme_bw()

#faceting
ice_facet_fig <- df_ice |>
  ggplot(
    aes(x = travel_time, y=travel_distance)
  ) +
  geom_point() +
  facet_wrap(. ~ travel_mode, scales = "free") +
  labs(x = "Travel Time", y = "Travel Distance") +
  theme_bw()

#just plot car
tt_mode_car_fig <- df_ice |>
  filter(travel_mode == "car") |>
  ggplot(
    aes(x = travel_time, y=travel_distance)
  ) +
  geom_point() +
  labs(x = "Travel Time", y = "Travel Distance") +
  theme_bw()


  