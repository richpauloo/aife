<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">

#### <i class="fas fa-angle-double-right fa-lg"></i> **Intrepretation**  

The `Groundwater level decline` scenarios project groundwater level decline at:  

* the minimum threshold for the selected GSA(s)  
* declines ranging from 0 ft to 500 ft relative to the 2019 groundwater level  

To view alternate groundwater level decline scenarios, click the `Groundwater scenario` button on the left-hand sidebar, scroll to the desired scenario, and select it from the list.  

<center>
  ![](etc/gw_button.png)
</center>

<br>

#### <i class="fas fa-angle-double-right fa-lg"></i> **Methods**  

Determination of the 2019 groundwater level and 2040 minimum threshold surface is detailed in Bostic et al. (2020), based upon the kriging model described in Pauloo et al. (2020). Generally speaking, ordinary kriging with $ln$ transformation and backtransformation was used to determine groundwater level from unconfined to semi-confined aquifer head measurements made by [CASGEM](https://water.ca.gov/Programs/Groundwater-Management/Groundwater-Elevation-Monitoring--CASGEM).  

Decline scenarios are calculated by applying a uniform decline to the 2019 groundwater level, whereas the minimum threshold surface is directly kriged, then related to uniform decline scenarios via bootstrapping (details provided in [Bostic et al. (2020)](link)).  

<br>

#### <i class="fas fa-angle-double-right fa-lg"></i> **References**

1. [Bostic, rest of citation needed (as well as link)](link)  
2. [Pauloo, R. A., et al. _"Domestic well vulnerability to drought duration and unsustainable groundwater management in California’s Central Valley."_ Environmental Research Letters 15.4 (2020): 044010.](https://doi.org/10.1088/1748-9326/ab6f10)  