<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">

<center>
# **Science and Methodology**
</center>

<br>
## **Abstract**  

Millions of Californians rely on drinking water obtained from private domestic wells, which are vulnerable to drought and unsustainable groundwater management. Groundwater planning under the Sustainable Groundwater Management Act (SGMA) aims to curb the chronic lowering of groundwater levels, which is known to increase domestic well failure. However, SGMA planning is decentralized, and thus, it is difficult to anticipate regional scale impacts to domestic wells resulting from water management decisions across numerous independent agencies. Here, we compile the minimum thresholds specified in the groundwater sustainability plans (GSPs) from 25 groundwater sustainability agencies (GSAs) in "critical priority" basins, and estimate the magnitude, spatial distribution, and cost of domestic well failure that would result if minimum thresholds are reached. Well failures are quantified and characterized in order to support the assessment of whether such failures are significant and unreasonable, and to inform the development of well protection programs. Additionally, we evaluate well failures under uniform groundwater level decline ranging from 10 to 300 ft below the average 2019 groundwater level in order to present alternative management scenarios that may be compared against the minimum threshold scenario. In the critical priority basins we examined, we observe significant domestic well failure if minimum thresholds are reached that range from 12-99% failure in individual GSAs. Well failure across all GSAs combined under specified minimum thresholds is estimated to be 61-63%, or 9,281 - 9,651 domestic well failures at a cost of $109.2 - 115.8M. Well failure is most severe in areas where groundwater levels are already low due to historical overdraft, and where large concentrations of relatively shallow domestic wells are located. Possible well protection measures include regional groundwater supply and demand management (e.g., managed aquifer recharge and pumping curtailments that increase groundwater levels), well protection funds that internalize well refurbishment and replacement costs, and domestic supply management, (e.g., connecting rural households to more reliable municipal water systems).

<br>
**Suggested Citation:**  

*Pauloo, R., Bostic, D., Monaco, A. and Hammond, K. 2021. GSA Well Failure: forecasting domestic well failure in critical priority basins. Berkeley, California. Available at https://www.gsawellfailure.com. (Date Accessed)*

<br> 
## **Introduction**  

Around 1.5 million Californians depend on private domestic wells for drinking water, about one third of which live in the Central Valley (CV) (Johnson and Belitz 2016). Private domestic wells in California's CV are more numerous than other types of wells (e.g., public or agricultural), and tend to be shallower and have smaller pumping capacities, which makes them more vulnerable to failure due to groundwater level decline (Theis 1935; Theis 1940; Sophocleous 2020; Greene 2020; Perrone and Jasechko 2019).

During previous droughts in California, increased demand for water has led to well drilling and groundwater pumping to replace lost surface water supplies (Hanak et al 2011; Medellín-Azuara et al 2016). Increased pumping lowers groundwater levels and may partially dewater wells or cause them to go dry (fail) altogether. During the 2012–2016 drought, 2,027 private domestic drinking water wells in California's CV were reported dry (Cal OPR 2018). Despite the social and economic value of domestic wells, and the clear linkages of well failure to regional groundwater development, few solutions and data products exist that address the vulnerability of private domestic wells to drought and unsustainable groundwater management (Mitchell et al. 2017; Feinstein et al. 2017).

The lack of well failure research in California until recent years is largely because well location and construction data (well completion reports, or WCRs) were only recently made public in 2017. The released digitized WCRs span over one hundred years in California drilling history and informed the first estimates of domestic well spatial distribution and count in the state (Johnson and Belitz 2015; Johnson and Belitz 2017). Since then, these WCRs, provided in the California Online State Well Completion Report Database (CA-DWR 2018), have been used to estimate failing well locations and counts (Perrone and Jasechko 2017), well depths (Perrone and Jasechko 2019), domestic well water supply interruptions during the 2012–2016 drought due to overpumping, and the costs to replenish lost domestic water well supplies (Gailey et al 2019). Recently, a regional aquifer scale domestic well failure model for the Central Valley was developed by Pauloo et al (2020) that simulated the impact of drought and various groundwater management regimes on domestic well failure. In this work, we extend the model developed by Pauloo et al (2020) to estimate well failures in critical priority groundwater basins in California.

California's snowpack is forecasted to decline by as much as 79.3% by the year 2100 (Rhoades et al 2018). Drought frequency in California's southern CV, also the location of greatest domestic well density, may increase by more than 100% (Swain et al 2018). A drier and warmer climate (Diffenbaugh 2015; Cook 2015) with more frequent heat waves and extended droughts (Tebaldi et al 2006; Lobell et al 2011) will coincide with the implementation of the Sustainable Groundwater Management Act (SGMA 2014), in which critical priority basins have already submitted groundwater sustainability plans (GSPs) that specify groundwater level minimum thresholds. These minimum thresholds signify the groundwater elevation at which undesirable impacts to beneficial users of groundwater, such as domestic wells, are anticipated to occur. Although methodological approaches to estimate well failure exist today, these were not widely understood during the development of GSPs in critical priority basins, and hence, a basic understanding of how groundwater minimum thresholds will impact well failure was unknown during the planning process. Two recent studies have shown that widespread and significant domestic well failure would result if minimum thresholds were reached in critical priority basins. 

In this research, we predict the spatial distribution, count, and cost of domestic well failure in California's critical priority basins, focusing on groundwater sustainability agencies (GSAs) as our unit of observation. We also evaluate uniform groundwater level decline scenarios from a roughly present day (2019) average groundwater level to compare the impact of these alternate management scenarios. Lastly, we compare our results to those of Bostic et al (2020), and EKI (2020) then provide a [dataset of our findings](#data) to enable further analysis and incorporation of domestic well protection measures (Islas et al, 2020) into ongoing GSP development and planning over the SGMA implementation period.  


<br>
## **Methods and data sources**

We well completion reports from 943,469 wells from the <a href = "https://data.ca.gov/dataset/well-completion-reports" target = "_blank">California Department of Water Resources</a> (CA-DWR 2018), seasonal groundwater level measurements (CA-DWR 2020) from the year 2019 in the <a href = "https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements" target = "_blank">CA-DWR Periodic Groundwater Level Measurement database</a>, and minimum thresholds reported at representative monitoring points specified in GSPs submitted in critical priority basins.


### **Groundwater level**

We estimate the groundwater depth below land surface in the unconfined to semiconfined aquifer system for measurements taken at an initial condition (2019), and the reported minimum thresholds at representative monitoring points specified in GSPs submitted in critical priority basins. 

The average 2019 groundwater level initial condition is based on seasonal (spring and fall) groundwater level measurements (CA-DWR 2020) and reflect the aquifer system from which many domestic wells draw water from. The minimum threshold surface was determined by reviewing 41 GSPs and 973 unique monitoring wells with specified minimum thresholds, detailed in (Bostic et al 2020).

We log-transformed and applied ordinary kriging to the 2019 and minimum threshold groundwater level measurements to normalize the data distribution, suppress outliers, and improve data stationarity (Deutsch C.V. and Journel 1992; Varouchakis 2012). Since the expected value of back-transformed log-normal kriging estimates is biased (not equal to the sample mean), we apply a correction (Laurent 1963; Journel A.G. and Huijbregts 1978):  

$$
    g = k_0 \cdot exp \Big[ ln(\hat{g}_{OK}) + \frac{\sigma^2_{OK}}{2} \Big]
$$

Where $g$ is the corrected and back-transformed groundwater level, $\hat{g}_{OK}$ is the ordinary kriging estimate, $\sigma^2_{OK}$ is the kriging variance, and $k_0$ is the correction factor, proportional to the ratio of the mean of the sample values to the mean of the back-transformed kriging estimates.  

Thus, we generate two surfaces: an initial condition representing 2019 average conditions, and a final condition representing the minimum threshold. 

Lastly, we define a set of 31 uniform groundwater level decline scenarios ranging from 0 to 300 feet, which we subtract from the 2019 groundwater level. In contrast, the minimum threshold surface is directly kriged from 865 minimum thresholds specified at specific monitoring wells in GSAs. The uniform decline scenarios are used to evaluate the well failure that would result from the given amount of groundwater level decline, and may be compared to the minimum threshold scenario, as well as other decline scenarios to facilitate informed decision making. 



### **Classification of failing wells and cost estimate**

The initial set of wells to consider are a subset (n = 15,368) of all domestic wells. Wells are removed based on the year in which they were constructed, and their estimated pump location relative to the initial groundwater level condition. 

Two previous studies estimate well retirement ages at 28 years in the Central Valley (Pauloo et al 2020), and 33 years in Tulare county (Gailey et al 2019), thus, we use the average of these two studies and remove wells older than a retirement age of 31 years.  

Wells dewater and experience reduced yield when the groundwater level approaches the level of the pump. However, for the purposes of this study, we assumed wells maintain net positive suction head (Tullis 1989) required for wells to provide uninterrupted flow until groundwater falls below the estimated pump location. Pump locations and associated 5 and 95% confidence intervals are estimated via a linear model at the Bulletin 118 subbasin scale for all domestic wells in the WCR database, as detailed in Pauloo et al, 2020. The initial set of wells to consider omits wells with a pump location shallower than the 2019 groundwater level initial condition -- these wells are not considered because they are dry at the initial condition.

The set of 15,368 initial wells, neglecting retired wells and wells dry at the 2019 groundwater level initial condition, are all initially considered active.

Next, we distinguish between two classes of well status: *active* and *failing*. We evaluate well failure at the minimum threshold surface, and at 30 uniform decline scenarios ranging from 10-300 ft below the 2019 initial condition. Active wells have a pump location deeper than the groundwater level and failing wells have a pump location shallower than the groundwater level. We propagate uncertainty from the pump location estimate via the 5 and 95% confidence intervals of pump location into the estimate of failing and active wells.  

<br>  
<center>
<div id = "content-desktop">
  <img src="etc/well_failure.png" style="width: 50%">
</div>
<div id = "content-mobile">
  <img src="etc/well_failure.png" style="width: 100%">
</div>
</center>

<i>Figure 1: A conceptual model of well failure from Pauloo et al, 2020. (A) groundwater level is shallower than the pump location of the two wells and both are active, (B) the shallower well fails because the groundwater level falls below the level of the pump, but the deep well remains active.</i>

<br>  

In order to compute costs, we consider that *failing* wells differ in the remaining depth between the pump location and the total completed depth of the well. Once a well fails, it is assumed that the remediation action of lowering the pump to the total completed depth of the well takes place, at a cost of USD \$100 / ft. If the groundwater level falls below the total completed depth of the well plus an operating margin of 30 ft, a second remediation action is assumed to take place, and the well is deepened by 100 ft at a cost of USD \$115/ft. These costs are derived from well failure studies by Gailey et al., 2019 and EKI, 2020. 

We neglect costs associated with increased lift, as these constitute around 1% of total costs estimated by EKI, 2020. We also neglect costs associated with screen cleaning, as this action is unlikely to yield significant additional water when groundwater levels have fallen below pumps.  


<br>
## **Results**

In the critical priority basins examined in this research, we estimate significant domestic well failure if minimum thresholds are reached. On the order of 12-99% wells are projected to fail in individual GSAs, and well failure across all GSAs combined is estimated to be 61-63%, or 9,281 - 9,651 domestic well failures, at a cost of $109.2 - 115.8M. Well failure is most severe in areas where groundwater levels are already low due to historical overdraft, and where large concentrations of relatively shallow domestic wells are located.

There is a wide range in the difference between minimum thresholds across GSAs. Some GSAs have set minimum thresholds relatively deep compared to 2019 conditions, whereas others have been more conservative and set shallower minimum thresholds which generally lead to lower estimated well failures. 

The 2019 groundwater level initial condition, the minimum threshold surface, and the locations of estimated active and failing wells per scenario are available in the [interactive map](#map) on the GSA Well Failure web dashboard. Users can select a groundwater sustainability agency to focus on results for a particular management zone, and a groundwater level decline scenario ranging from the minimum threshold, to 0-300 feet of decline relative to the 2019 initial condition. All of the input data and output model results are available for download on the [data tab](#data) as csv files. Users can also automate the data retrieval of these data via `R` or `Python`. The current <a href = "https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements" target = "_blank">CA-DWR Periodic Groundwater Level Measurement database</a> is available online for download from the California Department of Water Resources.



<br>
## **Discussion**

Domestic wells, particularly in California's Central Valley, tend to be privately owned and adjacent to or within areas of concentrated groundwater extraction for agricultural and municipal use. Due to their relatively shallow depth, these wells are vulnerable to failing when water levels decline due to drought or unsustainable management. With the passage of the Sustainable Groundwater Management Act, local groundwater sustainability agencies will develop sustainable management criteria including minimum thresholds and objectives, codified in monitoring networks that are intended to measure progress towards, or deviance from, sustainability goals. These sustainable management criteria may or may not include domestic wells, owing to a lack of data, models, and systemic understanding. 

Our estimates of domestic well failure count, percentage, and cost agree with other studies (Table 1). Notably, even though the three studies use have different initial well counts, they arrive at similar well failure precents. The nearly threefold higher cost estimate upper range estimated by EKI (2020) compared to this study's metric may be explained by the additional wells considered, and to a less extent, because this study did not consider screen cleaning and increased lift costs. Differences in well failure count estimates may be attributed to the initial set of wells considered, groundwater level initial condition, well retirement age, and the threshold at which failures are evaluated (e.g., pump location, total completed depth, total completed depth plus an operating margin). It is critical for future modeling efforts that these parameters are understood, standardized, and evaluated in terms of their sensitivity on model output. Nonetheless, across all studies, estimated well failures assuming minimum thresholds are reached range from the thousands to just over ten thousand, and may come at a cost of $1-3 or more million USD.  

<br>  

<i>Table 1: Comparison of well failure statistics across three studies, including this one, that estimate domestic well failure in critical priority basins, assuming the specified minimum threshold is reached.</i>

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;" width = "100%;">
 <thead>
  <tr>
   <th style="text-align:left;"> Study </th>
   <th style="text-align:left;"> Retirement age (yrs) </th>
   <th style="text-align:left;"> Groundwater level initial condition (yr) </th>
   <th style="text-align:left;"> Initial well count </th>
   <th style="text-align:left;"> Well failure count </th>
   <th style="text-align:left;"> Well failure percentage </th>
   <th style="text-align:left;"> Estimated Cost ($M USD) </th>
   <th style="text-align:left;"> Count of people impacted </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> this study </td>
   <td style="text-align:left;"> 31 </td>
   <td style="text-align:left;"> 2019 </td>
   <td style="text-align:left;"> 15,368 </td>
   <td style="text-align:left;"> 9,281-9651 </td>
   <td style="text-align:left;"> 61-63% </td>
   <td style="text-align:left;"> 109-115 </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bostic et al (2020) </td>
   <td style="text-align:left;"> 29 </td>
   <td style="text-align:left;"> 2019 </td>
   <td style="text-align:left;"> 8,206 </td>
   <td style="text-align:left;"> 5,416 </td>
   <td style="text-align:left;"> 66% </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 55,698-222,792 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EKI (2020) </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 24,500 </td>
   <td style="text-align:left;"> 12,000 </td>
   <td style="text-align:left;"> 49% </td>
   <td style="text-align:left;"> 88-359 </td>
   <td style="text-align:left;"> 106,000-127,000 </td>
  </tr>
</tbody>
</table>

<br>  

To support efforts to protect domestic wells, the input data and modeling results are made available on the [data](#data) page, and the `R` code that implements this model is available on <a href = "https://github.com/richpauloo/aife" target = "_blank">Github</a>.


<br>
## **Conclusion**

This study suggests that minimum thresholds for groundwater level set in critical priority basins may lead to thousands of well failures over the SGMA implementation time period from the present day through 2040. However, groundwater sustainability plans in these basins may not estimate well failure or define well protection plans or project management actions that address well failure. Estimated domestic well failure and refurbishment or replacement costs across the implementation time horizon may be small in comparison to the economic value of groundwater, yet studies linking these quantities are lacking. Possible project management actions to protect wells include regional groundwater supply and demand management (e.g., managed aquifer recharge and pumping curtailments to increase groundwater levels), well protection funds to cover well refurbishment and replacement costs, and domestic supply management, such as connecting households to reliable municipal water systems.


<br>
## **Acknowledgements**

This work is made possible with support from the AI for Earth Innovation Program Grant provided by Global Wildlife Conservation and Microsoft Corporation (<a href = "https://www.globalwildlife.org/press/winners-of-ai-for-earth-innovation-grants-poised-to-address-urgent-environmental-challenges-with-creative-use-of-technology/" target = "_blank">see press release</a>).  


<br>
## **References**

[1] <a href = "https://pacinst.org/publication/sustainable-for-whom/" target = "_blank">Bostic, D., Dobbin, K., Pauloo, R., Mendoza, J., Kuo, M., and London, J. (2020). Sustainable for Whom? The Impact of Groundwater Sustainability Plans on Domestic Wells. UC Davis Center for Regional Change.</a>

[2] <a href = "https://data.cnra.ca.gov/dataset/well-completion-reports" target = "_blank">CA-DWR. (2018). California Online State Well Completion Report Database. Available at: https://data.cnra.ca.gov/dataset/well-completion-reports. Accessed January 1, 2018</a>

[3] <a href = "https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements" target = "_blank">CA-DWR. (2020) Periodic Groundwater Level Measurement database. Available at: https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements. Accessed March 1, 2020</a>

[4] CA-OPR (2018). Observed domestic well failures during 2012-2016 drought dataset obtained via an agreement with the California Governor’s Office of Planning and Research. Sacramento, CA. Accessed May 6, 2018  

[5] Deutsch, C. V., & Journel, A. G. (1992). _Geostatistical software library and user’s guide_. New York, 119(147).

[6] Diffenbaugh, N. S., Swain, D. L., & Touma, D. (2015). Anthropogenic warming has increased drought risk in California. _Proceedings of the National Academy of Sciences_, 112(13), 3931-3936.

[7] <a href = "https://waterfdn.org/wp-content/uploads/2020/06/Groundwater-Management-and-Safe-Drinking-Water-in-the-San-Joaquin-Valley-Brief-6-2020.pdf" target = "_blank">EKI Environment and Water Inc. (2020). Groundwater Management and Safe Drinking Water in the San Joaquin Valley: Analysis of Critically Over-drafted Basins' Groundwater Sustainability Plans.</a>

[8] Feinstein, L., Phurisamban, R., Ford A., Tyler, C., and Crawford, A. (2017). Drought and Equity in California Drought and Equity in California. Pacific Institute. Oakland, CA. 

[9] Gailey, R.M., Lund, J., and Medellín-Azuara., J. (2019). Domestic well reliability: evaluating supply interruptions from groundwater overdraft, estimating costs and managing economic externalities. _Hydrogeology Journal_, 27.4 1159-1182. 

[10] Greene C., Climate vulnerability, Drought, Farmworkers, Maladaptation, Rural communities. (2018). _Environmental Science and Policy_ 89283–291. ISSN 18736416.

[11] Hanak, E., Lund, J., Dinar, A., Gray, B., and Howitt, R. (2011). Managing California’s  Water: From Conflict to Reconciliation. Public Policy Institute of California. ISBN9781582131412. 

[12] <a href = "https://d3n8a8pro7vhmx.cloudfront.net/communitywatercenter/pages/3928/attachments/original/1590776730/Well_Mitigation_Print.pdf?1590776730" target = "_blank">Islas, A., Monaco, A., Ores, D. (2020) Framework for a Drinking Water Well Impact Mitigation Program. Self Help Enterprises.</a>

[13] Johnson, T. D., & Belitz, K. (2015). Identifying the location and population served by domestic wells in California. _Journal of Hydrology: Regional Studies_, 3, 31-86.

[14] Johnson, T. D., & Belitz, K. (2017). Domestic well locations and populations served in the contiguous US: 1990. _Science of The Total Environment_, 607, 658-668.

[15] Journel, A. G., & Huijbregts, C. J. (1978). _Mining geostatistics_ (Vol. 600). London: Academic press.

[16] Laurent, A. G. (1963). The lognormal distribution and the translation method: description and estimation problems. _Journal of the American Statistical Association_, 58(301), 231-235.

[17] Lobell, D. B., Schlenker, W., & Costa-Roberts, J. (2011). Climate trends and global crop production since 1980. _Science_, 333(6042), 616-620.

[18] Lopez, A., Tebaldi, C., New, M., Stainforth, D., Allen, M., & Kettleborough, J. (2006). Two approaches to quantifying uncertainty in global temperature changes. _Journal of Climate_, 19(19), 4785-4796.

[19] Medellín-Azuara, J., MacEwan, D., Howitt, R., Sumner, D.A., Lund, J., Scheer, J., Gailey, R., Hart, Q., Alexander, N.D., and Arnold B. (2016). Economic Analysis of the California Drought on Agriculture: A report for the California Department of Food and Agriculture. Center for Watershed Sciences, University of California Davis. Davis, CA. 

[20] Mitchell, D., Hanak, E., Baerenklau, K., Escriva-Bou, A., Mccann, H., Pérez-Urdiales, M., and Schwabe, K. (2017). Building Drought Resilience in California's Cities and Suburbs. Public Policy Institute of California. SAn Francisco, CA. 

[21] Pauloo, R., Fogg, G., Dahlke, H., Escriva-Bou, A., Fencl, A., and Guillon, H. (2020). Domestic well vulnerability to drought duration and unsustainable groundwater management in California’s Central Valley. _Environmental Research Letters_, 15.4 044010

[22] Perrone, D., & Jasechko, S. (2017). Dry groundwater wells in the western United States. _Environmental Research Letters_, 12(10), 104002.

[23] Perrone, D. and Jasechko, S., Deeper well drilling an unsustainable stopgap to groundwater depletion. (2019). _Nature Sustainability_, 2773–782 

[24] Rhoades, A. M., Jones, A. D., & Ullrich, P. A. (2018). The changing character of the California Sierra Nevada as a natural reservoir. _Geophysical Research Letters_, 45(23), 13-008.

[25] Sophocleous M., From safe yield to sustainable development of water resources—the Kansas experience., (2000). _Journal of Hydrology_, 23527–43.   

[26] Sustainable Groundwater Management Act. (2014). California Water Code sec. 10720-10737.8

[27] Swain, D. L., Langenbrunner, B., Neelin, J. D., & Hall, A. (2018). Increasing precipitation volatility in twenty-first-century California. _Nature Climate Change_, 8(5), 427-433.

[28] Theis, C.V., (1935). The relation between the lowering of the piezometric surface and the rate and duration of discharge of a well using ground-water storage., Eos, _Transactions American Geophysical Union_, 16519–52. 

[29] Theis, C.V., (1940). The source of water derived from wells., _Civil Engineering_, 10277–280. 

[30] Tullis, J. Paul. (1989). Hydraulics of pipelines: Pumps, valves, cavitation, transients. John Wiley & Sons.  

[31] Williams, A. P., Seager, R., Abatzoglou, J. T., Cook, B. I., Smerdon, J. E., & Cook, E. R. (2015). Contribution of anthropogenic warming to California drought during 2012–2014. _Geophysical Research Letters_, 42(16), 6819-6828.

[32] Varouchakis, E. A., Hristopulos, D. T., & Karatzas, G. P. (2012). Improving kriging of groundwater level data using nonlinear normalizing transformations—a field application. _Hydrological Sciences Journal_, 57(7), 1404-1419.


<br>
<br>
<br>
<br>


<hr>
<footer>
  <p>Feedback? Contact <a href="mailto:richpauloo@gmail.com">Rich Pauloo</a></p><br>
  <p>© Copyright 2021 Water Data Lab, LLC. <a href = "#terms">Terms of Use</a></p>
</footer>

<br>
<br>
