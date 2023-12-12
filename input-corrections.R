library(tidyverse)
library(here)
library(tidyr)

# Remove underway samples from AR39B 
bottleAr39b <- read_csv(paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr39b.csv"), col_names = FALSE)
bottleAr39b <- bottleAr39b %>% filter(X8 != 0) 
write_csv(bottleAr39b, paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr39b_corrected.csv"), col_names = FALSE)

# Add delimitors to separate three columns in EN661 ncp gop data
ratesEn661 <- read_csv(paste0(here(),"/ncp-gop-transect-2021-pkg31/input_data_csv/discreteratesEn661.csv"), col_names = FALSE)
ratesEn661 <- separate_wider_delim(ratesEn661, cols = X6, delim = " ", names = c("X6", "X7", "X8", "X9", "X10"))
ratesEn661 <- subset(ratesEn661, select = -X7)
write_csv(ratesEn661, paste0(here(),"/ncp-gop-transect-2021-pkg31/input_data_csv/discreteratesEn661_expanded.csv"), col_names = FALSE)

# check cast station list
cast_stns <- read_csv(paste0(here(),"/ctd_nearest_stations.csv"), na = "NaN")

