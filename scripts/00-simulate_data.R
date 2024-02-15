#### Preamble ####
# Purpose: Simulates datasets from the paper 
"Improving Preferential Market Access through Rules of Origin: Firm-Level Evidence from Bangladesh"
# Author: Yuchao Niu
# Date: today
# Contact: yc.niu@utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)


#### Simulate data ####

set.seed(12)
year <- sample(c(2001:2018), size = 50000, replace = TRUE)

importer_list <- c("Belgium", "Bulgaria", "Czech Republic", "Denmark", "Germany", 
                   "Estonia", "Ireland", "Greece", "Spain", "France", "Croatia", 
                   "Italy", "Cyprus", "Latvia", "Lithuania", "Luxembourg", "Hungary",
                   "Malta", "Netherlands", "Austria", "Poland", "Portugal", "Romania",
                   "Slovenia", "Slovakia", "Finland", "Sweden", "United Kingdom")
importer <- sample(importer_list, size = 50000, replace = TRUE)

processing <- rep("normal", n = 50000)

ldc_list <- list("AFG", "AGO", "BEN", "BTN", "BFA", "BDI", "CAF", "TCD", "COM", "COD",
                 "DJI", "GNQ", "ERI", "ETH", "GMB", "GNB", "HTI", "KIR", "LSO", "LBR",
                 "MGD", "MWI", "MDV", "MIL", "MOZ", "MMR", "NPL", "NER", "RWA", "WSM",
                 "STP", "SEN", "SEL", "SOM", "SDN", "TLS", "TGO", "TUV", "UGA", "TZA",
                 "VUT", "YEM", "ZEM", "BGD")
ldc <- sample(unlist(ldc_list), size = 50000, replace = TRUE)

product_code <- sample(c(610000:620001), size = 50000, replace = TRUE)

eligibility <- rep("Only GSP", n = 50000)

# Assuming mean_value and sd_value are defined as provided earlier
mean_value = 900
sd_value = 150
logmean_value = log(mean_value^2 / sqrt(mean_value^2 + sd_value^2))
logsd_value = sqrt(log(1 + sd_value^2 / mean_value^2))
value <- rlnorm(n = 50000, meanlog = logmean_value, sdlog = logsd_value) |> floor()

import_regime <- sample(c("MFN ZERO", "MFN NON ZERO", "GSP ZERO", "GSP NON ZERO", "PREFERENCE ZERO", "PREFERENCE NON ZERO", "UNKNOWN"), size = 50000, replace = TRUE)

# Creating the dataframe
set.seed(14)
sim_trade_data <- data.frame(
  Year = year,
  Importer = importer,
  Processing = processing,
  LDC = ldc,
  ProductCode = product_code,
  Eligibility = eligibility,
  Value = value,
  ImportRegime = import_regime
)


#simulate market_share data

type <-sample(c("China", "LDCs"), size = 34, replace = TRUE)
year <-sample(c(2008:2017), size = 34, replace = TRUE)
total <-runif(34, min = 100000000, max = 500000000)
share <- runif(34, min = 0, max = 1)

# Simulate bimodal distribution for export valueset the parameters for the two distributions
# Parameters for type China
mean_china <- 10000000
sd_china <- 20000
n_china <- 17
logmean_china = log(mean_china^2/sqrt(mean_china^2+sd_china^2))
logsd_china = sqrt(log(1+sd_china^2/mean_china^2))

# Parameters for type LDC
mean_ldc <- 800000
sd_ldc <- 300
n_ldc <- 17
logmean_ldc = log(mean_ldc^2/sqrt(mean_ldc^2+sd_ldc^2))
logsd_ldc = sqrt(log(1+sd_ldc^2/mean_ldc^2))

# Generate data
data_china <- rlnorm(n_china, mean = logmean_china, sd = logsd_china)
data_ldc <- rlnorm(n_ldc, mean = logmean_ldc, sd = logsd_ldc)

# Create a type vector
type_china <- rep("china", n_china)
type_ldc <- rep("ldc", n_ldc)

# Combine data into a dataframe
sim_market_data <- data.frame(
  Value = c(data_china, data_ldc),
  Type = factor(c(type_china, type_ldc)), Year = year, Total = total)







