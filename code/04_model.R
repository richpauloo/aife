# ------------------------------------------------------------------------
# run the model for the entire CV and generate raw output
# ------------------------------------------------------------------------

library(here)
library(raster)
library(tidyverse)

# cost per failed well in millions
cost_per_well_lowering    <- 100 # USD $100 / ft
cost_per_well_replacement <- 115 * 100 # USD $115 / ft for 100 ft

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

# debugging
# selected_gsp = "ALL"
# decline = seq(10, 500, 10)
# j=1

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
      setNames(paste0("high_", decline[j])) %>% 
      mutate(
        lowering_cost = 
          (d@data$tot_depth_msh - d@data$mean_ci_lower) *
           cost_per_well_lowering
      ) 
    # only enforce a lowering cost if the well fails at the pump_loc
    result_pump_loc$lowering_cost <- 
      ifelse(
        result_pump_loc[, paste0("high_", decline[j])] == "active",
        0, result_pump_loc$lowering_cost
      )
    names(result_pump_loc)[2] <- paste0("lowering_cost_", decline[j])
    
    # low estimate of well failure (total completed depth + 
    # min net positive suction head of 3 meters)
    result_tot_dpth <- 
      ifelse(d@data$tot_depth_msh >= (d@data$gwl_2019 + decline[j]), 
             "active","failing"
             ) %>% 
      as.data.frame() %>% 
      setNames(paste0("low_", decline[j]))
    
    # bind to d
    d@data <- cbind.data.frame(d@data, result_pump_loc, result_tot_dpth) 
    
    # calculate total cost and bind to d, then rename
    total_cost <- 
      tibble(
        h  = d@data[,paste0("high_", decline[j])],
        l  = d@data[,paste0("low_", decline[j])],
        lc = d@data[,paste0("lowering_cost_", decline[j])]
      ) %>% 
      mutate(
        total_cost = 
          ifelse(
            h == "failing" & l == "failing", 
            lc + cost_per_well_replacement, 
            lc
          )
        ) %>% 
      pull(total_cost)
    
    d@data$total_cost <- total_cost
    names(d@data)[length(d@data)] <- paste0("total_cost_", decline[j])
    
    # for sanity checking & debugging
    #lapply(list(result_pump_loc, result_tot_dpth), table)
  }
  
  # compute fail count per decline scenario
  failn <- dplyr::select(d@data, matches("low_|high_")) %>% 
    apply(2, function(x) length(x[x == "failing"]) )
  
  # compute fail percentages per decline scenario
  failp <- dplyr::select(d@data, matches("low_|high_")) %>% 
    apply(2, function(x) length(x[x == "failing"])/nrow(d)) 
  
  # sum high and low total_cost per gsa nd decline scenario
  tot_cost <- dplyr::select(d@data, matches("total_cost_")) %>% 
    apply(2, sum) 
  
  # create errorbar dataframe for ggplot/plotly
  edf <- tibble(decline    = decline, 
                failn_high = failn[seq(1,length(failn),2)],
                failn_low  = failn[seq(2,length(failn),2)],
                failp_high = failp[seq(1,length(failp),2)],
                failp_low  = failp[seq(2,length(failp),2)]) %>% 
    mutate(cost_low  = failn_low  * cost_per_well_replacement,
           cost_high = tot_cost) %>%
    mutate(failp_mean = (failp_high + failp_low)/2) %>% 
    mutate(text = paste0("<em>groundwater decline:</em> ", 
                         decline, " ft<br>",
                         
                         "<em>failure count:</em> ", 
                         format(failn_low, big.mark = ","), " - ", 
                         format(failn_high, big.mark = ","), "<br>",
                         
                         "<em>failure rate:</em> ", 
                         round(100 * failp_low, 1), " - ", 
                         round(100 * failp_high, 1), " %<br>",
                         
                         "<em>estimated cost:</em> $", 
                         formatC(round((cost_low  / 1e6), 1), 
                                 format="f", digits=1), " - ", 
                         formatC(round((cost_high / 1e6), 1), 
                                 format="f", digits=1), 
                         "M")
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
