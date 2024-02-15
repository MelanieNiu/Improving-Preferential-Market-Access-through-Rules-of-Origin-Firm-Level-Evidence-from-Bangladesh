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

### Create Figure 1
# Summarize data by year
# Calculate the mean and standard deviation of the 'frac' variable for each 'year'
ldc_only <- eurodata %>%
  group_by(year) %>%
  summarise(
    util = mean(frac),  # Utilization rate (mean)
    var = sd(frac)      # Variability (standard deviation)
  )

# Create Figure 1: EBA Utilization Rate over Years
figure1 <- ggplot(data = ldc_only, aes(x = year, y = util)) +  # Plotting setup
  geom_line(size = 1, colour = "black") +  # Add line graph
  geom_point(size = 2, colour = "black") +  # Add points
  labs(x = 'Year', y = "EBA Utilization Rate") +  # Label axes
  theme_bw() +  # Use a white background theme for the plot
  theme(
    text = element_text(size = 10),  # Set overall text size
    axis.text.x = element_text()  # Customize x-axis text (optional adjustments)
  )

# Display the figure
figure1

Figure3<-ggplot()+
  geom_line(data=market_share, aes(x=Year, y=share, group=type, color=type), size=1)+
  geom_point(data=market_share, aes(x=Year, y=share, group=type, color=type), size=3)+
  labs(y = "Market Share")+
  guides(color=guide_legend(title=""))+
  theme_bw()+theme(text = element_text(size=10))+
  scale_color_manual(values = c("Grey", "Black"))
Figure3

# Filter data for bangladesh
bangladesh<-eurodata %>% filter(PARTNER_LAB=="BANGLADESH") %>%
  group_by(year, woven)%>% summarise(gsp_value=sum(gsp_value), value=sum(value))%>%
  mutate(frac=gsp_value/value)
cols <- c("1" = "black", "0" = "grey")


### Create Figure 4
Figure4<-ggplot(data=bangladesh, aes(x=year, y=frac, group=as.factor(woven)))+
  geom_line(data=bangladesh, aes(x=year, y=frac, color=as.factor(woven)), size=1)+
  geom_point(data=bangladesh, aes(x=year, y=frac, color=as.factor(woven)), size=3)+
  labs(x = "Year", y = "Utilization Rate")+
  labs(color = "") +
  scale_color_manual(values=cols, breaks=c("1","0"),
                     labels=c("Woven", "Knit"))+theme_bw()+
  scale_x_continuous(name="Year", limits=c(2001, 2018), breaks = scales::pretty_breaks(n = 9))+
  scale_y_continuous( limits=c(.1, 1), breaks = scales::pretty_breaks(n = 5))+
  theme(legend.position="bottom", legend.direction="horizontal",
        axis.text.x = element_text(color = "black", size = 10,  face = "plain"),
        axis.text.y = element_text(color = "black", size = 10,  face = "plain"),
        axis.title.x = element_text(color = "Black", size = 10, face = "plain"),
        axis.title.y = element_text(color = "Black", size = 10, face = "plain"),
        legend.text=element_text(size=10),
        plot.title = element_text(size=10))

Figure4


