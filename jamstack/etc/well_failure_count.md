<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">

#### <i class="fas fa-angle-double-right fa-lg"></i> **Intrepretation**  

The `Well failure count` is the range of domestic wells projected to fail for the selected `GSA`(s) and `Groundwater scenario`.  

The lower estimate can be interpreted as the number of wells that require **well deepening** in order to remain operational, and the higher estimate can be interpreted as the number of wells that require **pump lowering** in order to remain operational. Both **pump lowering** and **well deepening events** are commonly accepted remediation actions in response to well failure (Gailey et al., 2019; EKI, 2020).  

<br>

#### <i class="fas fa-angle-double-right fa-lg"></i> **Methods**  

We calculate a lower and an upper well failure count to account for uncertainty in well completion data (i.e., estimated pump location). The lower and upper bounds correspond to two critical vertical datum per well: the *total completed depth* of the well with an operating margin of 3 meters chosen to maintain a net positive suction head (e.g., Tullis, 1989; Gailey et al., 2019; Pauloo et al., 2020) and the *pump location* estimated by Pauloo et al. (2020).  

Thus, for each `Groundwater scenario`, the _lower_ and _upper_ failure counts represent the number of wells where the groundwater level falls below the:  

* _lower count_: total completed depth plus the operating margin  
* _upper count_: pump location  

In the figure below, **(A)** fails according to both metrics, **(B)** fails according to the pump location, and **&#40;C)** is active according to both criteria.  

<center>
  <img src="etc/well_failure.png" style="width: 75%">
</center>

As detailed in the `Cost estimate` summary, a well that fails according to pump location triggers a **pumping lowering** event, and is lowered to the total completed depth plus the operating margin. If the groundwater then falls below this second depth, a **well deepening** event is triggered.  

Further details on the well failure model are provided in Bostic et al. (2020).  

<br>

#### <i class="fas fa-angle-double-right fa-lg"></i> **References**

1. [Gailey, Robert M., Jay R. Lund, and Josué Medellín-Azuara. "Domestic well reliability: evaluating supply interruptions from groundwater overdraft, estimating costs and managing economic externalities." Hydrogeology Journal 27.4 (2019): 1159-1182.](https://link.springer.com/article/10.1007/s10040-019-01929-w)  
2. [EKI Environment and Water Inc. _"Groundwater Management and Safe Drinking Water in the San Joaquin Valley: Analysis of Critically Over-drafted Basins' Groundwater Sustainability Plans"_ (2020)]((https://waterfdn.org/wp-content/uploads/2020/06/Groundwater-Management-and-Safe-Drinking-Water-in-the-San-Joaquin-Valley-Brief-6-2020.pdf) 
3. Tullis, J. Paul. _"Hydraulics of pipelines: Pumps, valves, cavitation, transients."_ John Wiley & Sons, 1989.  
4. [Pauloo, R. A., et al. _"Domestic well vulnerability to drought duration and unsustainable groundwater management in California’s Central Valley."_ Environmental Research Letters 15.4 (2020): 044010.](https://doi.org/10.1088/1748-9326/ab6f10)  
5. Bostic, "Sustainable for Whom? The Impact of Groundwater Sustainability Plans on Domestic Wells". UC Davis Center for Regional Change. (2020)  

