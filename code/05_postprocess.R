# ------------------------------------------------------------------------
# postprocess model into visualizations for static sites
# ------------------------------------------------------------------------

library(here)
library(raster)
library(tidyverse)
library(plotly)

# read gsa shapefile and well failure model output from 04_model.R
gsa <- readr::read_rds(here::here("code", "results", "gsa_ll.rds"))
l   <- read_rds(here("code", "results", "model_output.rds"))

# vector of groundwater level declines to make plots for
decline_v <- c(0,10,20,30,40,50,100,150,200,250,300,400,500)

# create GSA level directories in github/jbp/gsas
gsa_names <- gsa@data$gsp_name %>% 
  tolower() %>% 
  str_remove_all("[\\(\\)]") %>% 
  str_remove_all(" dm") %>% 
  str_replace_all(" |-", "_") %>% 
  c("ALL", .)
# for(i in 1:nrow(gsa)) {
#   dir.create(paste0("~/Github/jbp/gsas/", gsa_names[i]))
#   dir.create(paste0("~/Github/jbp/gsas/", gsa_names[i], "/mt"))
#   for(j in 1:length(decline_v)){
#     dir.create(paste0("~/Github/jbp/gsas/", gsa_names[i], "/", decline_v[j])) 
#   }
# }

# plotly buttons to remove
buttons_to_remove <- 
  list("zoom2d", "select2d", "lasso2d", "autoscale",
       "hoverClosestCartesian", "hoverCompareCartesian",
       "zoom3d", "pan3d", "resetCameraDefault3d",
       "resetCameraLastSave3d", "hoverClosest3d",
       "orbitRotation", "tableRotation","zoomInGeo", 
       "zoomOutGeo", "resetGeo", "hoverClosestGeo",
       "sendDataToCloud", "pan2d","hoverClosestGl2d",
       "hoverClosestPie","toggleHover","toggleSpikelines",
       "autoScale2d","zoomIn2d","zoomOut2d")

# ------------------------------------------------------------------------
# create all plotly output for each gwl decline scenario and GSA
# ------------------------------------------------------------------------
for(i in 1:length(decline_v)){
  
  highlighted_data <- filter(l[[j]]$failp, decline == decline_v[i])
  
  for(j in 1:length(l)){
    
    cv                    <- rep("gray60", 50) # grey 
    cv[(decline_v[i]/10)] <- "black"
    
    p  <- ggplot(l[[j]]$failp, 
                 aes(x = decline, y = failp_mean, 
                     ymin = failp_low, ymax = failp_high)) +
      geom_rect(aes(xmin = 0, xmax = decline_v[i], ymin = 0, ymax = 1), fill = "red", alpha = 0.15) +      
      geom_point(aes(text=text), alpha=0, color=cv) +
      geom_errorbar(color = cv) +
      labs(x = "Groundwater level decline (ft)", y = "Failure percentage") +
      scale_y_continuous(labels = scales::percent) +
      theme_minimal()
    
    p2 <- ggplotly(p, tooltip = "text") %>% 
      layout(hovermode = "x unified") %>% 
      config(modeBarButtonsToRemove = buttons_to_remove,
             displaylogo = FALSE)
    col_vec <- rep("rgba(192,192,192,0.3)", 50) # grey marker colors
    col_vec[(decline_v[i]/10)] <- "rgba(255,0,0,0.3)"       # red marker for scenario
    p2$x$data[[2]]$marker$color <- col_vec      # specify colors in plotly
    p2
    write_rds(p2, here("plotly", paste0(decline_v[i], "_", gsa_names[j], ".rds")))
  }
}


# ------------------------------------------------------------------------
# write all plots for main index popups that show the MT CIs per GSA
# ------------------------------------------------------------------------

# bootstrapped and range output from `01_sampling_distribution...R`
bs <- read_rds(here("code", "results", "MT_diffs_bootstrapped.rds"))
rg <- read_rds(here("code", "results", "MT_diffs_range.rds"))

for(i in 1:length(l)) {
  p <- ggplot(l[[j]]$failp, 
              aes(x = decline, y = failp_mean, 
                  ymin = failp_low, ymax = failp_high)) +
    geom_rect(aes(xmin = mt_ci_low[i], xmax = mt_ci_up[i], 
                  ymin = 0, ymax = 1, fill = "red", alpha = 0.3)) +
    geom_point(aes(text=text), alpha=0) +
    geom_errorbar() + 
    labs(x = "Groundwater level decline (ft)", y = "Failure percentage") +
    scale_y_continuous(labels = scales::percent) +
    theme_minimal()
  
  ggsave(here("ggplot",""), p)
}


# ------------------------------------------------------------------------
# useful strings for master index files
# ------------------------------------------------------------------------
cat(paste(unique(gsa$gsp_name), collapse = "\n"))
cat(paste(gsa_names, collapse = "\n"))

# sanity check
tibble(x=unique(gsa$gsp_name),y=gsa_names) %>% View()


