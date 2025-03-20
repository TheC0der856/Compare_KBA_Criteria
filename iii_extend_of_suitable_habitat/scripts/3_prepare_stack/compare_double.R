
#################### compare the doubles

########## create occurences object
# load data
occ_data <- read.csv("occurences/Ariagona_margaritae_Alles.csv", sep = ",")  
# Extract and clean coordinates 
# only for rows which are not potential collection points and have exact coordinates
occ.std <- occ_data[!is.na(occ_data$Specimen_ID) & occ_data$Specimen_ID != "", c("WGS84_X", "WGS84_Y")]
# Remove duplicate coordinate pairs
occ.std <- occ.std[!duplicated(occ.std),]                            
# Replace commas with dots and convert to numeric values
occ.std$WGS84_X <- as.numeric(sub(",", ".", occ.std$WGS84_X))
occ.std$WGS84_Y <- as.numeric(sub(",", ".", occ.std$WGS84_Y))
# Remove rows with missing values (NA)
occ.std <- occ.std[complete.cases(occ.std), ]
# Convert to an sf object (Spatial Points Data)
occ.sf <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)

# load the meadows (and shrubs)
# Cabildo
library(sf)
library(dplyr)
formaciones_forestales_path <- "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"
formaciones_forestales <- st_read(formaciones_forestales_path)
herbazales <- formaciones_forestales %>%
  filter(inaccurate_vegetation_classification == "HERBAZALES")
matorrales <- formaciones_forestales %>%
  filter(inaccurate_vegetation_classification == "MATORRALES")
source("Scripts/1prepare_rasters/functions/shp2raster.R")
herbazales_raster <- shp2raster(herbazales)
matorrales_raster <- shp2raster(matorrales)
# Copernicus
grassland_path = "env_variables/processed/Grassland/Grassland.tif"
grassland_raster <- rast(grassland_path)
# change values, so distance to grassland within grassland will be 0
grassland_raster[grassland_raster == 0] <- 2
grassland_raster[grassland_raster == 1] <- 0
# get crs of herbazales raster
crs_herbazales_raster <- crs(herbazales_raster)
# grassland should be the same crs like herbazales
grassland_raster_projected <- project(grassland_raster, crs_herbazales_raster)

# Set up a 1x2 grid for side-by-side plots
par(mfrow = c(1, 2)) 
#plot grassland
# Convert to an sf object (Spatial Points Data)
occ.sf <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)
# Transform the coordinates of the points to the CRS of the raster
occ.sf <- st_transform(occ.sf, crs = crs(grassland_raster_projected))
# Extract raster values at point locations
raster_values <- extract(grassland_raster_projected, occ.sf)
# Add the raster values to the points data
occ.sf$raster_value <- raster_values
# Plot the raster
plot(grassland_raster_projected, main = "Grassland Raster with Points", col = terrain.colors(10))
# Add points to the plot
points(st_coordinates(occ.sf), col = "red", pch = 19, cex = 1)
# plot herbazales
# Convert to an sf object (Spatial Points Data)
occ.sf <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)
# Transform the coordinates of the points to the CRS of the herbazales raster
occ.sf <- st_transform(occ.sf, crs = crs(herbazales_raster))
# Extract raster values at point locations
raster_values <- extract(herbazales_raster, occ.sf)
# Add the raster values to the points data
occ.sf$raster_value <- raster_values
# Plot the herbazales raster
plot(herbazales_raster, main = "Herbazales Raster with Points", col = terrain.colors(10))
# Add points to the plot
points(st_coordinates(occ.sf), col = "red", pch = 19, cex = 1)


CLCplus_Backbone_path = "env_variables/processed/CLCplus_Backbone/CLCplus_Backbone.tif"
# Load raster 
CLCplus_Backbone_raster <- rast(CLCplus_Backbone_path)
# change values, so distance to low-growing woody plants within low-growing woody plants will be 0
CLCplus_Backbone_raster[CLCplus_Backbone_raster %in% c(0, 1, 2, 3, 4, 6, 7, 9, 10, 253)] <- 1
CLCplus_Backbone_raster[CLCplus_Backbone_raster == 5] <- 0
################ CLCplus Backbone 
#1   - Sealed, Woody needle leaved trees, Woody Broadleaved deciduous trees, Woody Broadleaved evergreen trees, Permanent herbaceous, Periodically herbaceous, Lichens and mosses, Non and sparsely vegetated, Coastal seawater buffer, Outside area, No data 
#0   - Low-growing woody plants
# grassland should be the same crs like herbazales
CLCplus_Backbone_raster_projected <- project(CLCplus_Backbone_raster, crs_herbazales_raster)

#plot low growing woody features
# Convert to an sf object (Spatial Points Data)
occ.sf <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)
# Transform the coordinates of the points to the CRS of the raster
occ.sf <- st_transform(occ.sf, crs = crs(CLCplus_Backbone_raster_projected))
# Extract raster values at point locations
raster_values <- extract(CLCplus_Backbone_raster, occ.sf)
# Add the raster values to the points data
occ.sf$raster_value <- raster_values
# Plot the raster
plot(CLCplus_Backbone_raster, main = "SWF Raster with Points", col = terrain.colors(10))
# Add points to the plot
points(st_coordinates(occ.sf), col = "red", pch = 19, cex = 1)
# plot herbazales
# Convert to an sf object (Spatial Points Data)
occ.sf <- st_as_sf(occ.std, coords = c("WGS84_X", "WGS84_Y"), crs = 4326)
# Transform the coordinates of the points to the CRS of the herbazales raster
occ.sf <- st_transform(occ.sf, crs = crs(matorrales_raster))
# Extract raster values at point locations
raster_values <- extract(matorrales_raster, occ.sf)
# Add the raster values to the points data
occ.sf$raster_value <- raster_values
# Plot the herbazales raster
plot(matorrales_raster, main = "Matorrales Raster with Points", col = terrain.colors(10))
# Add points to the plot
points(st_coordinates(occ.sf), col = "red", pch = 19, cex = 1)


