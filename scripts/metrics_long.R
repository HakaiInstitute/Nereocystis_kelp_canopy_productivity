#This script is used to format the raw "metrics" nereocystis dataset
#into long form 
#Created by Ondine July 2018.


rm(list=ls())
graphics.off()

#install.packages(c("tidyverse", "reshape2"))
lapply(c("tidyr", "plyr", "dplyr", "ggplot2", "magrittr", 
"lubridate", "knitr", "tidyverse", "reshape2"), library, character.only = T)

#read-in csv file
nereo<-read.csv("nereo_metrics.csv", 
                na.strings= "na", strip.white=T, header=TRUE)

head(nereo)
str(nereo)

#nereo <- as_tibble(nereo)

#subset by date, time
nereo_date1 <-select(nereo, interval, date1, site, diver, transect, side, dist, tag1, 
                     time1, presence1, stipeL1, bladeL1, Sbulb_max, Psori1, distP1, obladeL1)

nereo_date2 <-select(nereo, interval, site, diver, transect, side, dist, date2, tag2, 
                     time2, presence2, Bcount2, distP2, obladeL2)

nereo_date3 <-select(nereo, interval, site, diver, transect, side, dist, date3, tag3, time3, 
                     presence3, stipeL3, Bcount3)

#remame consistent column names for alignment
nereo_date1 <-rename(nereo_date1, date=date1, time=time1, distance=dist,
                     tag=tag1, punch_length=distP1, punch_blade_length=obladeL1, 
                     stipe_length=stipeL1, blade_avg_length=bladeL1, sori=Psori1, 
                     presence=presence1)

nereo_date2 <-rename(nereo_date2, date=date2, time=time2, distance=dist, 
                     tag=tag2, punch_length=distP2, punch_blade_length=obladeL2, 
                     blade_count=Bcount2, presence=presence2)

nereo_date3 <-rename(nereo_date3, date=date3, time=time3, distance=dist, 
                     tag=tag3, blade_count=Bcount3, stipe_length=stipeL3,
                     presence=presence3)

#change interval at timestamp 3 so that it transects up with next interval
#nereo_date3$interval <- nereo_date3$interval +1

#create column to keep of which parameter belong to which time stamp 
nereo_date1$timestamp <-1
nereo_date2$timestamp <-2
nereo_date3$timestamp <-3

#merging dataframes
nereo_merge <-merge(nereo_date1, nereo_date2, all=TRUE)
nereo_merge1 <-merge(nereo_merge, nereo_date3, all=TRUE)

#outputs csv
write.csv(nereo_merge1, "metrics_long.csv", row.names=FALSE)

