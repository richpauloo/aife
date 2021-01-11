# ------------------------------------------------------------------------
# We relate the MT scenario to the arbitrary decline scenarios NOT by the
# bootstrapped IQR of declines (which was a nice experiment), but RATHER
# by the nfail at the MT surface, which is more accurate. Thus, we compute
# failure at the MT surface, then split the nfail range per GSA for plotly 
# and the dashboards
# ------------------------------------------------------------------------
library(tidyverse)
library(sp)
library(here)

# remove a few GSAs because they have < 10 wells
rm_gsas_low_n <- c("New Stone (Madera)","Aliso (DM)","Farmers (DM)", 
                   "Henry Miller (Kern)", "Alpaugh (Tule)",
                   "Tri-County (Tule)", "Gravelly Ford (Madera)", 
                   "Root Creek (Madera)", "Fresno County (DM)",
                   "Delano-Earlimart (Tule)","Olcese (Kern)")

# cost per failed well in millions
cost_per_well_lowering    <- 100 # USD $100 / ft
cost_per_well_replacement <- 115 * 100 # USD $115 / ft for 100 ft

# ------------------------------------------------------------------------
# MT surface and wells
mts <- read_rds(here("code", "results","mt_surface_cv.rds"))
d   <- read_rds(here("code", "results", "dom_wells_ll.rds"))

# remove these GSAs
d   <- d[!d@data$gsp_name %in% rm_gsas_low_n, ] # same object as in 02_preprocess.R

# extract MT surface to domestic wells
d <- raster::extract(mts$Prediction, d, sp = TRUE)
d <- d[ !is.na(d@data$Prediction), ]

# failure range based on uncertainty in pump location estimate
d$fail_high <- ifelse(d$mean_ci_lower >= d$Prediction, FALSE, TRUE) # previously, mean_ci_lower
d$fail_low  <- ifelse(d$mean_ci_upper >= d$Prediction, FALSE, TRUE)

cat(table(d$fail_low)[2],"-", table(d$fail_high)[2], "failing, and", nrow(d), "total wells to begin with.")
# this lines up better with EKI's numbers

# calculate cost range
# high estimate of failures (lower CI of pump location)
result_high <- 
  ifelse(d@data$mean_ci_lower >= d@data$Prediction, 
         "active","failing"
  ) %>% 
  as.data.frame() %>% 
  setNames("high_mt") %>% 
  mutate(
    lowering_cost = 
      # distance to lower * cost per unit of lowering
      (d@data$tot_depth_msh - d@data$mean_ci_lower) *
      cost_per_well_lowering,
    lowering_cost = ifelse(lowering_cost < 0, 0, lowering_cost),
    deepening_cost = 
      ifelse(d@data$tot_depth_msh >= d@data$Prediction, 
             0, cost_per_well_replacement)
  ) 
# only enforce a lowering cost if the well fails at the pump_loc
result_high$lowering_cost <- 
  ifelse(
    result_high[, "high_mt"] == "active",
    0, result_high$lowering_cost
  )
names(result_high)[2] <- "lowering_cost_high_mt"
names(result_high)[3] <- "deepening_cost_high_mt"

# ------------------------------------------------------------------------
# low estimate of well failure (upper CI of pump location)
result_low <- 
  ifelse(d@data$mean_ci_upper >= d@data$Prediction, 
         "active","failing"
  ) %>% 
  as.data.frame() %>% 
  setNames("low_mt") %>% 
  mutate(
    lowering_cost = 
      # distance to lower * cost per unit of lowering
      (d@data$tot_depth_msh - d@data$mean_ci_upper) *
      cost_per_well_lowering,
    lowering_cost = ifelse(lowering_cost < 0, 0, lowering_cost),
    deepening_cost = 
      ifelse(d@data$tot_depth_msh >= d@data$Prediction, 
             0, cost_per_well_replacement)
  ) 
# only enforce a lowering cost if the well fails at the pump_loc
result_low$lowering_cost <- 
  ifelse(
    result_low[, "low_mt"] == "active",
    0, result_low$lowering_cost
  )
names(result_low)[2] <- "lowering_cost_low_mt"
names(result_low)[3] <- "deepening_cost_low_mt"

# ------------------------------------------------------------------------
# bind to d
d@data <- cbind.data.frame(d@data, result_high, result_low) 

# calculate total cost and bind to d, then rename
total_cost <- 
  tibble(
    h  = d@data[, "high_mt"],
    l  = d@data[, "low_mt"],
    lc_high = d@data[, "lowering_cost_high_mt"],
    lc_low  = d@data[, "lowering_cost_low_mt"],
    dc_high = d@data[, "deepening_cost_high_mt"],
    dc_low  = d@data[, "deepening_cost_low_mt"]
  ) %>% 
  mutate(
    total_cost_high = lc_high + dc_high,
    total_cost_low  = lc_low  + dc_low
  )

d@data$total_cost_high <- total_cost$total_cost_high
d@data$total_cost_low  <- total_cost$total_cost_low
names(d@data)[(length(d@data)-1):length(d@data)] <- 
  paste0(c("total_cost_high_", "total_cost_low_"), "mt")


# save mt model output
write_rds(d, here("code", "results", "model_output_mts_only.rds"))


# summarise MT failure counts and percent
# and grab cost from the decline scenarios
mt_fail_summary <- 
  group_by(d@data, gsp_name) %>% 
  summarise(fail_low    = sum(fail_low),
            fail_high   = sum(fail_high),
            fail_low_p  = fail_low  / n(),
            fail_high_p = fail_high / n(),
            cost_high = sum(total_cost_high_mt),
            cost_low = sum(total_cost_low_mt))

# add "ALL" to the summary
mt_fail_summary <- 
  tibble(gsp_name    = "ALL", 
       fail_low    = table(d$fail_low)[2],
       fail_high   = table(d$fail_high)[2],
       fail_low_p  = table(d$fail_low)[2] / nrow(d),
       fail_high_p = table(d$fail_high)[2] / nrow(d),
       cost_high = sum(d$total_cost_high_mt),
       cost_low = sum(d$total_cost_low_mt)) %>% 
  bind_rows(mt_fail_summary) %>% 
  rename(low = fail_low, high = fail_high, full_name = gsp_name, 
         failp_low = fail_low_p, failp_high = fail_high_p) %>% 
  mutate(gsp_name = c("ALL", "buena_vista_kern", "central_kings", "chowchilla", "east_kaweah", 
                      "east_tule", "eastern_san_joaquin", "grassland", "greater_kaweah", 
                      "james_kings", "kern_groundwater_authority", "kern_river", "kings_river_east", 
                      "lower_tule_river", "madera_joint", "mc_mullin", "merced", "mid_kaweah", 
                      "north_fork_kings", "north_kings", "northern_central", "pixley_tule", 
                      "sjrec", "south_kings", "tulare_lake", "westside"))

write_rds(mt_fail_summary, here("code", "results", "mt_fail_summary.rds"))

