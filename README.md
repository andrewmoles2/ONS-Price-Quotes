# ONS-Price-Quotes

## About this Dataset
Price quote data and item indices that underpin consumer price inflation statistics are now published, giving users unprecedented access to the detailed data that are used in the construction of the UK's inflation figures. With effect from the January 2017 consumer price inflation publication, these data are published on a monthly basis showing the latest month.

This repository has scripts for automated pulling of this data up to December 2017. Prior to this the data was released yearly, starting in 2005; aim is to also make scripts and extracts which includes yearly data. 

Extracts of this dataset have been provided in the data folder. These are various collections of price data which could be interesting. 

If you want to extract all the data, use the get_data.R script to pull the data. You might need to adjust the dates a little. It is currently extracting from Dec 2017 to Nov 2023.

## General information and links
data from: 

https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes

glossary for datasets can be found here:

https://www.ons.gov.uk/file?uri=%2feconomy%2finflationandpriceindices%2fdatasets%2fconsumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes%2fglossary/glossaryrevised.xls


ideas from https://github.com/VictimOfMaths/Routine-Data/blob/master/ONSPriceQuotes.R 