library(raster)
library(terra)

# define  file paths
CLCplus_Backbone_path <- "env_variables/originals/CLCplus_Backbone/Results/CLCplus_RASTER_2021_010m_03035/CLCplus_RASTER_2021_010m_03035/CLCplus_RASTER_2021_010m_03035.tif"
Dominant_Forest_Type_path = "env_variables/originals/Dominant_Forest_Type/Results/FTY_2018_010m_03035_V1_0/FTY_2018_010m_03035_V1_0/FTY_2018_010m_03035_V1_0.tif"
Dominant_Leaf_Type_path = "env_variables/originals/Dominant_Leaf_Type/Results/DLT_2018_010m_03035_V2_0/DLT_2018_010m_03035_V2_0/DLT_2018_010m_03035_V2_0.tif"
Grassland_path = "env_variables/originals/Grassland/Results/GRA_2018_010m_03035_V1_0/GRA_2018_010m_03035_V1_0/GRA_2018_010m_03035_V1_0.tif"
Imperviousness_path = "env_variables/originals/Imperviousness/Results/IMD_2018_010m_03035_V2_0/IMD_2018_010m_03035_V2_0/IMD_2018_010m_03035_V2_0.tif"
Small_Woody_Features_path = "env_variables/originals/Small_Woody_Features/Results/HRL_Small_Woody_Features_2018_005m/HRL_Small_Woody_Features_2018_005m/HRL_Small_Woody_Features_2018_005m.tif"
Tree_Cover_Density_path = "env_variables/originals/Tree_Cover_Density/Results/TCD_2018_010m_03035_V2_0/TCD_2018_010m_03035_V2_0/TCD_2018_010m_03035_V2_0.tif"
Water_Wetness_path <- "env_variables/originals/Water_Wetness/151206/Results/WAW_2018_010m_03035_V2_0/WAW_2018_010m_03035_V2_0/WAW_2018_010m_03035_V2_0.tif"

processed_CLCplus_Backbone_path <- "env_variables/processed/CLCplus_Backbone/CLCplus_Backbone.tif"
processed_Dominant_Forest_Type_path <- "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
processed_Dominant_Leaf_Type_path <- "env_variables/processed/Dominant_Leaf_Type/Dominant_Leaf_Type.tif"
processed_Grassland_path <- "env_variables/processed/Grassland/Grassland.tif"
processed_Imperviousness_path <- "env_variables/processed/Imperviousness/Imperviousness.tif"
processed_Small_Woody_Features_path <- "env_variables/processed/Small_Woody_Features/Small_Woody_Features.tif"
processed_Tree_Cover_Density_path <- "env_variables/processed/Tree_Cover_Density/Tree_Cover_Density.tif"
processed_Water_wetness_path <- "env_variables/processed/Water_wetness/Water_wetness.tif"
# list all directories
directories <- c("env_variables/processed/CLCplus_Backbone",
                 "env_variables/processed/Dominant_Forest_Type",
                 "env_variables/processed/Dominant_Leaf_Type",
                 "env_variables/processed/Grassland",
                 "env_variables/processed/Imperviousness",
                 "env_variables/processed/Small_Woody_Features",
                 "env_variables/processed/Tree_Cover_Density", 
                 "env_variables/processed/Water_wetness")
# create directories if they do not exist yet
for (dir in directories) {
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
}

# Load rasters
CLCplus_Backbone_raster <- raster(CLCplus_Backbone_path)
Dominant_Forest_Type_raster <- raster(Dominant_Forest_Type_path)
Dominant_Leaf_Type_raster <- raster(Dominant_Leaf_Type_path)
Grassland_raster <- raster(Grassland_path)
Imperviousness_raster <- raster(Imperviousness_path)
Small_Woody_Features_raster <- raster(Small_Woody_Features_path)
Tree_Cover_Density_raster <- raster(Tree_Cover_Density_path)
Water_Wetness_raster <- rast(Water_Wetness_path)

# example to see which values the rasters contain
# unique(Dominant_Leaf_Type_raster)
# explanations in: information_on_Copernicus_data_sets.R

# replace no data values with NA 
# NA is used in biomod
# -9999 is used in Maxent
CLCplus_Backbone_raster <- calc(CLCplus_Backbone_raster, fun = function(x) {
  x[x %in% c(255)] <- NA
  return(x)
})
Water_Wetness_raster <- app(Water_Wetness_raster, fun = function(x) {
  x[x == 254] <- NA
  return(x)
})

# replace outside area with 0
CLCplus_Backbone_raster <- calc(CLCplus_Backbone_raster, fun = function(x) {
  x[x %in% c(254)] <- 0
  return(x)
})
Dominant_Forest_Type_raster <- calc(Dominant_Forest_Type_raster, fun = function(x) {
  x[x %in% c(255)] <- 0
  return(x)
})
Dominant_Leaf_Type_raster <- calc(Dominant_Leaf_Type_raster, fun = function(x) {
  x[x %in% c(255)] <- 0
  return(x)
})
Grassland_raster <- calc(Grassland_raster, fun = function(x) {
  x[x %in% c(255)] <- 0
  return(x)
})
Imperviousness_raster <- calc(Imperviousness_raster, fun = function(x) {
  x[x %in% c(255)] <- 0
  return(x)
})
Small_Woody_Features_raster <- calc(Small_Woody_Features_raster, fun = function(x) {
  x[x %in% c(255)] <- 0
  return(x)
})
Tree_Cover_Density_raster <- calc(Tree_Cover_Density_raster, fun = function(x) {
  x[x %in% c(255)] <- 0
  return(x)
})
Water_Wetness_raster <- app(Water_Wetness_raster, fun = function(x) {
  x[x == 255] <- 0
  return(x)
})


# controll rasters example: 
# unique(Dominant_Leaf_Type_raster)

# save datasets
writeRaster(CLCplus_Backbone_raster, 
            filename = processed_CLCplus_Backbone_path, 
            overwrite = TRUE)
writeRaster(Dominant_Forest_Type_raster, 
            filename = processed_Dominant_Forest_Type_path, 
            overwrite = TRUE)
writeRaster(Dominant_Leaf_Type_raster, 
            filename = processed_Dominant_Leaf_Type_path, 
            overwrite = TRUE)
writeRaster(Grassland_raster, 
            filename = processed_Grassland_path, 
            overwrite = TRUE)
writeRaster(Imperviousness_raster, 
            filename = processed_Imperviousness_path, 
            overwrite = TRUE)
writeRaster(Small_Woody_Features_raster, 
            filename = processed_Small_Woody_Features_path, 
            overwrite = TRUE)
writeRaster(Tree_Cover_Density_raster, 
            filename = processed_Tree_Cover_Density_path, 
            overwrite = TRUE)
writeRaster(Water_Wetness_raster, 
            filename = processed_Water_wetness_path , 
            overwrite = TRUE)