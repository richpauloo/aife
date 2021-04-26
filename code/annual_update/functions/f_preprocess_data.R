# preprocess data
f_preprocess_data <- function(d, gwl_t0, aoi, t0, gsas = NULL){
  
  # subset points to area of interest
  d <- d[aoi, ]
  
  # apply a 31 year retirement age following the mean retirement ages found by
  # Pauloo et al (2020) (28 yrs) and Gailey et al (2019) (33 yrs)
  d <- d[d@data$year >= (t0 - 31), ]
  
  # select and rename desired data
  d@data <- d@data %>% 
    dplyr::select(
      WCRNumber, mean_ci_upper, pump_loc, 
      mean_ci_lower, TotalCompletedDepth, year
    )
  
  # add minimum suction head of 3m above total completed depth to wells
  # and for the 4% of wells where the tot_depth_msh == NA (because the 
  # TotalCompletedDepth is NA), make those == mean_ci_upper
  msh = 30 # ft
  d$tot_depth_msh <- d@data$TotalCompletedDepth - msh # previously 3 ft = 9.84252
  d$tot_depth_msh <- ifelse(
    is.na(d@data$tot_depth_msh), d$mean_ci_upper, d@data$tot_depth_msh
  )
  
  # add initial groundwater level to wells
  d$gwl_t0 <- raster::extract(gwl_t0, d) 
  
  # remove wells without an initial condition
  d <- d[!is.na(d$gwl_t0), ]
  
  # remove [N] wells dry at the start of the simulation based on pump_loc
  d <- d[d$pump_loc >= d$gwl_t0 | is.na(d$tot_depth_msh), ]

  # filter [N] wells with bad data 
  d <- d[d@data$tot_depth_msh > d@data$mean_ci_upper | is.na(d$tot_depth_msh), ]
  
  if(!is.null(gsas)){
    # clean up GSAs
    gsa@data <- gsa@data %>%
      dplyr::select(basin = Basin, gsa_name = GSA.Name) 

    # add GSA to wells
    d@data$gsa_name <- over(d, gsa[, "gsa_name"]) %>% unlist()
  }
  
  return(d)

}

