#This script is used to generate a csv that compiles all tag loss data by:
#1.reformats the nereocystis metrics long form dataset back into wide form
#2.tallies plant tagged at time 1 and found again at time 3 
#3.adds additional tag data collected seperately

#Created by Ondine Sept. 2018.
#Last updated Jul 2026


rm(list=ls())
graphics.off()

#install.packages(c("tidyverse", "reshape2"))
lapply(c("tidyr", "plyr", "dplyr", "ggplot2", "magrittr", 
         "lubridate", "knitr", "tidyverse", "reshape2"), library, character.only = T)


#read-in csv file
metrics <- read.csv("metrics_long.csv")

#gets rid of untagged plants
metrics_tag <-subset(metrics, tag !="NA")

### Converts long form dataframe into wide format ###

#reshape into wide format
metrics_tag_wide <- reshape(metrics_tag, 
                            idvar = c("tag", "site", "period"), 
                            timevar = "timestamp", 
                            direction = "wide")

metrics_tag_wide$transect <- coalesce(metrics_tag_wide$transect.1, metrics_tag_wide$transect.2, metrics_tag_wide$transect.3)

### Generating Plant Loss csv ###

#pool plants that were tagged at time 1 and found again at time 3 based on 
#interval, site, transect, and date
tag <- metrics_tag_wide %>%
  group_by(period, site, date.1, date.3) %>%
  summarise(tag_start = sum(!is.na(date.1)),
            tag_end = sum(presence.3 == "y", na.rm = TRUE))

#add collunm to differentiate datasource
tag$datasource <- "metrics"

## Adding additional tag loss data ##

tag_add <-read_csv("nereo_tag_additional.csv")
str(tag_add)

#formats date variable into format recognized by lubridate
tag_add$date1 <- format(as.Date(tag_add$date1), "%Y-%m-%d")
tag_add$date2 <- format(as.Date(tag_add$date2), "%Y-%m-%d")

#renames variable to match tag_loss dataframe
tag_add <-rename(tag_add, date.3 = date2, date.1 = date1, 
                 tag_start = new, tag_end = found)
#selects only variable of interest
tag_add <-dplyr::select(tag_add, period, site, transect, date.1, 
                 tag_start, date.3, tag_end)
#adds column to differenciate data source
tag_add$datasource <- "additional"

#merging both dataframe
tag_all <- merge(tag_add, tag, all=TRUE)

#pool plants that were tagged at time 1 and found again at time 3 based on 
#interval, site, transect, and date
tag_loss <-tag_all %>%
  group_by(period, site, date.3, date.1, datasource) %>%
  summarise(tag_start = sum(tag_start),
            tag_end = sum(tag_end), 
            tag_lost = tag_start-tag_end, 
            ratio_loss = tag_lost/tag_start)

#tallies number of days between intervals
tag_loss$period_day <- as.numeric(as.Date(tag_loss$date.3) - as.Date(tag_loss$date.1))

#create parameters for beta distribution
tag_loss$para1 = with (tag_loss, tag_end +0.5)
tag_loss$para2 = with (tag_loss, tag_start - tag_end +0.5)

#outputs csv
write.csv(tag_loss, "tag_loss.csv", row.names=FALSE)



