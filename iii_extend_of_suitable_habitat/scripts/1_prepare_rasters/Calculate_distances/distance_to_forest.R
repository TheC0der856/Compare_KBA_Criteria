library(terra)
source("Scripts/1prepare_rasters/functions/distance_from_0.R")
source("Scripts/1prepare_rasters/functions/shp2raster.R")

# Paths
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
formaciones_forestales_path <- "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"
Copernicus_Distance_to_Forest_path = "env_variables/processed/Distance_to_Forest/Distance_to_Forest_Copernicus.tif"
Cabildo_Distance_to_Forest_path = "env_variables/processed/Distance_to_Forest/Distance_to_Forest_Cabildo.tif"
if (!dir.exists(dirname(Copernicus_Distance_to_Forest_path))) {
  dir.create(dirname(Copernicus_Distance_to_Forest_path), recursive = TRUE)
}

# Load raster
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
formaciones_forestales <- st_read(formaciones_forestales_path)



# Create Copernicus forest: Reclassify the raster to have two values: 0 = no forest, 1 = forest
Copernicus_Forest_raster <- classify(Dominant_Forest_Type_raster, cbind(2, 1))
#switch values, so forest is 1
Copernicus_Forest_raster[Copernicus_Forest_raster == 0] <- 2
Copernicus_Forest_raster[Copernicus_Forest_raster == 1] <- 0

# Calculate the Euclidean distance 
Copernicus_Forest_distance <- distance_from_0(Copernicus_Forest_raster)
#plot(Copernicus_Forest_distance)


#  Create forest
Cabildo_forest_areas <- formaciones_forestales %>%
  filter(inaccurate_vegetation_classification == "BOSQUES Y ARBUSTEDAS")
Cabildo_forest_raster <- shp2raster(Cabildo_forest_areas)

# Calculate the Euclidean distance 
Cabildo_forest_distance <- distance_from_0(Cabildo_forest_raster)
# plot(Cabildo_forestedge_distance)






# 4. Save results
writeRaster(Copernicus_Forest_distance, 
            filename = Copernicus_Distance_to_Forest_path, 
            overwrite = TRUE)

writeRaster(Cabildo_forest_distance, 
            filename = Cabildo_Distance_to_Forest_path, 
            overwrite = TRUE)
