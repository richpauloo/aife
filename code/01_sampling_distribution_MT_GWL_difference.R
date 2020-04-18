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
              sample(x$diff_MT_wse, size = 4, replace = TRUE), na.rm=TRUE
            )
  )
}

# ------------------------------------------------------------------------
# Load and transform data
# ------------------------------------------------------------------------

# GSP names
#nam <- read_csv(here("data", "gsp_names.csv"))

# monitoring network of minimum thresholds
mn <- 
  list.files(
    here("data", "MinimumThresholdShapefiles"), 
    pattern = "\\.shp$"
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
  l[[i]] <- st_read(here("data", "MinimumThresholdShapefiles", mn[i]), 
                    stringsAsFactors = FALSE) %>% 
    mutate(MT_dtw  = as.numeric(MT_dtw),
           name    = str_remove(mn[i], ".shp")) %>% 
    st_transform(prj)
}

# remove z attribute data that in l[[4]] geometry
l[[4]] <- st_zm(l[[4]], drop=TRUE)

# remove an offending empty geometry
l[[17]] <- l[[17]][-36, ]

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
spplot(d_fa$Prediction, main = "2018 Spring Interpolation (ft)")
spplot(d_sp$Prediction, main = "2018 Fall Interpolation (ft)")
spplot(d_avg, main = "Mean WSE (ft) \n(2018 and 2019)")


# ------------------------------------------------------------------------
# extract groundwater level at MTs 
# ------------------------------------------------------------------------

# sanity check: CRS of gwl == CRS of MT points
st_crs(l[[1]]) == st_crs(d_avg)

# remove wells with MTs
l <- lapply(l, function(x) x[!is.na(x$MT_dtw), ]) 

# extract raster cell value where each monitoring well is located,
# bind back to the MT point data,
# rename the extracted column,
# find the difference between GSP MTs and WSE, 
# and replace any negative difference (MT above present GWL) with 0
for(i in 1:length(l)){
  wse_18_19          <- raster::extract(d_avg, l[[i]])
  l[[i]]             <- cbind(l[[i]], wse_18_19)
  l[[i]]$diff_MT_wse <- l[[i]]$MT_dtw - l[[i]]$wse_18_19
  l[[i]]$diff_MT_wse <- ifelse(l[[i]]$diff_MT_wse < 0, NA, l[[i]]$diff_MT_wse)
}


# 6.4 % of MT wells have a diff_MT_wse < 0, and these wells are neglected.
# In the code, this means we assign them a diff_MT_wse == NA, which is 
# filtered out in the next code block before bootstrapping
sum(((is.na(sapply(l, function(x) x$diff_MT_wse) %>% unlist()))), na.rm = TRUE) / 
  length(sapply(l, function(x) x$diff_MT_wse) %>% unlist())


# ------------------------------------------------------------------------
# compute sampling distribution of sampling means
# ------------------------------------------------------------------------

# remove wells with diff_MT_wse < 0, which was assigned NA in the 
# previous step
l2 <- lapply(l, function(x) x[!is.na(x$diff_MT_wse), ]) 

# take out wells that don't have enough MTs or that, upon visual 
# inspection, show non-normal sampling distributions
non_normal <- c("BuenaVista_Kern",
                "Alpaugh_Tule",
                "CountyofFresno_DeltaMendota",
                "FarmersWD_DeltaMendota",
                "GravellyFord_Madera",
                "Olcese_Kern",
                "Pixley_Tule"
                )
# GSAs with normal distribution of decline under MT
l3 <- l2[-str_which(mn, paste(non_normal, collapse="|"))]

# bootstrap sampling distributions of sample mean
bs <- vector("list", length(l3))
set.seed(12231241)
for(i in 1:length(l3)) {
  bs[[i]] <- tibble(
    z    = gen_sampling_dist_mean(l3[[i]]),
    n    = nrow(l3[[i]]),
    name = l3[[i]]$name[1]
  )
}

# GSAs with non-normal distribution
l4 <- l2[str_which(mn, paste(non_normal, collapse="|"))]

# compute range for GSAs with non-normal distribution
rg <- vector("list", length(l4))
for(i in 1:length(l4)) {
  rg[[i]] <- tibble(
    z_low = min(l4[[i]]$diff_MT_wse),
    z_up  = max(l4[[i]]$diff_MT_wse),
    n     = nrow(l4[[i]]),
    name  = l4[[i]]$name[1]
  )
}

# visualize projected groundwater level decline, which we conceptualize
# as the sampling distribution of the sample means of differences between
# MTs specified by GSAs and the current groundwater level at that location
p1 <- bind_rows(bs) %>%
  mutate(name_n = paste0(name, "_", n)) %>% 
  ggplot(aes(z)) +
  geom_line(stat="density") +
  facet_wrap(~name_n, scales="free", nrow = 7, ncol = 6) +
  labs(y = "Density", x = "Projected groundwater level decline (ft)",
       title = "Projected groundwater level decline under MTs (ft)",
       subtitle = "for selected GSAs in California's Central Valley")
p1

p2 <- bind_rows(bs) %>% 
  ggplot(aes(fct_reorder(name, z), z)) +
  geom_boxplot(outlier.shape = NA) +
  coord_flip() +
  labs(x = "", y = "Projected groundwater level decline (ft)",
       title = "Projected groundwater level decline under MTs (ft)",
       subtitle = "for selected GSAs in California's Central Valley")
p2


# calculate median and various quantiles of GWL decline projected by the MTs
zz <- bind_rows(bs) %>% 
  group_by(name) %>% 
  summarise(p10 = quantile(z, 0.10),
            p25 = quantile(z, 0.25),
            p50 = quantile(z, 0.50),
            p75 = quantile(z, 0.75),
            p90 = quantile(z, 0.90)) %>% 
  ungroup() %>% 
  mutate(IQR = p75-p25)

p3 <- ggplot(zz, aes(fct_reorder(name, IQR), IQR)) + 
  geom_point() + 
  coord_flip() +
  labs(x = "", y = "Interquartile range of projected groundwater level decline under MTs (ft)",
       title = "Interquartile range of groundwater level decline (ft)",
       subtitle = "for selected GSAs in California's Central Valley")
p3


# gsas
gsa <- shapefile(here("data","gsa_master","GSP_merc.shp"))
gsa <- spTransform(gsa, prj)

# combine all pts
st_crs(l[[17]]) <- st_crs(l[[16]]) # fix a garbled CRS 
pts <- lapply(l, as_Spatial) %>% 
  do.call(bind, .) %>% 
  spTransform(prj)

# subset GSAs to pts: these are the ones we're working with
# then simplify the boundary for easy plotting
gsa <- gsa[pts, ]
gsa <- rmapshaper::ms_simplify(gsa, keep_shapes = TRUE)

# visualize
p4 <- ggplot(st_as_sf(gsa)) +
  geom_sf() +
  geom_sf(data = st_as_sf(pts), alpha = 0.5, col = "red") +
  labs(title = "Critical priority GSAs",
       subtitle = "Points show monitoring well locations with defined MTs")
p4

# save
ggsave(p1, filename = here("code", "plots", "p1.pdf"), device = cairo_pdf)
ggsave(p2, filename = here("code", "plots", "p2.pdf"), device = cairo_pdf)
ggsave(p3, filename = here("code", "plots", "p3.pdf"), device = cairo_pdf)
ggsave(p4, filename = here("code", "plots", "p4.pdf"), device = cairo_pdf)
write_rds(gsa, here("shiny", "data", "gsa.rds"))

# list of MT and current GWL differences for GSAs normal distributions, 
# generated via bootstrap
write_rds(bs,  here("code", "results", "MT_diffs_bootstrapped.rds"))

# list of MT and current GWL differences for GSAs with non-normal or 
# small-sample-size data for which we only have a range
write_rds(rg,  here("code", "results", "MT_diffs_range.rds"))

# list of MT shapefiles, with difference from current GWL
write_rds(l,   here("code", "results", "GSP_min_thresholds.rds"))
