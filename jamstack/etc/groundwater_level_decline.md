<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">

#### <i class="fas fa-angle-double-right fa-lg"></i> **Interpretation**  

The `Groundwater scenario`s presented in this tool include projected groundwater level decline at:  

* the minimum threshold specified by the GSP  
* declines ranging from 0 - 500 ft relative to the 2019 groundwater level  

To view alternate groundwater level decline scenarios, click the `Groundwater scenario` button on the left-hand sidebar, scroll to the desired scenario, and select it from the list.  

<center>
  ![](etc/gw_button.png)
</center>

<br>

#### <i class="fas fa-angle-double-right fa-lg"></i> **Methods**  

Determination of the 2019 groundwater level and 2040 minimum threshold surface is detailed in Bostic et al. (2020), based upon the kriging model described in Pauloo, et al. (2020) and consistent with Gailey et al., (2019) and EKI (2020). Generally speaking, ordinary kriging with $ln$ transformation and backtransformation was used to estimate groundwater level from unconfined to semi-confined aquifer head measurements reported by [CASGEM](https://water.ca.gov/Programs/Groundwater-Management/Groundwater-Elevation-Monitoring--CASGEM).  

Next, `Groundwater scenario`s ranging from 0 - 500 ft of decline are specified by applying a uniform decline to the 2019 groundwater level. In contrast, the minimum threshold surface is directly kriged from 865 minimum thresholds specified at specific monitoring wells in GSAs (according to critical priority GSPs as of 2020-08-31). Next, for CV as a whole and in each GSA, Minimum Threshold scenarios are related to uniform decline scenarios via bootstrapping (details provided in Bostic et al. (2020)), such that the Minimum Threshold scenario can be interpreted as, and compared against, one of many uniform groundwater level decline scenarios.  

<br>

#### <i class="fas fa-angle-double-right fa-lg"></i> **References**

1. Bostic, _"Sustainable for Whom? The Impact of Groundwater Sustainability Plans on Domestic Wells"_. UC Davis Center for Regional Change. (2020)  
2. [Pauloo, R. A., et al. _"Domestic well vulnerability to drought duration and unsustainable groundwater management in California’s Central Valley."_ Environmental Research Letters 15.4 (2020): 044010.](https://doi.org/10.1088/1748-9326/ab6f10)  
3. [Gailey, Robert M., Jay R. Lund, and Josué Medellín-Azuara. _"Domestic well reliability: evaluating supply interruptions from groundwater overdraft, estimating costs and managing economic externalities."_ Hydrogeology Journal 27.4 (2019): 1159-1182.](https://link.springer.com/article/10.1007/s10040-019-01929-w)  
4. [EKI Environment and Water Inc. _"Groundwater Management and Safe Drinking Water in the San Joaquin Valley: Analysis of Critically Over-drafted Basins' Groundwater Sustainability Plans"_ (2020)]((https://waterfdn.org/wp-content/uploads/2020/06/Groundwater-Management-and-Safe-Drinking-Water-in-the-San-Joaquin-Valley-Brief-6-2020.pdf)  
