# distance to water_wetness
library(terra)
source("Scripts/1prepare_rasters/functions/distance_from_0.R")

# Define paths
Water_Wetness_path =  "env_variables/processed/Water_wetness/Water_wetness.tif"
output_path <- "env_variables/processed/Distance_Water_wetness/Distance_Water_wetness.tif"
# Create the directory if it doesn't already exist
dir.create(dirname(output_path), recursive = TRUE)

# Load raster 
Water_Wetness_raster <- rast(Water_Wetness_path)
#0   - dry
#1   - permanent water
#2   - temporary water
#3   - permanent wet
#4   - temporary wet
#253 - sea water
#254 - unclassifiable (=NA)
#255 - outside area (=0)

# change values, so distance to water and wet areas within water and wet areas will be 0
Water_Wetness_raster[Water_Wetness_raster %in% c(0, 253)] <- 5     # dry, ocean or cost
Water_Wetness_raster[Water_Wetness_raster %in% c(1, 2, 3, 4)] <- 0 # non salty water 
#5   - dry, ocean or cost  
#0   - Fresh water

Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
template_raster <- Dominant_Forest_Type_raster 
template_raster[] <- 1

Water_Wetness_raster_resampled <- resample(Water_Wetness_raster, template_raster, method = "near")

# This will measure the distance from the zero values.
distance_Water_Wetness <- distance_from_0(Water_Wetness_raster_resampled)
#plot(distance_Water_Wetness)

# Save the raster
writeRaster(distance_Water_Wetness, output_path, overwrite = TRUE)
