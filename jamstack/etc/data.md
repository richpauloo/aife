<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">


<center>
# **Data download**
</center>


In addition to the web tool data viewer, GSP Well Failure data is available for downloaded via static files and can be accessed programmatically via a scripting language. `R` and `Python` examples below are provided below.  

The well failure model in this study is implemented in `R`, and openly available on <i class="fab fa-github fa-lg" style="color:#be4bdc"></i> <a href = "https://github.com/richpauloo/aife" target = "_blank">Github</a>.  

<br>  


### **Domestic Well Data**  

The Well Completion report database can be downloaded from the California Natural Resources Agency's Online Well Completion Report Database (OSWCR). This DWR database is constantly updated with new records, and new refinements to existing data. Consider accessing this data directly from DWR for the most up-to-date data.   

<a href = "https://data.cnra.ca.gov/dataset/well-completion-reports" target = "_blank>https://data.cnra.ca.gov/dataset/well-completion-reports</a>

<br>

The subset of 15,368 domestic wells considered in this study are provided below.  

[<i class="fa fa-download fa-lg" style="color:#65a2e7"></i> domestic_wells.csv, 2MB](https://github.com/richpauloo/aife/raw/q4-updates/download/domestic_wells.csv.zip)  

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Variable </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> wcr_number </td>
   <td style="text-align:left;"> Well Completion Report Number from the Well Completion report database, <a href = 'https://data.cnra.ca.gov/dataset/well-completion-reports' target = '_blank';>https://data.cnra.ca.gov/dataset/well-completion-reports</a> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mean_ci_upper </td>
   <td style="text-align:left;"> Upper 95% CI of estimated pump location in feet below land surface from Pauloo et al., (2020) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pump_loc </td>
   <td style="text-align:left;"> Estimated pump location in feet below land surface from Pauloo et al., (2020) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mean_ci_lower </td>
   <td style="text-align:left;"> Lower 95% CI of estimated pump location in feet below land surface from Pauloo et al., (2020) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> tot_completed_depth </td>
   <td style="text-align:left;"> Total completed depth of well in feet below land surface from the Well Completion report database <a href = 'https://data.cnra.ca.gov/dataset/well-completion-reports' target = '_blank';>https://data.cnra.ca.gov/dataset/well-completion-reports</a> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gwl_2019 </td>
   <td style="text-align:left;"> Initial groundwater level condition (2019 average) at the well in feet below land surface, calculated via ordinary kriging from ambient seasonal groundwater level measurements in the Periodic Groundwater Level Measurement Database <a href = 'https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements' target = '_blank';>https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements</a> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> gsp_name </td>
   <td style="text-align:left;"> name of the GSP the well is within </td>
  </tr>
  <tr>
   <td style="text-align:left;"> year_drilled </td>
   <td style="text-align:left;"> year the well was drilled </td>
  </tr>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> x coordinate of the well in EPSG 4269 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> y coordinate of the well in EPSG 4269 </td>
  </tr>
</tbody>
</table>


<br>


### **GSP Spatial Boundaries**  

GSP spatial boundaries for the GSPs examined in this study were downloaded from the State of California's GSP Map Viewer, which provides all GSP spatial boundaries in full.   

<a href = "https://sgma.water.ca.gov/webgis/index.jsp?appid=gasmaster&rz=true" target = "_blank>https://sgma.water.ca.gov/webgis/index.jsp?appid=gasmaster&rz=true</a>

The GSPs considered in this study are: *Buena Vista (Kern), Central Kings, Chowchilla, East Kaweah, East Tule, Eastern San Joaquin, Grassland (DM), Greater Kaweah, James (Kings), Kern Groundwater Authority, Kern River, Kings River East, Lower Tule River, Madera Joint, Mc Mullin, Merced, Mid Kaweah, North Fork Kings, North Kings, Northern Central (DM), Pixley (Tule), SJREC (DM), South Kings, Tulare Lake,* and *Westside.*  


<br>



### **Kriged Groundwater Levels and Groundwater Level Measurements**  

Two groundwater level surfaces were developed via ordinary kriging for this study. They include a 2019 groundwater level initial condition, and a minimum threshold surface, as described in the [Methodology](#methodology).  

[<i class="fa fa-download fa-lg" style="color:#65a2e7"></i> gwl_2019.tif, 12KB](https://github.com/richpauloo/aife/raw/q4-updates/download/gwl_2019.tif)

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Variable </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> gwl_2019 </td>
   <td style="text-align:left;"> Initial groundwater level condition representing the average 2019 groundwater level in the GSPs considered in this study. Values reported are in feet below land surface. </td>
  </tr>
</tbody>
</table>

[<i class="fa fa-download fa-lg" style="color:#65a2e7"></i> gwl_mt.tif, 12KB](https://github.com/richpauloo/aife/raw/q4-updates/download/gwl_mt.tif)

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Variable </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> gwl_mt </td>
   <td style="text-align:left;"> Groundwater level condition representing the minimum threshold surface specified by individual monitoring locations in the GSPs reviewed by this study. Values reported are in feet below land surface. </td>
  </tr>
</tbody>
</table>

The 2019 groundwater level initial condition was derived from individual groundwater level measurements available for download in full from the California Natural Resources Agency's Periodic Groundwater Level Measurement Database.  

<a href = "https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements" target = "_blank>https://data.cnra.ca.gov/dataset/periodic-groundwater-level-measurements</a>
 


<br>


### **GSA Well Failure Model Results**  

Well failure model results are available for interactive visual inspection on the [Map](#map) page, and can be downloaded below.  

[<i class="fa fa-download fa-lg" style="color:#65a2e7"></i> well_failure_model_results.csv, 40MB](https://github.com/richpauloo/aife/raw/q4-updates/download/well_failure_model_results.csv.zip)  


<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Variable </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> wcr_number </td>
   <td style="text-align:left;"> Well Completion report number to join to domestic_wells.csv </td>
  </tr>
  <tr>
   <td style="text-align:left;"> high_n </td>
   <td style="text-align:left;"> Well status (active or failing) for the pump location 5% confidence interval at n feet of decline </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lowering_cost_high_n </td>
   <td style="text-align:left;"> Cost in $USD to lower the well for the pump location 5% confidence interval at n feet of decline </td>
  </tr>
  <tr>
   <td style="text-align:left;"> deepening_cost_high_n </td>
   <td style="text-align:left;"> Cost in $USD to deepen the well for the pump location 5% confidence interval at n feet of decline </td>
  </tr>
  <tr>
   <td style="text-align:left;"> low_n </td>
   <td style="text-align:left;"> Well status (active or failing) for the pump location 95% confidence interval at n feet of decline </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lowering_cost_low_n </td>
   <td style="text-align:left;"> Cost in $USD to lower the well for the pump location 95% confidence interval at n feet of decline </td>
  </tr>
  <tr>
   <td style="text-align:left;"> deepening_cost_low_n </td>
   <td style="text-align:left;"> Cost in $USD to deepen the well for the pump location 95% confidence interval at n feet of decline </td>
  </tr>
  <tr>
   <td style="text-align:left;"> total_cost_high_n </td>
   <td style="text-align:left;"> Total cost in $USD to lower and deepen the well for the pump location 5% confidence interval at n feet of decline </td>
  </tr>
  <tr>
   <td style="text-align:left;"> total_cost_low_n </td>
   <td style="text-align:left;"> Total cost in $USD to lower and deepen the well for the pump location 5% confidence interval at n feet of decline </td>
  </tr>
</tbody>
</table>


<br>



### **R data access**  


<div>
<pre>
<code class="r">
library(tidyverse)
library(raster)
library(sf)

# urls
url_dw <- "https://github.com/richpauloo/aife/raw/q4-updates/download/domestic_wells.csv"
url_mr <- "https://github.com/richpauloo/aife/raw/q4-updates/download/well_failure_model_results.csv"
url_g1 <- "/vsicurl/https://github.com/richpauloo/aife/raw/q4-updates/download/gwl_2019.tif"
url_g2 <- "/vsicurl/https://github.com/richpauloo/aife/raw/q4-updates/download/gwl_mt.tif"

# read domestic well data and model results
domestic_wells <- read_csv(url_dw) %>% st_as_sf(coords = c("x", "y"), crs = 4269)
model_results  <- read_csv(url_mr)

# read 2019 groundwater level and MT surface
gwl_2019 <- raster(url_g1)
gwl_mt   <- raster(url_g2)

# the above code may not work depending on how your spatial packages are configured
# in this case, download the files and open them like so:
temp1 <- temp2 <- tempfile()
download.file(url_g1, temp1); download.file(url_g2, temp2)

gwl_2019 <- raster(temp1)
gwl_mt   <- raster(temp2)

</code>
</pre>
</div>

<br>


### **Python data access**  

<div>
<pre>
<code class="python">
import pandas as pd
import rasterio

# urls
url_dw = "https://github.com/richpauloo/aife/raw/q4-updates/download/domestic_wells.csv"
url_mr = "https://github.com/richpauloo/aife/raw/q4-updates/download/well_failure_model_results.csv" 
url_g1 = "/vsicurl/https://github.com/richpauloo/aife/raw/q4-updates/download/gwl_2019.tif"
url_g2 = "/vsicurl/https://github.com/richpauloo/aife/raw/q4-updates/download/gwl_mt.tif"

# read domestic well data and model results
domestic_wells = pd.read_csv(url_dw)
model_results  = pd.read_csv(url_mr)

# read 2019 groundwater level and MT surface
gwl_2019 = rasterio.open(url_g1)
gwl_mt   = rasterio.open(url_g2)

</code>
</pre>
</div>

<br>
<br>


<hr>
<footer>
  <p>Feedback? Contact <a href="mailto:richpauloo@gmail.com">Rich Pauloo</a></p><br>
  <p>© Copyright 2021 Water Data Lab, LLC. <a href = "#terms">Terms of Use</a></p>
</footer>

<br>
<br>