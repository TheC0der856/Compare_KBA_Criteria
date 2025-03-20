# distance to broadleaf forest/ coniferous forest
library(terra)
source("Scripts/1prepare_rasters/functions/distance_from_0.R")

# Define paths
forest_type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
broadleaf_path <- "env_variables/processed/Distance_Forest_Type/distance_broadleaf.tif"
coniferous_path <- "env_variables/processed/Distance_Forest_Type/distance_coniferous.tif"
# Create the directory if it doesn't already exist
dir.create(dirname(broadleaf_path), recursive = TRUE)

# Load raster 
forest_type_raster <- rast(forest_type_path)
#0    - no forest
#1   - broadleaved trees
#2   - coniferous trees


#################### calculate broadleaved forest distance ###########################
# rename raster
broadleaved_raster <- forest_type_raster

# change values, so distance to broadleaves within broeadleaf forest will be 0
broadleaved_raster[broadleaved_raster == 0] <- 2
broadleaved_raster[broadleaved_raster == 1] <- 0
#2     - no forest & coniferous trees
#0     - broadleaved trees

# Calculate the Euclidean distance 
distance_broadleaved <- distance_from_0(broadleaved_raster)
#plot(distance_broadleaved)


#################### calculate coniferous forest distance ###########################
# rename raster
coniferous_raster <- forest_type_raster

# change values, so distance to conifers within coniferous forest will be 0
coniferous_raster[coniferous_raster == 0] <- 1
coniferous_raster[coniferous_raster == 2] <- 0
#0     - no forest & coniferous trees
#1     - broadleaved trees

# Calculate the Euclidean distance 
# This will measure the distance from the zero values.
distance_coniferous <- distance_from_0(coniferous_raster)
#plot(distance_coniferous)



# Save rasters
writeRaster(distance_broadleaved, broadleaf_path, overwrite = TRUE)
writeRaster(distance_coniferous, coniferous_path, overwrite = TRUE)
