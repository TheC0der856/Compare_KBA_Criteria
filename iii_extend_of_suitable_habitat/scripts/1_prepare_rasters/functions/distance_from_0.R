# calculate distance from 0
distance_from_0 <- function(input_raster) {
  
  # exclude all 0 values from the calculation
  input_raster_filtered <- mask(input_raster, input_raster == 0, maskvalues = FALSE)
  
  # calculate distance to 0 values
  distance_raster <- distance(input_raster_filtered )
  
  # return ther resulting raster
  return(distance_raster)
}