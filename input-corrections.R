library(tidyverse)
library(here)

# Remove underway samples from AR39B 
bottleAr39b <- read_csv(paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr39b.csv"), col_names = FALSE)
bottleAr39b <- bottleAr39b %>% filter(X8 != 0) 
write_csv(bottleAr39b, paste0(here(),"/eims-toi-transect/input_data_csv/bottleAr39b_corrected.csv"), col_names = FALSE)

          