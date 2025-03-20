# combine stacks
library(terra)


google_rest_distance_stack <- rast("env_variables/stacks/google_rest_distance_stack.tif")
source("Scripts/2combine_rasters/DEM_stack.R")

# List of raster names to project
dem_rasters <- c("aspect", "curvature", "DEM", "hillshade", "slope", "TRI")

# Project all rasters and store them in a list
dem_reproj <- lapply(dem_rasters, function(raster_name) {
  project(DEM_stack[[raster_name]], google_rest_distance_stack)
})

# Stack all the rasters together, including the original google_rest_distance_stack
all_stack <- c(google_rest_distance_stack, do.call(c, dem_reproj))
#print(names(all_stack))

# save the stack 
writeRaster(all_stack, "env_variables/stacks/all_stack.tif", overwrite = TRUE)

