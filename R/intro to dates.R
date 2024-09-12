####Intro to Dates####
#R training day 3

#load library
library(dplyr)
library(ggplot2)
library(lubridate)
library(plotly)
#lubridate has some masked functions from base
#plotly has masks of ggplot2 as well

#load data
detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

#look at metadata
str(detectors)
head(detectors$start_date)
#dates come in as chr strings

#to change type of date variables
detectors$start_date <- ymd_hms(detectors$start_date) |> 
  with_tz("US/Pacific")

#how to figure out the time zone names
OlsonNames()

#convert end date to time date format as well
detectors$end_date <- ymd_hms(detectors$end_date) |> 
  with_tz("US/Pacific")

#select detectors that are active (no end date)
open_det <- detectors |> 
  filter(is.na(end_date))

closed_det <- detectors |> 
  filter(!is.na(end_date))

#want total daily volume, avg vol, and avg speed/statistics
##relevant example!! ----

#step 1: join detector data, select relevant columns
data_stid <- data |> 
  left_join(open_det, by = c("detector_id" = "detectorid")) |> 
  select(detector_id, starttime, volume, speed, countreadings, stationid)

#step 2: convert starttime to datetime format
data_stid$starttime <- ymd_hms(data_stid$starttime) |> 
  with_tz("US/Pacific")

#step 3: convert to time resolution desired, then pipe to group, then summarize
#floor_date can round up to nearest day, minute, etc.
daily_data <- data_stid |> 
  mutate(date = floor_date(starttime, unit = "day")) |> 
  group_by(stationid, date) |> 
  summarize(
    daily_volume = sum(volume),
    daily_obs = sum(countreadings),
    mean_speed = mean(speed)) 

#check data structure. sometimes too much manipulating makes the structure over-
  #complicated (-attr and more junk under the five column descriptions)
str(daily_data)

#add this to the pipe, force to data frame
daily_data <- data_stid |> 
  mutate(date = floor_date(starttime, unit = "day")) |> 
  group_by(stationid, date) |> 
  summarize(
    daily_volume = sum(volume),
    daily_obs = sum(countreadings),
    mean_speed = mean(speed)) |> 
  as.data.frame()

#plot data to check it out
daily_vol_fig <- daily_data |>
  ggplot(aes(x = date, y=daily_volume)) +
  geom_line() +
  geom_point() +
  facet_grid(stationid ~ ., scales = "free") +
  labs(x = "Date", y = "Daily Vol") +
  theme_bw()
daily_vol_fig

#using plotly
ggplotly(daily_vol_fig)
#gives info when you hover over the big plot in zoom mode. click zoom button in viewer

#hard to find data gaps
#no good packages, just have to start looking into the data

#how many stations, make list
length(unique(daily_data$stationid))
#23
stids <- unique(daily_data$stationid)
#setting up a process to add in missing dates. 
# ggplot will show a break for nas, so we have to add them in
start_date <- ymd("2023-03-01")
end_date <- ymd("2023-03-31")
date_df <- data.frame(
  date_seq = rep(seq(start_date, end_date, by = "1 day")),
  station_id = rep(stids, each = 31)
)

data_with_gaps <- date_df |> 
  left_join(daily_data, by = c("date_seq" = "date",
                               "station_id" = "stationid"))
#save out as csv
write.csv(data_with_gaps, "data/data_with_gaps.csv", row.names = F) 
#makes sure row numbers aren't maintained
#faster ways to read or save in tidyverse

#can also save as intact R format, also compresses file
saveRDS(data_with_gaps, "data/data_with_gaps.rds")

#plot new data with gaps
daily_vol_fig2 <- data_with_gaps |>
  ggplot(aes(x = date_seq, y=daily_volume)) +
  geom_line() +
  geom_point() +
  facet_grid(station_id ~ ., scales = "free") +
  labs(x = "Date", y = "Daily Vol") +
  theme_bw()
daily_vol_fig2

#plot new data with gaps, filtered to 3 stations for visibility
daily_vol_fig3 <- data_with_gaps |>
  filter(station_id %in% c(1056, 1057, 1059))  |> 
  ggplot(aes(x = date_seq, y=daily_volume)) +
  geom_line() +
  geom_point() +
  facet_grid(station_id ~ .) +
  labs(x = "Date", y = "Daily Vol") +
  theme_bw()
daily_vol_fig3

#plot with better date labels
#have to convert current date (as timestamp) to actual date format
daily_vol_fig4 <- data_with_gaps |>
  filter(station_id %in% c(1056, 1057, 1059))  |> 
  ggplot(aes(x = as.Date(date_seq), y=daily_volume)) +
  geom_line() +
  geom_point() +
  facet_grid(station_id ~ .) +
  scale_x_date(date_breaks = "1 day") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Date", y = "Daily Vol") +
  theme_bw()
daily_vol_fig4

#add in average line with geom hline
daily_vol_fig5 <- data_with_gaps |>
  filter(station_id %in% c(1056, 1057, 1059))  |> 
  ggplot(aes(x = as.Date(date_seq), y=daily_volume)) +
  geom_line() +
  geom_point() +
  facet_grid(station_id ~ .) +
  scale_x_date(date_breaks = "1 day") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_hline(yintercept = mean(daily_data$daily_volume)) +
  labs(x = "Date", y = "Daily Vol")
daily_vol_fig5