# script is for extracting various parts of the price data
# save some extracts in the data folder for ease of use

# libraries
library(tidyverse)
library(lubridate)
library(data.table)
library(glue)

# pull data (this might take a little while)
source("scripts/get_data.R")

# tidy up into categories ----
price_quotes[, `:=` (shop_type = fifelse(shop_type == 1, "Multiple", "Independent"))]
price_quotes[, `:=` (region = fcase(
  region==2, "London", 
  region==3, "South East England", 
  region==4, "South West England", 
  region==5, "East Anglia", 
  region==6, "East Midlands", 
  region==7, "West Midlands",
  region==8, "Yorkshire & Humberside", 
  region==9, "North West England", 
  region==10, "North East England", 
  region==11, "Wales", 
  region==12, "Scotland",
  region==13, "Northern Ireland"
))]

# due to github size limitations, only send the olive oil data up. Rest has to be pulled when in session

# olive oil ----
olive_oil <- price_quotes[item_id == 211408]

fwrite(olive_oil, file = "data/olive_oil_price.csv")

# fruit and veg ----
fv_codes <- c(212027, 212504, 212510, 212511,212515,
              212516,212518,212519,212520,212527,212530,
              212531, 212532,212533,212535,212536, 212601, 
              212603,212608,212609, 212612, 212613,212709,
              212710,212712, 212715, 212717,212718, 212719,
              212720, 212722, 212725, 212726, 212730, 212732,
              212733, 212734,212735, 212736, 212737, 212806,
              212807,212808,212809)

fruit_veg <- price_quotes[item_id %in% fv_codes]

fruit_veg[, `:=` (product_cat = fcase(
  item_desc %in% c("ORANGES-CLASS 1-EACH","KIWI FRUIT-EACH","GRAPEFRUIT-EACH","APPLES-DESSERT-PER KG",
                   "PEARS-DESSERT-PER KG", "BANANAS-PER KG","STRAWBERRIES PER KG OR PUNNET","GRAPES-PER KG",
                   "SMALL TYPE ORANGES PER PACK/KG","PLUMS PER KG/PACK","FRUIT FRESH SNACKING 150-350G","LEMON EACH",
                   "BLUEBERRIES PUNNET OR PER KG","RASPBERRIES PUNNET OR PER KG","DRIED FRUIT - EG APRICOTS",
                   "APPLES DESSERT EACH","MELON EACH EG HONEYDEW","PINEAPPLE EACH"), "Fruit",
  item_desc %in% c("PRE-PACKED SALAD 100-250G","AVOCADO PEAR-EACH","PRE-PACKED SALAD 75-250G"), "Salad",
  item_desc %in% c("FRESH VEG-CAULIFLOWER-EACH","FRESH VEG-CUCUMBER-WHOLE","FRESH VEG-LETTUCE-ICEBERG-EACH","FRESH VEG-TOMATOES-PER KG",
                   "FRESH VEG-CABBAGE-WHOLE-PER KG", "FRESH VEG-CARROTS-PER KG","FRESH VEG-ONIONS-PER KG","FRESH VEG-MUSHROOMS-PER KG",
                   "FRESH VEG-BROCCOLI-PER KG","FRESH VEG-COURGETTE-PER KG","FRESH VEG-PEPPERS -LOOSE OR KG",
                   "VEGETABLE STIR FRY FRESH PACK","SWEET POTATO PER KG OR EACH","GREEN BEANS PER KG OR PACK"), "Vegetables",
  item_desc %in% c("CANNED TOMATOES 390-400G","BAKED BEANS, 400-420G TIN",
                   "CANNED SWEETCORN 198-340G","CANNED FRUIT-400-450G",
                   "BAKED BEANS, 400-425G TIN","PULSES CAN 390 - 420G"), "Canned",
  item_desc %in% c("FROZEN GARDEN PEAS 800G-1KG","FROZEN PRE-PREPARED VEGTABLES","BERRIES FROZEN PACK"), "Frozen",
  default = "Other"
))]


# alcohol and tobacco ----
at_codes <- c(310102,310104,310109,310110,310111,310114,
              310207,310215,310216,310217,310219, 310220, 
              310221, 310222,310301, 310302,310306,310307,
              310310, 310315,  310316, 310401,310403, 310405, 
              310406,310419,310420, 310423, 310425, 310426, 
              310427, 310428, 310429, 310430,310431,320108,320115,
              320122,320123,320124,320205,320206)

alcohol_tobacco <- price_quotes[item_id %in% at_codes]

alcohol_tobacco[, `:=` (product_cat = fcase(
  item_desc %in% c("20 FILTER - OTHER BRAND", "CIGARETTES 12", "CIGARETTES 15", "CIGARETTES18", 
                   "CIGARETTES 20", "CIGARETTES 21", "CIGARETTES 22", "CIGARETTES 8") , "Cigarettes",
  item_desc=="5 CIGARS: SPECIFY BRAND" , "Cigars",
  item_desc=="HAND ROLLING TOBACCO PACK 30GM" , "RYO Tobacco",
  item_desc=="E-CIG REFILL BOTTL/CART 2-10ML" , "E-cigarettes",
  item_desc %in% c("APPLE CIDER 4 CAN PK 440-500ML", "APPLE CIDER 500-750ML 4.5-5.5%",
                   "CIDER-PER PINT OR 500-568ML", "CIDER FLAVOURED BOTT 500-568ML",
                   "CIDER 4.5%-5.5% ABV PINT/BOTTL") , "Cider",
  item_desc %in% c("BITTER-4CANS-440-500ML", "BOTTLE OF LAGER IN NIGHTCLUB",
                   "LAGER 10-24 BOTTLES 250-330ML",
                   "LAGER 10 - 24 CANS (440-500ML)", "LAGER 4 BOTTLES- PREMIUM",
                   "SPEC'Y BEER BOTT 500ML 4-5.5", "STOUT - 4 CAN PACK",
                   "BOTTLED PREMIUM LAGER 4.3-7.5%","DRAUGHT BITTER (PER PINT)",
                   "DRAUGHT STOUT PER PINT") , "Beer",
  item_desc %in% c("FORTIFIED WINE  (70-75CL)", "RED WINE- EUROPEAN 75CL",
                   "RED WINE- NEW WORLD 75CL", "ROSE WINE-75CL BOTTLE",
                   "SPARKLING WINE 75CL MIN 11%ABV", "WHITE WINE- EUROPEAN 75CL", 
                   "WHITE WINE- NEW WORLD 75CL", "BOTTLE OF CHAMPAGNE 75 CL",
                   "BOTTLE OF WINE 70-75CL", "BOTTLE OF CHAMPAGNE") , "Wine",
  item_desc %in% c("BRANDY 70CL BOTTLE", "CREAM LIQUER 70CL-1LT 14-20%",
                   "GIN BOTTLE 70CL", "PRE MIXED SPIRIT 250-330ML",
                   "RUM WHITE EG BACARDI 70CL BOTT", "VODKA-70 CL BOTTLE", "WHISKY-70 CL BOTTLE",
                   "GIN PER NIP", "LIQUEUR PER NIP   SPECIFY ML", "SPIRIT BASED DRINK 250-330MLS",
                   "SPIRIT BASED DRINK 275ML", "VODKA (PER NIP) SPECIFY ML",
                   "WHISKY (PER NIP) SPECIFY ML") , "Spirits",
  default = "Other"
))]

alcohol_tobacco[, `:=` (channel = fcase(
  item_desc %in% c("APPLE CIDER 4 CAN PK 440-500ML", "BITTER-4CANS-440-500ML", 
                   "BRANDY 70CL BOTTLE", "CIDER FLAVOURED BOTT 500-568ML",
                   "CREAM LIQUER 70CL-1LT 14-20%", "FORTIFIED WINE  (70-75CL)",
                   "GIN BOTTLE 70CL", "LAGER 10-24 BOTTLES 250-330ML", 
                   "LAGER 10 - 24 CANS (440-500ML)", "LAGER 4 BOTTLES- PREMIUM",
                   "PRE MIXED SPIRIT 250-330ML", "RED WINE- EUROPEAN 75CL",
                   "RED WINE- NEW WORLD 75CL", "ROSE WINE-75CL BOTTLE",
                   "RUM WHITE EG BACARDI 70CL BOTT", "SPARKLING WINE 75CL MIN 11%ABV",
                   "SPEC'Y BEER BOTT 500ML 4-5.5", "STOUT - 4 CAN PACK",
                   "VODKA-70 CL BOTTLE", "WHISKY-70 CL BOTTLE",
                   "WHITE WINE- EUROPEAN 75CL", "WHITE WINE- NEW WORLD 75CL",
                   "APPLE CIDER 500-750ML 4.5-5.5%") , "Off-trade",
  item_desc %in% c("BOTTLE OF CHAMPAGNE 75 CL", "BOTTLE OF CHAMPAGNE", "BOTTLE OF MIXER 125-200ML",
                   "BOTTLE OF WINE 70-75CL", "BOTTLED PREMIUM LAGER 4.3-7.5%",
                   "CIDER 4.5%-5.5% ABV PINT/BOTTL", "DRAUGHT BITTER (PER PINT)",
                   "DRAUGHT STOUT PER PINT", "GIN PER NIP", "LAGER - PINT 3.4-4.2%",
                   "LIQUEUR PER NIP   SPECIFY ML", "PREMIUM LAGER - PINT 4.3-7.5%",
                   "SPIRIT BASED DRINK 275ML", "VODKA (PER NIP) SPECIFY ML",
                   "WHISKY (PER NIP) SPECIFY ML", "WINE, PER 175 - 250 ML SERVING",
                   "CIDER-PER PINT OR 500-568ML", "SPIRIT BASED DRINK 250-330MLS") , "On-trade",
  default = "N/A"
))]


# for testing on smaller dataset ----
df <- price_quotes[sample(1:nrow(price_quotes), 1000), ]

