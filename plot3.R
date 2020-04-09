# This assignment uses data from the UC Irvine Machine Learning Repository, 
# a popular repository for machine learning datasets. In particular, 
# we will be using the “Individual household electric power consumption 
# Data Set” which I have made available on the course web site:

# Dataset: Electric power consumption [20Mb]
# Description: Measurements of electric power consumption in one household 
# with a one-minute sampling rate over a period of almost 4 years. 
# Different electrical quantities and some sub-metering values are available.

# The following descriptions of the 9 variables in the dataset are taken from the UCI web site:

# Date: Date in format dd/mm/yyyy
# Time: time in format hh:mm:ss
# Global_active_power: household global minute-averaged active power (in kilowatt)
# Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# Voltage: minute-averaged voltage (in volt)
# Global_intensity: household global minute-averaged current intensity (in ampere)
# Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
# Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
# Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

library(dplyr)

if (!file.exists("exdata_data_household_power_consumption.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
  unzip("exdata_data_household_power_consumption.zip")
}

if (!file.exists("household_power_consumption.txt")) {
  unzip("exdata_data_household_power_consumption.zip")
}

# load the data
df <- read.csv("household_power_consumption.txt", sep = ';', na.strings = '?')
# select only specific columns
df2 <- select(df, Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3)
# subset only specific dates
df3 <- mutate(df2, Date=as.Date(Date, format="%d/%m/%Y"))
df4 <- filter(df3, Date == "2007-02-01" | Date == "2007-02-02")
df5 <- mutate(df4, Date = as.POSIXct(strptime(paste(as.Date(Date), Time), "%Y-%m-%d%H:%M:%S")))
df5 <- select(df5, -Time)
# generate png file
png(filename = "plot3.png", width = 480, height = 480)
# make line plot
plot(df5$Date, df5$Sub_metering_1, type = 'l', xlab = '', ylab = "Energy sub metering")
lines(df5$Date, df5$Sub_metering_2, type = 'l', col = "red")
lines(df5$Date, df5$Sub_metering_3, type = 'l', col = "blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1, cex=0.8)
dev.off()