# some archived messy code that contains the png github appraoch to 
# rendering ggplots in leaflet popups that was replaced with plotly in popps

# color palettes for gwl decline
col <- rev(colormap::colormap(colormap::colormaps$magma, nshades = 20))
pal <- colorNumeric(col, raster::values(gwl), na.color = "transparent")

#pal2 <- colorNumeric(col, raster::values(gwl)/2, na.color = "transparent")
gwl2 <- gwl/2
library(htmlwidgets)

# Step 1 convert htmlwidget to character representation of HTML components
as.character.htmlwidget <- function(x, ...) {
  htmltools::HTML(
    htmltools:::as.character.shiny.tag.list(
      htmlwidgets:::as.tags.htmlwidget(
        x
      ),
      ...
    )
  )
}
add_deps <- function(dtbl, name, pkg = name) {
  tagList(
    dtbl,
    htmlwidgets::getDependency(name, pkg)
  )
}
decline = "mt"
gsa_selected = "ALL"
p <- readr::read_rds("~/Github/aife/plotly/100_ALL.rds")

leaflet(gsa) %>% 
  
  # tiles
  addProviderTiles(providers$CartoDB,             group = "Light") %>% 
  #addProviderTiles(providers$CartoDB.DarkMatter,  group = "Dark") %>% 
  #addProviderTiles(providers$Esri.WorldStreetMap, group = "Street") %>% 
  
  # center
  setView(-119.7, 36.8, 7) %>% 
  
  # groundwater level
  addRasterImage(gwl, opacity = 0.8, colors = pal,
                 layerId = "2019", group = "2019 groundwater level") %>%
  addRasterImage(gwl2, opacity = 0.8, colors = pal,
                 layerId = "2040", group = "2040 min threshold") %>%
  addLegend(pal = pal, values = raster::values(gwl),
            title    = "Groundwater <br>level (ft. BLS)",
            position = "bottomright") %>%
  
  # raster value display
  leafem::addMouseCoordinates() %>%
  leafem::addImageQuery(gwl, type="mousemove", layerId = "2019",
                        group = "2019 groundwater level", prefix = "",
                        digits = 2, position = "bottomright") %>%
  leafem::addImageQuery(gwl2, type="mousemove", layerId = "2040",
                        group = "2040 min threshold", prefix = "",
                        digits = 2, position = "bottomright") %>%
  
  # layer control
  addLayersControl(
    overlayGroups = c("critical priority GSAs"),
    baseGroups    = c("2019 groundwater level", "2040 min threshold"),
    options       = layersControlOptions(collapsed = FALSE,
                                         position = "bottomleft")
  ) %>%
  
  # zoom to home
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 1",
    onClick=JS("function(btn, map){ map.setView([36.8, -119.7], 7); }"),
    position = "topleft")
  ) %>% 
  
  # polygons
  addPolygons(data = gsa, weight = 1, opacity = 1, fillOpacity = 0.1, 
              group = "critical priority GSAs",
              label = ~gsp_name, 
              highlightOptions = 
                highlightOptions(color = "black", weight = 2,
                                 bringToFront = TRUE),
              labelOptions = labelOptions(textsize = "13px"),               
              # popup = paste0("<style> div.leaflet-popup-content {width:auto !important;}</style> <em><b>", gsa$gsp_name, "</b></em><br>",
              #                "N-M wells fail at min threshold<br>",
              #                "$X-Y estimated cost<br><br>", 
              #                "<img", " src='",
              #                paste0("https://raw.githubusercontent.com/richpauloo/aife/master/ggplot/", 250, "_", gsa_selected, ".png"),
              #                "'>")
              popup = paste0("<em><b>", "GSA NAME", "</b></em><br>",
                             "N-M wells fail at min threshold<br>",
                             "$X-Y estimated cost<br>",
                             p %>%
                               as.tags() %>%
                               {tags$div(style="width:270px; height:220px;", .)} %>%
                               as.character() %>% 
                               stringr::str_replace("height:400px","height:100%")
              )
  ) %>% 
  
  onRender(
    "function(el,x) {
    this.on('popupopen', function() {HTMLWidgets.staticRender(); remove()})
    }"
  ) %>%
  add_deps("plotly") %>%
  htmltools::attachDependencies(plotly:::plotlyMainBundle(), append = TRUE) %>%
  htmltools::attachDependencies(crosstalk::crosstalkLibs(),  append = TRUE) %>%
  browsable()
