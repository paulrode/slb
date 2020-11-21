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
alldata <- read_csv("./slb/data/starrett-year.csv", col_names = TRUE, col_types = "cddddd")
alldata$Timestamp <-ymd_hms(str_sub(alldata$Timestamp, start = 1L, end = 19)) #Get timestamp readable
colSums(is.na(alldata)) # Check for NA's
alldata <- alldata %>% mutate(`Active Power Sum` = rowSums(alldata[,2:6])) 
alldata <- alldata[complete.cases(alldata),] #get rid of na's 

# Make a timeseries object
TS_alldata <- alldata %>% as_tsibble(index = Timestamp, regular = TRUE)
autoplot(TS_alldata$`Active Power Sum`)
