library(terra)

# Define the file path for the raster data
Imperviousness_path = "env_variables/originals/Imperviousness/Results/IMD_2018_010m_03035_V2_0/IMD_2018_010m_03035_V2_0/IMD_2018_010m_03035_V2_0.tif"
output_path <- "env_variables/processed/Distance_Imperviousness/distance_Imperviousness.tif"
# Create the directory if it doesn't already exist
dir.create(dirname(output_path), recursive = TRUE)

# Load the raster data from the file
Imperviousness_raster <- rast(Imperviousness_path)
# 0 - 100 [%]
#255 - Outside area (=0)

# Set all non-zero values to NA (so only 0 values remain)
Imperviousness_raster[Imperviousness_raster != 0] <- NA


# create template raster
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
template_raster <- Dominant_Forest_Type_raster 
template_raster[] <- 1

# adjust grassland to template raster
Imperviousness_raster_resampled <- resample(Imperviousness_raster, template_raster, method = "near")
# Calculate the Euclidean distance from the NA values (previously non-zero cells)
# This will measure the distance from the zero (impervious) values.
distance_Imperviousness <- distance(Imperviousness_raster_resampled, target = NA)

# Replace all NA values in the distance raster with 0
# This step ensures that areas with no valid distance (NA) will be set to 0.
distance_Imperviousness[is.na(distance_Imperviousness)] <- 0

# Plot the resulting distance raster to visualize the calculated distances
#plot(distance_Imperviousness)

# Save the raster to the specified file
writeRaster(distance_Imperviousness, output_path, overwrite = TRUE)