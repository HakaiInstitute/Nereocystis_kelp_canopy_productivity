#This script combines all sub-bulb diameter (Sbulb_max) measurements from
#nereo_metrics.csv (T1, T2, T3) and nereo_size.csv into a single long-form csv.
# * this generates nereo_sbulb_combined.csv

rm(list=ls())
graphics.off()

lapply(c("dplyr", "tidyverse"), library, character.only = T)

#read-in csv files
metrics <- read.csv("nereo_metrics.csv", na.strings = c("NA", "na"), strip.white = T, header = TRUE)
size <- read.csv("nereo_size.csv", na.strings = c("NA", "na"), strip.white = T, header = TRUE)

#extract Sbulb_max at each timepoint from nereo_metrics, keeping shared site/diver/transect/side/dist
metrics_t1 <- metrics %>%
  transmute(period, site, diver, transect, side, dist, date = date1, tag = tag1,
            Sbulb_max = Sbulb_max1, data_source = "nereo_metricsT1") %>%
  filter(!is.na(Sbulb_max))

metrics_t2 <- metrics %>%
  transmute(period, site, diver, transect, side, dist, date = date2, tag = tag2,
            Sbulb_max = Sbulb_max2, data_source = "nereo_metricsT2") %>%
  filter(!is.na(Sbulb_max))

metrics_t3 <- metrics %>%
  transmute(period, site, diver, transect, side, dist, date = date3, tag = tag3,
            Sbulb_max = Sbulb_max3, data_source = "nereo_metricsT3") %>%
  filter(!is.na(Sbulb_max))

metrics_sbulb <- bind_rows(metrics_t1, metrics_t2, metrics_t3)

#nereo_size has no tag (population-level survey, not tied to a growth timestamp)
size_sbulb <- size %>%
  transmute(period, site, diver, transect, side, dist, date, tag = NA_real_,
            Sbulb_max, data_source = "nereo_size") %>%
  filter(!is.na(Sbulb_max))

#combine both sources into one long-form dataset
sbulb_combined <- bind_rows(metrics_sbulb, size_sbulb) %>%
  arrange(period, site, date)

#outputs csv
write.csv(sbulb_combined, "nereo_sbulb_combined.csv", row.names = FALSE)
