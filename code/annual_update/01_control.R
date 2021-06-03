# ------------------------------------------------------------------------
# estimate number of failing wells if 2021 drought persists for 1-2 years
# ------------------------------------------------------------------------

library(here)
library(raster)
library(tidyverse)
library(sf)
library(patchwork)

# source functions
walk(list.files(here("functions"), full.names = TRUE), ~source(.x))

# mercator projection in meters
merc <- "+proj=merc +lon_0=0 +lat_ts=0 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +nadgrids=@null +units=m +no_defs"

# cost per failed well in millions
cost_per_well_lowering    <- 100 # USD $100 / ft
cost_per_well_replacement <- 115 * 100 # USD $115 / ft for 100 ft


# ------------------------------------------------------------------------
# domestic wells, initial groundwater level conditions, and gsas
d   <- read_rds(here("input","data", "domcv6_mean_gw_with_beta_GF_CI.rds")) %>% spTransform(merc)
gsa <- shapefile(here("input","data","gsa_master","GSA_Master.shp")) %>% spTransform(merc)
# gwl <- readr::read_rds(here::here("results", "gwl_2019_avg_ll.rds"))

# study area polygon
cv  <- shapefile(here("input","data","cv","Alluvial_Bnd.shp")) %>% 
  spTransform(merc) %>% 
  st_as_sf()
aoi <- read_rds(here("input","data","b_trim_fill.rds")) %>% spTransform(merc)


# ------------------------------------------------------------------------
# periodic groundwater level measurement database, last updated March 2021
# will eventually use these to set t_0, t_1, t_2, and base off wse and dem
# m    <- read_csv(here("data", "periodic_gwl_bulkdatadownload", "measurements.csv"))
# perf <- read_csv(here("data", "periodic_gwl_bulkdatadownload", "perforations.csv"))
# sta  <- read_csv(here("data", "periodic_gwl_bulkdatadownload", "stations.csv"))
# 
# # join measurement data to perforation and station data
# m <- left_join(m, perf, by = "SITE_CODE") %>% 
#   left_join(sta, by = "SITE_CODE") 


# ------------------------------------------------------------------------
# alvar's scenarios fill in t_1 now, and should eventually be code to 
# create these based on the last year's data (as with t_0)

# t_0: initial condition
gwl_t0 <- raster(here("input","t0","r_fall2020.tif")) %>% 
  projectRaster(crs = crs(merc))
  
# t_1: conditions to test
gwl_t1 <- map(
  list.files(here("input", "t1"), full.names = TRUE), 
  ~raster(.x) %>% 
    projectRaster(crs = crs(merc))
)


# ------------------------------------------------------------------------
# preprocess for model - remove wells dry at start of simulation, etc
d2 <- f_preprocess_data(d = d, gwl_t0 = gwl_t0, t0 = 2020, aoi = aoi, gsas = gsa) 

d2@data %>% 
  filter(!is.na(gsa_name)) %>% 
  # mutate(gsa_name = factor(gsa_name),
  #        gsa_name = fct_lump_n(gsa_name, 500)) %>% 
  count(gsa_name) %>% 
  ggplot(aes(fct_reorder(gsa_name, n), n)) + 
  geom_col() + 
  coord_flip() 


# ------------------------------------------------------------------------
# run model
scen_names <- map_chr(gwl_t1, ~names(.x))
m <- map2(
  gwl_t1, scen_names,
  ~f_run_model(d2, gwl_t0, .x, .y)
)

# postprocessed aggregate stats
failp <- f_postprocess_failp(m)
failp %>% 
  select(-c("failp_mean","text")) %>% 
  write_csv(here("output","tables","impact_summary.csv"))

# postprocessed spatial data
sp <- f_postprocess_sp(m, scen_names) %>% 
  map(
    ~mutate(
      .x, 
      high = ifelse(high == "failing","impacted", high),
      low  = ifelse(high == "failing","impacted", low)
    )
  )

# maps
plot_titles <- paste(
  c("2012-2013","2013-2014","2012-2014","2014-2015","2013-2015","2015-2016","2014-2016"), 
  "decline"
)

# individual plots
p <- map2(sp, plot_titles, ~f_make_map(.x, aoi, .y))
walk2(p, scen_names, ~ggsave(here("output","single","pdf",paste0(.y,".pdf")), .x))
walk2(p, scen_names, ~ggsave(here("output","single","png",paste0(.y,".png")), .x))

# composite plots
p1 <- p[[1]] + p[[2]] + p[[4]] + p[[6]] + 
  patchwork::plot_layout(guides = "collect", nrow = 1)
p2 <- p[[3]] + p[[5]] + p[[7]] + 
  patchwork::plot_layout(guides = "collect", nrow = 1)

ggsave(here("output","composite","decline_1yr.png"), p1, height = 7, width = 13)
ggsave(here("output","composite","decline_1yr.pdf"), p1, height = 7, width = 13)
ggsave(here("output","composite","decline_2yr.png"), p2, height = 7, width = 13)
ggsave(here("output","composite","decline_2yr.pdf"), p2, height = 7, width = 13)


# ------------------------------------------------------------------------
# save
# write_rds(l, here("code", "results", "model_output.rds"))


# ------------------------------------------------------------------------
# save spatial data
sp %>% 
  walk(
    ~st_transform(.x, 4269) %>% 
      mutate(
        x = st_coordinates(.)[, 1],
        y = st_coordinates(.)[, 2]
      ) %>% 
      st_drop_geometry() %>% 
      write_csv(here("output", "sp", glue::glue("{.x$scen_name[1]}.csv")))
  )
