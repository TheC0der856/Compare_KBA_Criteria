
# create template raster
library(terra)

Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
template_raster <- Dominant_Forest_Type_raster 
template_raster[] <- 1




# function to create raster 
shp2raster <- function(parts_of_shp) {
  # project the extracted shapefile object to the same coordinate system like template_raster
  parts_of_shp_same_crs <- project(vect(parts_of_shp), crs(template_raster))
  
  # rasterize the extracted shapefile object to the same extend like template raster
  raster <- rasterize(parts_of_shp_same_crs, template_raster, field = 0, background = 1)
  
  # return the resulting raster
  return(raster)
}