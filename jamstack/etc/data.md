<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-gfdkjb5BdAXd+lj+gudLWI+BXq4IuLW5IT+brZEZsLFm++aCMlF1V92rMkPaX4PP" crossorigin="anonymous">

<center>
# **Data download**
</center>


In addition to the web tool data viewer, GSA Well Failure data is available for downloaded via static files and can be accessed programmatically via a scripting language. `R` and `Python` examples below are provided below.  

The well failure model in this study is implemented in `R`, and openly available on <i class="fab fa-github fa-lg" style="color:#be4bdc"></i> <a href = "https://github.com/richpauloo/aife" target = "_blank">Github</a>.  

<br>  


### **Domestic Well Data**  

The Well Completion report database can be downloaded from the California Natural Resources Agency's Online Well Completion Report Database (OSWCR).  

<a href = "https://data.cnra.ca.gov/dataset/well-completion-reports" target = "_blank>https://data.cnra.ca.gov/dataset/well-completion-reports</a>

<br>

The subset of 15,368 domestic wells considered in this study, unfiltered for retirement age, are provided below.  

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
   <td style="text-align:left;"> name of the GSA the well is within </td>
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


### **GSA Spatial Boundaries**  

GSA spatial boundaries for the GSAs examined in this study were downloaded from the State of California's GSA Map Viewer, which provides all GSA spatial boundaries in full.   

<a href = "https://sgma.water.ca.gov/webgis/index.jsp?appid=gasmaster&rz=true" target = "_blank>https://sgma.water.ca.gov/webgis/index.jsp?appid=gasmaster&rz=true</a>

The GSAs considered in this study are: *Buena Vista (Kern), Central Kings, Chowchilla, East Kaweah, East Tule, Eastern San Joaquin, Grassland (DM), Greater Kaweah, James (Kings), Kern Groundwater Authority, Kern River, Kings River East, Lower Tule River, Madera Joint, Mc Mullin, Merced, Mid Kaweah, North Fork Kings, North Kings, Northern Central (DM), Pixley (Tule), SJREC (DM), South Kings, Tulare Lake,* and *Westside.*  


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
   <td style="text-align:left;"> Initial groundwater level condition representing the average 2019 groundwater level in the GSAs considered in this study. Values reported are in feet below land surface. </td>
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

<center>
<iframe scrolling = "no"
  src="https://carbon.now.sh/embed?bg=rgba%28242%2C242%2C242%2C1%29&t=material&wt=none&l=r&ds=false&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=56px&ph=56px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code=library%28tidyverse%29%250Alibrary%28raster%29%250Alibrary%28sf%29%250A%250A%2523%2520urls%250Aurl_dw%2520%253C-%2520%2522https%253A%252F%252Fgithub.com%252Frichpauloo%252Faife%252Fraw%252Fq4-updates%252Fdownload%252Fdomestic_wells.csv%2522%250Aurl_mr%2520%253C-%2520%2522https%253A%252F%252Fgithub.com%252Frichpauloo%252Faife%252Fraw%252Fq4-updates%252Fdownload%252Fwell_failure_model_results.csv%2522%250Aurl_g1%2520%253C-%2520%2522%252Fvsicurl%252Fhttps%253A%252F%252Fgithub.com%252Frichpauloo%252Faife%252Fraw%252Fq4-updates%252Fdownload%252Fgwl_2019.tif%2522%250Aurl_g2%2520%253C-%2520%2522%252Fvsicurl%252Fhttps%253A%252F%252Fgithub.com%252Frichpauloo%252Faife%252Fraw%252Fq4-updates%252Fdownload%252Fgwl_mt.tif%2522%250A%250A%2523%2520read%2520domestic%2520well%2520data%2520and%2520model%2520results%250Adomestic_wells%2520%253C-%2520read_csv%28url_dw%29%2520%2525%253E%2525%2520st_as_sf%28coords%2520%253D%2520c%28%2522x%2522%252C%2520%2522y%2522%29%252C%2520crs%2520%253D%25204269%29%250Amodel_results%2520%2520%253C-%2520read_csv%28url_mr%29%250A%250A%2523%2520read%25202019%2520groundwater%2520level%2520and%2520MT%2520surface%250Agwl_2019%2520%253C-%2520raster%28url_g1%29%250Agwl_mt%2520%2520%2520%253C-%2520raster%28url_g2%29%250A%250A%2523%2520they%2520above%2520code%2520may%2520not%2520work%2520depending%2520on%2520how%2520your%2520spatial%2520packages%2520are%2520configured%250A%2523%2520in%2520this%2520case%252C%2520download%2520the%2520files%2520and%2520open%2520them%2520like%2520so%253A%250Atemp1%2520%253C-%2520temp2%2520%253C-%2520tempfile%28%29%250Adownload.file%28url_g1%252C%2520temp1%29%253B%2520download.file%28url_g2%252C%2520temp2%29%250A%250Agwl_2019%2520%253C-%2520raster%28temp1%29%250Agwl_mt%2520%2520%2520%253C-%2520raster%28temp2%29"
  style="width: 1001px; height: 636px; border:0; transform: scale(1); overflow:hidden;"
  sandbox="allow-scripts allow-same-origin">
</iframe>
</center>


<br>

### **Python data access**  

<center>
<iframe scrolling = "no"
  src="https://carbon.now.sh/embed?bg=rgba%28242%2C242%2C242%2C1%29&t=material&wt=none&l=python&ds=false&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=56px&ph=56px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code=import%2520pandas%2520as%2520pd%250Aimport%2520rasterio%250A%250A%2523%2520urls%250Aurl_dw%2520%253D%2520%2522https%253A%252F%252Fgithub.com%252Frichpauloo%252Faife%252Fraw%252Fq4-updates%252Fdownload%252Fdomestic_wells.csv%2522%250Aurl_mr%2520%253D%2520%2522https%253A%252F%252Fgithub.com%252Frichpauloo%252Faife%252Fraw%252Fq4-updates%252Fdownload%252Fwell_failure_model_results.csv%2522%2520%250Aurl_g1%2520%253D%2520%2522%252Fvsicurl%252Fhttps%253A%252F%252Fgithub.com%252Frichpauloo%252Faife%252Fraw%252Fq4-updates%252Fdownload%252Fgwl_2019.tif%2522%250Aurl_g2%2520%253D%2520%2522%252Fvsicurl%252Fhttps%253A%252F%252Fgithub.com%252Frichpauloo%252Faife%252Fraw%252Fq4-updates%252Fdownload%252Fgwl_mt.tif%2522%250A%250A%2523%2520read%2520domestic%2520well%2520data%2520and%2520model%2520results%250Adomestic_wells%2520%253D%2520pd.read_csv%28url_dw%29%250Amodel_results%2520%2520%253D%2520pd.read_csv%28url_mr%29%250A%250A%2523%2520read%25202019%2520groundwater%2520level%2520and%2520MT%2520surface%250Agwl_2019%2520%253D%2520rasterio.open%28url_g1%29%250Agwl_mt%2520%2520%2520%253D%2520rasterio.open%28url_g2%29"
  style="width: 1001px; height: 474px; border:0; transform: scale(1); overflow:hidden;"
  sandbox="allow-scripts allow-same-origin">
</iframe>
<center>

<br>
<br>


<hr>
<footer>
  <p>Feedback? Contact <a href="mailto:richpauloo@gmail.com">Rich Pauloo</a></p><br>
  <p>© Copyright 2021 Water Data Lab, LLC. <a href = "#terms">Terms of Use</a></p>
</footer>

<br>
<br>