# script is for extracting various parts of the price data
# save some extracts in the data folder for ease of use

# libraries
library(tidyverse)
library(lubridate)
library(data.table)
library(glue)

# pull data (this might take a little while)
source("scripts/get_data.R")


# next steps
# pull out data we are interested in
# check out various codes etc. 
bread <- price_quotes |>
  filter(grepl("loaf", item_desc, ignore.case = TRUE))


# for testing on smaller dataset ----
df <- price_quotes[1:200, ]