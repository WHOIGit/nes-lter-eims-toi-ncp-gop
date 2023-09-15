## Functions for prepping EIMS-TOI data for continuous package

# Read in toi data
read_toi <- function(toi_filename, cruiseid){

  toi_in <- read_csv((paste0(here(), "/eims-toi-transect/input_data_csv/", toi_filename)), col_names = FALSE)

  #colnames(toi_in) <- c("datetime_utc_matlab", "O2_Ar_delta", "O2_Ar_ratio", "depth_matlab", "cap_Delta_17O", "d17O", "d18O", "niskin")
  
  if (ncol(toi_in) == 8){
    colnames(toi_in) <- c("datetime_utc_matlab", "O2_Ar_delta", "O2_Ar_ratio", "depth_matlab", "cap_Delta_17O", "d17O", "d18O", "niskin")
    toi_in$toi_bottle_id <- NA
    } else if (ncol(toi_in) == 9){
    colnames(toi_in) <- c("datetime_utc_matlab", "O2_Ar_delta", "O2_Ar_ratio", "depth_matlab", "cap_Delta_17O", "d17O", "d18O", "niskin", "toi_bottle_id")
    }
  
  toi <- toi_in

  # populate cruise column
  toi$cruise <- cruiseid 
  
  return(toi)
  
  }


# Format toi datetime to ISO 8601
time_toi <- function(date_mat){
  
  # convert datetime format
  toi$datetime_utc_matlab <- as.POSIXct(date_mat, format="%d-%b-%Y %H:%M:%OS")
  # ensure rows are in time order
  toi <- toi[order(toi$datetime_utc_matlab),]
  
  return(toi)
  
  }


# Identify toi source based on niskin, reassign Niskin bottle zero to NA, edit AR31A Niskins, reassign underway depth 
set_toi_source <- function(nisk, depth_mat, source) {
  
  # define bottle vs underway based on niskin
  toi$toi_source <- ifelse(nisk == 0, 
        yes = "toi_underway", 
        no = "toi_niskin")
  
  # assign NA to niskin bottle 0
  toi$niskin[toi$niskin == 0] <- NA_integer_
  
  # for AR31A, adjust Niskin bottle number to let PI-provided data (24 bottle positions) match API (12 bottles)
  toi <- toi %>%
    mutate(niskin = case_when(cruise == "AR31A" ~ niskin/2,
                              cruise == "ar31a" ~ niskin/2,
                              TRUE ~ niskin))
  
  # for underway samples, assign depth to 5m if Endeavor cruise and 2.1336 if Armstrong cruise
  toi <- toi %>%
    mutate(depth = case_when(depth_matlab == 0 & toi_source =="toi_underway" & str_detect(cruise, "^EN") ~ 5,
                                    depth_matlab == 0 & toi_source =="toi_underway" & str_detect(cruise, "^AR") ~ 2.1336,
                                    TRUE ~ depth_matlab))
  
  return(toi)
  
  }


# Read in eims data
read_eims <- function(eims_filename, cruiseid){
  
  eims_in <- read_csv((paste0(here(), "/eims-toi-transect/input_data_csv/", eims_filename)), col_names = FALSE)
  colnames(eims_in) <- c("datetime_utc_matlab", "O2_Ar_ratio", "temperature", "salinity", "latitude_matlab", "longitude_matlab", "cumulative_dist", "biosat")
  eims <- eims_in %>% select(-cumulative_dist)
  
  # populate cruise column
  eims$cruise <- cruiseid 
  
  # set underway depth depending on vessel
  if(str_detect(cruiseid, '^EN') ){
    eims$depth <- 5
  }
  if(str_detect(cruiseid, '^AR') ){
    eims$depth <- 2.1336
  }
  if(str_detect(cruiseid, '^AT') ){
    eims$depth <- 5 
  }
  if(str_detect(cruiseid, '^en') ){
    eims$depth <- 5
  }
  if(str_detect(cruiseid, '^ar') ){
    eims$depth <- 2.1336
  }
  if(str_detect(cruiseid, '^at') ){
    eims$depth <- 5 
  }
 
  return(eims)
  
}


# Format eims datetime to ISO 8601
time_eims <- function(date_mat){
  
  # convert datetime format
  # replace date and time for samples exactly at midnight
  eims$date_utc_matlab <- as.POSIXct(eims$datetime_utc_matlab, format="%d-%b-%Y %H:%M:%OS")
  eims$date_utc_matlab <- as_date(eims$date_utc_matlab)
  eims$date_string <- str_trunc(eims$datetime_utc_matlab, 14, side = "right")
  eims$date_string <- str_remove(eims$date_string, "\\.")
  eims$date_string <- str_remove(eims$date_string, "\\.")
  eims$date_string <- str_remove(eims$date_string, "\\.")
  eims$time_utc_matlab <- as.POSIXct(eims$datetime_utc_matlab, format="%d-%b-%Y %H:%M:%OS")
  eims$time_utc_matlab <- strftime(eims$time_utc_matlab, format="%H:%M:%OS")
  eims$time_utc_matlab <- replace(eims$time_utc_matlab, is.na(eims$time_utc_matlab), "00:00:01")
  eims$datetime_utc_midnights <- paste(eims$date_string, eims$time_utc_matlab)
  eims$datetime_utc_matlab <- as.POSIXct(eims$datetime_utc_midnights,format="%d-%b-%Y %H:%M:%OS")
  # ensure rows are in time order
  eims <- eims[order(eims$datetime_utc_matlab),]
  
  return(eims)
  
}

# This functionality is so far needed only for this set of packages (multiple packages produced from one workflow). If needed for others, consider adding to the ediutilities package. 
# Function inserts project node after the methods node of an xml document
# requires the existence of a parent_project.txt
# input path to xml file

add_parent <- function(edi_pkg, parent_name, xml.path) {
  if (!file.exists(parent_name)) {
    stop(paste0(parent_name, "does not exist"))
  }
  # read in parent project and xml file to be modified
  newnode <- read_xml(parent_name, from = "xml")
  xml_file <- read_xml(paste0(xml.path, "/", edi_pkg, ".xml"), from = "xml")
  
  # replace existant project node
  if (is.na(xml_find_first(xml_file, ".//project")) == FALSE) {
    # find old project node
    oldnode <- xml_find_first(xml_file, ".//project") # find project node
    # replace with new project node
    xml_replace(oldnode, newnode)
    warning("<project> node already existed but was overwritten")
  }
  # insert new project node
  if (is.na(xml_find_first(xml_file, ".//project")) == TRUE) {
    # find methods node
    methodsnode <- xml_find_first(xml_file, ".//methods")
    # add project node after methods and before dataTable
    xml_add_sibling(methodsnode, newnode, where = "after")
  }
  # validate script
  if (eml_validate(xml_file) == FALSE) {
    warning("XML document not valid")
  }
  # return(xml_file)
  write_xml(xml_file, paste0(xml.path, "/", edi_pkg, ".xml"))
}


