# ------------------------------------------------------------------------
# data aand metadta tables for "data" tab

library(here)
library(raster)
library(tidyverse)
library(sf)


# ------------------------------------------------------------------------
# domestic wells

# remove a few GSAs because they have < 10 wells
rm_gsas_low_n <- c("New Stone (Madera)","Aliso (DM)","Farmers (DM)", 
                   "Henry Miller (Kern)", "Alpaugh (Tule)",
                   "Tri-County (Tule)", "Gravelly Ford (Madera)", 
                   "Root Creek (Madera)", "Fresno County (DM)",
                   "Delano-Earlimart (Tule)","Olcese (Kern)")

# cost per failed well in millions
cost_per_well_lowering    <- 100 # USD $100 / ft
cost_per_well_replacement <- 115 * 100 # USD $115 / ft for 100 ft

# read wells, initial groundwater level conditions, and gsas
d   <- read_rds(here("code", "results", "dom_wells_ll.rds"))
d   <- d[!d@data$gsp_name %in% rm_gsas_low_n, ] # same object as in 02_preprocess.R

# write data
d2 <- d %>% 
  st_as_sf() %>% 
  select(wcr_number = WCRNumber, mean_ci_upper:mean_ci_lower, 
         tot_completed_depth = TotalCompletedDepth, gwl_2019, gsp_name) %>% 
  mutate(x = st_coordinates(.)[,1], y = st_coordinates(.)[,2]) %>% 
  st_drop_geometry()
d2 %>% write_csv(here("download","domestic_wells.csv"))
tibble(Variable = colnames(d2), 
       Description = c("Well Completion Report Number from the Well Completion report database (https://data.cnra.ca.gov/dataset/well-completion-reports)",
                       "95% CI of estimated pump location in feet below land surface from Pauloo et al., (2020)",
                       "Estimated pump location in feet below land surface from Pauloo et al., (2020)",
                       "5% CI of estimated pump location in feet below land surface from Pauloo et al., (2020)",
                       "Total completed depth of well in feet below land surface from the Well Completion report database (https://data.cnra.ca.gov/dataset/well-completion-reports)",
                       "Initial groundwater level condition (2019 average) at the well in feet below land surface, calculated via ordinary kriging from ambient seasonal groundwater level measurements in the Periodic Groundwater Level Measurement Database (https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements)",
                       "GSA the well falls within",
                       "x coordinate of the well in EPSG 4269",
                       "y coordinate of the well in EPSG 4269")) %>%
  knitr::kable() %>% 
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>% 
  htmltools::HTML()


# ------------------------------------------------------------------------
# initial groundwater condition
gwl <- readr::read_rds(here::here("code", "results", "gwl_2019_avg_ll.rds"))
mask(gwl, gsa) %>% 
  writeRaster(here("download","gwl_2019.tif"), overwrite=TRUE)
raster(here("download","gwl_2019.tif"))

tibble(Variable = "gwl_2019",
       Description = "Initial groundwater level condition representing the average 2019 groundwater level in the GSAs considered in this study. Values reported are in feet below land surface.") %>% 
  knitr::kable() %>% 
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>% 
  htmltools::HTML()

# ------------------------------------------------------------------------
# mt surface
mts <- read_rds(here("code", "results","mt_surface_cv.rds"))
mts %>% 
  projectRaster(crs = CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs")) %>% 
  writeRaster(here("download","gwl_mt.tif"))

tibble(Variable = "gwl_mt",
       Description = "Groundwater level condition representing the minimum threshold surface specified by individual monitoring locations in the GSPs reviewed by this study. Values reported are in feet below land surface.") %>% 
  knitr::kable() %>% 
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>% 
  htmltools::HTML()

# ------------------------------------------------------------------------
# model results
l   <- read_rds(here("code", "results", "model_output.rds"))
# remove first element (ALL), and combine into df
l <- map_df(l[2:length(l)], ~.x$sp %>% 
              st_as_sf() %>% 
              select(wcr_number = WCRNumber, high_10:total_cost_low_300) %>% 
              st_drop_geometry()
            ) %>% 
  left_join(read_rds(here("code", "results", "model_output_mts_only.rds"))@data %>% 
              select(wcr_number = WCRNumber, high_mt:total_cost_low_mt),
            by = "wcr_number")
write_csv(l, here("download","well_failure_model_results.csv"))

tibble(Variable = c("wcr_number", 
                    "high_n", "lowering_cost_high_n", "deepening_cost_high_n",
                    "low_n",  "lowering_cost_low_n",  "deepening_cost_low_n",
                    "total_cost_high_n", "total_cost_low_n"),
       Description = c("Well Completion report number to join to domestic_wells.csv",
                       "Well status (active or failing) for the pump location 5% confidence interval at n feet of decline",
                       "Cost in $USD to lower the well for the pump location 5% confidence interval at n feet of decline",
                       "Cost in $USD to deepen the well for the pump location 5% confidence interval at n feet of decline",
                       "Well status (active or failing) for the pump location 95% confidence interval at n feet of decline",
                       "Cost in $USD to lower the well for the pump location 95% confidence interval at n feet of decline",
                       "Cost in $USD to deepen the well for the pump location 95% confidence interval at n feet of decline",
                       "Total cost in $USD to lower and deepen the well for the pump location 5% confidence interval at n feet of decline",
                       "Total cost in $USD to lower and deepen the well for the pump location 5% confidence interval at n feet of decline")) %>% 
  knitr::kable() %>% 
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>% 
  htmltools::HTML()



