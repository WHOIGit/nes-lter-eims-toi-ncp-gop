library(dplyr)
library(here)
library(tidyr)
library(readr)

# Several cruises have one-off corrections made manually

# Remove row from EN617 NCP-GOP data
# This frow is from cast 14, which had no surface TOI bottles, and the NCP-GOP row has NaN for all measured values
ratesEn617 <- read_csv(paste0(here(),"/ncp-gop-transect-2018-pkg13/input_data_csv/discreteratesEn617_original.csv"), col_names = FALSE)
ratesEn617 <- ratesEn617[-which(ratesEn617$X1 == "22-Jul-2018 08:58:00"),]
write_csv(ratesEn617, paste0(here(),"/ncp-gop-transect-2018-pkg13/input_data_csv/discreteratesEn617.csv"), col_names = FALSE)
                              
# Remove underway samples from AR39B 
bottleAr39b <- read_csv(paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr39b.csv"), col_names = FALSE)
bottleAr39b <- bottleAr39b %>% filter(X8 != 0) 
write_csv(bottleAr39b, paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr39b_corrected.csv"), col_names = FALSE)

# Remove duplicate rows and fix one start time in EN661 bottle file
bottleEn661 <- read_csv(paste0(here(), "/eims-toi-transect/input_data_csv/bottleEn661_original.csv"), col_names = FALSE)
bottleEn661 <- bottleEn661 |> 
  distinct()
bottleEn661 <- bottleEn661 |> 
  mutate(X1 = case_when(X1 == "05-Feb-2021 10:41:00" & X4 == 140 ~ "05-Feb-2021 13:08:00",
                        TRUE ~ X1))
write_csv(bottleEn661, paste0(here(),"/eims-toi-transect/input_data_csv/bottleEn661.csv"), col_names = FALSE)

# Add delimitors to separate three columns in EN661 ncp gop data
# Remove duplicate rows
ratesEn661 <- read_csv(paste0(here(),"/ncp-gop-transect-2021-pkg31/input_data_csv/discreteratesEn661.csv"), col_names = FALSE)
ratesEn661 <- separate_wider_delim(ratesEn661, cols = X6, delim = " ", names = c("X6", "X7", "X8", "X9", "X10"))
ratesEn661 <- subset(ratesEn661, select = -X7)
ratesEn661 <- ratesEn661 |> 
  distinct()
write_csv(ratesEn661, paste0(here(),"/ncp-gop-transect-2021-pkg31/input_data_csv/discreteratesEn661_expanded.csv"), col_names = FALSE)

# check cast station list
cast_stns <- read_csv(paste0(here(),"/ctd_nearest_stations.csv"), na = "NaN")

