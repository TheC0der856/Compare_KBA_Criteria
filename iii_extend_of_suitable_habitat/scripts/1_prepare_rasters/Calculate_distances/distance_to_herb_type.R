# distance to permanent and periodically herbaceous
# load library
library(terra)
source("Scripts/1prepare_rasters/functions/distance_from_0.R")


# Define paths
CLCplus_Backbone_path = "env_variables/processed/CLCplus_Backbone/CLCplus_Backbone.tif"
permanent_herbs_path <- "env_variables/processed/Distance_herbaceous_type/distance_permanent_herbaceous.tif"
periodical_herbs_path <- "env_variables/processed/Distance_herbaceous_type/distance_periodically_herbaceous.tif"
# Create the directory if it doesn't already exist
dir.create(dirname(permanent_herbs_path), recursive = TRUE)

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

Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
template_raster <- Dominant_Forest_Type_raster 
template_raster[] <- 1

########### permanent herbs
permanent_herbs_raster <- CLCplus_Backbone_raster

# change values, permanent herbs to 0, 
permanent_herbs_raster[permanent_herbs_raster %in% c(0, 1, 2, 3, 4, 5, 7, 9, 10, 253)] <- 1
permanent_herbs_raster[permanent_herbs_raster == 6] <- 0
#1   - all except permanent herbs and NA
#0   - permanent herbs

# adjust the raster to Dominat_Forest_Type in its extend
permanent_herbs_raster_resampled <- resample(permanent_herbs_raster, template_raster, method = "near")

# measure Euclidean distance 
distance_permanent_herbs <- distance_from_0(permanent_herbs_raster_resampled)
# visualize the calculated distances
#plot(distance_permanent_herbs)


########### periodical herbs
periodical_herbs_raster <- CLCplus_Backbone_raster

# change values, periodical herbs to 0, 
periodical_herbs_raster[periodical_herbs_raster %in% c(0, 1, 2, 3, 4, 5, 6, 9, 10, 253)] <- 1
periodical_herbs_raster[periodical_herbs_raster == 7] <- 0
#1   - all except periodical herbs and NA
#0   - periodical herbs

# adjust the raster to Dominat_Forest_Type in its extend
periodical_herbs_raster_resampled <- resample(periodical_herbs_raster, template_raster, method = "near")

# measure Euclidean distance 
distance_periodical_herbs <- distance_from_0(periodical_herbs_raster_resampled)
# visualize the calculated distances
#plot(distance_periodical_herbs)



# Save the rasters
writeRaster(distance_permanent_herbs, permanent_herbs_path , overwrite = TRUE)
writeRaster(distance_periodical_herbs, periodical_herbs_path , overwrite = TRUE)

