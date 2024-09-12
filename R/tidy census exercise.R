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
tidy_acs_result <- function(raw_result, include_moe = F) {
  #takes a tidycensus acs result and returns a wide and tidy table
  if (isTRUE(include_moe)) {
    new_df <- raw_result |> pivot_wider(id_cols = GEOID:NAME,
                                        names_from = variable,
                                        values_from = estimate:moe)
  } else {
    new_df <- raw_result |> pivot_wider(id_cols = GEOID:NAME,
                                        names_from = variable,
                                        values_from = estimate)
  }
  return(new_df)
}

#end functions section ----

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

#write function to do same tidy and widen process
#see functions section
#test
comm_19 <- tidy_acs_result(comm_19_raw)

#do the same for 2022
#get data
comm_22_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah",
                       state = "OR",
                       year = 2022,
                       survey = "acs5",
                       geometry = FALSE)
comm_22 <-tidy_acs_result(comm_22_raw)
#not the Names and geoids change in 2022 because of new decennial census!!
#tracts are split when the pop grows too large

#see how mode splits of transit and wfh change pre and post pandemic
# join the years, use inner join to only keep tracts that stayed the same between years
comm_19_22 <- comm_19 |> inner_join(comm_22,
                                    by = "GEOID",
                                    suffix = c("_19", "_22")) |>  #instead of x and y R will append
  select(-starts_with("NAME"))

#create some change variables
comm_19_22 <- comm_19_22 |> 
  mutate(wfh_chg = wfh_22 - wfh_19,
         transit_chg = transit_22 - transit_19)

summary(comm_19_22 |> select(ends_with("_chg"))) #check to see if reasonable

#make some plots
fig1 <- comm_19_22 |> 
  ggplot(aes(x = wfh_chg, y = transit_chg)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(x="change in WFH", 
       y="change in transit use",
       title = "ACS 2022 vs 2019 (5-year)") +
  annotate("text", x=800, y=50,
           label = paste("r =",
                         round(cor(comm_19_22$wfh_chg,
                             comm_19_22$transit_chg), 2)))
fig1
#annotate is cool!
#paste is like concat

#simple linear (default Pearson) correlation
cor(comm_19_22$wfh_chg,
    comm_19_22$transit_chg)
#gives the -0.38 plot notation

#model it ----
m <- lm(transit_chg ~ wfh_chg, 
        data = comm_19_22)
summary(m)
#model formula is dependent var ~ indep var1 + indep var2, etc

#model is an object ready for re-use
head(m$model) #Model comes with data included

scen1 <- comm_19_22 |> 
  mutate(wfh_chg = wfh_chg * 1.5)
scen1_pred <- predict(m, newdata = scen1)

#difference in total daily transit impact from 50% increase in WFH change
sum(comm_19_22$transit_chg)
sum(scen1_pred)
