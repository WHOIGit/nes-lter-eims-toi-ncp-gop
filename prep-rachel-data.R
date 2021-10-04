## Functions for prepping EIMS-TOI data for continuous package

# Read in toi data
read_toi <- function(toi_filename, cruiseid){

  toi_in <- read_csv((paste0(here(), "/eims-toi-transect/", toi_filename)), col_names = FALSE)

  colnames(toi_in) <- c("datetime_utc_matlab", "O2_Ar_delta", "O2_Ar_ratio", "depth_matlab", "cap_Delta_17O", "d17O", "d18O", "niskin")
  toi <- toi_in

  # populate cruise column
  toi$cruise <- cruiseid 
  
  return(toi)
  
  }


# Format toi datetime
time_toi <- function(date_mat){
  
  # convert datetime format
  toi$datetime_utc_matlab <- as.POSIXct(date_mat, format="%d-%b-%Y %H:%M:%OS")
  # ensure rows are in time order
  toi <- toi[order(toi$datetime_utc_matlab),]
  
  return(toi)
  
  }


# Identify toi source based on niskin, reassign Niskin bottle zero to NA, reassign underway depth from 0 to 5 m
set_toi_source <- function(nisk, depth_mat, source) {
  
  # define bottle vs underway based on niskin
  toi$toi_source <- ifelse(nisk == 0, 
        yes = "toi_underway", 
        no = "toi_niskin")
  
  # assign NA to niskin bottle 0
  toi$niskin[toi$niskin == 0] <- NA_integer_
  
  # for underway samples, assign depth to 5m 
  toi <- toi %>%
    mutate(depth_matlab = case_when(depth_matlab == 0 & toi_source =="toi_underway" ~ 5,
                                    TRUE ~ depth_matlab))
        
  return(toi)
  
  }


# Read in eims data
read_eims <- function(cruiseid){
  
  eims_in <- read_csv((paste0(here(), "/eims-toi-transect/Ra", cruiseid, "withbiosat.csv")), col_names = FALSE)
  colnames(eims_in) <- c("datetime_utc_matlab", "O2_Ar_ratio", "temp", "sal", "latitude_matlab", "longitude_matlab", "cumulative_dist", "biosat")
  eims <- eims_in %>% select(-temp, -sal, -cumulative_dist)
  # populate cruise column
  eims$cruise <- cruiseid 
  eims$depth <- 5
  
  return(eims)
  
}


# Format eims datetime
time_eims <- function(date_mat){
  
  # convert datetime format
  eims$datetime_utc_matlab <- as.POSIXct(date_mat, format="%d-%b-%Y %H:%M:%OS")
  # ensure rows are in time order
  eims <- eims[order(eims$datetime_utc_matlab),]
  
  return(eims)
  
}



# read_eims_cruise <- function(cruiseid){
#   
#   
#   # check for samples without timestamp
#   if (any(is.na(eims$datetime_utc_matlab))) {
#     missingdate <- eims[which(is.na(eims$datetime_utc_matlab)),]
#     print(missingdate)
#   }

#######################################################################################
# cruiselist <- c("EN608", "EN617", "EN627", "EN644")
# summary <- read_from_api(type = "summary", cruises = cruiselist)
# 
# 
# api_toi <- function(){
#   
# # create columns to populate from API
# toi$cast <- NA_integer_
# toi$depth_API <- NA_integer_
# toi$datetime_utc_API <- as.POSIXct(NA)
# toi$latitude_API <- NA_integer_
# toi$longitude_API <- NA_integer_
# 
# for (i in 1:nrow(toi)) {
#   # store values
#   #cruise <- bottle$cruise[i]
#   nisk <- toi$niskin[i]
#   sampletime <- toi$datetime_utc_matlab[i]
#   
#   # skip row if underway
#   if (is.na(nisk)) {
#     next
#   }
#   
#   # find the index of the nearest datetime
#   ind <- which.min(abs(sampletime - summary$date))
#   smry_cast <- summary$cast[ind]
#   
#   # populate cast column from summary
#   toi$cast[i] <- smry_cast
#   
#   # store cast to find bottle time
#   smry <- summary %>% filter(cast == smry_cast &
#                                niskin == nisk)
#   
#   # case: smry subset is empty  
#   if (nrow(smry) == 0) {
#     print(paste0(" Niskin ", nisk, " not found in bottle summary for cast ", smry_cast))
#     next
#   }
#   
#   # add parameters from API to TOI data frame
#   toi$datetime_utc_API[i] <- smry$date
#   toi$depth_API[i] <- smry$depth
#   toi$latitude_API[i] <- smry$latitude
#   toi$longitude_API[i] <- smry$longitude
# }
# 
# return(toi)
# 
# }
# 


