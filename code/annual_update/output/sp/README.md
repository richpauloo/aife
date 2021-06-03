# README

"WCRNumber"            - well completion report number     
"mean_ci_upper"        - 90% CI of estimated pump location (ft below land surface)
"pump_loc"             - mean estimate of pump location (ft below land surface)
"mean_ci_lower"        - 10% CI of estimated pump location (ft below land surface)
"TotalCompletedDepth"  - total compelted well depth (ft below land surface)
"year"                 - year the well was drilled
"tot_depth_msh"        - total depth plus an operating margin of 30 ft
"gwl_t0"               - depth to groundwater at initial contition (ft below land surface)
"gsa_name"             - name of GSP plan area the well resides within
"gwl"                  - projected groundwater level (ft below land surface)
"high"                 - active/failing well based on 90% CI of ordinary kriging estimate
"lowering_cost_high"   - cost to lower wells based on 90% CI of ordinary kriging estimate ($USD)
"deepening_cost_high"  - cost to deepen wells based on 90% CI of ordinary kriging estimate ($USD)
"low"                  - active/failing well based on 10% CI of ordinary kriging estimate
"lowering_cost_low"    - cost to lower wells based on 10% CI of ordinary kriging estimate ($USD)
"deepening_cost_low"   - cost to deepen wells based on 10% CI of ordinary kriging estimate ($USD)
"total_cost_high"      - cost to lower and deepen wells based on 90% CI of ordinary kriging estimate ($USD)
"total_cost_low"       - cost to lower and deepen wells based on 10% CI of ordinary kriging estimate ($USD)
"x"                    - x coordinate in NAD 83 (EPSG 4269)
"y"                    - y coordinate in NAD 83 (EPSG 4269)
"scen_name"            - name of scenario corresponding to plots