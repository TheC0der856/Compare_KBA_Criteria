# distance to trees and distance to forest
source("Scripts/1prepare_rasters/functions/distance_from_0.R")
#source("Scripts/prepare_rasters/functions/shp2raster.R")


# Paths
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
formaciones_forestales_path <- "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"
Small_Woody_Features_path <- "env_variables/processed/Small_Woody_Features/Small_Woody_Features.tif"

Copernicus_Distance_to_Trees_path = "env_variables/processed/Distance_to_Trees/Distance_to_Trees_Copernicus.tif"
Cabildo_Distance_to_Trees_path = "env_variables/processed/Distance_to_Trees/Distance_to_Trees_Cabildo.tif"
if (!dir.exists(dirname(Copernicus_Distance_to_Trees_path))) {
  dir.create(dirname(Copernicus_Distance_to_Trees_path), recursive = TRUE)
}


# Load raster
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
Small_Woody_Features_raster <- rast(Small_Woody_Features_path)
formaciones_forestales <- st_read(formaciones_forestales_path)

###### Copernicus forest
# Create forest data
# Reclassify the raster to have two values: 0 = no forest, 1 = forest
Copernicus_Forest_raster <- classify(Dominant_Forest_Type_raster, cbind(2, 1))

# Combine with Small Woody Features
Small_Woody_Features_raster_aligned <- resample(Small_Woody_Features_raster, Copernicus_Forest_raster , method = "near")
# Create the combined raster (forest or small woody features)
Copernicus_Trees_raster <- mosaic(Copernicus_Forest_raster, 
                                  Small_Woody_Features_raster_aligned, 
                                  fun = max)

# Trees should be 0 
Copernicus_Trees_raster[Copernicus_Trees_raster == 0] <- 2
Copernicus_Trees_raster[Copernicus_Trees_raster == 1] <- 0

# Calculate the Euclidean distance 
Copernicus_Trees_distance <- distance_from_0(Copernicus_Trees_raster)
#plot(Copernicus_Trees_distance)




### Cabildo forest
# Create forest data 
Cabildo_forest_areas <- formaciones_forestales %>%
  filter(inaccurate_vegetation_classification == "BOSQUES Y ARBUSTEDAS")
# create template raster: 
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
template_raster <- Dominant_Forest_Type_raster 
template_raster[] <- 1
#create raster
Cabildo_forest_raster <- rasterize(project(vect(Cabildo_forest_areas), crs(template_raster)), template_raster, field = 1, background = 0)


# Combine with Small Woody Features
Cabildo_Trees_raster <- mosaic(Cabildo_forest_raster, 
                        Small_Woody_Features_raster_aligned, 
                        fun = max)

# Trees should be 0 
Cabildo_Trees_raster[Cabildo_Trees_raster == 0] <- 2
Cabildo_Trees_raster[Cabildo_Trees_raster == 1] <- 0

# Calculate Euclidean distance to forest 
Cabildo_Trees_distance <- distance_from_0(Cabildo_Trees_raster)
#plot(Cabildo_Trees_distance)





################# Save results
writeRaster(Copernicus_Trees_distance, 
            filename = Copernicus_Distance_to_Trees_path, 
            overwrite = TRUE)

writeRaster(Cabildo_Trees_distance, 
            filename = Cabildo_Distance_to_Trees_path, 
            overwrite = TRUE)
