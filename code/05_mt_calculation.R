# ------------------------------------------------------------------------
# We relate the MT scenario to the arbitray decline scenarios NOT by the
# bootstrapped IQR of declines (which was a nice experiment), but RATHER
# by the nfail at the MT surface, which is more accurate. Thus, we compute
# failure at the MT surface herein, and split the nfail range per GSA
# for plotly and the dashboards
# ------------------------------------------------------------------------
library(tidyverse)
library(sp)
library(here)

mts <- read_rds(here("code", "results","mt_surface_cv.rds"))
d   <- read_rds(here("code", "results", "dom_wells_ll.rds"))

# extract MT surface to domestic wells
d <- raster::extract(mts$Prediction, d, sp = TRUE)
d <- d[ !is.na(d@data$Prediction), ]

d$fail_high <- ifelse(d$mean_ci_lower >= d$Prediction, FALSE, TRUE)
d$fail_low  <- ifelse(d$TotalCompletedDepth >= d$Prediction, FALSE, TRUE)

cat(table(d$fail_low)[2],"-", table(d$fail_high)[2], "failing, and", nrow(d), "total wells to begin with.")
# this lines up better with EKI's numbers

# summarise MT failure counts and percent
# and grab cost from the decline scenarios
mt_fail_summary <- 
  group_by(d@data, gsp_name) %>% 
  summarise(fail_low    = sum(fail_low),
            fail_high   = sum(fail_high),
            fail_low_p  = fail_low  / n(),
            fail_high_p = fail_high / n())

# add "ALL" to the summary
mt_fail_summary <- 
  tibble(gsp_name    = "ALL", 
       fail_low    = table(d$fail_low)[2],
       fail_high   = table(d$fail_high)[2],
       fail_low_p  = table(d$fail_low)[2] / nrow(d),
       fail_high_p = table(d$fail_high)[2] / nrow(d)) %>% 
  bind_rows(mt_fail_summary)

write_rds(mt_fail_summary, here("code", "results", "mt_fail_summary.rds"))

