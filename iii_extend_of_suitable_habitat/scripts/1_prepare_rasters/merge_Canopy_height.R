source("packages_installer.R")
# Load the necessary libraries
library(raster)
library(terra)

# Define the paths 
CanopyHeight1_path <- "env_variables/originals/Canopy_Height/ETH_GlobalCanopyHeight_10m_2020_N27W018_Map.tif"
CanopyHeight2_path <- "env_variables/originals/Canopy_Height/ETH_GlobalCanopyHeight_10m_2020_N27W021_Map.tif"
CanopyHeight_output_path <- "env_variables/processed/Canopy_Height/Canopy_Height.tif"

# Load the raster files
CanopyHeight1 <- raster(CanopyHeight1_path)
CanopyHeight2 <- raster(CanopyHeight2_path)

# Merge the two rasters
merged_CanopyHeight <- merge(CanopyHeight1, CanopyHeight2)

# View the merged raster data 
#plot(merged_CanopyHeight)

# Save the merged raster
# Create the directory if it doesn't exist
dir.create(dirname(CanopyHeight_output_path), recursive = TRUE)
writeRaster(merged_CanopyHeight, CanopyHeight_output_path, overwrite = TRUE)

