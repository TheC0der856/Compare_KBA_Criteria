library(sf)
library(dplyr)
library(terra)
source("Scripts/1prepare_rasters/functions/shp2raster.R")
source("Scripts/1prepare_rasters/functions/distance_from_0.R")

# paths
formaciones_forestales_path = "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"
# create output directory if it does not exist
if (!dir.exists("env_variables/processed/Distance_Fayal_Brezal")) {
  dir.create("env_variables/processed/Distance_Fayal_Brezal", recursive = TRUE)
}
distance_fayal_brezal_path <- "env_variables/processed/Distance_Fayal_Brezal/distance_to_fayal_brezal.tif"


# Load data
formaciones_forestales <- st_read(formaciones_forestales_path)

# extrakt fayal brezal areas
fayal_brezal_areas <- formaciones_forestales %>%
  filter(accurate_vegetation_classification == "Fayal_brezal")


# create raster
fayal_brezal <- shp2raster(fayal_brezal_areas)
# measure Euclidean distance 
distance_fayal_brezal <- distance_from_0(fayal_brezal)
#plot(distance_fayal_brezal)

# save raster
writeRaster(distance_fayal_brezal, distance_fayal_brezal_path, overwrite = TRUE)
