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
#used the Import feature to read in xlsx and copy/paste the code below
library(readxl)
icebreaker_answers <- read_excel("data/icebreaker_answers.xlsx")
View(icebreaker_answers)
