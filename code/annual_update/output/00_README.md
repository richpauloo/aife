# README

Methods to estimate impacts (pump loweing, well deepening, and associated costs) are consistent with gspdrywells.com/#methodology.

Maps in /composite and /single depict the "failn_high" failure count, based on the 90% confidence interval of the ordinary kriging estimate. Alternatively, we can output the "failn_high" failure count, based on the 10% confidence interval of the ordinary kriging estimate.

/composite maps aggregate maps based on 1-yr decline and 2-yr decline. 

/single maps are named after the scenario they represent.

All plots in /composite and /single are provided in .pdf and .png format to streamline editing for the blog post.

/tables contains one table summarizing results across all scenarios tested. Fields are described below:

	- scen: decline scenario name
	- failn_high: high count of well failures based on 90% confidence interval of ordinary kriging estimate  
	- failn_low: low count of well failures based on 10% confidence interval of ordinary kriging estimate  
	- failp_high: high proportion of well failures based on 90% CI (failures / active wells)
	- failp_low: low proportion of well failures based on 10% CI (failures / active wells)
	- cost_high: estimated cost in USD associated with failn_high 
	- cost_low: estimated cost in USD associated with failn_low

Cost methodology is provided in gspdrywells.com/#methodology.
