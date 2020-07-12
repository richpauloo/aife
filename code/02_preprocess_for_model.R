library(tidyverse)
library(here)
library(raster)

# Mercator projection in meters to use for all spatial data
prj <- CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")

# read in domestic wells, GSAs, groundwater level
d   <- read_rds(here("data","domcv6_mean_gw_with_beta_GF_CI.rds"))
gsa <- read_rds(here("code", "results","gsa.rds"))
gwl <- read_rds(here("code", "results","gwl_2019_avg.rds"))

# re-project
d   <- spTransform(d, prj)
gsa <- spTransform(gsa, prj)

# subset points to gsa
d <- d[gsa, ]

# apply a 31 year retirement age following the mean retirement ages found by
# Pauloo et al (2020) (28 yrs) and Gailey et al (2019) (33 yrs)
d <- d[d@data$year >= (2020-31), ]

# select and rename desired data
d@data <- d@data %>% 
  dplyr::select(WCRNumber, mean_ci_upper, mean_ci_lower, TotalCompletedDepth) 

# add minimum suction head of 3m above total completed depth to wells
# and for the 4% of wells where the tot_depth_msh == NA because the 
# TotalCompletedDepth is NA, make those == mean_ci_upper
d$tot_depth_msh <- d@data$TotalCompletedDepth - 9.84252
d$tot_depth_msh <- ifelse(
  is.na(d@data$tot_depth_msh), d$mean_ci_upper, d@data$tot_depth_msh
)

# add 2019 groundwater level to wells
d$gwl_2019 <- raster::extract(gwl, d) 

# remove [652] wells that are dry at the start of the simulation
d <- d[d$tot_depth_msh >= d$gwl_2019 | is.na(d$tot_depth_msh), ]

# filter 44 wells with bad data (0.2%)
d <- d[d@data$tot_depth_msh > d@data$mean_ci_upper | is.na(d$tot_depth_msh), ]

# clean up GSAs
gsa@data <- gsa@data %>% 
  dplyr::select(BASIN, GSP_Name, Pln.Mngr, PM.Email) %>% 
  rename(basin = BASIN, gsp_name = GSP_Name, 
         plan_manager = Pln.Mngr, email = PM.Email)

# add GSA to wells
d@data$gsp_name <- over(d, gsa[, "gsp_name"]) %>% unlist()

# convert to ll for leaflet
ll <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
d   <- spTransform(d,   CRS(ll))
gsa <- spTransform(gsa, CRS(ll))
gwl <- projectRaster(gwl, crs = CRS(ll))

# remove "Olcese (Kern)" GSP because it has 0 domestic wells and is super tiny
gsa <- gsa[gsa@data$gsp_name != "Olcese (Kern)", ]

# save for static site generation
write_rds(d,   here("code", "results", "dom_wells_ll.rds"))
write_rds(gsa, here("code", "results", "gsa_ll.rds"))
write_rds(gwl, here("code", "results", "gwl_2019_avg_ll.rds"))
