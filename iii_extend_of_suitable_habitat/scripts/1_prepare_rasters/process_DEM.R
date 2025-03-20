# Load required library
library(terra)
library(spatialEco)

# Define file paths
DEM1_path <- "env_variables/originals/DEM/Copernicus_DSM_04_N27_00_W017_00_DEM.tif"
DEM2_path <- "env_variables/originals/DEM/Copernicus_DSM_04_N27_00_W018_00_DEM.tif"
DEM3_path <- "env_variables/originals/DEM/Copernicus_DSM_04_N27_00_W019_00_DEM.tif"
DEM4_path <- "env_variables/originals/DEM/Copernicus_DSM_04_N28_00_W017_00_DEM.tif"
DEM5_path <- "env_variables/originals/DEM/Copernicus_DSM_04_N28_00_W018_00_DEM.tif"
DEM6_path <- "env_variables/originals/DEM/Copernicus_DSM_04_N28_00_W019_00_DEM.tif"
  
output_hillshade <- "env_variables/processed/DEM_n_related/hillshade.tif"
output_slope <- "env_variables/processed/DEM_n_related/slope.tif"
output_aspect <- "env_variables/processed/DEM_n_related/aspect.tif"
output_curvature <- "env_variables/processed/DEM_n_related/curvature.tif"
output_tri <- "env_variables/processed/DEM_n_related/Terrain_Ruggedness_Index.tif"
output_dem <- "env_variables/processed/DEM_n_related/DEM.tif"
#create folder if it does not exist yet
if (!dir.exists(dirname(output_dem))) {
  dir.create(dirname(output_dem), recursive = TRUE)
}


# Load the DEM
DEM1 <- rast(DEM1_path)
DEM2 <- rast(DEM2_path)
DEM3 <- rast(DEM3_path)
DEM4 <- rast(DEM4_path)
DEM5 <- rast(DEM5_path)
DEM6 <- rast(DEM6_path)

# Merge the rasters (digital elevation models)
DEM123 <- merge(DEM1, DEM2, DEM3)
DEM456 <- merge(DEM4, DEM5, DEM6)
DEM <- merge(DEM123, DEM456)
writeRaster(DEM, output_dem, overwrite= TRUE)
#plot(DEM)



# Calculate more environmental variables
# Compute Hillshade
hillshade <- shade(terrain(DEM, v = "slope"), terrain(DEM, v = "aspect"))
writeRaster(hillshade, output_hillshade, overwrite = TRUE)
#plot(hillshade)

# Compute Slope
slope <- terrain(DEM, v = "slope", unit = "degrees")
writeRaster(slope, output_slope, overwrite = TRUE)
#plot(slope)

# Compute Aspect
aspect <- terrain(DEM, v = "aspect")
writeRaster(aspect, output_aspect, overwrite = TRUE)
#plot(aspect)

# Compute curvature
curvature <- curvature(DEM)
writeRaster(curvature, output_curvature, overwrite = TRUE)
#plot(curvature)

# Compute Terrain Ruggedness Index
TRI <- tri(DEM)
writeRaster(TRI, output_tri, overwrite = TRUE)
#plot(TRI)

