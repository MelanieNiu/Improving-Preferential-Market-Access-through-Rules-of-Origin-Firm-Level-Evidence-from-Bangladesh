### Preamble ####
#Purpose: "Cleans the raw datasets"
#Author: "Yuchao Niu"
#Date: today
#Contact: yc.niu@utoronto.ca
#License: MIT

#### Workspace setup ####
#install.packages('Hmisc')
library(tidyverse)
library(Hmisc)

#### Clean data ####

euro_data <- read_csv("data/raw_data/Eurostat.csv") %>% select(-1)
head(euro_data)

#Renaming columns
label(euro_data$DECLARANT_LAB)<-"Importer"
label(euro_data$PARTNER_LAB)<-"Exporter"
label(euro_data$PRODUCT)<-"Product HS Code"
label(euro_data$PRODUCT_LAB)<-"Product description"
label(euro_data$STAT_REGIME_LAB)<-"Processing type"
label(euro_data$ELIGIBILITY_LAB)<-"Preference eligibility"
label(euro_data$IMPORT_REGIME_LAB)<-"Preferences product was imported under"
label(euro_data$year)<-"Year of transaction"
label(euro_data$value)<-"Value of transaction"

#Remove aggregate data to keep only transaction data
euro_data <- euro_data %>%
  filter(DECLARANT_LAB != "EU total" & 
           DECLARANT_LAB != "EU MEMBER STATES- EVOLUTIVE (EU15 UNTIL 30/04/2004, EU25 UNTIL 31/12/2006, EU27 UNTIL 30/06/2013, EU 28 SINCE 01/07/2013)")

# Adding group identifiers for transactions
euro_data <- euro_data %>%
  group_by(PARTNER_LAB, PRODUCT, DECLARANT_LAB, year) %>%
  mutate(group_id = cur_group_id()) %>%
  ungroup() %>%
  group_by(PARTNER_LAB, year) %>%
  mutate(exp_year = cur_group_id()) %>%
  ungroup()

# Filter for specific trade regimes (GSP ZERO and GSP NON ZERO)
gsp_only <- euro_data %>%
  filter(IMPORT_REGIME_LAB %in% c("GSP ZERO", "GSP NON ZERO")) %>%
  mutate(gsp_value = value)

# Calculate total trade values within each group
total <- aggregate(value ~ group_id + PARTNER_LAB + PRODUCT + year + DECLARANT_LAB, data = euro_data, FUN = sum)
total_gsp <- aggregate(gsp_value ~ group_id, data = gsp_only, FUN = sum)

# Merge total and total_gsp datasets
cleaned_euro_data <- merge(total, total_gsp, by = "group_id", all = FALSE, all.x = TRUE)

# Set missing gsp values to 0 and calculate fraction column indicating utilization rate
cleaned_euro_data$gsp_value[is.na(cleaned_euro_data$gsp_value)] <- 0
cleaned_euro_data <- cleaned_euro_data %>%
  mutate(frac = gsp_value / value) %>%
  filter(value != 0)

# Add a binary indicator for transactions post-2011 and for product categories (woven)
cleaned_euro_data <- cleaned_euro_data %>%
  mutate(
    post = if_else(year >= 2011, 1, 0),
    woven = if_else(PRODUCT >= 620000, 1, 0)
  )

#### Save data ####
write_csv(cleaned_euro_data, "data/clean_data/cleaned_euro_data.csv")
head(cleaned_euro_data)


