# ------------------------------------------------------------------------
# run the model for the entire CV and generate raw output
# ------------------------------------------------------------------------

library(here)
library(raster)
library(tidyverse)

# cost per failed well in millions
cost_per_failed_well <- 3000/1e6

# read wells, initial groundwater level conditions, and gsas
d   <- read_rds(here("code", "results", "dom_wells_ll.rds"))
gwl <- readr::read_rds(here::here("code", "results", "gwl_2019_avg_ll.rds"))
gsa <- readr::read_rds(here::here("code", "results", "gsa_ll.rds"))


# ------------------------------------------------------------------------
# determine how many gwl decline scenarios are needed for each GSA
# ------------------------------------------------------------------------

# start by applying the failure threshold across the entire CV for a 
# vector of groundwater level declines.
# then, subset for individual GSAs and calculate stats there.
# dropdown menu should provide 10 bins

run_model <- function(d, selected_gsp, decline){

  # GSA level selection
  if(selected_gsp != "ALL") {
    d <- d[d@data$gsp_name == selected_gsp, ]
  }
  
  # vector of declines
  decline <- decline

  for(j in 1:length(decline)){
    
    # high estimate of failures (lower CI of pump location)
    result_pump_loc <- 
      ifelse(d@data$mean_ci_lower >= (d@data$gwl_2019 + decline[j]), 
             "active","failing"
             ) %>% 
      as.data.frame() %>% 
      setNames(paste0("high_", decline[j])) 
    
    # low estimate of well failure (total completed depth + min suction head)
    result_tot_dpth <- 
      ifelse(d@data$tot_depth_msh >= (d@data$gwl_2019 + decline[j]), 
             "active","failing"
             ) %>% 
      as.data.frame() %>% 
      setNames(paste0("low_", decline[j]))
    
    # bind to d
    d@data <- cbind.data.frame(d@data, result_pump_loc, result_tot_dpth)
    
    # for sanity checking & debugging
    #lapply(list(result_pump_loc, result_tot_dpth), table)
  }
  
  # compute fail count per decline scenario
  failn <- dplyr::select(d@data, matches("low_|high_")) %>% 
    apply(2, function(x) length(x[x == "failing"]) )
  
  # compute fail percentages per decline scenario
  failp <- dplyr::select(d@data, matches("low_|high_")) %>% 
    apply(2, function(x) length(x[x == "failing"])/nrow(d)) 
  
  # create errorbar dataframe for ggplot/plotly
  edf <- tibble(decline    = decline, 
                failn_high = failn[seq(1,length(failn),2)],
                failn_low  = failn[seq(2,length(failn),2)],
                failp_high = failp[seq(1,length(failp),2)],
                failp_low  = failp[seq(2,length(failp),2)]) %>% 
    mutate(cost_low  = failn_low  * cost_per_failed_well,
           cost_high = failn_high * cost_per_failed_well) %>%
    mutate(failp_mean = (failp_high + failp_low)/2) %>% 
    mutate(text = paste0("<em>groundwater decline:</em> ", 
                         decline, " ft<br>",
                         
                         "<em>failure count:</em> ", 
                         failn_low, " - ", 
                         failn_high, "br>",
                         
                         "<em>failure rate:</em> ", 
                         round(100 * failp_low, 1), " - ", 
                         round(100 * failp_high, 1), " %<br>",
                         
                         "<em>estimated cost:</em> $", 
                         round(cost_low, 1), " - ", 
                         round(cost_high, 1), "M")
    )
  
  return(list(failp = edf, sp = d))
}

# sanity checks
#length(unique(gsa@data$gsp_name)) == length(unique(d@data$gsp_name))
#unique(gsa@data$gsp_name) %in% unique(d@data$gsp_name) 

# iterate function over gsa names
gsa_names_full <- c("ALL", unique(gsa$gsp_name))
l <- vector("list", length = length(gsa_names_full))
for(i in 1:length(gsa_names_full)) {
  l[[i]] <- run_model(
    d, gsa_names_full[i], 
    seq(10, 500, 10)
    )
}
names(l) <- gsa_names_full

# save
write_rds(l, here("code", "results", "model_output.rds"))
