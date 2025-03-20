library(terra)
library(sf)
library(dplyr)
source("Scripts/1prepare_rasters/functions/distance_from_0.R")
source("Scripts/1prepare_rasters/functions/shp2raster.R")

# paths
formaciones_forestales_path <- "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"

herbazales_path = "env_variables/processed/Distance_to_Herbazales/Distance_to_Herbazales.tif"
matorrales_path <- "env_variables/processed/Distance_to_Matorrales/Distance_to_Matorrales.tif"
pinar_y_cypreses_path <- "env_variables/processed/Distance_to_PinaryCipreses/Distance_to_PinaryCipreses.tif"
if (!dir.exists(dirname(herbazales_path))) {
  dir.create(dirname(herbazales_path), recursive = TRUE)
}
if (!dir.exists(dirname(matorrales_path))) {
  dir.create(dirname(matorrales_path), recursive = TRUE)
}
if (!dir.exists(dirname(pinar_y_cypreses_path))) {
  dir.create(dirname(pinar_y_cypreses_path), recursive = TRUE)
}

# load data
formaciones_forestales <- st_read(formaciones_forestales_path)


# extract important data
herbazales <- formaciones_forestales %>%
  filter(inaccurate_vegetation_classification == "HERBAZALES")
matorrales <- formaciones_forestales %>%
  filter(inaccurate_vegetation_classification == "MATORRALES")
pinar_y_cipreses <- formaciones_forestales %>%
  filter(accurate_vegetation_classification == "Pinar y cipreses")


# create a raster
herbazales_raster <- shp2raster(herbazales)
matorrales_raster <- shp2raster(matorrales)
pinar_y_cipreses_raster <- shp2raster(pinar_y_cipreses)
#unique(pinar_y_cipreses_raster)
#plot(pinar_y_cipreses_raster)



# measure Euclidean distance 
distance_herbazales_raster <- distance_from_0(herbazales_raster_filtered)
distance_matorrales_raster <- distance_from_0(matorrales_raster_filtered)
distance_pinar_y_cipreses_raster <- distance_from_0(pinar_y_cipreses_raster_filtered)
# visualize the calculated distances
#plot(distance_herbazales_raster)
#plot(distance_matorrales_raster)
#plot(distance_pinar_y_cipreses_raster)



# Save the rasters
writeRaster(distance_herbazales_raster, herbazales_path , overwrite = TRUE)
writeRaster(distance_matorrales_raster, matorrales_path , overwrite = TRUE)
writeRaster(distance_pinar_y_cipreses_raster, pinar_y_cypreses_path  , overwrite = TRUE)


