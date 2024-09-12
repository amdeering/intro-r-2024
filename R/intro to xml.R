####intro to xml####
#R class day 3
#special session

#load library
library(tidyr)
library(dplyr)
library(xml2)
library(readr)

#read in xml data for wsdot stations metadata
meta_xml <- as_list(read_xml("https://wsdot.wa.gov/Traffic/WebServices/SWRegion/Service.asmx/GetRMDCLocationData"))

meta_df <- as_tibble(meta_xml) %>% 
  unnest_longer(RTDBLocationList)


