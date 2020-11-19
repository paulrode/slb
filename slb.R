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

alldata <- read_csv("./slb/data/starrett-year.csv", col_names = TRUE, col_types = "cddddd")
alldata$`Start Date`<- mdy(alldata$`Start Date`)
alldata$`End Date` <- mdy(alldata$`End Date`)
colnames(alldata)[2] <- "Type"
units <- data.frame("Type" = unique(alldata$Type), "unit" = c("kWh", "MLbs", "hcf", "hcf", "hcf", "gal", "Therms", "hcf"))
alldata <- alldata %>% select(-Units) %>% left_join(units, by = "Type")