library(tidyr)
library(tidyverse)
library(lubridate)
library(forcats)

# Download, unzip, and load the datasets

fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

download.file(fileurl, destfile = "EPA.zip")

unzip("EPA.zip")

NEI <- readRDS("summarySCC_PM25.rds")

SCC <- readRDS("Source_Classification_Code.rds")

# Merge and join the two datasets together

data <- as.tibble(inner_join(NEI, SCC, by = "SCC"))

# Create plot3 on screen device

data %>% 
  filter(fips == "24510") %>% #Filter to Baltimore City 
  group_by(type, year) %>% 
  summarise(Emissions = sum(Emissions, na.rm = TRUE)) %>% 
  mutate(type_f = factor(type, levels=c('NONPOINT','POINT','NON-ROAD','ON-ROAD'))) %>% # Create a new factor variable of "type" to modify the factor order 
  ggplot(aes(as.factor(year), Emissions, fill = type_f)) +
  geom_col() +
  facet_grid(.~type_f) +
  labs(title = "Baltimore City PM2.5 Emissions Trend by Source Type, 1999 - 2008",
       subtitle = "Non-Road, NonPoint and On-Road source types did see decreases in PM2.5 Emissions. ",
       x = "Year",
       y = "PM2.5 Emissions (tons)",
       fill = "Types of Sources",
       caption = "Data from www3.epa.gov") +
  theme_bw()

# Copy my plot to a PNG file
dev.copy(png, file = "plot3.png", width = 600, height = 480)

# Close the PNG device
dev.off()
