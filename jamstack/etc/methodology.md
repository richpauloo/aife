<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">


### **Abstract**  

dsg sdg ds  


**Suggested Citation:**  

*Pauloo, R., Bostic, D., Monaco, A. and Hammond, K. 2021. GSA Well Failure: forecasting domestic well failure in critical priority basins. Berkeley, California. Available at https://www.gsawellfailure.com.*  

<br> 
### **Introduction**  

About 1.5 million residents of California’s Central Valley rely on private domestic wells for drinking water ([Johnson and Belitz, 2016](https://www.sciencedirect.com/science/article/pii/S0048969717317217)), and many of these wells can, and oftentimes do, fail during drought or as the result of unsustainable groundwater management. This project integrates and builds upon the body of existing literature and research to provide estimates of drinking water shortages for underserved populations. Local groundwater sustainability agencies (GSAs) and state regulators may use this information to inform and anticipate the impacts of groundwater sustainability plans (GSPs) on domestic well failure. Consulting firms may use this open model as a baseline for domestic well failure planning, and a jumping off point for more detailed spatial analyses and models.  

This project aims to integrate existing approaches ([Perrone and Jasechko, 2017](https://iopscience.iop.org/article/10.1088/1748-9326/aa8ac0/meta); [Gailey et al., 2019](https://link.springer.com/article/10.1007/s10040-019-01929-w); [Pauloo, et al. 2020](https://iopscience.iop.org/article/10.1088/1748-9326/ab6f10); Bostic, et al. 2020) into a unified, transparent, extensible well failure model. In order to facilitate decision-making and planning for sustainable groundwater management in California we present model estimates in an interactive decision-support tool and make the data and model results available for download to advance well protection planning.  

Importantly, the well failure and cost estimates provided herein (assuming groundwater levels reach specified minimum thresholds in critical priority basins) are consistent with results obtained in previous analyses by [EKI (2020)](https://waterfdn.org/wp-content/uploads/2020/06/Groundwater-Management-and-Safe-Drinking-Water-in-the-San-Joaquin-Valley-Brief-6-2020.pdf), and Bostic et al. (2020).  The well failure model itself is based on the model described in [Pauloo, et al. (2020)](https://iopscience.iop.org/article/10.1088/1748-9326/ab6f10), which is consistent in terms of well failure estimates from the model described by [Gailey et al., 2019](https://link.springer.com/article/10.1007/s10040-019-01929-w).  


<br>
### **Methods and data sources**

#### **Groundwater level**

**(1) Interpolation:**    

**(2) MTs:**  

**(3) Decline scenarios:**  

Determination of the 2019 groundwater level and 2040 minimum threshold surface is detailed in Bostic et al. (2020), based upon the kriging model described in Pauloo, et al. (2020) and consistent with Gailey et al., (2019) and EKI (2020). Generally speaking, ordinary kriging with $ln$ transformation and backtransformation was used to estimate groundwater level from unconfined to semi-confined aquifer head measurements reported by [CASGEM](https://water.ca.gov/Programs/Groundwater-Management/Groundwater-Elevation-Monitoring--CASGEM).  

Next, `Groundwater scenario`s ranging from 0 - 500 ft of decline are specified by applying a uniform decline to the 2019 groundwater level. In contrast, the minimum threshold surface is directly kriged from 865 minimum thresholds specified at specific monitoring wells in GSAs (according to critical priority GSPs as of 2020-08-31). Next, for CV as a whole and in each GSA, Minimum Threshold scenarios are related to uniform decline scenarios via bootstrapping (details provided in Bostic et al. (2020)), such that the Minimum Threshold scenario can be interpreted as, and compared against, one of many uniform groundwater level decline scenarios.  



<br>
#### **Well failure**  

Model based on Pauloo 2020  

We calculate a lower and an upper well failure count to account for uncertainty in estimated pump location. The lower and upper bounds correspond to the 95% confidence interval of the estimated pump location.  

To illustrate, in the figure below, **(A)** fails according to both metrics, **(B)** fails according to the pump location, and **(C)** is active according to both criteria.  

<center>
  <img src="etc/well_failure.png" style="width: 75%">
</center>

As detailed in the `Cost estimate` summary, a well that fails according to pump location triggers a **pumping lowering** event and is lowered to the total completed depth plus the operating margin. If the groundwater then falls below this second depth, a **well deepening** event is triggered.  

Further details on the well failure model are provided in Bostic et al. (2020), which adopts the framework of Pauloo et al. (2020) and bears many critical similarities to the model described by Gailey et al. (2019).  


<br>
#### **Cost estimate**  


A **pump lowering** occurs when the groundwater level falls below the pump location. Pumps are lowered to the total completed depth at a rate of $100/ft, consistent with the methodology of Gailey et al. (2019) and EKI (2020). Wells with lowered pumps can fail again when the groundwater level falls below the total completed depth plus an operating margin of 3 meters, whereupon a net positive suction head cannot be maintained (e.g., Tullis, 1989; Gailey, et al. 2019; Pauloo et al., 2020), and consequently, a **well deepening** is required.  

In this study, **well deepening** event increases the total completed depth of the well by 100 ft, at a cost of $115/ft, consistent with the methodology of Gailey et al. (2019) and EKI (2020).  

We neglect costs associated with increased lift, as these constitute around 1% of total costs (EKI, 2020). We also neglect costs associated with screen cleaning, as this action is unlikely to yield significant additional water when groundwater levels have fallen below pumps.  


<br>
### **Results**



<br>
### **Discussion**


<br>
### **References**

1. Bostic, _"Sustainable for Whom? The Impact of Groundwater Sustainability Plans on Domestic Wells"_. UC Davis Center for Regional Change. (2020)  
2. [Pauloo, R. A., et al. _"Domestic well vulnerability to drought duration and unsustainable groundwater management in California’s Central Valley."_ Environmental Research Letters 15.4 (2020): 044010.](https://doi.org/10.1088/1748-9326/ab6f10)  
3. [Gailey, Robert M., Jay R. Lund, and Josué Medellín-Azuara. _"Domestic well reliability: evaluating supply interruptions from groundwater overdraft, estimating costs and managing economic externalities."_ Hydrogeology Journal 27.4 (2019): 1159-1182.](https://link.springer.com/article/10.1007/s10040-019-01929-w)  
4. [EKI Environment and Water Inc. _"Groundwater Management and Safe Drinking Water in the San Joaquin Valley: Analysis of Critically Over-drafted Basins' Groundwater Sustainability Plans"_ (2020)]((https://waterfdn.org/wp-content/uploads/2020/06/Groundwater-Management-and-Safe-Drinking-Water-in-the-San-Joaquin-Valley-Brief-6-2020.pdf)  
5. Tullis, J. Paul. _"Hydraulics of pipelines: Pumps, valves, cavitation, transients."_ John Wiley & Sons, 1989.  

