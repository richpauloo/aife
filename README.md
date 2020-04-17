# [Project title from grant]

Rich Pauloo, PhD [email]
Darcy Bostic, MS [email]

Project repository for [project title with link], supported by the Microsfot AI for Earth Grant [link to press release], [link to grant number webpage if applicable].  

***

## Overview

## Repository notes

## Processed data for the app in `shiny/data`:

* `dom_wells.rds`: domestic wells in critical-priority GSAs and within a 28 year retirement age* with selected data (wcr_num, lat, lon, pump_loc_low, pump_loc_up). Derived from [published data here (`domcv6_mean_gw_with_beta_GF_CI.rds`)](https://datadryad.org/stash/dataset/doi:10.25338/B8Q31D). `year` data was removed to reduce file size.
* `gsa.rds`: critical priority GSA polygons (output from `rmapshaper::ms_simplify` to reduce file size) containing monitoring well locations. Output from `code/01_sampling_distribution_MT_GWL.R`.  

## `SessionInfo()`

```
update this from the final shiny server 
```

* following [Pauloo, et al. (2020)](https://iopscience.iop.org/article/10.1088/1748-9326/ab6f10)