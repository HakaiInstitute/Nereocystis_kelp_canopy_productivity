#This script is used to generate a csv that compiles all tag loss data by:
#1.reformats the nereocystis metrics long form dataset back into wide form
#2.tallies plant tagged at time 1 and found again at time 3 
#3.adds additional tag data collected seperately

#Created by Ondine Sept. 2018.


rm(list=ls())
graphics.off()

#install.packages(c("tidyverse", "reshape2"))
lapply(c("tidyr", "plyr", "dplyr", "ggplot2", "magrittr", 
         "lubridate", "knitr", "tidyverse", "reshape2"), library, character.only = T)


#read-in csv file
metrics <- read.csv("metrics_long.csv")

#gets rid of untagged plants
metrics_tag <-subset(metrics, tag !="NA")

#combines date and time into one variable 
metrics_tag$date_time <- as.POSIXct((paste(metrics_tag$date, metrics_tag$time)))

str(metrics_tag)

### Converts long form dataframe into wide format ###

#reshape into wide format
metrics_tag_wide <-reshape(metrics_tag, 
                           idvar = c("tag", "site", "transect", "side", "distance", "diver", "interval"), 
                           timevar = "timestamp", 
                           direction = "wide")


### Generating Plant Loss csv ###

#pool plants that were tagged at time 1 and found again at time 3 based on 
#interval, site, transect, and date
tag <-metrics_tag_wide %>%
  group_by(interval, site, side, date.1, date.3) %>%
  summarise(tag_start = sum(presence.1 == "y"),
            tag_end = sum(presence.3 == "y")) 

#add collunm to differentiate datasource
tag$datasource <- "metrics"

## Adding additional tag loss data ##

tag_add <-read_csv("tag_additional_2019.csv")
str(tag_add)

#formats date variable into format recognized by lubridate
tag_add$date1 <-as.POSIXct(tag_add$date1)
tag_add$date2 <-as.POSIXct(as.Date(tag_add$date2))

#renames variable to match tag_loss dataframe
tag_add <-rename(tag_add, date.3 = date2, date.1 = date1, 
                 tag_start = new, tag_end = found)
#selects only variable of interest
tag_add <-dplyr::select(tag_add, interval, site, transect, side, date.1, 
                 tag_start, date.3, tag_end)
#adds column to differenciate data source
tag_add$datasource <- "additional"

#merging both dataframe
tag_all <- merge(tag_add, tag, all=TRUE)

#pool plants that were tagged at time 1 and found again at time 3 based on 
#interval, site, transect, and date
tag_loss <-tag_all %>%
  group_by(interval, site, date.3, date.1, datasource) %>%
  summarise(tag_start = sum(tag_start),
            tag_end = sum(tag_end), 
            tag_lost = tag_start-tag_end, 
            ratio_loss = tag_lost/tag_start)

#tallies number of days between intervals
tag_loss$period_day = with (tag_loss, (date.3 - date.1))

#create parameters for beta distribution 
tag_loss$para1 = with (tag_loss, tag_end +0.5)
tag_loss$para2 = with (tag_loss, tag_end - tag_start +0.5)

#outputs csv
write.csv(tag_loss, "tag_loss.csv", row.names=FALSE)



