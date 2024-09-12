####Tidy Census Example####
#Day 3 R training
#special sessions

#load library
library(tidycensus)
library(dplyr)
library(tidyr)
library(ggplot2)

# key time! ----
#run on first use if not already stored in R
#installs into R user environment
census_api_key("myCensusAPIKey", install=T)
readRenviron("~/.Renviron")
# end key initialize step ----

#User functions ----

#census example ----
#get a searchable census variable table
v19 <- load_variables(2019, "acs5")
v19 |> filter(grepl("^B08006_", name)) |>
  print(n=25)

#get the data for transit, work from home, and total workers
comm_19_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah",
                       state = "OR",
                       year = 2019,
                       survey = "acs5",
                       geometry = FALSE) #can retrieve spatial geoms pre-joined if true

#reshape table with a column for each variable
comm_19 <- comm_19_raw |> 
  pivot_wider(id_cols = GEOID,
              names_from = variable,
              values_from = estimate:moe)
comm_19

#write function to get same data for 2019











