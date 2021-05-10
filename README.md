# AI enabled forecasting of regional-scale drinking water shortages in underserved communities

Rich Pauloo, PhD [richpauloo at gmail dot com], *Larry Walker Associates, UC Davis*  
Darcy Bostic, MS [dbostic at pacinst dot org], *Pacific Institute, UC Davis*  


## Overview

This is the project repository for [gspdrywells.com](www.gspdrywells.com), made possible with support from the AI for Earth Innovation Program Grant provided by Global Wildlife Conservation and Microsoft Corporation. [See press release](https://www.globalwildlife.org/press/winners-of-ai-for-earth-innovation-grants-poised-to-address-urgent-environmental-challenges-with-creative-use-of-technology/).  

This work further extends the domestic well failure modeling published in [Pauloo, et al (2020)](https://iopscience.iop.org/article/10.1088/1748-9326/ab6f10), and [Bostic, et al (2020)](WF_report).  

If you've reached this site looking for the static site at [gspdrywells.com](gspdrywells.com), see [this Github repository](https://github.com/richpauloo/jbp).  


## Project summary

About 1.5 million residents of California’s Central Valley rely on private domestic wells for drinking water, and many of these wells can, and oftentimes do, fail during drought or as the result of unsustainable groundwater management. This project uses hydrologic modeling, statistical learning, and data science to predict how groundwater level changes will impact domestic well failure and provides estimated information on drinking water shortages for underserved populations. Decision makers and local agencies can use this information to prevent well failure and inform water resource management and planning.


## Workflow

Run scripts in `code` beginning in 02, 05, 06, 07 in order to generate objects for 00, which writes the static site.    


## Contents

`/archive`: outdated, unused material  
`/code`: analysis and modeling scripts  
* `01_sampling_distribution_MT_GWL_difference.R`: data cleaning, bootstrapping forecasted groundwater declines, generating plots `p1-p4`   
* `02_preprocess_data_for_dashbard`: read in data saved in `01_...` and preprocess specifically for jamstack   
* `03_compare_domestic_and_MT_well_depths.R`: sanity check to ensure domestic well depths coincide with the ranges of groundwater level decline  
* `04_model.R`: generate forecasts and assets used in the static pages  
* `05_postprocess.R`: postprocess model results from `04_model.R` into plotly popups for main page  
* `06_kriging.R`: krige present day groundwater level and 2040 MT surface

`/data`: raw data used by the code in this project  
`/jamstack`: code and files related to dashboard generation, which is hosted via Jekyll at [github.com/richpauloo/jbp](github.com/richpauloo/jbp)  
* `00_main.html`: main GSA landing pages  
* `01_scen.html`: scenario specific pages  


## Processed data in `/data`:

* `dom_wells_ll.rds`: domestic wells in critical-priority GSAs and within a 28 year retirement age* with selected data (`wcr_num, lat, lon, pump_loc_low, pump_loc_up, TotalCompletedDepth`). Derived from [published data here (`domcv6_mean_gw_with_beta_GF_CI.rds`)](https://datadryad.org/stash/dataset/doi:10.25338/B8Q31D). `year` data was removed to reduce file size. CRS in LL.  
* `gsa_ll.rds`: critical priority GSA polygons (output from `rmapshaper::ms_simplify()` to reduce file size) containing monitoring well locations. Output from `code/01_sampling_distribution_MT_GWL.R`. CRS in LL.  
* `gwl_2019_avg_ll.rds`: 2019 average kriged groundwater level data.  

## TODO:

Spring and Fall groundwater levels are taken from Pauloo (2020). Darcy implemented this code in `data/4Interpolationinterpolate_cgwl_mts_CVcobs.R`, which should be genralized into a kriging pipeline in `code/06_kriging.R` for future updates to the "present day" groundwater level and the "MT surface".
