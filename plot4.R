library(tidyr)
library(tidyverse)
library(lubridate)

# Download, unzip, and load the datasets

fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

download.file(fileurl, destfile = "EPA.zip")

unzip("EPA.zip")

NEI <- readRDS("summarySCC_PM25.rds")

SCC <- readRDS("Source_Classification_Code.rds")

# Merge and join the two datasets together

data <- as.tibble(inner_join(NEI, SCC, by = "SCC"))

# Create plot4 on screen device

data %>% 
  filter(grepl("Coal", Short.Name)) %>% # Filter for observations that contain "Coal" in the Short.Name variable. 
  group_by(year) %>% 
  summarise(Emissions = sum(Emissions, na.rm = TRUE)) %>% 
  ggplot(aes(as.factor(year), Emissions/10^3)) +
  geom_col() +
  labs(title = "US PM2.5 Emissions From Coal-Combustion Related Sources Trend, 1999 - 2008",
       subtitle = "Emissions From Coal-Combustion Related Sources Dropped Significantly in 2008",
       x = "Year",
       y = "PM2.5 Emissions (kilotons)",
       caption = "Data from www3.epa.gov") +
  theme_bw()

# Copy my plot to a PNG file
dev.copy(png, file = "plot4.png", width = 600, height = 480)

# Close the PNG device
dev.off()
