# Day 2 of R Training


#base R
sta_meta <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
#use dropdown on side to check data types and columns
#this example treats the NA columns weirdly in terms of guessing type

#can also use str to see structure of data
str(sta_meta)

head(sta_meta) #first six rows of data, preview
tail(sta_meta) #last six rows

nrow(sta_meta) #number of rows

summary(sta_meta) #gives NA counts, which can be helpful to check import

#reading in excel files
#uses a specific package
#used the Import feature to read in xlsx and copy/paste the code below
library(readxl)
icebreaker_answers <- read_excel("data/icebreaker_answers.xlsx")
View(icebreaker_answers)

#entering the tidyverse
library(dplyr)
#gives a warning that some of the functions in this package override some same-
#named ones in other base packages, when calling by name

odot_meta <- sta_meta |>
  filter(agency == "ODOT",
         highwayid == 1)

notodot_meta <- sta_meta |>
  filter(agency != "ODOT")
#looking for NAs
nas_meta <- sta_meta |>
  filter(is.na(detectorlocation))
#excluding NAs
real_meta <- sta_meta |>
  filter(!is.na(detectorlocation))
