library(tidyverse)
library(here)
library(raster)
library(sf)

# Mercator projection in meters to use for all spatial data
prj <- CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")

# read in domestic wells, GSAs, and MT wells which have current GWL and MT
d   <- read_rds(here("data","domcv6_mean_gw_with_beta_GF_CI.rds"))
gsa <- read_rds(here("code", "results", "gsa.rds"))
l2  <- read_rds(here("code", "results", "GSP_min_thresholds_NA.rds"))

# re-project
d   <- spTransform(d, prj)
gsa <- spTransform(gsa, prj)
l2  <- lapply(l2, st_transform, prj)

# subset domestic well to gsa
d <- d[gsa, ]

# apply a 28 year retirement age following Pauloo et al (2020)
d <- d[d@data$year >= (2020-28), ]

# select and rename total completed depth
d@data <- d@data %>% 
  dplyr::select(TotalCompletedDepth) %>% 
  rename(tot_completed_depth = TotalCompletedDepth)

# extract GSP name to points with `over()`
d@data$GSP_Name  <- over(d, gsa[,"GSP_Name"])$GSP_Name

# compute current gwl and MTs from MT wells for vertical lines
for(i in 1:length(l2)){
  l2[[i]] <- dplyr::select(l2[[i]], 
                           gsa_master_shp_name, 
                           wse_18_19, MT_dtw) %>% 
    as_tibble() %>% 
    dplyr::select(-geometry)
}

# vertical line geom data: min current gwl and max MT for each GSA
vl <- bind_rows(l2) %>% 
  group_by(gsa_master_shp_name) %>% 
  summarise(min_z1 = min(wse_18_19),
            max_z2 = max(MT_dtw)) %>% 
  rename(GSP_Name = gsa_master_shp_name)

# a few GSAs have a disproportionate amount of the domestic wells, so these 
# are the areas we have to get right. Look at top GSAs which together 
# account for 90% of wells
top_90p <- d@data %>% count(GSP_Name) %>% top_n(12) %>% pull(GSP_Name)
# sanity check
nrow(filter(d@data, GSP_Name %in% top_90p)) / nrow(d@data) 


# plot domestic well depth distribution and compare to MT well depth range

  # omit < 5 % of very deep wells for visualization purposes, but leave 
  # them in the analysis. They are highly unlikely to go dry.

p5 <- ggplot() +
  geom_rect(data = 
              filter(vl, GSP_Name %in% top_90p), 
            aes(xmin = min_z1, xmax = max_z2),
            ymin = 0, ymax = 10, 
            fill = "red", alpha = 0.3
            ) +
  # n1 = count of MT wells
  geom_text(data = 
              filter(
                dplyr::select(gsa@data, GSP_Name, n_MT_wells),
                GSP_Name %in% top_90p),
            aes(x = 600, y = , 0.007, 
                label = paste0("n1 = ", n_MT_wells)),
            ) +
  # n2 = count of domestic wells
  geom_text(data = 
              filter(
                count(d@data, GSP_Name),
                GSP_Name %in% top_90p),
            aes(x = 600, y = , 0.006, 
                label = paste0("n2 = ", n)),
  ) +
  geom_line(data = 
              filter(
                filter(
                  d@data, GSP_Name %in% top_90p), 
                tot_completed_depth < 750),
            stat="density",
            aes(tot_completed_depth)
  ) +
  facet_wrap(~GSP_Name, nrow= 4) +
  theme_minimal() +
  theme(panel.grid.major = element_blank()) +
  labs(y = "Density", x = "Depth (ft)",
       title = "Domestic well depth agrees with the range of groundwater level deline implied by MTs")

ggsave(p5, filename = here("code", "plots","p5.pdf"), device = cairo_pdf)



