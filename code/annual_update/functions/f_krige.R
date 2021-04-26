# krige groundwater elevation
f_krige <- function(d, g, aoi){

  # fix sets of overlapping points
  # index of sets 1 and 2: wells wtih an overlapping observation
  s1 <- get_set(d, 1) 
  s2 <- get_set(d, 2) 
  
  # get parallel minima of overlapping points
  min_list_mt = pmin(d[s1, ]$wse_ft, d[s2, ]$wse_ft)
  
  # replace DGBS of set 2 wells wtih average of set 1 and 2
  d[s2, "wse_ft"] <- min_list_mt
  
  # remove set 1 wells
  d <- d[-s1, ]
  
  # rm extreme values
  d <- d %>% f_remove_outliers()
  # d <- d[d@data$wse_ft > quantile(d@data$wse_ft, 0.1) &
  #        d@data$wse_ft < quantile(d@data$wse_ft, 0.9), ]
  # hist(d$wse_ft)
  
  # # depth below land surface
  # gs <- gstat(formula = wse_ft ~ 1, # spatial data -- fit xy as idp vars
  #             locations = d)        # groundwater monitoring well locations 
  # 
  # v <- variogram(gs,              # gstat object
  #                width = 5)     # lag distance
  # plot(v)                         # check for range and patial sill and input below
  # fve <- fit.variogram(v,         # takes `gstatVariogram` object
  #                      vgm(5000,   # partial sill: semivariance at the range
  #                          "Sph", # linear model type
  #                          100, # range: distance where model first flattens out
  #                          300))   # nugget: semivariance at the y-intercept
  # 
  # # plot variogram and fit
  # plot(v, fve)
  # 
  # # ordinary kriging 
  # kp <- krige(wse_ft ~ 1, d, g, model = fve)
  # spplot(kp)
  kp <- automap::autoKrige(wse_ft ~ 1, d, g)
  ok <- brick(kp$krige_output)[[1:2]]
  
  # covert to raster brick and crop to area of interest
  # ok <- brick(kp)                          # spatialgrid df -> raster brick 
  ok <- mask(ok, aoi)                      # mask to aoi extent
  names(ok) <- c('prediction', 'variance') # name raster layers in brick
  
  # add CIs
  ok$ci_upper_90 <- ok$prediction + (1.645 * sqrt(abs(ok$variance)))
  ok$ci_lower_90 <- ok$prediction - (1.645 * sqrt(abs(ok$variance)))
  
  # base R
  # plot(ok$prediction)
  # contour(ok$prediction, add=TRUE, nlevels=25)
  # plot(spTransform(as(cv, "Spatial"), TA), add=TRUE)
  # plot(d, add=TRUE, pch = 16, cex = 1, col="red")
  
  return(list(ok, kp$exp_var, kp$var_model))
  
}
