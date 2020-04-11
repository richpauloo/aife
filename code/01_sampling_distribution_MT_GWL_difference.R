# ------------------------------------------------------------------------
# Determine average difference in GWL MTs specified in GSPs 
# to the present day GWL (2018-2019 avg)
# Darcy Bostic and Rich Pauloo (3/25/2020)
# ------------------------------------------------------------------------

library(tidyverse)
library(sf)
library(mapview)
library(dismo)     
library(gstat)     
library(raster) 
library(here)

theme_set(theme_minimal())

# Mercator projection in meters to use for all spatial data
prj <- CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")

# take sampling distributions of 5, compute mean, and repeat 1,000 times
gen_sampling_dist_mean <- function(x) {
  replicate(1000,
            mean(
              sample(x$diff_MT_wse, size = 5, replace = TRUE), na.rm=TRUE
            )
  )
}

# ------------------------------------------------------------------------
# Load and transform data
# ------------------------------------------------------------------------

# GSP names
nam <- read_csv(here("data", "gsp_names.csv"))

# monitoring network of minimum thresholds
mn <- 
  list.files(
    here("data", "MinimumThresholdShapefiles"), 
    pattern = "\\.shp$",
    full.names = TRUE
  )

# remove coastal GSPs (by name in case more shapefiles are added later):
# Borrego, Cuyama, Santa Cruz, PasoRobles, Salinas, Oxnard, Pleasant Valley
to_rm <- c("BorregoValley_BorregoSprings", "Cuyama", "FoxCanyon", 
           "IndianWellsValley", "PasoRobles", "SalinasValley", 
           "SantaCruzMidCounty")
mn <- mn[!grepl(paste(to_rm, collapse="|"), mn)]

# organize all minimum threshold data into a list
l <- vector("list", length(mn)) 
for(i in 1:length(l)){
  l[[i]] <- st_read(mn[i], stringsAsFactors = FALSE) %>% 
    mutate(MT_dtw = as.numeric(MT_dtw)) %>% 
    dplyr::select(Well_ID, MT_dtw) %>% 
    st_transform(prj)
}

# remove z attribute data that in l[[4]] geometry
l[[4]] <- st_zm(l[[4]], drop=TRUE)


# read groundwater levels (roughly present day) from ERL paper
# https://iopscience.iop.org/article/10.1088/1748-9326/ab6f10
# and transform to Mercatorprojection
d_sp <- read_rds(here("data", "lGF_SP2018.rds")) # SP 2018
d_fa <- read_rds(here("data", "lGF_FA2018.rds")) # FA 2018
d_19 <- read_rds(here("data", "lGF_2019.rds"))   # FA SP 2019 avg

d_sp <- projectRaster(d_sp, crs = prj)
d_fa <- projectRaster(d_fa, crs = prj)
d_19 <- projectRaster(d_19, crs = prj)

# calculate avg spring and fall groundwater level and visualize
d_avg <- mean(d_fa$Prediction, d_sp$Prediction, d_19$Prediction)
plot(d_fa$Prediction, main = "2018 Spring Interpolation (ft)")
plot(d_sp$Prediction, main = "2018 Fall Interpolation (ft)")
plot(d_avg, main = "Mean WSE (ft) \n(2018 and 2019)")


# ------------------------------------------------------------------------
# extract groundwater level at MTs 
# ------------------------------------------------------------------------

# sanity check: CRS of gwl == CRS of MT points
st_crs(l[[1]]) == st_crs(d_avg)

# extract raster cell value where each monitoring well is located,
# bind back to the MT point data,
# rename the extracted column,
# find the difference between GSP MTs and WSE, 
# and replace any negative difference (MT above present GWL) with 0
for(i in 1:length(l)){
  wse_18_19          <- raster::extract(d_avg, l[[i]])
  l[[i]]             <- cbind(l[[i]], wse_18_19)
  l[[i]]$diff_MT_wse <- l[[i]]$MT_dtw - l[[i]]$wse_18_19
  l[[i]]$diff_MT_wse <- ifelse(l[[i]]$diff_MT_wse < 0, 0, l[[i]]$diff_MT_wse)
}


# 5.3 % of MT wells were re-assigned a value of 0
sum(((sapply(l, function(x) x$diff_MT_wse) %>% unlist()) == 0), na.rm = TRUE) / 
  length(sapply(l, function(x) x$diff_MT_wse) %>% unlist())

# save
write_rds(l, here("results", "GSP_MinimumThresholds.rds"))


# ------------------------------------------------------------------------
# compute sampling distribution of sampling means
# ------------------------------------------------------------------------

# subset to wells with a MT
l2 <- lapply(l, function(x) x[!is.na(x$diff_MT_wse), ])

# take out wells that don't have enough MTs
nam <- nam[-29, ]
l2[[29]] <- NULL

# bootstrap sampling distributions of sample mean
bs <- vector("list", length(l2))
for(i in 1:length(l2)) {
  bs[[i]] <- data.frame(
    name = nam[i, 1], 
    z = gen_sampling_dist_mean(l2[[i]])
  )
}

# visualize projected groundwater level decline, which we conceptualize
# as the sampling distribution of the sample means of differences between
# MTs specified by GSAs and the current groundwater level at that location
p1 <- bind_rows(bs) %>%
  ggplot(aes(z)) +
  geom_line(stat="density") +
  facet_wrap(~GSP_Name, scales="free", nrow = 7, ncol = 5) +
  labs(y = "Density", x = "Projected groundwater level decline (ft)",
       title = "Projected groundwater level decline under MTs (ft)",
       subtitle = "for selected GSAs in California's Central Valley")
p1

p2 <- bind_rows(bs) %>% 
  ggplot(aes(fct_reorder(GSP_Name, z), z)) +
  geom_boxplot(outlier.shape = NA) +
  coord_flip() +
  labs(x = "", y = "Projected groundwater level decline (ft)",
       title = "Projected groundwater level decline under MTs (ft)",
       subtitle = "for selected GSAs in California's Central Valley")
p2


# calculate median and various quantiles of GWL decline projected by the MTs
zz <- bind_rows(bs) %>% 
  group_by(GSP_Name) %>% 
  summarise(p10 = quantile(z, 0.10),
            p25 = quantile(z, 0.25),
            p50 = quantile(z, 0.50),
            p75 = quantile(z, 0.75),
            p90 = quantile(z, 0.90)) %>% 
  ungroup() %>% 
  mutate(IQR = p75-p25)
result
p3 <- ggplot(zz, aes(fct_reorder(GSP_Name, IQR), IQR)) + 
  geom_point() + 
  coord_flip() +
  labs(x = "", y = "Interquartile range of projected groundwater level decline under MTs (ft)",
       title = "Interquartile range of groundwater level decline (ft)",
       subtitle = "for selected GSAs in California's Central Valley")
p3

# save
ggsave(p1, filename = here("plots", "p1.pdf"), device = cairo_pdf)
ggsave(p2, filename = here("plots", "p2.pdf"), device = cairo_pdf)
ggsave(p3, filename = here("plots", "p3.pdf"), device = cairo_pdf)

# gsas
gsa <- shapefile(here("data","gsa_master","GSP_merc.shp"))
gsa <- spTransform(gsas, prj)

# combine all pts
pts <- lapply(l, as_Spatial) %>% 
  do.call(bind, .) %>% 
  spTransform(prj)

# subset GSAs to pts: these are the ones we're working with
# then simplify the boundary for easy plotting
gsa <- gsa[pts, ]
gsa <- rmapshaper::ms_simplify(gsa)

# visualize
ggplot(st_as_sf(gsa)) +
  geom_sf() +
  geom_sf(data = st_as_sf(pts))

