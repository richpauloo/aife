# AI enabled forecasting of regional-scale drinking water shortages in underserved communities

Rich Pauloo, PhD [richpauloo at gmail dot com], *Larry Walker Associates, UC Davis*  
Darcy Bostic, MS [email], *Pacific Institute, UC Davis*  
Amanda Monaco, JD [email], *Leadership Counsel for Justice and Accountability*  
Kaylon Hammond, JD [email], *Leadership Counsel for Justice and Accountability*  
 

## Overview

This is the project repository for [gsawellfailure.com](www.gsawellfailure.com), made possible with support from the AI for Earth Innovation Program Grant provided by Global Wildlife Conservation and Microsoft Corporation. [See press release](https://www.globalwildlife.org/press/winners-of-ai-for-earth-innovation-grants-poised-to-address-urgent-environmental-challenges-with-creative-use-of-technology/).  

This work further extends the domestic well failure modeling published in [Pauloo, et al (2020)](https://iopscience.iop.org/article/10.1088/1748-9326/ab6f10), and [Bostic, et al (2020)](WF_report).


## Project summary

About 1.5 million residents of California’s Central Valley rely on private domestic wells for drinking water, and many of these wells can, and oftentimes do, fail during drought or as the result of unsustainable groundwater management. This project uses hydrologic modeling, statistical learning, and data science to predict how groundwater level changes will impact domestic well failure and provides estimated information on drinking water shortages for underserved populations. Decision makers and local agencies can use this information to prevent well failure and inform water resource management and planning.


## Contents

`/archive`: outdated, unused material  
`/code`: analysis and modeling scripts  
* `01_sampling_distribution_MT_GWL_difference.R`: data cleaning, bootstrapping forecasted groundwater declines, generating plots `p1-p4`   
* `02_preprocess_data_for_dashbard`: read in data saved in `01_...` and preprocess scpecifically for JAMstack   
* `03_compare_domestic_and_MT_well_depths.R`: sanity check to ensure domestic well depths coincide with the ranges of groundwater level decline  

`/data`: data used in this project  
`/jamstack`: code and files related to dashboard generation, which is hosted via Jekyll at [github.com/richpauloo/jbp](github.com/richpauloo/jbp)


## Processed data for the app in `shiny/data`:

* `dom_wells.rds`: domestic wells in critical-priority GSAs and within a 28 year retirement age* with selected data (wcr_num, lat, lon, pump_loc_low, pump_loc_up). Derived from [published data here (`domcv6_mean_gw_with_beta_GF_CI.rds`)](https://datadryad.org/stash/dataset/doi:10.25338/B8Q31D). `year` data was removed to reduce file size.
* `gsa.rds`: critical priority GSA polygons (output from `rmapshaper::ms_simplify` to reduce file size) containing monitoring well locations. Output from `code/01_sampling_distribution_MT_GWL.R`.  

## LICENSE

Add MIT
