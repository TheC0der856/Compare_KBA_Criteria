# create distance stack
# load packages:
library(terra)
library(dplyr)

# path names
distances_paths <- c(
  "env_variables/processed/cultivos/abandoned_farms.tif",  
  "env_variables/processed/cultivos/active_farms.tif", 
  "env_variables/processed/Distance_Fayal_Brezal/distance_to_fayal_brezal.tif", 
  "env_variables/processed/Distance_Forest_Type/distance_broadleaf.tif", 
  "env_variables/processed/Distance_Forest_Type/distance_coniferous.tif", 
  "env_variables/processed/Distance_Grassland/distance_grassland.tif", 
  "env_variables/processed/Distance_herbaceous_type/distance_periodically_herbaceous.tif",   
  "env_variables/processed/Distance_herbaceous_type/distance_permanent_herbaceous.tif",      
  "env_variables/processed/Distance_Imperviousness/distance_Imperviousness.tif",
  "env_variables/processed/Distance_low_growing_woody_plants/distance_low_growing_woody_plants.tif",
  "env_variables/processed/Distance_to_Forest/Distance_to_Forest_Copernicus.tif",           
  "env_variables/processed/Distance_to_Forest/Distance_to_Forest_Cabildo.tif",              
  "env_variables/processed/Distance_to_Forestedge/Distance_to_Forestedge_Cabildo.tif",      
  "env_variables/processed/Distance_to_Forestedge/Distance_to_Forestedge_Copernicus.tif",   
  "env_variables/processed/Distance_to_Herbazales/Distance_to_Herbazales.tif",
  "env_variables/processed/Distance_to_Matorrales/Distance_to_Matorrales.tif",
  "env_variables/processed/Distance_to_PinaryCipreses/Distance_to_PinaryCipreses.tif",
  "env_variables/processed/Distance_to_Treeedge/Distance_to_Treeedge_Cabildo.tif",
  "env_variables/processed/Distance_to_Treeedge/Distance_to_Treeedge_Copernicus.tif",
  "env_variables/processed/Distance_to_Trees/Distance_to_Trees_Cabildo.tif",
  "env_variables/processed/Distance_to_Trees/Distance_to_Trees_Copernicus.tif",
  "env_variables/processed/Distance_Water_wetness/Distance_Water_wetness.tif"
)
#  file.exists(environmental_variables_paths) # check if all files exist

# Load rasters
distances_rasters <- lapply(distances_paths, rast)

# create stack
distance_stack <- do.call(c, distances_rasters)

# new names for rasters in stack
new_names <- c("d_abandoned_farms", 
               "d_active_farms", 
               "d_fayal_brezal", 
               "d_broadleaf_forest", 
               "d_coniferous_forest",
               "d_grassland", 
               "d_periodically_herb", 
               "d_permanent_herb",
               "d_imperviousness",
               "d_low_growing_woody_plants",
               "d_forest_Copernicus",
               "d_forest_Cabildo", 
               "d_forestedge_Cabildo", 
               "d_forestedge_Copernicus", 
               "d_herbazales", 
               "d_matorrales", 
               "d_pinar_cipreses",
               "d_treeedge_Cabildo",
               "d_treeedge_Copernicus",
               "d_trees_Cabildo",
               "d_trees_Copernicus",
               "d_water_wetness")

# rename rasters within stack
names(distance_stack) <- new_names
