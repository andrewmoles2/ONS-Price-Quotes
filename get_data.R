# ideas from https://github.com/VictimOfMaths/Routine-Data/blob/master/ONSPriceQuotes.R 

# fetch the data ----
# so far only from Sept 2019 to Aug 2023
library(tidyverse)
library(glue)

# Setup sequence of dates for string manipulation
month_year <- seq.Date(from = as.Date("2019-09-01"), to = as.Date("2023-08-01"), by = "month") |> 
  format("%B%Y") |>
  tolower()

year_month <- seq.Date(from = as.Date("2019-09-01"), to = as.Date("2023-08-01"), by = "month") |>
  format("%Y%m")

# function to make unique url links
# several try catches for the weird urls
making_links <- function(month_year, year_month) {
  
  prices <- c("202001", "202002", "202003", "202004", "202007")
  v1 <- c("201912")
  wrong_way <- c("202005")
  added_digit <- c("202105")
  
  if(year_month %in% prices) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricesquotes{month_year}/upload-pricequotes{year_month}.csv")
  } else if(year_month %in% v1) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes{month_year}/upload-pricequotes{year_month}v1.csv")
  } else if(year_month %in% wrong_way) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricesquotes{month_year}/upload-{year_month}pricequotes.csv")
  } else if(year_month %in% added_digit) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes{month_year}/upload-pricequotes{year_month}1.csv")
  } else {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes{month_year}/upload-pricequotes{year_month}.csv")
  }
  
  return(link)
}

# make links
urls <- map2_vec(.x = month_year,
                 .y = year_month,
                 .f = making_links)

# pull the data into a list
df_list <- map(.x = urls, .f = read_csv)

# next steps
# bind data
# pull out data we are interested in
# check out various codes etc. 



