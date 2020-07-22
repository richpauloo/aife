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
# plotly popups for each gwl decline scenario and GSA
# ------------------------------------------------------------------------
ndeclines = length(unique(l$ALL$failp$decline))

for(i in 1:length(decline_v)){
  
  for(j in 1:length(l)){
    
    cv                    <- rep("gray60", ndeclines) # grey 
    cv[(decline_v[i]/10)] <- "black" 

    # plotly needs darker alpha...
    p  <- ggplot(l[[j]]$failp, 
                 aes(x = decline, y = failp_mean, 
                     ymin = failp_low, ymax = failp_high)) +
      geom_rect(aes(xmin = 0, xmax = decline_v[i], 
                    ymin = 0, ymax = 1), fill = "red", alpha = 0.15) +      
      geom_point(aes(text=text), alpha = 0, color = cv) +
      geom_errorbar(color = cv) +
      labs(x = "Groundwater level decline (ft)", y = "Failure percentage") +
      scale_y_continuous(labels = scales::percent) +
      theme_minimal()
    
    p2 <- ggplotly(p, tooltip = "text") %>% 
      layout(hovermode = "x unified") %>% 
      config(modeBarButtonsToRemove = buttons_to_remove,
             displaylogo = FALSE)
    col_vec <- rep("rgba(192,192,192,0.3)", ndeclines) # grey markers
    col_vec[(decline_v[i]/10)] <- "rgba(255,0,0,0.3)"  # red scenario marker
    p2$x$data[[2]]$marker$color <- col_vec             # modify plotly

    write_rds(p2, here("plotly", paste0(decline_v[i], "_", gsa_names[j], ".rds")))
  }
}

# ------------------------------------------------------------------------
# plotly popups of all MT CIs or range per GSA
# ------------------------------------------------------------------------
# bootstrapped and range output from `01_sampling_distribution...R`
bs  <- read_rds(here("code", "results", "MT_diffs_bootstrapped.rds"))
rg  <- read_rds(here("code", "results", "MT_diffs_range.rds"))
key <- read_csv(here("data", "gsa_key.csv")) %>% 
  filter(!is.na(gsp_name))

# sanity check is FALSE
(length(bs) + length(rg)) == (length(gsa_names) - 1)

gsa_names_model_order <- 
  c(sapply(bs, function(x) x$name[1]),
    sapply(rg, function(x) x$name[1])) %>% 
    tolower() %>% 
    str_remove_all("[\\(\\)]") %>% 
    str_remove_all(" dm") %>% 
    str_replace_all(" |-", "_") 

# extract IRR of bootstrapped output and range of range output
x1 <- map(bs, "z") %>% 
  map(quantile, c(0.25, 0.75))  %>% 
  map_df(bind_rows) %>% 
  rename(q1 = `25%`, q2 = `75%`) %>% 
  mutate(type = "IQR")
x2 <- bind_rows(rg) %>% 
  rename(q1 = z1, q2 = z2) %>% 
  select(q1, q2) %>% 
  mutate(type = "range")
n <- c(map(bs, "n") %>% map(1) %>% unlist(),
       map(rg, "n") %>% unlist())

# construct gwl decline MT intervals and get the gsp names right!
ivs <- bind_rows(x1, x2) %>% 
  mutate(n = n,
         name = gsa_names_model_order) %>% 
  # somehow olcese sneaked in... remove it
  filter(name %in% key$gsp_name_model) %>% 
  left_join(key, by = c("name" = "gsp_name_model")) %>% 
  select(-name) %>% 
  left_join(tibble(name = gsa_names[-1], 
                   full_name = names(l)[-1]),
            by = c("gsp_name" = "name")) %>% 
  mutate(low  = round(q1, -1), 
         high = round(q2, -1))

# sanity checks pass!
ivs$gsp_name  %in% gsa_names
ivs$full_name %in% names(l)[-1]

# add ALL
z   <- map(bs, "z") %>% unlist() %>% quantile(c(0.25,0.75))
ncv <- map(bs, "n") %>% map(1) %>% unlist() %>% sum()
ivs <- bind_rows(
  tibble(q1=z[1], q2=z[2],type="IQR",n=ncv,
         gsp_name="ALL",full_name="ALL",
         low=round(z[1],-1), high=round(z[2],-1)),
  ivs)

# write the MT decline ggplots and plotly objects
for(j in 1:nrow(ivs)){
  
  cv <- rep("gray60", ndeclines) # grey 
  cv[ (seq(ivs$low[j], ivs$high[j], 10)/10) ] <- "black"
  
  # modeled results are out of order, so filter for the right gsa!
  # plotly 
  p  <- ggplot(l[[  ivs$full_name[j]  ]]$failp, 
               aes(x = decline, y = failp_mean, 
                   ymin = failp_low, ymax = failp_high)) +
    geom_rect(aes(xmin = ivs$q1[j], xmax = ivs$q2[j], 
                  ymin = 0, ymax = 1), fill = "red", alpha = 0.15) +      
    geom_point(aes(text=text), alpha = 0, color = cv) +
    geom_errorbar(color = cv) +
    labs(x = "Groundwater level decline (ft)", y = "Failure percentage") +
    scale_y_continuous(labels = scales::percent) +
    theme_minimal()
  
  p2 <- ggplotly(p, tooltip = "text") %>% 
    layout(hovermode = "x unified") %>% 
    config(modeBarButtonsToRemove = buttons_to_remove,
           displaylogo = FALSE)
  col_vec <- rep("rgba(192,192,192,0.3)", ndeclines) # grey markers
  # red scenario marker
  col_vec[ (seq(ivs$low[j], ivs$high[j], 10)/10) ] <- "rgba(255,0,0,0.3)"  
  p2$x$data[[2]]$marker$color <- col_vec             # modify plotly
  
  write_rds(p2, here("plotly", paste0("mt_", ivs$gsp_name[j], ".rds")))
}




# ------------------------------------------------------------------------
# useful strings for master index files
# ------------------------------------------------------------------------
cat(paste(unique(gsa$gsp_name), collapse = "\n"))
cat(paste(gsa_names, collapse = "\n"))

# sanity check
tibble(x=unique(gsa$gsp_name),y=gsa_names) %>% View()


