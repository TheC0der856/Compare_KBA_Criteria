# load packages:
library(terra)
library(dplyr)

# Define paths to DEM related variables
DEM_directory <- "env_variables/processed/DEM_n_related"
DEM_file_names <- c("aspect.tif", "curvature.tif", 
                    "DEM.tif", "hillshade.tif", 
                    "slope.tif", "Terrain_Ruggedness_Index.tif")
DEM_paths <- file.path(DEM_directory, DEM_file_names)

# Load rasters
DEM_rasters <- lapply(DEM_paths, rast)

# Stack rasters
DEM_stack <- do.call(c, DEM_rasters)

# new names for rasters in stack
new_names <- c("aspect", 
               "curvature",
               "DEM",
               "hillshade",
               "slope",
               "TRI")

# rename rasters within stack
names(DEM_stack) <- new_names