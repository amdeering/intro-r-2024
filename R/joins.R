####Joins, etc.####

#load library
library(dplyr)
library(ggplot2)

#import data
detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

head(data)

#how many detectors are there
table(data$detector_id)
data_detectors <- data |> distinct(detector_id)
#61 

#joining detector info with data

data_detectors_meta <- data_detectors |>
  left_join(detectors, by = c("detector_id" = "detectorid"))

#how many are missing? 2629 - 61 = 2568
data_detectors_missing <- detectors |>
  anti_join(data_detectors, by = c("detectorid" = "detector_id")) |>
  distinct(detectorid)

#stations practice problem
#multiple detectors to a station
#data_detectors_meta to join with the stations metadata
station_data <- data_detectors_meta |>
  select(detector_id, stationid) |>
  left_join(stations, by = "stationid")
#many to many error. this is because the stations file isn't clean

