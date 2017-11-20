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

# Group the datasets to get to Total US Emissions by year. 
data2 <- data %>% 
  group_by(year) %>% 
  summarise(Emissions = sum(Emissions, na.rm = TRUE))

# Create plot1 (line chart) on screen device
with(data2, plot(year, Emissions/10^6, type = "l", col = "red", 
                 main = "US PM2.5 Emissions Trend, 1999 - 2008", 
                 xlab = "Year", 
                 ylab = "Total PM2.5 Emissions (megatons)"))
with(data2, points(year, Emissions/10^6, pch = 18, col = "red")) #
with(data2, abline(lm(Emissions/10^6 ~ year, data2), lty = "dashed", col = "grey")) # add regression line
mtext("Total PM2.5 Emissions in the United States have decreased since 1999") # add subtitle
mtext("Data from www3.epa.gov", side=1, line=3.5, at=2007.5, font = 3) # add caption

# Copy my plot to a PNG file
dev.copy(png, file = "plot1.png", width = 600, height = 480)

# Close the PNG device
dev.off()
