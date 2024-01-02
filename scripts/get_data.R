# ideas from https://github.com/VictimOfMaths/Routine-Data/blob/master/ONSPriceQuotes.R 
# data from : https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes
# glossary for datasets can be found here: https://www.ons.gov.uk/file?uri=%2feconomy%2finflationandpriceindices%2fdatasets%2fconsumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes%2fglossary/glossaryrevised.xls

# fetch the data ----
# so far only from Sept 2019 to Aug 2023
library(tidyverse)
library(lubridate)
library(data.table)
library(glue)
library(curl)

# setup sequence of dates for string manipulation
month_year <- c(as.Date("2018-12-01"), seq.Date(from = as.Date("2019-08-01"), to = as.Date("2023-11-01"), by = "month")) |> 
  format("%B%Y") |>
  tolower()

year_month <- c(as.Date("2018-12-01"), seq.Date(from = as.Date("2019-08-01"), to = as.Date("2023-11-01"), by = "month")) |>
  format("%Y%m")

# function to make unique url links
# several try catches for the weird urls
making_links <- function(month_year, year_month) {
  
  prices <- c("202001", "202002", "202003", "202004", "202007")
  v1 <- c("201912")
  wrong_way <- c("202005")
  added_digit <- c("202105")
  no_month <- c("201908")
  
  if(year_month %in% prices) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricesquotes{month_year}/upload-pricequotes{year_month}.csv")
  } else if(year_month %in% v1) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes{month_year}/upload-pricequotes{year_month}v1.csv")
  } else if(year_month %in% wrong_way) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricesquotes{month_year}/upload-{year_month}pricequotes.csv")
  } else if(year_month %in% added_digit) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes{month_year}/upload-pricequotes{year_month}1.csv")
  } else if (year_month %in% no_month) {
    link <- glue("https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes{str_sub(year_month, 1, 4)}/upload-pricequotes{year_month}.csv")
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

# bind data
price_quotes <- data.table::rbindlist(df_list) |>
  janitor::clean_names()

# dates for files stored in zip ----
month_year2 <- seq.Date(from = as.Date("2017-12-01"), to = as.Date("2018-11-01"), by = "month") |> 
  format("%B%Y") |>
  tolower()

year_month2 <- seq.Date(from = as.Date("2017-12-01"), to = as.Date("2018-11-01"), by = "month") |>
  format("%Y%m")

# making zip links
making_links_zip <- function(month_year2, year_month2) {
  
  quotes <- c("201712")
  
  if (year_month2 %in% quotes) {
    link <- glue("https://www.ons.gov.uk/file?uri=%2feconomy%2finflationandpriceindices%2fdatasets%2fconsumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes%2fpricequotes{month_year2}/pricequote{year_month2}.zip")
  } else {
    link <- glue("https://www.ons.gov.uk/file?uri=%2feconomy%2finflationandpriceindices%2fdatasets%2fconsumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes%2fpricequote{month_year2}/pricequote{year_month2}.zip")
  }
  
  return(link)
  
}

# construct zip links
urls_zip <- map2_vec(.x = month_year2,
                     .y = year_month2,
                     .f = making_links_zip)

# making temp file links for reading
make_temp_files <- function(urls_zip) {
  
  temp <- tempfile()
  temp2 <- tempfile()
  
  temp <- curl_download(url = urls_zip, destfile = temp, quiet = FALSE, mode = "wb")
  unzip(zipfile = temp, exdir = temp2)
  
  return(temp)
  
}

# construct temp file links
temp_links <- map_chr(.x = urls_zip, .f = make_temp_files)

# load in data
df_list2 <- map(.x = temp_links, .f = read_csv)

# bind data in the list
price_quotes2 <- data.table::rbindlist(df_list2) |>
  janitor::clean_names()

# bind to rest of data
price_quotes <- rbind(price_quotes, price_quotes2)

# fix up the dates ----
# convert to data.table for speed (very large df)
price_quotes <- as.data.table(price_quotes)

price_quotes[, `:=` (start_date = lubridate::ym(start_date))]
price_quotes[, `:=` (year = data.table::year(start_date))]
price_quotes[, `:=` (month = lubridate::month(start_date, label = TRUE, abbr = FALSE))]
price_quotes[, `:=` (quote_date = format(start_date, "%B %Y"))]

#str(price_quotes)
#unique(price_quotes$quote_date)

# currently pulling Nov 2023 to roughly Feb 2018
# data goes yearly pre Dec 2017


