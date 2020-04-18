library(tidyverse)
library(here)
library(raster)

# Mercator projection in meters to use for all spatial data
prj <- CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")

# read in domestic wells and GSAs
d   <- read_rds(here("data","domcv6_mean_gw_with_beta_GF_CI.rds"))
gsa <- read_rds(here("code", "results","gsa.rds"))

# re-project
d   <- spTransform(d, prj)
gsa <- spTransform(gsa, prj)

# subset points to gsa
d <- d[gsa, ]

# apply a 28 year retirement age following Pauloo et al (2020)
d <- d[d@data$year >= (2020-28), ]

# select and rename desired data
d@data <- d@data %>% 
  dplyr::select(WCRNumber, mean_ci_upper, mean_ci_lower) %>% 
  rename(wcr_number = WCRNumber)

gsa@data <- gsa@data %>% 
  dplyr::select(BASIN, GSP_Name, Pln.Mngr, PM.Email) %>% 
  rename(basin = BASIN, gsp_name = GSP_Name, 
         plan_manager = Pln.Mngr, email = PM.Email)

# save to shiny data folder
write_rds(d,   here("shiny", "data", "dom_wells.rds"))
write_rds(gsa, here("shiny", "data", "gsa.rds"))
