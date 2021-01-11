# ------------------------------------------------------------------------
# prepare results for download and dataframe for leaflet to show
# active and failing wells

library(tidyverse)
library(here)

d   <- read_rds(here("code", "results", "model_output.rds")) %>% map("sp")
d2  <- read_rds(here("code", "results", "model_output_mts_only.rds"))
d2l <- d2@data %>% 
  split(., d2@data$gsp_name) %>% 
  map(~select(.x, WCRNumber, mt_ft_bls = Prediction, high_mt:total_cost_low_mt)) 

# take care of "ALL"
d2@data <- d2@data %>% 
  select(WCRNumber, mt_ft_bls = Prediction, high_mt:total_cost_low_mt) 
d[[1]]@data  <- left_join(d[[1]]@data, d2@data, by = "WCRNumber")

# take care of the rest of the GSAs
for(i in names(d)[-1]){
  d[[i]]@data <- left_join(d[[i]]@data, d2l[[i]], by = "WCRNumber")
}

# write results to csv for data download, and to rds for leaflet
write_rds(d, here("code", "results", "results_leaflet.rds"))
d %>% 
  map2(., names(d), ~write_csv(.x@data, here("code", "results", "share", paste0(.y, ".csv"))))
