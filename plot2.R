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

# Group and filter the datasets to get to Total US Emissions by year in Baltimore City. 

baltimore_byyear_data <- data %>% 
  filter(fips == "24510") %>% # filter to Baltimore City
  group_by(year) %>% 
  summarise(Emissions = sum(Emissions, na.rm = TRUE))

# Create plot2 (bar plot) on screen device

with(baltimore_byyear_data, 
     barplot(Emissions, names.arg = year, col = "red", 
             main = "PM2.5 Emissions Trend in Baltimore City, 1999 - 2008", 
             ylab = "PM2.5 Emissions (tons)", 
             xlab = "Year"))
mtext("In spite of the spike in 2005, Total Emissions from PM2.5 in Baltimore City have decreased from 1999 to 2008") # add subtitle

# Copy my plot to a PNG file
dev.copy(png, file = "plot2.png", width = 480, height = 480)

# Close the PNG device
dev.off()
