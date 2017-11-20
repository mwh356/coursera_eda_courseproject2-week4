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


# Create plot5 on screen device

data %>% 
  filter(fips == "24510") %>%
  filter(grepl("Vehicle", SCC.Level.Two)) %>% # Filtering under the assumption that off-highway/non-road vehicles also constitute as "Motor Vehicles"
  group_by(year) %>% 
  summarise(Emissions = sum(Emissions, na.rm = TRUE)) %>% 
  ggplot(aes(as.factor(year), Emissions)) +
  geom_col() +
  labs(title = "PM2.5 Emissions Related to Motor Vehicle Sources in Baltimore City, 1999 - 2008",
       subtitle = "Emissions From Motor Vehicle Sources Have Trended Down Since 1999",
       x = "Year",
       y = "PM2.5 Emissions (tons)",
       caption = "Data from www3.epa.gov") +
  theme_bw()


# Copy my plot to a PNG file
dev.copy(png, file = "plot5.png", width = 600, height = 480)

# Close the PNG device
dev.off()
