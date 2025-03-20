# distance to grassland
library(terra)
source("Scripts/1prepare_rasters/functions/distance_from_0.R")

# Define paths
grassland_path = "env_variables/processed/Grassland/Grassland.tif"
output_path <- "env_variables/processed/Distance_Grassland/distance_grassland.tif"
# Create the directory if it doesn't already exist
dir.create(dirname(output_path), recursive = TRUE)

# Load raster 
grassland_raster <- rast(grassland_path)
#0    - no grassland
#1    - grassland

# change values, so distance to grassland within grassland will be 0
grassland_raster[grassland_raster == 0] <- 2
grassland_raster[grassland_raster == 1] <- 0
# 0  - grassland
# NA - no grassland

# create template raster
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
template_raster <- Dominant_Forest_Type_raster 
template_raster[] <- 1

# adjust grassland to template raster
grassland_raster_resampled <- resample(grassland_raster, template_raster, method = "near")

# Calculate the Euclidean distance 
distance_grassland <- distance_from_0(grassland_raster_resampled)
# plot(distance_grassland)

# Save the raster to the specified file
writeRaster(distance_grassland, output_path, overwrite = TRUE)

