###############################################################################
                            # Enviroment Setup #
###############################################################################

# Packages for tidyverse 
library("tidyverse")
library("gridExtra")
library("lubridate")
# Package for building tables in markdown and notebook 
library("knitr")
library("kableExtra") 
library("xtable")
# Packages for forecasting
library("fable")
library("tsibble")
library("feasts")
library("tsibbledata")
# Packages for reading excel and html files and XML
library("openxlsx")
library("XML")
# Parkage for using data tables for very large data operations
#library("data.table")
#Package for reading fixed width tables
library("utils")
# Packages for reading data through API's 
library("httr")
library("jsonlite")
# Package for performing inquires with SQL databases 
library("sqldf")
#Package for reading and writing to jpeg files
library("jpeg")

# Set proper working Dir 
if (!getwd() == "C:/Users/paulr/Documents/R/slb") {setwd("C:/Users/paulr/Documents/R/slb")}

# Set proper working Dir
if (!getwd() == "C:/Users/paulr/Documents/R/slb") {setwd("./slb/slb")}

# Check for data directory and if one is not present then make it
if (!file.exists("data")) {
  dir.create("data")
}

###############################################################################
                          # Read in data #
###############################################################################
#Read in data and fix formats

# Get data in
alldata <- read_csv("./slb/data/starrett-year.csv", col_names = TRUE, col_types = "cnnnnn")
alldata$Timestamp <-ymd_hms(str_sub(alldata$Timestamp, start = 1L, end = 19)) #Get timestamp readable
colSums(is.na(alldata)) # Check for NA's
alldata <- alldata %>% mutate(`Active Power Sum` = rowSums(alldata[,2:6])) 
alldata <- alldata[complete.cases(alldata),] #get rid of na's 

WeatherDataNYC <- read_csv("./slb/data/WeatherDataNYC.csv", col_names = TRUE)
WeatherDataNYC$`Date/Time` <- mdy_hm(WeatherDataNYC$`Date/Time`)
colnames(WeatherDataNYC)[1] = "Timestamp"

Weather <- WeatherDataNYC %>% filter(Timestamp >= min(alldata$Timestamp) & Timestamp <= max(alldata$Timestamp))
alldata <- left_join(alldata, Weather,  by = "Timestamp")
alldata <- alldata %>% distinct()


###############################################################################
                          # Time Series Work #
###############################################################################


TS_alldata <- alldata %>% as_tsibble(index = Timestamp, key = `Active Power Sum`, regular = TRUE)

ggplot(alldata, aes(Timestamp)) +
  geom_line(aes(y = `MasterMeter-Triacta Meter 1 Active Power`, color = "blue")) +
  geom_line(aes(y = `MasterMeter-Triacta Meter 2 Active Power`, color = "red")) +
  geom_line(aes(y = `MasterMeter-Triacta Meter 3 Active Power`, color = "purple")) +
  geom_line(aes(y = `MasterMeter-Triacta Meter 4 Active Power`, color = "yellow")) +
  geom_line(aes(y = `MasterMeter-Triacta Meter 5 Active Power`, color = "green")) +
  geom_line(aes(y = `Active Power Sum`, color = "black")) 


ggplot(alldata, aes(Timestamp)) +
  geom_line(aes(y = (Temp))) +
  geom_line(aes( y = Enthalpy, color = "blue"))

alldata$Temp <- as.double(alldata$Temp)
ggplot(alldata, aes(Temp, `Active Power Sum` )) +
  geom_smooth(color = "red") + # Showing relationship with Temp
  geom_smooth(aes(WB, `Active Power Sum` )) #Showing relationsip with WB

alldata$Temp <- as.factor(alldata$Temp)
alldata %>% ggplot() +
  geom_boxplot(aes(x = Temp, y = `Active Power Sum`)) + # adding box plots
  geom_smooth(aes(x = WB, y = `Active Power Sum`, color = "black")) # adding wet bulb 
  geom_smooth() #adding temp line

alldata %>% filter(as.integer(Temp > 55)) %>%  ggplot() +
  geom_boxplot(aes(x = Temp, y = `Active Power Sum`)) + # adding box plots
  geom_smooth(aes(x = WB, y = `Active Power Sum`, color = "black")) # adding wet bulb 
geom_smooth() #adding temp line

ggplot(alldata, aes(WB, `Active Power Sum`)) + 
  geom_point()


