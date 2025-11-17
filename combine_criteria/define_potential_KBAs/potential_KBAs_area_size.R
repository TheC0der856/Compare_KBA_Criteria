# load libraries
library(sf)
library(dplyr)
library(tmap)
library(ggplot2)
library(viridis)

# load potential areas
potential_KBAs <- st_read("combine_criteria/define_potential_KBAs/potential_KBAs.shp")

# calculate size
potential_KBAs$area_m2 <- st_area(potential_KBAs)
potential_KBAs$area_km2 <- as.numeric(potential_KBAs$area_m2) / 1e6


# view potential areas
tmap_mode("view")
tm_shape(potential_KBAs) +
  tm_polygons(
    fill = "area_km2",
    fill.scale = tm_scale(values = "viridis"),
    fill.legend = tm_legend(title = "area (km²)")
  )


st_write(potential_KBAs, "combine_criteria/define_potential_KBAs/potential_KBAs_including_area_size.shp")

