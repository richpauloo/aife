# load packages
library(tidyverse) # general purpose data science toolkit
library(sp)        # spatial objects
library(raster)    # for raster objects
library(sf)
library(readr)

# set working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
#setwd("/Volumes/GoogleDrive/My Drive/Graduate School/GSP_Analy/Organized_CnD/")

# set coordinate reference system
merc <- crs("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0
            +k=1.0 +units=m +nadgrids=@null +no_defs")

# load data
# shapefile names
fall <- list.files("Data/Fall_2018_Elevation_Points/", pattern = "\\.shp$")
spring <- list.files("Data/Spring_2018_Elevation_Points/", pattern = "\\.shp$")

# data list
falll = shapefile(file.path("Data/Fall_2018_Elevation_Points/", fall))
springg = shapefile(file.path("Data/Spring_2018_Elevation_Points/", spring))

f <- spTransform(falll, merc) # change the crs of each points dataframe
sp <- spTransform(springg, merc)

# GSP outline
interp_boundary <- read_rds("Data/interpolation_buffer_CVcobs.rds")
interp_boundary <- spTransform(interp_boundary, merc) # transform central valley shapefile

#### interpolation ####

### fall ###
# subset pts to the central valley polygon
subset_boundary <- function(x){x[interp_boundary,]}
f_cv <- subset_boundary(f) 

sp_cv <- subset_boundary(sp)

# get sets of overlapping points
get_set <- function(x, y){zerodist(x)[, y]}
sfa1 <- get_set(f_cv, 1)      # index of set 1: wells wtih an overlapping observation
sfa2 <- get_set(f_cv, 2)      # index of set 2: wells wtih an overlapping observation

sp1 <- get_set(sp_cv, 1)      # index of set 1: wells wtih an overlapping observation
sp2 <- get_set(sp_cv, 2)      # index of set 2: wells wtih an overlapping observation


# get parallel minima of overlapping points
f_min_list = pmin(f_cv[sfa1,]$DGBS, f_cv[sfa2,]$DGBS)
sp_min_list = pmin(sp_cv[sp1,]$DGBS, sp_cv[sp2,]$DGBS)

# replace DGBS of set 2 wells wtih average of set 1 and 2
f_cv[sfa2, "DGBS"] <- f_min_list
sp_cv[sp2, "DGBS"] <- sp_min_list

# remove set 1 wells
f_cv <- f_cv[-sfa1, ]
sp_cv <- sp_cv[-sp1, ]

# fix incorrect values: observations depth below groud surface > 0 
no_neg <- function(x){x[x$DGBS > 0, ]}
f_cv <- no_neg(f_cv)
sp_cv <- no_neg(sp_cv)

# log transform Depth Below Ground Surface 
f_cv@data$DGBS <- log(f_cv@data$DGBS)
sp_cv@data$DGBS <- log(sp_cv@data$DGBS)

# plot to ensure all is working
title <- "2018 and 2019 Groundwater Level Monitoring Wells"
st <- formatC(nrow(f_cv), big.mark = ",")

plot(interp_boundary, col="grey90", sub = paste0("Spatially Unique Observations: ", st))
plot(f_cv, add = T, pch = 16, cex = .2, col = "red")
plot(sp_cv, add=T, cex=.2, col="orange")

#### set up interpolation boundary ####
r <- raster(interp_boundary)           # create a template raster to interpolate over
res(r) <- 5000            # > township resolution: 6 miles = 9656.06 meters
g <- as(r, "SpatialGrid") # convert raster to spatial grid object


#### FALL 18 KRIGING #####  
gs_f <- gstat(formula = DGBS ~ 1, # spatial data, so fitting xy as idp vars
              locations = f_cv)        # groundwater monitoring well points 

v_f <- variogram(gs_f,              # gstat object
                 width = 5000)    # lag distance

fve_f <- fit.variogram(v_f,         # takes `gstatVariogram` object
                       vgm(0.8,   # partial sill: semivariance at the range
                           "Exp",     # linear model type
                           100000,    # range: distance where model first flattens out
                           0.18))      # nugget

# plot variogram and fit
plot(v_f, fve_f, xlab = 'Distance (m)', main = "FA 2018 Variogram")

# ordinary kriging 
kp_f <- krige(DGBS ~ 1, f_cv, g, model = fve_f)

# backtransformed
bt_f <- exp(kp_f@data$var1.pred + (kp_f@data$var1.var / 2) )

# means of backtransformed values and the sampled values
mu_bt_f <- mean(bt_f)
mu_original_f <- mean(mean(exp(f_cv$DGBS)))

# these means differ by > 5%, thus we make another correction
btt_f <- bt_f * (mu_original_f/mu_bt_f)
kp_f@data$var1.pred <- btt_f                    # overwrite w/ correct vals 
kp_f@data$var1.var  <- exp(kp_f@data$var1.var)  # exponentiate the variance

# covert to raster brick and crop to CV
ok_f <- brick(kp_f)                          # spatialgrid df -> raster brick obj.
ok_f <- mask(ok_f, interp_boundary)                       # mask to cv extent
names(ok_f) <- c('Prediction', 'Variance') # name the raster layers in brick

plot(ok_f$Prediction)
ok_f$ci_upper <- ok_f$Prediction + (1.96 * sqrt(ok_f$Variance))
ok_f$ci_lower <- ok_f$Prediction - (1.96 * sqrt(ok_f$Variance))
#readr::write_rds(ok_f, "Output/fall18_interp_CV.rds")

#### SPRING 18 KRIGING ####
gs_sp <- gstat(formula = DGBS ~ 1, # spatial data, so fitting xy as idp vars
               locations = sp_cv)        # groundwater monitoring well points 

v_sp <- variogram(gs_sp,              # gstat object
                  width = 5000)    # lag distance

fve_sp <- fit.variogram(v_sp,         # takes `gstatVariogram` object
                        vgm(1.1,   # partial sill: semivariance at the range
                            "Exp",     # linear model type
                            100000,    # range: distance where model first flattens out
                            0.14))      # nugget

# plot variogram and fit
plot(v_sp, fve_sp, xlab = 'Distance (m)', main = "SP 2018 Variogram")
# ordinary kriging 
kp_sp <- krige(DGBS ~ 1, sp_cv, g, model = fve_sp)

# backtransformed
bt_sp <- exp(kp_sp@data$var1.pred + (kp_sp@data$var1.var / 2) )

# means of backtransformed values and the sampled values
mu_bt_sp <- mean(bt_sp)
mu_original_sp <- mean(mean(exp(sp_cv$DGBS)))

# these means differ by > 5%, thus we make another correction
btt_sp <- bt_sp * (mu_original_sp/mu_bt_sp)
kp_sp@data$var1.pred <- btt_sp                    # overwrite w/ correct vals 
kp_sp@data$var1.var  <- exp(kp_sp@data$var1.var)  # exponentiate the variance

# covert to raster brick and crop to CV
ok_sp <- brick(kp_sp)                          # spatialgrid df -> raster brick obj.
ok_sp <- mask(ok_sp, interp_boundary)                       # mask to cv extent
names(ok_sp) <- c('Prediction', 'Variance') # name the raster layers in brick

plot(ok_sp$Prediction)
ok_sp$ci_upper <- ok_sp$Prediction + (1.96 * sqrt(ok_sp$Variance))
ok_sp$ci_lower <- ok_sp$Prediction - (1.96 * sqrt(ok_sp$Variance))
#readr::write_rds(ok_sp, "Output/spring18_interp_CV.rds")

#### FALL AND SPRING 2019 KRIGING ####
d  <- read_csv("4Interpolation/Data/Fall_Spring_2019_InterpolationPoints/measurements.csv")
d2 <- read_csv("4Interpolation/Data/Fall_Spring_2019_InterpolationPoints/stations.csv")

# subset measurements to 2019
d <- filter(d, lubridate::year(MSMT_DATE) == 2019) %>% 
  left_join(d2, by = "STN_ID")

# subset for observation wells with a 2019 measurement
d3 <- d %>% 
  filter(!is.na(GSE_WSE) & WELL_USE == "Observation") %>% 
  group_by(STN_ID) %>% 
  summarise(mean_gwl = mean(GSE_WSE)) %>% 
  left_join(d2, by = "STN_ID")

d3 <- d3 %>% filter(mean_gwl >= 1)

# convert d3 into spatialPointsDataFrame
# prepare the 3 components: coordinates, data, and proj4string
coords <- d3[ , c("LONGITUDE", "LATITUDE")]   # coordinates
data   <- d3[ , c(1,2,13)]                    # data
crs    <- CRS("+proj=longlat +ellps=GRS80 +datum=NAD83 +no_defs") # proj4string

# make the spatial points data frame object
spdf <- SpatialPointsDataFrame(coords = coords,
                               data = data, 
                               proj4string = crs)

spdf_merc <- spTransform(spdf, merc)

subset_cv <- function(x){x[interp_boundary, ]}
pcv <- subset_cv(spdf_merc) 

# plot to see where monitoring wells are
interp_boundary2 <- st_as_sf(interp_boundary)
pcv3 <- st_as_sf(pcv)
ggplot() +
  geom_sf(data = interp_boundary2)+
  geom_sf(data = pcv3, aes(color = mean_gwl)) + 
  scale_colour_gradientn(colours=rainbow(4))

# get sets of overlapping points
get_set <- function(x, y){zerodist(x)[, y]}
s1 <- get_set(pcv, 1)      # index of set 1: wells wtih an overlapping observation
s2 <- get_set(pcv, 2)      # index of set 2: wells wtih an overlapping observation

# get parallel minima of overlapping points
min_list = pmin(pcv[s1,]$mean_gwl, pcv[s2,]$mean_gwl)

# replace DGBS of set 2 wells wtih average of set 1 and 2
pcv[s2, "mean_gwl"] <- min_list

# remove set 1 wells
pcv <- pcv[-s1, ]

# log transform Depth Below Ground Surface 
pcv@data$mean_gwl_log <- log(pcv@data$mean_gwl)

plot(autofitVariogram(mean_gwl_log~1, pcv, "Exp"))

gs <- gstat(formula = mean_gwl_log ~ 1, # spatial data, so fitting xy as idp vars
            locations = pcv)        # groundwater monitoring well points 

v <- variogram(gs,              # gstat object
               width = 5000)    # lag distance
plot(v)


fve <- fit.variogram(v,         # takes `gstatVariogram` object
                     vgm(1.2,   # partial sill: semivariance at the range
                         "Exp",     # linear model type
                         10000,    # range: distance where model first flattens out
                         0.25))      # nugget

# plot variogram and fit
plot(v, fve, xlab = 'Distance (m)', main = "FA & SP 2019 Variogram")

# ordinary kriging 
kp <- krige(mean_gwl_log ~ 1, pcv, g, model = fve)

# backtransformed
bt <- exp( kp@data$var1.pred + (kp@data$var1.var / 2) )

# means of backtransformed values and the sampled values
mu_bt <- mean(bt)
mu_original <- mean(mean(exp(pcv$mean_gwl_log)))

# these means differ by > 5%, thus we make another correction
btt <- bt * (mu_original/mu_bt)
kp@data$var1.pred <- btt                    # overwrite w/ correct vals 
kp@data$var1.var  <- exp(kp@data$var1.var)  # exponentiate the variance

# covert to raster brick and crop to CV
ok_19 <- brick(kp)                          # spatialgrid df -> raster brick obj.
ok_19 <- mask(ok_19, interp_boundary)                       # mask to cv extent
names(ok_19) <- c('Prediction', 'Variance') # name the raster layers in brick

plot(ok_19$Prediction)
ok_19$ci_upper <- ok_19$Prediction + (1.96 * sqrt(ok_19$Variance))
ok_19$ci_lower <- ok_19$Prediction - (1.96 * sqrt(ok_19$Variance))
#readr::write_rds(ok_19, "Output/FSP19_interpolation_CV.rds")

#### Average 2018 2019 groundwater level predictions ####
d_avg <- mean(ok_f$Prediction, ok_sp$Prediction, ok_19$Prediction)

pal <- colorRampPalette(c("cornflowerblue","red"))
plot(d_avg, col = pal(6), main = "Mean WSE \nFA SP 2018", axes=FALSE, box=FALSE)
plot(gsps, add=T)

#writeRaster(d_avg, filename = "Output/1819avginterp_CV.tif", overwrite=TRUE)

#### Interpolate MTs ####
# subset pts to the central valley polygon
mt <- read_rds("Data/all_mts.rds")
subset_gsp_outline <- function(x){x[interp_boundary, ]}
mt_gsp_outline <- subset_gsp_outline(mt) 

# get sets of overlapping points
get_set <- function(x, y){zerodist(x)[, y]}
s1_mt <- get_set(mt_gsp_outline, 1)      # index of set 1: wells wtih an overlapping observation
s2_mt <- get_set(mt_gsp_outline, 2)      # index of set 2: wells wtih an overlapping observation

# get parallel minima of overlapping points
min_list_mt = pmin(mt_gsp_outline[s1_mt,]$MT_dtw, mt_gsp_outline[s2_mt,]$MT_dtw)

# replace DGBS of set 2 wells wtih average of set 1 and 2
mt_gsp_outline[s2_mt, "MT_dtw"] <- min_list_mt

# remove set 1 wells
mt_gsp_outline <- mt_gsp_outline[-s1_mt, ]

# fix incorrect values: remove NAs
no_na <- function(x){x[!is.na(mt_gsp_outline$MT_dtw),]}
mt_gsp_outline <- no_na(mt_gsp_outline)

# log transform Depth Below Ground Surface 
mt_gsp_outline@data$MT_dtw <- log(mt_gsp_outline@data$MT_dtw)

# plot to ensure all is working
title <- "Township Coverage \nMinimum Threshold Wells"
st <- formatC(nrow(mt_gsp_outline), big.mark = ",")
plot(interp_boundary, main = title, sub = paste0("Monitoring Wells Used: ", st))
plot(mt_gsp_outline, add = T, pch = 16, cex = .2, col = "blue")


gs_mt <- gstat(formula = MT_dtw ~ 1, # spatial data, so fitting xy as idp vars
               locations = mt_gsp_outline)        # groundwater monitoring well points 

v_mt <- variogram(gs_mt,              # gstat object
                  width = 5000)    # lag distance

plot(v_mt)
fve_mt <- fit.variogram(v_mt,         # takes `gstatVariogram` object
                        vgm(.45,   # partial sill: semivariance at the range
                            "Exp",     # linear model type
                            100000,    # range: distance where model first flattens out
                            0.05))      # nugget

# plot variogram and fit
plot(v_mt, fve_mt, main="Minimum Threshold Variogram")

# ordinary kriging 
kp_mt <- krige(MT_dtw ~ 1, mt_gsp_outline, g, model = fve_mt)

# backtransformed
bt_mt <- exp( kp_mt@data$var1.pred + (kp_mt@data$var1.var / 2) )

# means of backtransformed values and the sampled values
mu_bt_mt <- mean(bt_mt)
mu_original_mt <- mean(mean(exp(mt_gsp_outline$MT_dtw)))

# these means differ by > 5%, thus we make another correction
btt_mt <- bt_mt * (mu_original_mt/mu_bt_mt)
kp_mt@data$var1.pred <- btt_mt                    # overwrite w/ correct vals 
kp_mt@data$var1.var  <- exp(kp_mt@data$var1.var)  # exponentiate the variance

# covert to raster brick and crop to buff_ts
ok_mt <- brick(kp_mt)                          # spatialgrid df -> raster brick obj.
ok_mt <- mask(ok_mt, interp_boundary)                       # mask to gsp_outline extent
names(ok_mt) <- c('Prediction', 'Variance') # name the raster layers in brick

ok_mt$ci_upper <- ok_mt$Prediction + (1.96 * sqrt(ok_mt$Variance))
ok_mt$ci_lower <- ok_mt$Prediction - (1.96 * sqrt(ok_mt$Variance))

plot(ok_mt$Prediction)
#write_rds(ok_mt, "Output/minthreshinterpolation_CV.rds")

ba <- brick(d_avg$layer, ok_mt$Prediction)
names(ba) <- c("Current GWL", "MT GWL")
spplot(ba, sp.layout=gsps)

