### Preamble ####
#Purpose: "Cleans the raw datasets"
#Author: "Yuchao Niu"
#Date: today
#Contact: yc.niu@utoronto.ca
#License: MIT

#### Workspace setup ####
library(tidyverse)

#### Test data ####

## Test trade_data
#Test the importing countries are from the European Union
df$Importer |> unique() == c("Belgium", "Bulgaria", "Czech Republic", "Denmark", "Germany", 
                                         "Estonia", "Ireland", "Greece", "Spain", "France", "Croatia", 
                                         "Italy", "Cyprus", "Latvia", "Lithuania", "Luxembourg", "Hungary",
                                         "Malta", "Netherlands", "Austria", "Poland", "Portugal", "Romania",
                                         "Slovenia", "Slovakia", "Finland", "Sweden", "United Kingdom") 
#Test the data are within the years of interest
sim_trade_data$Year |> min() > 2000
sim_trade_data$Year |> max() < 2019

#Test the processing of the transaction belongs to the normal category
sim_trade_data$Processing  == "normal"

#Test the exporters are least developed countries
sim_trade_data$LDC |> unique() == list("AFG", "AGO", "BEN", "BTN", "BFA", "BDI", "CAF", "TCD", "COM", "COD",
                 "DJI", "GNQ", "ERI", "ETH", "GMB", "GNB", "HTI", "KIR", "LSO", "LBR",
                 "MGD", "MWI", "MDV", "MIL", "MOZ", "MMR", "NPL", "NER", "RWA", "WSM",
                 "STP", "SEN", "SEL", "SOM", "SDN", "TLS", "TGO", "TUV", "UGA", "TZA",
                 "VUT", "YEM", "ZEM", "BGD")

#Test the product falls into the two apparel categories
sim_trade_data$ProductCode |> min >= 610000
sim_trade_data$ProductCode |> max() == 629999

#Test the eligibility of the transaction is GSP
sim_trade_data$Eligibility == "Only GSP"

#Test the product value is a positive number
sim_trade_data$Value |> class() == "Numeric"
sim_trade_data$Value |> min() >= 0

## Test market_data

#Test the data are within the years of interest
sim_market_data$Year |> min() > 2007
sim_market_data$Year |> max() < 2018

# Test the countries in the data are of interest
sim_market_data$Type |> unique() == c("china", "ldc")

#Test the total is of a numeric type
sim_market_data$Total |> class() == "Numeric"











