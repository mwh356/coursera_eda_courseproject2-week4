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

# Create plot6 on screen device

data %>% 
  filter(grepl("Vehicle", SCC.Level.Two)) %>% # Filtering under the assumption that off-highway/non-road vehicles also constitute as "Motor Vehicles"
  filter(fips == "24510" | fips == "06037") %>% # filter for LA and Baltimore City
  group_by(fips, year) %>%
  summarise(Emissions = sum(Emissions, na.rm = TRUE)) %>%
  mutate(City = ifelse(fips == "24510", "Baltimore City, MD", ifelse(fips == "06037", "Los Angeles County, CA", "Others"))) %>% # Create a column describing the city name
  ggplot(aes(as.factor(year), Emissions/10^3, fill = City)) +
  facet_grid(.~City) +
  geom_col() +
  labs(title = "PM2.5 Emissions From Motor Vehicles in Baltimore City and Los Angeles County, 1999 - 2008",
       x = "Year",
       y = "PM2.5 Emissions (kilotons)",
       fill = "City",
       caption = "Data from www3.epa.gov") +
  theme_bw()


# Copy my plot to a PNG file
dev.copy(png, file = "plot6.png", width = 600, height = 480)

# Close the PNG device
dev.off()
