# make a map of active and failing wells
f_make_map <- function(l, aoi, plot_title){
  p <- ggplot() + 
    geom_sf(data = cv, fill = "white") +
    geom_sf(data = st_as_sf(aoi)) + 
    geom_sf(data = l, aes(color = high), pch = 20, cex = 0.2, alpha = 0.5) +
    theme_void() +
    labs(fill = "") +
    scale_colour_manual("", values = c("#67a9cf","#ca0020")) +
    theme(legend.position = c(0.25,0.15)) +
    guides(colour = guide_legend(override.aes = list(size = 3, pch = 16, alpha = 0.9))) +
    labs(title = plot_title)
  return(p)
}
