# distance to forestedge
# load scripts
source("Scripts/1prepare_rasters/functions/distance_from_0.R")
source("Scripts/1prepare_rasters/functions/shp2raster.R")
# load packages
library(terra)
library(sf)
library(dplyr)

# create raster: distance_to_forestedge
#     1. create Forest 
#        1.1 Copernicus
#        1.2 Cabildo
#     2. create forestedge
#        2.1 Copernicus
#        2.2 Cabildo
#     3. calculate distance
#        3.1 Copernicus
#        3.2 Cabildo
#     4. save results

# Paths
Dominant_Forest_Type_path = "env_variables/processed/Dominant_Forest_Type/Dominant_Forest_Type.tif"
formaciones_forestales_path <- "env_variables/processed/formaciones_forestales/formaciones_forestales.gpkg"
Copernicus_Distance_to_Forestedge_path = "env_variables/processed/Distance_to_Forestedge/Distance_to_Forestedge_Copernicus.tif"
Cabildo_Distance_to_Forestedge_path = "env_variables/processed/Distance_to_Forestedge/Distance_to_Forestedge_Cabildo.tif"
if (!dir.exists(dirname(Copernicus_Distance_to_Forestedge_path))) {
  dir.create(dirname(Copernicus_Distance_to_Forestedge_path), recursive = TRUE)
}

# Load raster
Dominant_Forest_Type_raster <- rast(Dominant_Forest_Type_path)
formaciones_forestales <- st_read(formaciones_forestales_path)



############# 1. Create forest data

# 1.1 Copernicus forest: Reclassify the raster to have two values: 0 = no forest, 1 = forest
Copernicus_Forest_raster <- classify(Dominant_Forest_Type_raster, cbind(2, 1))

# 1.2 Cabildo forest
Cabildo_forest_areas <- formaciones_forestales %>%
  filter(inaccurate_vegetation_classification == "BOSQUES Y ARBUSTEDAS")
# create the raster
Cabildo_forest_raster <- shp2raster(Cabildo_forest_areas)



############# 2. Create forest edge

# 2.1 Copernicus forest edge
# exclude 0 values, otherwise the edge of 0 values is calculated
Copernicus_Forest_raster_filtered <- mask(Copernicus_Forest_raster, Copernicus_Forest_raster == 1, maskvalues = FALSE)
# convert into polygons
Copernicus_Forest_polygons <- as.polygons(Copernicus_Forest_raster_filtered, dissolve = TRUE)
# convert terra-polygons into sf-object
Copernicus_Forest_polygons_sf <- st_as_sf(Copernicus_Forest_polygons)
# create multiple lines around the polygons
Copernicus_Forestedge_sf <- st_cast(Copernicus_Forest_polygons_sf, "MULTILINESTRING")
# result:
#plot(Copernicus_Forestedge_sf)

# 2.2 Cabildo forest edge
# Exclude 0 values to avoid calculating edges around non-forest areas
Cabildo_forest_raster_filtered <- mask(Cabildo_forest_raster, Cabildo_forest_raster == 0, maskvalues = FALSE)
# Convert filtered raster into polygons
Cabildo_forest_polygons <- as.polygons(Cabildo_forest_raster_filtered, dissolve = TRUE)
# Convert terra polygons into an sf object
Cabildo_forest_polygons_sf <- st_as_sf(Cabildo_forest_polygons)
# Create multiple lines around the polygons
Cabildo_forestedge_sf <- st_cast(Cabildo_forest_polygons_sf, "MULTILINESTRING")



################# 3. Calculate Euclidean distance to forest edge

# 3.1 Copernicus:

# Treeedge_sf has to be converted into a raster
Copernicus_Forestedge_raster <- rasterize(vect(Copernicus_Forestedge_sf), Dominant_Forest_Type_raster , field = 0, background = 1)
#plot(Copernicus_Forestedge_raster)
# Calculate the Euclidean distance to the lines
Copernicus_Forestedge_distance <- distance_from_0(Copernicus_Forestedge_raster)
# check if the Euclidean distance was calculated correctly
#plot(Copernicus_Forestedge_distance)

# 3.2 Cabildo:
# Ensure the distance raster has the same resolution and extent
Cabildo_forestedge_raster <- rasterize(vect(Cabildo_forestedge_sf ), Dominant_Forest_Type_raster, field = 0, background = 1)
# Calculate the Euclidean distance to the forest edge
Cabildo_forestedge_distance <- distance_from_0(Cabildo_forestedge_raster)
# Check results
# plot(Cabildo_forestedge_distance)



# 4. Save results
writeRaster(Copernicus_Forestedge_distance, 
            filename = Copernicus_Distance_to_Forestedge_path, 
            overwrite = TRUE)

writeRaster(Cabildo_forestedge_distance, 
            filename = Cabildo_Distance_to_Forestedge_path, 
            overwrite = TRUE)