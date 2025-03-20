# distance to low growing woody plants
library(terra)
source("Scripts/1prepare_rasters/functions/distance_from_0.R")

# Define paths
CLCplus_Backbone_path = "env_variables/processed/CLCplus_Backbone/CLCplus_Backbone.tif"
output_path <- "env_variables/processed/Distance_low_growing_woody_plants/distance_low_growing_woody_plants.tif"
# Create the directory if it doesn't already exist
dir.create(dirname(output_path), recursive = TRUE)

# Load raster 
CLCplus_Backbone_raster <- rast(CLCplus_Backbone_path)
################ CLCplus Backbone 
#1   - Sealed
#2   - Woody needle leaved trees
#3   - Woody Broadleaved deciduous trees
#4   - Woody Broadleaved evergreen trees
#5   - Low-growing woody plants
#6   - Permanent herbaceoous
#7   - Periodically herbaceous
#9   - Lichens and mosses
#10  - Non and sparsely vegetated
#253 - Coastal seawater buffer
#254 - Outside area (=0)
#255 - No data (NA)

# change values, so distance to low-growing woody plants within low-growing woody plants will be 0
CLCplus_Backbone_raster[CLCplus_Backbone_raster %in% c(0, 1, 2, 3, 4, 6, 7, 9, 10, 253)] <- 1
CLCplus_Backbone_raster[CLCplus_Backbone_raster == 5] <- 0
################ CLCplus Backbone 
#1   - Sealed, Woody needle leaved trees, Woody Broadleaved deciduous trees, Woody Broadleaved evergreen trees, Permanent herbaceous, Periodically herbaceous, Lichens and mosses, Non and sparsely vegetated, Coastal seawater buffer, Outside area, No data 
#0   - Low-growing woody plants

# create template raster
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
template_raster <- Dominant_Forest_Type_raster 
template_raster[] <- 1

# adjust to template raster
CLCplus_Backbone_raster_resampled <- resample(CLCplus_Backbone_raster, template_raster, method = "near")


# This will measure the distance from the zero values.
distance_lowgrow_woody_plants <- distance_from_0(CLCplus_Backbone_raster_resampled)

# Plot the resulting distance raster to visualize the calculated distances
#plot(distance_lowgrow_woody_plants)

# Save the raster to the specified file
writeRaster(distance_lowgrow_woody_plants, output_path, overwrite = TRUE)
