#This script is used to generate a csv that compiles all 4 rates measured in 
#the "metrics" neresocystis dataset by:
#1.reformating metrics dataframe from long form dataset back into wide form,
#2.calculating stipe growth, blade growth, blade erosion and change in blade count for every plant
# * this generates metrics_rates.csv
#3. tallies and plots average rate per site and interval
#4. plots size distribution for certain growth rates

#Created by Ondine Sept. 2018.
#Last updated : Jul 2026


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
metrics_tag$date_time <- parse_date_time(paste(metrics_tag$date, metrics_tag$time),
                                         orders = c("ymd HMS", "ymd HM"))

str(metrics_tag)

### Converts long form dataframe into wide format ###

#reshape into wide format
metrics_tag_wide <- reshape(metrics_tag, 
                            idvar = c("tag", "site", "period"), 
                            timevar = "timestamp", 
                            direction = "wide")
metrics_tag_wide$transect <- coalesce(metrics_tag_wide$transect.1, metrics_tag_wide$transect.2, metrics_tag_wide$transect.3)

#extract interval and event dates from metrics
#metrics_dates <- metrics_tag_wide %>% 
#  distinct(interval, site, date.1, date.2, date.3)

#Outputs csv 
#write.csv(metrics_dates, "nereo_survey_dates.csv", row.names=FALSE)

### Generating Growth Rates ###

#calculates stipe growth, represented as a rate of cm of stipe per day
metrics_tag_wide$stipe_growth_rate <- with (metrics_tag_wide, 
                                            ((stipe_length.3-stipe_length.1))/(as.numeric(date_time.3-date_time.1)))
#calculates change in blade count, represented as a rate of blades per day
#used to take the LOG of each count before subtracting them... proprotional change
metrics_tag_wide$change_blade_count_rate <- with (metrics_tag_wide, 
                                                  ((blade_count.3)-(blade_count.2))/as.numeric(date_time.3-date_time.2))
#calculates blade growth, represented as a rate of cm of blade length per day
metrics_tag_wide$blade_growth_rate <- with (metrics_tag_wide, 
                                            ((punch_length.2-punch_length.1))/(as.numeric((date_time.2-date_time.1))))
#calculates erosion, represented as a rate of cm of blades per day
metrics_tag_wide$blade_erosion_rate <- with (metrics_tag_wide, 
                                             ((punch_blade_length.2-punch_blade_length.1)-(punch_length.2-punch_length.1))
                                             /as.numeric((date_time.2-date_time.1)))
#calculates change in sub-bulb diamter (proxi for biomass), represented as a rate of mm girth per day
#since Sbulb measurements were done inconsistently across timepoints the difference is calculated between 
# time1 and 3, time 1 and 2 and time 2 and 3
metrics_tag_wide$Sbulb_growth_rate <- with(metrics_tag_wide, case_when(
  !is.na(Sbulb_max.1) & !is.na(Sbulb_max.3) ~ 
    (Sbulb_max.3 - Sbulb_max.1) / as.numeric(date_time.3 - date_time.1),
  !is.na(Sbulb_max.1) & !is.na(Sbulb_max.2) ~ 
    (Sbulb_max.2 - Sbulb_max.1) / as.numeric(date_time.2 - date_time.1),
  !is.na(Sbulb_max.2) & !is.na(Sbulb_max.3) ~ 
    (Sbulb_max.3 - Sbulb_max.2) / as.numeric(date_time.3 - date_time.2),
  TRUE ~ NA_real_
))

metrics_tag_wide$Sbulb_growth_rate_interval <- with(metrics_tag_wide, case_when(
  !is.na(Sbulb_max.1) & !is.na(Sbulb_max.3) ~ "t1-t3",
  !is.na(Sbulb_max.1) & !is.na(Sbulb_max.2) ~ "t1-t2",
  !is.na(Sbulb_max.2) & !is.na(Sbulb_max.3) ~ "t2-t3",
  TRUE ~ NA_character_
))


#selects calculatated rates and initial measurements (for size dependencies)
metrics_rates <- metrics_tag_wide %>%
  mutate(Sbulb_max_initial = coalesce(Sbulb_max.1, Sbulb_max.2)) %>%
  
  select( period, site, transect, tag, 
          stipe_length.1, punch_blade_length.1, blade_avg_length.1, 
          blade_count.2, Sbulb_max_initial, 
          date_time.1, date_time.2, date_time.3,
          stipe_growth_rate, change_blade_count_rate, 
          blade_growth_rate, blade_erosion_rate, Sbulb_growth_rate, Sbulb_growth_rate_interval)


#outputs csv
write.csv(metrics_rates, "metrics_rates.csv", row.names=FALSE)





