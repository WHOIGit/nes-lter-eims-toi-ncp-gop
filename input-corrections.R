library(dplyr)
library(here)
library(tidyr)
library(readr)

# Several cruises have one-off corrections made manually

#EN608 
# Convert depth to zero: 2/1/2018  17:31:00	 row 28, 2/1/2018  18:12 	row 29, 2/3/2018  03:50	row 70
# correct depth to 35 for 2/2/2018 9:10 Niskin 12 depth 55
bottleEn608 <- read_csv(paste0(here(),"/eims-toi-transect/input_data_csv/bottleEn608_original.csv"), col_names = FALSE)
bottleEn608 <- bottleEn608 %>% 
  mutate(X4 = case_when(X8 == 0 & X4 !=0 ~ 0, TRUE ~ X4)) %>%
  mutate(X4 = case_when(X1 == "02-Feb-2018 09:10:00" & X4 == 55 ~ 35, TRUE ~ X4))  %>%
  mutate(X6 = round(X6, 5)) # one value acquired many more decimal places for some reason  
bottleEn608$X6 <- round(bottleEn608$X6, digits = 5) # this still isn't fixing it
write_csv(bottleEn608, paste0(here(),"/eims-toi-transect/input_data_csv/bottleEn608.csv"), col_names = FALSE)

# Replace AR28 underway TOI data capDelta, d17O, d18O with NaN
# One sample is provided with a depth of 5, Niskin 0 (4/3/2018 20:37). It is on underway log so needs depth corrected to 0. 
# Niskins 17 and 13 matched to cast 11 should have start time 1:53 for cast 12 (they have 4/10/2018 0:03) 
bottleAr28b <- read_csv(paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr28_original.csv"), col_names = FALSE)
bottleAr28b <- bottleAr28b %>% 
  mutate(X5 = case_when(X8 == 0 ~ NA, TRUE ~ X5)) %>%
  mutate(X6 = case_when(X8 == 0 ~ NA, TRUE ~ X6)) %>%
  mutate(X7 = case_when(X8 == 0 ~ NA, TRUE ~ X7)) %>%
  mutate(X1 = case_when(X1 == "10-Apr-2018 00:03:00" & X8 == 13 ~ "10-Apr-2018 01:53:00", TRUE ~ X1)) %>%    
  mutate(X1 = case_when(X1 == "10-Apr-2018 00:03:00" & X8 == 17 ~ "10-Apr-2018 01:53:00", TRUE ~ X1)) %>%
  mutate(X4 = case_when(X1 == "03-Apr-2018 20:37:00" & X4 == 5 & X8 == 0 ~ 0, TRUE ~ X4)) 
write_csv(bottleAr28b, paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr28.csv"), col_names = FALSE)

# # One extra row in discreterates file that breaks join. 0:03 timestamp (it is not surface). Exclude row 3. 
# ratesAr28 <- read_csv(paste0(here(),"/ncp-gop-transect-2018-pkg13/input_data_csv/discreteratesAr28_original.csv"), col_names = FALSE)
# ratesAr28 <- ratesAr28[-which(ratesAr28$X1 == "10-Apr-2018 00:03:00" & ratesAr28$X4 == 199.0),]
# write_csv(ratesAr28, paste0(here(),"/ncp-gop-transect-2018-pkg13/input_data_csv/discreteratesAr28.csv"), col_names = FALSE)

# Ar31A cast 6 depths were mis-entered. Correct them and remove one non-surface row from discreterates files
bottleAr31 <- read_csv(paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr31_original.csv"), col_names = FALSE)
bottleAr31 <- bottleAr31 %>% 
  mutate(X4 = case_when(X1 == "21-Oct-2018 17:56:00" & X8 == 4 ~ 16, TRUE ~ X4)) %>%    
  mutate(X4 = case_when(X1 == "21-Oct-2018 17:56:00" & X8 == 8 ~ 3, TRUE ~ X4)) %>%
  mutate(X4 = case_when(X1 == "21-Oct-2018 17:56:00" & X8 == 10 ~ 2, TRUE ~ X4)) 
write_csv(bottleAr31, paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr31.csv"), col_names = FALSE)
ratesAr31 <- read_csv(paste0(here(),"/ncp-gop-transect-2018-pkg13/input_data_csv/discreteratesAr31_original.csv"), col_names = FALSE)
ratesAr31 <- ratesAr31[-which(ratesAr31$X1 == "21-Oct-2018 17:56:00" & ratesAr31$X4 == 115.40),]
write_csv(ratesAr31, paste0(here(),"/ncp-gop-transect-2018-pkg13/input_data_csv/discreteratesAr31.csv"), col_names = FALSE)

# Remove row from EN617 NCP-GOP data
# This row is from cast 14, which had no surface TOI bottles, and the NCP-GOP row has NaN for all measured values
ratesEn617 <- read_csv(paste0(here(),"/ncp-gop-transect-2018-pkg13/input_data_csv/discreteratesEn617_original.csv"), col_names = FALSE)
ratesEn617 <- ratesEn617[-which(ratesEn617$X1 == "22-Jul-2018 08:58:00"),]
write_csv(ratesEn617, paste0(here(),"/ncp-gop-transect-2018-pkg13/input_data_csv/discreteratesEn617.csv"), col_names = FALSE)

# AR34B correct a start time, which will correct the cast from 18 to 21 (2019-04-22 04:34 to 2019-04-17 03:19)
# remove this row from discreterates (it is not surface)
bottleAr34b <- read_csv(paste0(here(), "/eims-toi-transect/input_data_csv/bottleAr34_original.csv"), col_names = FALSE)
bottleAr34b <- bottleAr34b |> 
  mutate(X1 = case_when(X1 == "22-Apr-2019 04:34:00" & X4 == 2.143 ~ "17-Apr-2019 03:19:00", TRUE ~ X1))
write_csv(bottleAr34b, paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr34.csv"), col_names = FALSE)
ratesAr34b <- read_csv(paste0(here(),"/ncp-gop-transect-2019-pkg14/input_data_csv/discreteratesAr34_original.csv"), col_names = FALSE)
ratesAr34b <- ratesAr34b[-which(ratesAr34b$X1 == "22-Apr-2019 04:34:00"),]
write_csv(ratesAr34b, paste0(here(),"/ncp-gop-transect-2019-pkg14/input_data_csv/discreteratesAr34.csv"), col_names = FALSE)

# Remove underway samples from AR39B 
bottleAr39b <- read_csv(paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr39b.csv"), col_names = FALSE)
bottleAr39b <- bottleAr39b %>% filter(X8 != 0) 
write_csv(bottleAr39b, paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr39b_corrected.csv"), col_names = FALSE)

# EN649 fix some cast start times
bottleEn649 <- read_csv(paste0(here(), "/eims-toi-transect/input_data_csv/bottleEn649_original.csv"), col_names = FALSE)
bottleEn649 <- bottleEn649 |> 
  mutate(X1 = case_when(X1 == "02-Feb-2020 18:07:00" ~ "01-Feb-2020 18:07:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "02-Feb-2020 18:14:00" ~ "01-Feb-2020 18:14:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "02-Feb-2020 18:17:00" ~ "01-Feb-2020 18:17:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "02-Feb-2020 23:04:00" & X8 == 4 ~ "01-Feb-2020 23:04:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "02-Feb-2020 23:07:00" ~ "01-Feb-2020 23:07:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "02-Feb-2020 23:04:00" & X8 == 5 ~ "02-Feb-2020 08:34:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "02-Feb-2020 23:02:00" ~ "02-Feb-2020 08:34:00", TRUE ~ X1)) 
write_csv(bottleEn649, paste0(here(),"/eims-toi-transect/input_data_csv/bottleEn649.csv"), col_names = FALSE)

# EN655
bottleEn655 <- read_csv(paste0(here(), "/eims-toi-transect/input_data_csv/bottleEn655_original.csv"), col_names = FALSE)
bottleEn655 <- bottleEn655 |> 
  mutate(X1 = case_when(X1 == "25-Jul-2020 03:50:00" ~ "25-Jul-2020 15:50:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "25-Jul-2020 03:53:00" ~ "25-Jul-2020 15:53:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "25-Jul-2020 09:50:00" ~ "25-Jul-2020 21:50:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "25-Jul-2020 09:56:00" ~ "25-Jul-2020 21:56:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "27-Jul-2020 09:31:00" ~ "27-Jul-2020 21:31:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "27-Jul-2020 09:36:00" ~ "27-Jul-2020 21:36:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "27-Jul-2020 09:38:00" ~ "27-Jul-2020 21:38:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "26-Jul-2020 01:41:00" ~ "27-Jul-2020 01:41:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "26-Jul-2020 01:43:00" ~ "27-Jul-2020 01:43:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "26-Jul-2020 07:20:00" ~ "26-Jul-2020 19:20:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "26-Jul-2020 07:24:00" ~ "26-Jul-2020 19:24:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "26-Jul-2020 02:30:00" ~ "26-Jul-2020 14:30:00", TRUE ~ X1)) 
write_csv(bottleEn655, paste0(here(),"/eims-toi-transect/input_data_csv/bottleEn655.csv"), col_names = FALSE)

# Remove duplicate rows and fix one start time in EN661 bottle file
bottleEn661 <- read_csv(paste0(here(), "/eims-toi-transect/input_data_csv/bottleEn661_original.csv"), col_names = FALSE)
bottleEn661 <- bottleEn661 |> 
  distinct()
bottleEn661 <- bottleEn661 |> 
  mutate(X1 = case_when(X1 == "05-Feb-2021 10:41:00" & X4 == 140 ~ "05-Feb-2021 13:08:00", TRUE ~ X1))
write_csv(bottleEn661, paste0(here(),"/eims-toi-transect/input_data_csv/bottleEn661.csv"), col_names = FALSE)

# Add delimitors to separate three columns in EN661 ncp gop data
# Remove duplicate rows
ratesEn661 <- read_csv(paste0(here(),"/ncp-gop-transect-2021-pkg31/input_data_csv/discreteratesEn661.csv"), col_names = FALSE)
ratesEn661 <- separate_wider_delim(ratesEn661, cols = X6, delim = " ", names = c("X6", "X7", "X8", "X9", "X10"))
ratesEn661 <- subset(ratesEn661, select = -X7)
ratesEn661 <- ratesEn661 |> 
  distinct()
write_csv(ratesEn661, paste0(here(),"/ncp-gop-transect-2021-pkg31/input_data_csv/discreteratesEn661_expanded.csv"), col_names = FALSE)

# Fix AT46 times
bottleAt46 <- read_csv(paste0(here(), "/eims-toi-transect/input_data_csv/bottleAt46_original.csv"), col_names = FALSE)
bottleAt46 <- bottleAt46 |> 
  mutate(X1 = case_when(X1 == "16-Feb-2022 08:28:00"  ~ "17-Feb-2022 08:28:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "17-Feb-2022 08:16:00"  ~ "17-Feb-2022 02:45:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "17-Feb-2022 18:29:00"  ~ "16-Feb-2022 18:29:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "17-Feb-2022 18:33:00"  ~ "16-Feb-2022 18:33:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "17-Feb-2022 18:35:00"  ~ "16-Feb-2022 18:35:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "18-Feb-2022 21:49:00"  ~ "17-Feb-2022 21:49:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "18-Feb-2022 21:54:00"  ~ "17-Feb-2022 21:54:00", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "20-Feb-2022 01:58:00"  ~ "21-Feb-2022 00:01:58", TRUE ~ X1)) |>
  mutate(X1 = case_when(X1 == "21-Feb-2022 04:50:00"  ~ "21-Feb-2022 00:04:50", TRUE ~ X1)) 
write_csv(bottleAt46, paste0(here(),"/eims-toi-transect/input_data_csv/bottleAt46.csv"), col_names = FALSE)

# check cast station list
cast_stns <- read_csv(paste0(here(),"/ctd_nearest_stations.csv"), na = "NaN")

