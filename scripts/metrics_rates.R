nereo_merg#This script is used to generate a csv that compiles all 4 rates measured in 
#the "metrics" neresocystis dataset by:
#1.reformating metrics dataframe from long form dataset back into wide form,
#2.calculating stipe growth, blade growth, blade erosion and change in blade count for every plant
# * this generates metrics_rates.csv
#3. tallies and plots average rate per site and interval
#4. plots size distribution for certain growth rates

#Created by Ondine Sept. 2018.
#Last updated : Nov. 2020


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
metrics_tag$date_time <- ymd_hms((paste(metrics_tag$date, metrics_tag$time)))

str(metrics_tag)

### Converts long form dataframe into wide format ###

#reshape into wide format
metrics_tag_wide <-reshape(metrics_tag, 
                           idvar = c("tag", "site", "transect", "side", "distance", "diver", "interval"), 
                           timevar = "timestamp", 
                           direction = "wide")

#extract interval and event dates from metrics
metrics_dates <- metrics_tag_wide %>% 
  distinct(interval, site, date.1, date.2, date.3)

#Outputs csv 
#write.csv(metrics_dates, "nereo_survey_dates.csv", row.names=FALSE)

### Generating Growth Rates ###

#calculates stipe growth, represented as a rate of cm of stipe per day
metrics_tag_wide$stipe_growth_rate <- with (metrics_tag_wide, 
                                            ((stipe_length.3-stipe_length.1))/(as.numeric(date_time.3-date_time.1)))
#calculates change in blade count, represented as a rate of blades per day
#used to take the LOG of each count before subtracting them... proprotional change
metrics_tag_wide$prp_blade_dpl_rate <- with (metrics_tag_wide, 
                                                  ((blade_count.3)-(blade_count.2))/as.numeric(date_time.3-date_time.2))
#calculates blade growth, represented as a rate of cm of blades per day
metrics_tag_wide$blade_growth_rate <- with (metrics_tag_wide, 
                                            ((punch_length.2-punch_length.1))/(as.numeric((date_time.2-date_time.1))))
#calculates erosion, represented as a rate of cm of blades per day
metrics_tag_wide$blade_erosion_rate <- with (metrics_tag_wide, 
                                             ((punch_blade_length.2-punch_blade_length.1)-(punch_length.2-punch_length.1))
                                             /as.numeric((date_time.2-date_time.1)))

#selects variables of interest
metrics_rates <- select(metrics_tag_wide, interval, site, diver, transect, side, distance, tag, 
                        stipe_length.1, blade_avg_length.1, Sbulb_max.1, punch_length.1, punch_blade_length.1,
                        blade_count.2, punch_length.2, punch_blade_length.2,
                        stipe_length.3, blade_count.3, 
                        interval, date_time.1, date_time.2, date_time.3,
                        stipe_growth_rate, prp_blade_dpl_rate, 
                        blade_growth_rate, blade_erosion_rate )

#creates a collumn for year and month
metrics_rates$year <- year(metrics_rates$date_time.1)
metrics_rates$month <- month(metrics_rates$date_time.1, label = TRUE)

#outputs csv
write.csv(metrics_rates, "metrics_rates.csv", row.names=FALSE)

metrics_rates_avg <- metrics_rates %>%
  group_by(interval, year, month, date_time.1, site) %>%
  summarise_at(vars(stipe_length.1, blade_avg_length.1, 
                    Sbulb_max.1, blade_count.2,
                    stipe_growth_rate, prp_blade_dpl_rate, 
                    blade_growth_rate, blade_erosion_rate), 
               funs(mean, sd), na.rm=TRUE)

#write.csv(metrics_rates_avg, "metrics_rates_avg.csv", row.names=FALSE)



