# well failure model based on initial condition and final condition
f_run_model <- function(d, gwl_t0, gwl_t1, scen_name){
  
  # extract t1 gwl to points
  d[["gwl"]] <- raster::extract(gwl_t1, d)
    
    # ------------------------------------------------------------------------
    # high estimate of failures (lower CI of pump location)
    result_high <- 
      ifelse(d@data$mean_ci_lower >= d[["gwl"]], 
             "active","failing"
      ) %>% 
      as.data.frame() %>% 
      setNames("high") %>% 
      mutate(
        lowering_cost = 
          # distance to lower * cost per unit of lowering
          (d@data$tot_depth_msh - d@data$mean_ci_lower) * cost_per_well_lowering,
        lowering_cost = 
          ifelse(
            lowering_cost < 0, 
            0, lowering_cost
          ),
        deepening_cost = 
          ifelse(
            d@data$tot_depth_msh >= d[["gwl"]], 
            0, cost_per_well_replacement
          )
      ) 
    # only enforce a lowering cost if the well fails at the pump_loc
    result_high$lowering_cost <- 
      ifelse(
        result_high[, "high"] == "active",
        0, result_high$lowering_cost
      )
    names(result_high)[2] <- "lowering_cost_high"
    names(result_high)[3] <- "deepening_cost_high"
    
    # ------------------------------------------------------------------------
    # low estimate of well failure (upper CI of pump location)
    result_low <- 
      ifelse(d@data$mean_ci_upper >= d[["gwl"]], 
             "active","failing"
      ) %>% 
      as.data.frame() %>% 
      setNames("low") %>% 
      mutate(
        lowering_cost = 
          # distance to lower * cost per unit of lowering
          (d@data$tot_depth_msh - d@data$mean_ci_upper) * cost_per_well_lowering,
        lowering_cost = 
          ifelse(
            lowering_cost < 0, 
            0, lowering_cost
          ),
        deepening_cost = 
          ifelse(
            d@data$tot_depth_msh >= d[["gwl"]], 
            0, cost_per_well_replacement
          )
      ) 
    # only enforce a lowering cost if the well fails at the pump_loc
    result_low$lowering_cost <- 
      ifelse(
        result_low[, "low"] == "active",
        0, result_low$lowering_cost
      )
    names(result_low)[2] <- "lowering_cost_low"
    names(result_low)[3] <- "deepening_cost_low"
    
    # ------------------------------------------------------------------------
    # bind to d
    d@data <- cbind.data.frame(d@data, result_high, result_low) 
    
    # calculate total cost and bind to d, then rename
    total_cost <- 
      tibble(
        h       = d@data[, "high"],
        l       = d@data[, "low"],
        lc_high = d@data[, "lowering_cost_high"],
        lc_low  = d@data[, "lowering_cost_low"],
        dc_high = d@data[, "deepening_cost_high"],
        dc_low  = d@data[, "deepening_cost_low"]
      ) %>% 
      mutate(
        total_cost_high = lc_high + dc_high,
        total_cost_low  = lc_low  + dc_low
      )
    
    d@data$total_cost_high <- total_cost$total_cost_high
    d@data$total_cost_low  <- total_cost$total_cost_low
    names(d@data)[(length(d@data)-1):length(d@data)] <- 
      c("total_cost_high", "total_cost_low")
    
    # for sanity checking & debugging
    # lapply(list(result_high, result_low), table)
  # }
  
  # compute fail count per decline scenario
  failn <- dplyr::select(d@data, matches("^low$|^high$")) %>% 
    apply(2, function(x) length(x[x == "failing"]) )
  
  # compute fail percentages per decline scenario
  failp <- dplyr::select(d@data, matches("^low$|^high$")) %>% 
    apply(2, function(x) length(x[x == "failing"])/nrow(d)) 
  
  # sum high and low total_cost per gsa nd decline scenario
  tot_cost <- dplyr::select(d@data, matches("total_cost")) %>% 
    apply(2, sum) 
  
  # create errorbar dataframe for ggplot/plotly
  edf <- tibble(scen       = scen_name, 
                failn_high = failn[grep("^high", names(failn))],
                failn_low  = failn[grep("^low",  names(failn))],
                failp_high = failp[grep("^high", names(failp))],
                failp_low  = failp[grep("^low", names(failp))],
                cost_high  = tot_cost[grep("high", names(tot_cost))],
                cost_low   = tot_cost[grep("low", names(tot_cost))]) %>%
    mutate(failp_mean = (failp_high + failp_low)/2) %>% 
    mutate(text = paste0("<em>groundwater scenario:</em> ", 
                         scen_name, " ft<br>",
                         
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
