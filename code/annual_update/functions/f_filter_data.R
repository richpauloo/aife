# pre data for CV kriging
f_filter_data <- function(d, yr, sn = c("spring", "fall")){
  
  # subset to years and season specified
  yr_sn <- filter(d, year(dt) %in% yr & season %in% sn)
  
  # summarize by year and season
  yr_sn_gwl <- yr_sn %>% 
    group_by(id) %>% 
    summarise(wse_ft  = mean(wse_ft,  na.rm = TRUE)) %>% 
    ungroup() %>% 
    mutate(wse_ft  = ifelse(is.nan(wse_ft), NA, wse_ft)) %>% 
    filter(!is.na(wse_ft))
  
  return(yr_sn_gwl)
  
}
