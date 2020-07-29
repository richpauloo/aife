<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">

#### <i class="fas fa-angle-double-right fa-lg"></i> **Intrepretation**  

The `Well failure count` is the range of domestic wells projected to fail for the `selected GSA(s)` and `selected groundwater level decline`.  

The lower estimate can be interpreted as the number of wells that require **well deepening** in order to remain operational, and the higher estimate can be interpreted as the number of wells that require **pump lowering** in order to remain operational.  

<br>

#### <i class="fas fa-angle-double-right fa-lg"></i> **Methods**  

We calculate a lower and an upper well failure count to account for uncertainty in well completion data (i.e., estimated pump location). The lower and upper bounds correspond to two critical vertical datum per well: the *total completed depth* of the well with an operating margin of 3 meters chosen to maintain a net positive suction head (e.g., see Tullis (1989) and Pauloo et al. (2020)), and the *pump depth* (calculated by Pauloo et al. (2020)).  

Thus, for each `groundwater level decline` scenario, the lower and upper failure counts represent the number of wells with groundwater level below the:  

* lower: total completed depth plus the operating margin  
* upper: pump location  

In the figure below, **(A)** fails according to both metrics, **(B)** fails according to the pump location, and **(C)** is active according to both criteria.  

<center>
  <img src="etc/well_failure.png" style="width: 75%">
</center>

Further details are provided in Bostic et al. (2020).  

<br>

#### <i class="fas fa-angle-double-right fa-lg"></i> **References**

1. [Pauloo, R. A., et al. _"Domestic well vulnerability to drought duration and unsustainable groundwater management in California’s Central Valley."_ Environmental Research Letters 15.4 (2020): 044010.](https://doi.org/10.1088/1748-9326/ab6f10)  
2. Tullis, J. Paul. _"Hydraulics of pipelines: Pumps, valves, cavitation, transients."_ John Wiley & Sons, 1989.  
3. [Bostic, rest of citation needed (as well as link)](link)  

