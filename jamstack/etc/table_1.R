library(tidyverse)
library(knitr)
library(kableExtra)

tibble(Study = c("Pauloo et al (2021), this study","Bostic et al (2020)","EKI (2020)"),
       Retirement_age_yrs = c("31 yrs","29 yrs","not reported"),
       initial_gwl = c("2019","2019","not reported"),
       Initial_wells = c("15,368","8,206","24,500"),
       well_failure_count = c("9,281-9651","5,416","12,000"),
       well_failure_percent = c("61-63%","66%","49%"),
       estimated_cost_M_USD = c("109-115","NA","88-359"),
       people_impacted = c("not calculated","55,698-222,792","106,000-127000")) %>% 
  setNames(c("Study", "Retirement age (yrs)",
             "Groundwater level initial condition (yr)","Initial well count",
             "Well failure count","Well failure percentage",
             "Estimated Cost ($M USD)", "Count of people impacted")) %>% 
  kable() %>% 
  kable_styling(bootstrap_options = c("striped", "hover", "condensed")) %>%
  cat()
