# ------------------------------------------------------------------------
# krige present day groundwater level and 2040 MT surface
# adapted from Darcy's code in data/4Interpolation/interpolatecgwl_mts...R
# ------------------------------------------------------------------------

library(here)
library(tidyverse)
library(raster)
library(gstat)

# get sets of overlapping points
get_set <- function(x, y){zerodist(x)[, y]}

# fix incorrect values: remove NAs
no_na <- function(x){x[!is.na(mt_gsp$MT_dtw),]}

# Mercator projection in meters to use for all spatial data
prj <- CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")

# GSP interpolation buffer: area covered by MT wells with a township 
# resolution buffer: 6 miles = 9656.06 meters 
# TO DO: include code to create this object, because over time, this area
# will change as MT wells are added and removed
interp_boundary <- read_rds(here("data", "4Interpolation", "Data", "interpolation_buffer_CVcobs.rds"))
interp_boundary <- readr::read_rds(here::here("code", "results", "gsa_ll.rds")) %>% 
  as("SpatialPolygons") %>% spTransform(., prj)
r      <- raster(extent(interp_boundary))           
res(r) <- 5000                 # 5000 meters
g      <- as(r, "SpatialGrid") # convert raster to spatial grid object
crs(g) <- prj

# MT data that needs to be subset to GSPs in the central valley
mt     <- read_rds(here("data", "4Interpolation", "Data", "all_mts.rds"))

# sanity check
all.equal(crs(mt), crs(interp_boundary), prj)

# subset MT data to GSPs in the central valley
mt_gsp <- mt[interp_boundary, ]


# ------------------------------------------------------------------------
# kirging
# ------------------------------------------------------------------------

# index of sets 1 and 2: wells wtih an overlapping observation
s1_mt <- get_set(mt_gsp, 1) 
s2_mt <- get_set(mt_gsp, 2) 

# get parallel minima of overlapping points
min_list_mt = pmin(mt_gsp[s1_mt,]$MT_dtw, mt_gsp[s2_mt,]$MT_dtw)

# replace DGBS of set 2 wells wtih average of set 1 and 2
mt_gsp[s2_mt, "MT_dtw"] <- min_list_mt

# remove set 1 wells
mt_gsp <- mt_gsp[-s1_mt, ]

# remove NA
mt_gsp <- no_na(mt_gsp)

# log transform Depth Below Ground Surface 
mt_gsp@data$MT_dtw <- log(mt_gsp@data$MT_dtw)

# plot to ensure all is working
title <- "Township Coverage \nMinimum Threshold Wells"
st <- formatC(nrow(mt_gsp), big.mark = ",")
plot(interp_boundary, main = title, sub = paste0("Monitoring Wells Used: ", st))
plot(mt_gsp, add = T, pch = 16, cex = .2, col = "blue")

gs_mt <- gstat(formula   = MT_dtw ~ 1, # spatial data, fit xy as idp vars
               locations = mt_gsp)     # groundwater monitoring well pts

v_mt <- variogram(gs_mt,               # gstat object
                  width = 5000)        # lag distance

plot(v_mt)
fve_mt <- fit.variogram(v_mt,          # takes `gstatVariogram` object
                        vgm(.45,       # partial sill: semivar at the range
                            "Exp",     # linear model type
                            100000,    # range: dist where mod flattens out
                            0.05))     # nugget

# plot variogram and fit
plot(v_mt, fve_mt, main="Minimum Threshold Variogram")

# ordinary kriging 
kp_mt <- krige(MT_dtw ~ 1, mt_gsp, g, model = fve_mt)

# backtransformed
bt_mt <- exp( kp_mt@data$var1.pred + (kp_mt@data$var1.var / 2) )

# means of backtransformed values and the sampled values
mu_bt_mt       <- mean(bt_mt)
mu_original_mt <- mean(exp(mt_gsp$MT_dtw))

# these means DON'T differ by > 5%, thus we DON'T make another correction
kp_mt@data$var1.pred <- bt_mt                    # overwrite w/ correct vals
kp_mt@data$var1.var  <- exp(kp_mt@data$var1.var) # exponentiate the variance

# compare pre and post kriging depth to water distributions
list(data.frame(id = "x0", z = exp(mt_gsp$MT_dtw)), 
     data.frame(id = "x1", z = bt_mt)) %>% 
  bind_rows() %>% 
  ggplot(aes(z, color = id)) + 
  geom_line(stat = "density")

# covert spatialgrid to raster brick and crop to gsp_outline extent
ok_mt        <- brick(kp_mt)    
ok_mt        <- mask(ok_mt, interp_boundary)     
names(ok_mt) <- c('Prediction', 'Variance') 

ok_mt$ci_upper <- ok_mt$Prediction + (1.96 * sqrt(ok_mt$Variance))
ok_mt$ci_lower <- ok_mt$Prediction - (1.96 * sqrt(ok_mt$Variance))

# sanity check
spplot(ok_mt$Prediction)

# write
ok_mt$Prediction %>% 
  raster::projectRaster(., crs = raster::crs("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")) %>%
write_rds(., here("code", "results","mt_surface_cv.rds"))

